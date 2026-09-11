#Requires -Version 5.1

Write-Output "Disables Windows Game Recording and Broadcasting"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\GameDVR' -ValueName 'AllowGameDVR' -Type 'REG_DWORD' -Data '0'

Write-Output "toggle Gamebar"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\GameDVR' -ValueName "AppCaptureEnabled" -Type 'REG_DWORD' -Data '0'