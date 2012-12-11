@ECHO OFF 
CLS 
color 0a
setlocal enabledelayedexpansion

echo.
echo. ===================================
echo.
echo. author: huanglei
echo.
echo. www.ihuanglei.org
echo. ===================================
echo.

cd /d %~dp0



set BASE=%CD%
set MEMCACHED=%BASE%\memcached
set MYSQL=%BASE%\mysql

%MEMCACHED%\memcached.exe -d stop
%MEMCACHED%\memcached.exe -d uninstall

echo. uninstall success. press any key close
pause >nul
