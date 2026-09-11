#Requires -Version 5.1

Write-Output "Turn off automatic updates and upgrades completely"
# https://devblogs.microsoft.com/windows-music-dev/take-control-of-windows-updates-on-your-windows-11-daw-pc/#how-to-completely-turn-off-automtic-updates-and-upgrades
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -ValueName 'NoAutoUpdate' -Type 'REG_DWORD' -Data '1'

Write-Output "Receive updates for other Microsoft products when you update Windows"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -ValueName 'AllowMUUpdateService' -Type 'REG_DWORD' -Data '1'

Write-Output "Allow Automatically Download Updates over Metered Connections"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -ValueName 'AllowAutoWindowsUpdateDownloadOverMeteredNetwork' -Type 'REG_DWORD' -Data '1'

Write-Output "Notify me when a restart is required to finish updating"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -ValueName 'RestartNotificationsAllowed2' -Type 'REG_DWORD' -Data '1'

Write-Output "Turn off Delivery Optimization (DO)"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings' -ValueName 'DownloadMode' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\DoSvc' -ValueName 'Start' -Type 'REG_DWORD' -Data '3'

Write-Output "Don't Offer Malicious Software Reporting Tool (MSRT) through Windows Update AutoUpdate"
# https://support.microsoft.com/en-us/topic/deploy-windows-malicious-software-removal-tool-in-an-enterprise-environment-kb891716-a10cc756-2b3b-32e3-9ee3-2c1298ea3538#ID0EDX
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\MRT' -ValueName 'DontOfferThroughWUAU' -Type 'REG_DWORD' -Data '1'

Write-Output "Disable safeguards for Feature Updates"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -ValueName 'DisableWUfBSafeguards' -Type 'REG_DWORD' -Data '1'