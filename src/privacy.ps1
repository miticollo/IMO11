#Requires -Version 5.1

Write-Output 'Change the feedback frequency to "Never"'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Siuf\Rules' -ValueName 'NumberOfSIUFInPeriod' -Type 'REG_DWORD' -Data '0'

Write-Output "Don't let websites show me locally relevant content by accessing my language list"
# It is a common fingerprinting technique to identify a user by their languages
New-ActiveSetupRegistryEntry 'reg.exe add "HKCU\Control Panel\International\User Profile" /v HttpAcceptLanguageOptOut /t REG_DWORD /d 1 /f' -Name "Don''t let websites show me locally relevant content by accessing my language list"

Write-Output "Disable pre-release features or settings"
# ------> If you disable this policy setting, all experimentations will be turned off.
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\PreviewBuilds' -ValueName 'EnableConfigFlighting' -Type 'REG_DWORD' -Data '0'

Write-Output "Disable communication with the Experimentation and Configuration Service"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\EdgeUpdate' -ValueName 'UpdaterExperimentationAndConfigurationServiceControl' -Type 'REG_DWORD' -Data '0'

# Clear virtual memory pagefile (see unattend.xml)
# Systems that are configured to allow booting to other operating systems might have to
# make sure that the system pagefile is wiped clean when this system shuts down. This
# ensures that sensitive information from process memory that might go into the pagefile
# is not available to an unauthorized user who manages to directly access the pagefile.

Write-Output "Disallow search and Cortana to use location"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\Windows Search' -ValueName 'AllowSearchToUseLocation' -Type 'REG_DWORD' -Data '0'

Write-Output "Disable improve inking and typing recognition:"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\input\TIPC' -ValueName 'Enabled' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Input\TIPC' -ValueName 'Enabled' -Type 'REG_DWORD' -Data '0'

Write-Output "Don't communicate with unpaired devices"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync' -ValueName 'Value' -Type 'REG_SZ' -Data 'Deny'

Write-Output "Turn off KMS Client Online AVS Validation"
# Turns off Key Management System (KMS) client online AVS validation, which prevents
# from sending data to Microsoft regardless of its activation state, for privacy.
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform' -ValueName 'NoGenTicket' -Type 'REG_DWORD' -Data '1'

Write-Output "Do not let apps use voice activiation when device is locked"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps' -ValueName 'AgentActivationOnLockScreenEnabled' -Type 'REG_DWORD' -Data '0'

Write-Output "Turn off caching of thumbnail pictures"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -ValueName 'NoThumbnailCache' -Type 'REG_DWORD' -Data '1'

Write-Output "Disable Remote Assistance"
# As Remote Assistance is an unused and a potential vulnerable feature, it is disabled
# https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-remoteassistance-exe-fallowfullcontrol#values
Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Control\Remote Assistance' -ValueName 'fAllowFullControl' -Type 'REG_DWORD' -Data '0'
# https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-remoteassistance-exe-fenablechatcontrol#values

Write-Output "Turn off handwriting personalization data sharing"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\TabletPC' -ValueName 'PreventHandwritingDataSharing' -Type 'REG_DWORD' -Data '1'

Write-Output "Do not use diagnostic data for tailored experiences"
Set-RegistryValue 'HKLM\zNTUSER\Software\Policies\Microsoft\Windows\CloudContent' -ValueName 'DisableTailoredExperiencesWithDiagnosticData' -Type 'REG_DWORD' -Data '1'

#region Telemetry
    Write-Output "Disallow Telemetry and Data Collection"
    # GPOMinimumTelemetryLevel
    Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\DataCollection' -ValueName 'AllowTelemetry' -Type 'REG_DWORD' -Data '0'
    # MinimumTelemetryLevel
    Set-RegistryValue 'HKLM\zSYSTEM\Setup\FirstBoot\PostOobe' -ValueName '00' -Type 'REG_SZ' -Data 'cmd.exe /c reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f'
    # IntuneMinimumTelemetryLevel
    # https://techcommunity.microsoft.com/blog/intunecustomersuccess/troubleshooting-windows-feature-updates-in-microsoft-intune/4401828#:~:text=AllowTelemetry_PolicyManager
    Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\DataCollection' -ValueName 'AllowTelemetry_PolicyManager' -Type 'REG_DWORD' -Data '0'
    Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\AllowTelemetry' -ValueName 'Value' -Type 'REG_DWORD' -Data '0'

    Write-Output "Disallow device name to be sent in Windows diagnostic data"
    Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\DataCollection' -ValueName 'AllowDeviceNameInTelemetry' -Type 'REG_DWORD' -Data '0'

    Write-Output "Disables .NET CLI telemetry for privacy"
    # https://learn.microsoft.com/en-us/dotnet/core/tools/telemetry
    Set-RegistryValue 'HKLM\zNTUSER\Environment' -ValueName 'DOTNET_CLI_TELEMETRY_OPTOUT' -Type 'REG_SZ' -Data '1'

    Write-Output "Disable diagnostic data opt-in settings"
    # If devices in your organization are running Windows 10, 1803 and later, the user
    # can still use Settings to set the diagnostic data setting to a more restrictive
    # value, unless the Configure diagnostic data opt-in settings user interface policy
    # is set.
    Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\DataCollection' -ValueName 'DisableTelemetryOptInSettingsUx' -Type 'REG_DWORD' -Data '1'

    Write-Output "Disable Windows Error Reporting"
    # https://learn.microsoft.com/en-us/windows/win32/wer/wer-settings
    Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\Windows Error Reporting' -ValueName 'Disabled' -Type 'REG_DWORD' -Data '1' # -eq Disable-WindowsErrorReporting
    Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\WerSvc' -ValueName 'Start' -Type 'REG_DWORD' -Data '4'

    Write-Output "Disable PerfTrack"
    # If you do not configure this policy setting, the DPS will enable Windows Performance
    # PerfTrack by default: responsiveness events are processed and aggregated. The aggregated
    # data will be transmitted to Microsoft through SQM.
    Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}' -ValueName 'ScenarioExecutionEnabled' -Type 'REG_DWORD' -Data '0'

    Write-Output "Turn off Windows Customer Experience Improvement Program (CEIP)"
    # https://learn.microsoft.com/en-us/windows/win32/devnotes/ceipenable#change-method
    # https://learn.microsoft.com/en-us/windows/configuration/unified-write-filter/uwfexclusions#customer-experience-improvement-program-ceip
    Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\SQMClient\Windows' -ValueName 'CEIPEnable' -Type 'REG_DWORD' -Data '0'

    Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\TelemetryController' -ValueName 'Oobe' -Type 'REG_DWORD' -Data '0'
#endregion