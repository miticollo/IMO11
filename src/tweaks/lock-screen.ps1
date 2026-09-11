#Requires -Version 5.1

#TODO(miticollo): Disable the lock screen background picture on the sign-in screen

Write-Output "Do not display the lock screen"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\Personalization' -ValueName 'NoLockScreen' -Type 'REG_DWORD' -Data '1'