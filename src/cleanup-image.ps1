#Requires -Version 5.1

Write-Output "Cleaning up image..."

# https://forums.mydigitallife.net/threads/windows-10-hotfix-repository.57050/page-419#post-1533353
# https://forums.mydigitallife.net/threads/windows-10-hotfix-repository.57050/page-418#post-1532957
dism.exe /Image:"$ScratchDisk\scratchdir" /NoRestart /Cleanup-Image /StartComponentCleanup 2>&1
# https://discord.com/channels/@me/1546608606449766600/1547021066491265094
dism.exe /Image:"$ScratchDisk\scratchdir" /NoRestart /Cleanup-Image /StartComponentCleanup /ResetBase 2>&1

# %WINDIR%\Logs\DISM\dism.log -> Further logs for driver related operations
Remove-Item -Path "$ScratchDisk\scratchdir\Windows\inf\setupapi.offline*.log"

reg load HKLM\zSOFTWARE $ScratchDisk\scratchdir\Windows\System32\config\SOFTWARE
$key = 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\SideBySide\Configuration'
reg_own "$key" -user S-1-1-0
Set-RegistryValue "$key" -ValueName 'DisableResetbase' -Type 'REG_DWORD' -Data '1'
reg_own "$key" -user S-1-1-0 -recurse Delete
reg unload HKLM\zSOFTWARE

Write-Output "Cleanup complete."