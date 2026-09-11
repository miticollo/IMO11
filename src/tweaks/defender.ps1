#Requires -Version 5.1

Write-Output "Configure local setting override for reporting Microsoft MAPS"
# Enable this setting, the local preference setting will take priority over Group Policy
# https://learn.microsoft.com/en-us/defender-endpoint/enable-cloud-protection-microsoft-defender-antivirus#turn-on-cloud-protection-on-individual-clients-with-the-windows-security-app
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows Defender\Spynet' -ValueName 'LocalSettingOverrideSpynetReporting' -Type 'REG_DWORD' -Data '1'

Write-Output "Hide the Account Protection page in Defender"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows Security Health\State' -ValueName 'AccountProtection_MicrosoftAccount_Disconnected' -Type 'REG_DWORD' -Data '0'