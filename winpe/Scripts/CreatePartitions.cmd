<!-- : Begin batch script
@echo off
if not exist X:\Windows\System32 (echo ERROR: This script is built to run in Windows PE. &goto :EOF)
if "%1" neq "0x2" if "%1" neq "0x1" (
echo ERROR: To run this script, pass 0x1 for BIOS mode or 0x2 for UEFI mode.
echo Example: CreatePartitions 0x2
goto :EOF
)

set "_csa=cscript.exe //NoLogo //Job:DiskAssert "%~nx0?.wsf""
:START
set "partitioning="
set "disk="
set "win_size="
set "output="
color
cls
echo Discovering disks...
for /f "skip=7 usebackq delims=" %%l in (`echo LIST DISK ^| diskpart.exe`) do if /i not "%%l"=="DISKPART> " for /f "tokens=2" %%d in ("%%l") do echo %%d | findstr /R "[0-9]" >nul && (%_csa% %%d && set "output=!output!^&echo.%%l" || break) || set "output=!output!^&echo.%%l"
cls
rem https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/echo#:~:text=If%20there's%20an,echo:%var%
echo:%output%
(echo:%output% | findstr /R "[0-9]") >nul || (color 4F & timeout /t 3 /nobreak >nul & exit /b 1)
echo.
set /p disk="Select Disk: "
%_csa% %disk% || (color 4F & echo The disk you specified is not valid. & timeout /t 2 /nobreak >nul & goto :START)
echo SELECT DISK=%disk% > %TMP%\DiskPartScript.txt
:SHOW_VOLUMES
echo.
for /f "skip=9 delims=" %%l in ('^(echo SELECT DISK=%disk% ^&^& echo DETAIL DISK ^&^& echo LIST PARTITION^) ^| diskpart.exe ^| findstr /n "^"') do (
set "line=%%l"
setlocal EnableDelayedExpansion
set "line=!line:*:=!"
if defined line (if "DISKPART> " neq "!line!" echo(!line!
) else echo.
ENDLOCAL
)
echo [C] - CLEAN ^& Initialize DISK=%disk%
echo [P] - Partitioning...
echo [G] - Go back to select another disk
echo.
choice /c CPG /n /m "Select Option: "
set errlvl=%errorlevel%
if %errlvl%==3 goto :START
if %errlvl%==2 goto :SYS_PARTITION
if %errlvl%==1 goto :CLEAN_INIT
if %errlvl%==0 goto :SHOW_VOLUMES
:CLEAN_INIT
set "partitioning=y"
echo CLEAN >> %TMP%\DiskPartScript.txt
if "%1" == "0x2" echo CONVERT GPT >> %TMP%\DiskPartScript.txt

:SYS_PARTITION
echo.
if "%1" == "0x2" choice /c YN /m "Do you want to create an EFI partition"
if "%1" == "0x1" choice /c YN /m "Do you want to create a System partition"
set "sys_partition=!options[%errorlevel%]!"
if /i "%sys_partition%" == "Y" (
set "partitioning=y"
if "%1" == "0x2" (
echo.
set "efi_size=100"
rem https://forums.mydigitallife.net/threads/windows-8-1-update-1-wimboot-discussion.52931/page-9#post-906059
echo 1. If primary drive is less than 16GB, you can use a minimum size of 32 MB.
echo 2. If the primary drive is an Advanced Format 4K Native ^(4Kn^) drive ^(4-KB-per sector^),
echo    the minimum size is 260 MB. See also https://superuser.com/a/1310938
echo ======================================================================================
set /p efi_size="Size in MB for the EFI partition [ENTER = !efi_size! MB]: "
echo CREATE PARTITION EFI SIZE=!efi_size! >> %TMP%\DiskPartScript.txt
echo FORMAT FS=FAT32 LABEL="System" QUICK >> %TMP%\DiskPartScript.txt
echo ASSIGN LETTER="S" >> %TMP%\DiskPartScript.txt
goto :MSR
)
if "%1" == "0x1" (
echo CREATE PARTITION PRIMARY SIZE=100 >> %TMP%\DiskPartScript.txt
echo FORMAT FS=NTFS LABEL="System" QUICK >> %TMP%\DiskPartScript.txt
echo ASSIGN LETTER="S" >> %TMP%\DiskPartScript.txt
echo ACTIVE >> %TMP%\DiskPartScript.txt
goto :WIN_PARTITION
)
)
if /i "%sys_partition%" == "N" (
if "%1" == "0x2" (
echo Skipping EFI partition
goto :MSR
)
if "%1" == "0x1" (
echo Skipping System partition
goto :WIN_PARTITION
)
)
goto :SYS_PARTITION

:MSR
echo.
echo Do you want to create a Microsoft Reserved (MSR) partition?
echo    (If you're not sure, type Y).
choice /c YN /n /m "(Y or N): "
if "%errorlevel%" == "0" goto :MSR
set "MSR=!options[%errorlevel%]!"
if /i %MSR%.==y. (
echo CREATE PARTITION MSR SIZE=16 >> %TMP%\DiskPartScript.txt 
set "partitioning=y"
) else echo Skipping MSR partition

:WIN_PARTITION
echo.
choice /c YN /m "Do you want to create a Windows partition"
if "%errorlevel%" == "0" goto :WIN_PARTITION
set "win_partition=!options[%errorlevel%]!"
if /i "%win_partition%" == "Y" (
set "partitioning=y"
echo.
set /p win_size="Size in MB for the Windows partition [ENTER = full disk]: "
if "!win_size!" == "" (
echo The partition continues until there is no more unallocated space in the current region!
echo CREATE PARTITION PRIMARY >> %TMP%\DiskPartScript.txt
) else echo CREATE PARTITION PRIMARY SIZE=!win_size! >> %TMP%\DiskPartScript.txt
echo FORMAT FS=NTFS LABEL="Windows" QUICK >> %TMP%\DiskPartScript.txt
echo ASSIGN LETTER="W" >> %TMP%\DiskPartScript.txt
)
if /i %win_partition%==N echo Skipping Windows partition

echo.
if DEFINED partitioning (
type %TMP%\DiskPartScript.txt
echo.
echo CAUTION: All the data on the disk will be DELETED.
:RUN_DISKPART
choice /c YN /m "Erase all data and continue"
if "!errorlevel!" == "0" goto :RUN_DISKPART
call set "READY=%%options[!errorlevel!]%%"
if /i !READY!.==N. goto :START
diskpart /s %TMP%\DiskPartScript.txt
if !ERRORLEVEL! neq 0 (
color 4F
timeout /t 5 /nobreak >nul
goto :START
)
echo.
) else (
echo NO PARTITIONING ACTIONS!
echo.
rem TODO(miticollo): Handle volume selection
)
goto :EOF

rem https://learn.microsoft.com/en-us/previous-versions/windows/desktop/mscs/creating-a-cluster-automation-server-script
----- Begin wsf script --->
<package>
 <job id="DiskAssert">
  <script language="VBScript">
    On Error Resume Next

    'https://learn.microsoft.com/en-us/windows/win32/wmisdk/document-conventions-for-the-scripting-api
    strComputer = "."
    
    'https://learn.microsoft.com/en-us/windows/win32/wmisdk/constructing-a-moniker-string
    'https://learn.microsoft.com/en-us/windows/win32/wmisdk/describing-the-location-of-a-wmi-object
    'https://learn.microsoft.com/en-us/windows/win32/wmisdk/retrieving-an-instance#:~:text=To%20retrieve%20an%20instance%20of%20a%20WMI%20class%20using%20VBScript
    'https://learn.microsoft.com/en-us/previous-versions/visualstudio/visual-studio-2008/e9waz863(v=vs.90)
    'https://learn.microsoft.com/en-us/windows/win32/wmisdk/swbemservices#:~:text=you%20can%20use%20the%20VBScript%20GetObject%20function
    Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

    'https://learn.microsoft.com/en-us/windows/win32/wmisdk/describing-the-location-of-a-wmi-object#script
    'https://learn.microsoft.com/en-us/windows/win32/wmisdk/swbemservices-get
    'https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-diskdrive
    'https://learn.microsoft.com/en-us/windows/win32/wmisdk/key-qualifier
    'https://stackoverflow.com/a/47670274
    Set objDisk = objWMIService.Get("Win32_DiskDrive.DeviceID='\\.\PHYSICALDRIVE" & WScript.Arguments(0) & "'")

    If Err.Number <> 0 Then
        WScript.Quit 1
    End If
	
    strInterface = objDisk.InterfaceType
    If strInterface <> "SCSI" And strInterface <> "IDE" Then
        WScript.Quit 1
    End If
    WScript.Quit 0
  </script>
 </job>
</package>