#Requires -Version 5.1

Write-Output "Show clear logon background"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\System' -ValueName 'DisableAcrylicBackgroundOnLogon' -Type 'REG_DWORD' -Data '1'