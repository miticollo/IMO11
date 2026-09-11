#Requires -Version 5.1

# https://www.catalog.update.microsoft.com/Faq.aspx#HowToSearch

Write-Output "Do not include drivers with Windows Update"
# https://learn.microsoft.com/en-us/windows/deployment/windows-autopatch/manage/windows-autopatch-driver-and-firmware-update-programmatic-controls#policies-that-exclude-drivers-from-windows-update-for-a-device
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -ValueName 'ExcludeWUDriversInQualityUpdate' -Type 'REG_DWORD' -Data '1'

Write-Output "Prevent automatic download of applications associated with device metadata"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata' -ValueName 'PreventDeviceMetadataFromNetwork' -Type 'REG_DWORD' -Data '1'

Write-Output "Download over metered connections"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\DeviceSetup' -ValueName 'CostedNetworkPolicy' -Type 'REG_DWORD' -Data '1'

Write-Output "Specify search order for device driver source locations"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\DriverSearching' -ValueName 'SearchOrderConfig' -Type 'REG_DWORD' -Data '0'