#Requires -Version 5.1

Write-Output "Turn off Windows Mobility Center"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Policies\MobilityCenter' -ValueName 'NoMobilityCenter' -Type 'REG_DWORD' -Data '1'

Copy-Item -Path "$RootDir\deployment\finalize.bat" -Destination "$ScratchDisk\scratchdir\Users\Public\Desktop\finalize.bat" -Force
icacls "$ScratchDisk\scratchdir\Users\Public\Desktop\finalize.bat" /grant Everyone:d 2>&1

. "$PSScriptRoot\7zip.ps1"
. "$PSScriptRoot\photo-viewer.ps1"
. "$PSScriptRoot\msedge.ps1"
. "$PSScriptRoot\calculator.ps1"
. "$PSScriptRoot\cleanmgr.ps1"
. "$PSScriptRoot\adobe-reader.ps1"
. "$PSScriptRoot\explorer.ps1"