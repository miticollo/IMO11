#Requires -Version 5.1

# https://learn.microsoft.com/en-us/windows-server/remote/remote-desktop-services/remote-desktop-services-vdi-optimize-configuration#system-services
# https://forums.mydigitallife.net/threads/which-windows-10-services-you-guys-disable.75202/page-4#post-1507722
# https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize/services

Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\dmwappushservice' -ValueName 'Start' -Type 'REG_DWORD' -Data '4'

Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack' -ValueName 'DiagTrackStatus' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\DiagTrack' -ValueName 'Start' -Type 'REG_DWORD' -Data '4'
Remove-RegistryItem 'HKLM\zSYSTEM\ControlSet001\Control\WMI\AutoLogger\Diagtrack-Listener'
# === View diagnostic data - Off
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey' -ValueName 'EnableEventTranscript' -Type 'REG_DWORD' -Data '0'

# NFC SEManagement Service DLL
Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\SEMgrSvc' -ValueName 'Start' -Type 'REG_DWORD' -Data '4'

Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\DusmSvc' -ValueName 'Start' -Type 'REG_DWORD' -Data '4'

Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\W32Time' -ValueName 'Start' -Type 'REG_DWORD' -Data '2'

Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\WpcMonSvc' -ValueName 'Start' -Type 'REG_DWORD' -Data '4'

#region Xbox
    Write-Output "Disable Xbox Live:"
    # Xbox Accessory Management manages connected Xbox accessories.
    Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\XboxGipSvc' -ValueName 'Start' -Type 'REG_DWORD' -Data '4'
    # Xbox Live Auth Manager service provides authentication and authorization services
    # for interacting with Xbox Live.
    Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\XblAuthManager' -ValueName 'Start' -Type 'REG_DWORD' -Data '4'
    # Xbox Live Game Save service syncs save data for Xbox Live save enabled games.
    Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\XblGameSave' -ValueName 'Start' -Type 'REG_DWORD' -Data '4'
    # Xbox Live Networking Service
    Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\XboxNetApiSvc' -ValueName 'Start' -Type 'REG_DWORD' -Data '4'
    # Broadcast DVR User Service
    Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\BcastDVRUserService' -ValueName 'Start' -Type 'REG_DWORD' -Data '4'
    Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\UserServiceFlags' -ValueName 'Start' -Type 'REG_DWORD' -Data '0'
#endregion