#Requires -Version 5.1

Write-Output "Disable new DMA devices when this computer is locked"
Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Control\PnP\Pci' -ValueName 'DisableExternalDMAUnderLock' -Type 'REG_DWORD' -Data '1'

Write-Output "Disable Wi-Fi Sense"
# https://learn.microsoft.com/en-us/troubleshoot/windows-client/networking/configure-wifi-sense-and-paid-wifi-service#summary
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config' -ValueName 'AutoConnectAllowedOEM' -Type 'REG_DWORD' -Data '0'

Write-Output "Turn off multicast name resolution"
# Disable Link-Local Multicast Name Resolution (LLMNR) protocol as it is vulnerable and has been replaced by DNS
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows NT\DNSClient' -ValueName 'EnableMulticast' -Type 'REG_DWORD' -Data '0'