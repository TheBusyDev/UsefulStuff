@ECHO OFF

::if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

set /a h=%time:~0,2%+2
set /a m=%time:~3,2%
set /a s=%time:~6,2%

echo %h%
echo %m%
echo %s%

time %h%:%m%:%s%

timeout 15
