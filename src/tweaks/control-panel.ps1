#Requires -Version 5.1

Write-Output "Set the Control Panel icons view"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel' -ValueName 'AllItemsIconView' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel' -ValueName 'StartupPage' -Type 'REG_DWORD' -Data '1'