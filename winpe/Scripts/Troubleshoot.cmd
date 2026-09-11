@echo off

:MENU
color
cls
echo.
echo [1] - Repair BCD store into System Partition
echo.
echo [0] - Go back to Main Menu
echo.
choice /c 10 /n /m "Select Option: "
set errlvl=%errorlevel%
if %errlvl%==2 goto :EOF
if %errlvl%==1 goto :BCD
if %errlvl%==0 goto :MENU

:BCD
bcdboot /?
goto :MENU