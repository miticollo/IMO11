@echo off
if not exist X:\Windows\System32 (echo ERROR: This script is built to run in Windows PE. &goto :EOF)

CLS
REM https://www.ilsoftware.it/focus/requisiti-windows-11-che-non-possono-essere-superati-per-installazione-e-aggiornamento/#requisiti-cpu-avanzati-di-windows-11-popcnt-e-sse4-2
Coreinfo64.exe -ACCEPTEULA -f -nobanner > %TMP%\cpu_flags.txt 2>&1
more %TMP%\cpu_flags.txt | find /v "x86-64-v2" | find "SSE4.2" | find "*" > nul
if "%errorlevel%" == "1" (color 4F & echo ERROR: This CPU doesn't support SSE4.2 instruction. & timeout /t 5 /nobreak >nul & exit /b 1)
more %TMP%\cpu_flags.txt | find /v "x86-64-v2" | find "POPCNT" | find "*" > nul
if "%errorlevel%" == "1" (color 4F & echo ERROR: This CPU doesn't support POPCNT instruction. & timeout /t 5 /nobreak >nul & exit /b 1)

if %1.==. (
echo ERROR: To run this script, add a path to a Windows image file.
echo Example: ApplyImage D:\WindowsWithFrench.wim
goto :EOF
)
echo *********************************************************************
echo Checking to see the type of image being deployed
if "%~x1" == ".wim" goto :WIM
if "%~x1" == ".esd" goto :ESD
echo *********************************************************************
if not "%~x1" == ".esd". if not "%~x1" == ".wim" echo Please use this script with a WIM or ESD image.
if not "%~x1" == ".esd". if not "%~x1" == ".wim" goto :EOF
:ESD
:WIM
echo Starting WIM Deployment
echo *********************************************************************
echo Checking to see if the PC is booted in BIOS or UEFI mode.
wpeutil UpdateBootInfo
rem https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/wpeutil-command-line-options?view=windows-11#updatebootinfo
for /f "tokens=2* delims=	 " %%A in ('reg query HKLM\System\CurrentControlSet\Control /v PEFirmwareType') do set Firmware=%%B
echo            Note: delims is a TAB followed by a space.
if x%Firmware%==x echo ERROR: Can't figure out which firmware we're on.
if x%Firmware%==x echo        Common fix: In the command above:
if x%Firmware%==x echo             for /f "tokens=2* delims=    "
if x%Firmware%==x echo        ...replace the spaces with a TAB character followed by a space.
if x%Firmware%==x goto :EOF
if %Firmware%==0x1 echo The PC is booted in BIOS mode. & set "F_PARAM=BIOS" & set "STORE=boot"
if %Firmware%==0x2 echo The PC is booted in UEFI mode. & set "F_PARAM=UEFI" & set "STORE=EFI\Microsoft\Boot"
echo *********************************************************************
echo CreatePartitions.cmd %Firmware%
call CreatePartitions.cmd %Firmware% || exit /b 1
echo *********************************************************************
echo  == Apply the image to the Windows partition ==
:EA
echo Does this image include Extended Attributes?
echo    (If you're not sure, type N).
choice /c YN /n /m "(Y or N): "
if "%errorlevel%" == "0" (echo. & goto :EA)
if /i "!options[%errorlevel%]!"=="Y" set "EA_PARAM=/EA"
rem /Compact: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/compact-os?view=windows-11#compact-os
rem Compact OS is NOT recommended on rotational devices
dism /Apply-Image /ImageFile:%1 /Index:1 /ApplyDir:W:\ /Compact /CheckIntegrity /Verify %EA_PARAM% || ( echo dism.exe encountered an error. & pause & exit /b 1 )
echo *********************************************************************
echo == Copy boot files to the System partition ==
if %Firmware%==0x2 (
    :COPY_BOOT
    echo Should the Windows Boot Manager firmware entry be added last?
    echo    (If you're not sure, type N^).
    choice /c YN /n /m "(Y or N): "
    if "!errorlevel!" == "0" (echo. & goto :COPY_BOOT)
    call set "addlast=%%options[!errorlevel!]%%"
)
if /i %addlast%.==y. set "ADDLAST_PARAM=/addlast"
bcdboot W:\Windows /l it-it /s S: /f %F_PARAM% /v %ADDLAST_PARAM% || ( echo bcdboot.exe encountered an error. & pause & exit /b 1 )
bcdedit /store S:\%STORE%\BCD /set {default} bootmenupolicy legacy
echo *********************************************************************
echo == Strip 8.3 file names ==
fsutil.exe 8dot3name strip /s /f W:\
echo *********************************************************************
rem https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/jj647767(v=ws.11)#using-manage-bde-with-operating-system-volumes
manage-bde -status W:
echo *********************************************************************
rem Avoid creation of recovery partition
rem https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/reagentc-command-line-options?view=windows-11#info-usage
REAGENTC.EXE /info /target W:\Windows
echo *********************************************************************
echo      All done!