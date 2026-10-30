#Requires -Version 5.1

Write-Output 'Display the recycle bin files delete confirmation dialog'
# https://github.com/farag2/Sophia-Script-for-Windows/blob/0e83ca4d317899b6be511e2dda17b068df6bfb3c/src/Sophia_Script_for_Windows_11_LTSC_2024/Module/Sophia.psm1#L1734-L1792
New-ActiveSetupRegistryEntry 'powershell -ep unrestricted -nop -c "$b=''''HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'''';$a=gpv $b ShellState;$a[4]=$a[4]-band-bnot4;New-ItemProperty $b ShellState -Type Binary -Value $a -Force"' -Name 'Display the recycle bin files delete confirmation dialog'

Write-Output "Disable Snap Layouts"
'SnapAssist', 'EnableSnapAssistFlyout', 'EnableSnapBar', 'EnableTaskGroups' | ForEach-Object -Process {
    Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName "$_" -Type 'REG_DWORD' -Data '0'
}

Write-Output "Disallow Cortana"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\Windows Search' -ValueName 'AllowCortana' -Type 'REG_DWORD' -Data '0'

Write-Output "Don't let Windows app run in the background"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -ValueName 'LetAppsRunInBackground' -Type 'REG_DWORD' -Data '2'

Write-Output "Turn off all Windows spotlight features"
# Windows Spotlight provides lockscreen messages like 'Like what you see?', and are
# disabled to minimize network traffic from target devices
Set-RegistryValue 'HKLM\zNTUSER\Software\Policies\Microsoft\Windows\CloudContent' -ValueName 'DisableWindowsSpotlightFeatures' -Type 'REG_DWORD' -Data '1'
Write-Output "Do not suggest third-party content in Windows spotlight"
Set-RegistryValue 'HKLM\zNTUSER\Software\Policies\Microsoft\Windows\CloudContent' -ValueName 'DisableThirdPartySuggestions' -Type 'REG_DWORD' -Data '1'

Write-Output "Disable OneSettings Downloads"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\DataCollection' -ValueName 'DisableOneSettingsDownloads' -Type 'REG_DWORD' -Data '1'

Write-Output "Do not show Windows tips"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\CloudContent' -ValueName 'DisableSoftLanding' -Type 'REG_DWORD' -Data '1'

# TODO(miticollo): Do not use my sign-in info to automatically finish setting up after an update

Write-Output "Disable Windows Platform Binary Table Execution (WPBT)"
# Disables WPBT with an undocumented Registry value, which is an ACPI table in your
# firmware to execute a program each boot of Windows such as unwanted OEM bloatware.
#
# https://github.com/Jamesits/dropWPBT
# https://download.microsoft.com/download/8/A/2/8A2FB72D-9B96-4E2D-A559-4A27CF905A80/windows-platform-binary-table.docx
Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Control\Session Manager' -ValueName 'DisableWpbtExecution' -Type 'REG_DWORD' -Data '1'

Write-Output "Turn off Bluetooth"
Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\bthserv\Parameters\BluetoothControlPanelTasks' -ValueName 'State' -Type 'REG_DWORD' -Data '0'

Write-Output "Do not allow Automatic Update of Speech Data"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Speech' -ValueName 'AllowSpeechModelUpdate' -Type 'REG_DWORD' -Data '0'

#region Maps
    Write-Output "Don't update automatically maps"
    Set-RegistryValue 'HKLM\zSYSTEM\Maps' -ValueName 'AutoUpdateEnabled' -Type 'REG_DWORD' -Data '0'

    Write-Output "Turn off unsolicited network traffic on the Offlice Maps settings page"
    Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\Maps' -ValueName 'AllowUntriggeredNetworkTrafficOnSettingsPage' -Type 'REG_DWORD' -Data '0'
#endregion

Write-Output "Configure Crash Control"
Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Control\CrashControl' -ValueName 'DisplayParameters' -Type 'REG_DWORD' -Data '1'

Write-Output "Allow Online Tips"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -ValueName 'AllowOnlineTips' -Type 'REG_DWORD' -Data '0'
