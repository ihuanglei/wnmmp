@ECHO OFF 
CLS 
color 0a
setlocal enabledelayedexpansion

echo.
echo. ===================================
echo. window nginx mysql memcached php 
echo.
echo. author: huanglei
echo. 
echo. www.ihuanglei.org
echo. ===================================
echo.

cd /d %~dp0



set BASE=%CD%
set NGINX=%BASE%\nginx
set PHP=%BASE%\php
set MEMCACHED=%BASE%\memcached
set MYSQL=%BASE%\mysql
set CONFIG=%BASE%\config
set SCRIPTS=%BASE%\scripts
set SCRIPTS_CONF=%CONFIG%\scripts
set NGINX_CONF=%CONFIG%\nginx
set PHP_CONF=%CONFIG%\php
set LOG=%BASE%\logs
set TEMP=%BASE%\temp

set PATH=%PATH%;%BASE%\bin


echo. unzip
7z.exe x -f server.zip

echo.
echo. create directory
if not exist scripts md scripts
if not exist log md log
if not exist temp md temp

:PHP_CGI
echo.
set /p c=php-cgi:(default:20)?[20]
echo.
echo.php-cgi
echo SET objShell = CreateObject("Wscript.Shell") > %SCRIPTS%\phpcgi.vbs
if "%c%" == "" set /a c=20
set /a m=9000 + %c%
set /a j=9000
:LOOP2
set back_server=server 127.0.0.1:%j%;%back_server%
echo objShell.Run """%PHP%\php-cgi.exe"" -b 127.0.0.1:%j% ",0 >> %SCRIPTS%\phpcgi.vbs
set /a j+=1
if %j% LEQ %m% goto LOOP2

echo.
echo. start.bat
sed "s#@nginx_path@#%NGINX:\=\\%#g;s#@scripts_path@#%SCRIPTS:\=\\%#g" %SCRIPTS_CONF%\start.conf >%SCRIPTS%\start.bat

echo.
echo. php.ini
sed "s#@log_path@#%LOG:\=/%#g;s#@php_path@#%PHP:\=/%#g" %PHP_CONF%\php.conf >%PHP%\php.ini

echo.
echo. nginx.conf
sed "s#@log_path@#%LOG:\=/%#g;s#@back_server@#%back_server%#g" %NGINX_CONF%\nginx.conf >%NGINX%\conf\nginx.conf

:MEMCACHED
echo.
set /p yn=install memcached?[y/N]
if "%yn%" == "N" goto MYSQL
%MEMCACHED%\memcached.exe -d install

:MYSQL
echo.
set /p yn=install mysql?[y/N]
if "%yn%" == "N" goto AUTO
REM %MYSQL%\bin\mysqld.exe -d install

:AUTO
echo.
set /p yn=open window start nginx & php?[y/N]
if "%yn%" == "N" goto EP
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v snp /t REG_SZ /d "\"%SCRIPTS%\start.bat\" a" /F  


:EP
echo. shortcut
shortcut.exe /f:"%USERPROFILE%\Desktop\nps.lnk" /a:c /t:%SCRIPTS%\start.bat

echo. reg
regedit %CONFIG%\http-80.reg

:COMPLETE
echo.
echo. start desktop nps

:END
echo.
echo. install success. press any key close

pause>nul
