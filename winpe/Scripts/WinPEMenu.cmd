@echo off
cls
SETLOCAL EnableDelayedExpansion

for %%d in (C D E F G H I J K L M N O P Q T U V Y Z) do (
if exist %%d:\sources\install.wim set "IMAGE_FILE=%%d:\sources\install.wim"
if exist %%d:\sources\install.esd set "IMAGE_FILE=%%d:\sources\install.esd"
if exist %%d:\$WinPEDriver$ set "WINPE_FOLDER=%%d:\$WinPEDriver$"
if exist %%d:\$OfflineDriver$ set "OFFLINE_FOLDER=%%d:\$OfflineDriver$"
)
if not defined IMAGE_FILE echo Could not locate install.wim or install.esd. & pause & exit /b 1

rem Install drivers from $WinPEDriver$ folder
if defined WINPE_FOLDER (
for /R %WINPE_FOLDER% %%f IN (*.inf) do drvload.exe "%%f"
)

set "options[1]=Y" && set "options[2]=N"

:MENU
color
cls
echo.
echo [1] - Apply .wim file
echo __________________________
echo.
echo [2] - Open new CMD Window
echo [3] - Troubleshoot
echo __________________________
echo.
echo [R] - Reboot
echo [S] - Shutdown
echo.
rem https://stackoverflow.com/a/148991
choice /c 123RS /n /m "Select Option: "
set errlvl=%errorlevel%
if %errlvl%==5 goto :SHUTDOWN
if %errlvl%==4 goto :REBOOT
if %errlvl%==3 goto :TROUBLESHOOT
if %errlvl%==2 goto :NEWWIN
if %errlvl%==1 goto :APPLYWIM
if %errlvl%==0 goto :MENU

:APPLYWIM
echo.
echo Apply-Image.bat "%IMAGE_FILE%"
call Apply-Image.bat "%IMAGE_FILE%" || goto :MENU
rem https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-driver-servicing-command-line-options-s14?view=windows-11#add-driver
if defined WINPE_FOLDER dism.exe /Add-Driver /Image:W:\ /Driver:"%WINPE_FOLDER%" /Recurse /ForceUnsigned
if defined OFFLINE_FOLDER (
dism.exe /Add-Driver /Image:W:\ /Driver:"%OFFLINE_FOLDER%" /Recurse /ForceUnsigned && echo.
) else if defined WINPE_FOLDER ( echo. ) 
pause
goto :MENU

:NEWWIN
rem https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-input-locales-for-windows-language-packs?view=windows-11#input-locales
start CMD /K "echo Run the following command to set keyboard layout && echo    wpeutil.exe SetKeyboardLayout Input_locale && echo. && echo Examples && echo    wpeutil.exe SetKeyboardLayout it-IT && echo    wpeutil.exe SetKeyboardLayout 0410:00000409 && echo."
goto :MENU

:TROUBLESHOOT
call Troubleshoot.cmd
goto :MENU

:REBOOT
wpeutil.exe reboot

:SHUTDOWN
rem https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/wpeutil-command-line-options?view=windows-11#shutdown
wpeutil.exe Shutdown
