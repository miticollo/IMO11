#Requires -Version 5.1

Write-Output "Dism servicing options"
# https://forums.mydigitallife.net/threads/even-with-telemetry-disabled-windows-10-talks-to-dozens-of-microsoft-servers.68065/page-5#post-1206508

reg load HKLM\zSOFTWARE $ScratchDisk\scratchdir\Windows\System32\config\SOFTWARE

$key = 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing'
reg_own "$key" -user S-1-1-0
# https://forums.mydigitallife.net/threads/how-to-disable-features-with-payload-removed-for-windows-11.86848/#post-1804712
Set-RegistryValue "$key" -ValueName 'DisableRemovePayload' -Type 'REG_DWORD' -Data '0'
# Remove non-inherited rules from Everyone
reg_own "$key" -user S-1-1-0 -recurse Delete

$key = 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\SideBySide\Configuration'
reg_own "$key" -user S-1-1-0
# control superseded components, 3 = delta compress: https://forums.mydigitallife.net/threads/windows-10-hotfix-repository.57050/page-621#post-1655472
Set-RegistryValue "$key" -ValueName 'SupersededActions' -Type 'REG_DWORD' -Data '3'
Set-RegistryValue "$key" -ValueName 'DisableResetbase' -Type 'REG_DWORD' -Data '0'
reg_own "$key" -user S-1-1-0 -recurse Delete

reg unload HKLM\zSOFTWARE