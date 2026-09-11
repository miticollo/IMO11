#Requires -Version 5.1

Write-Output "Disable autocorrect misspelled words"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\TabletTip\1.7' -ValueName 'EnableAutocorrection' -Type 'REG_DWORD' -Data '0'

Write-Output "Disable typing insights"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Input\Settings' -ValueName 'InsightsEnabled' -Type 'REG_DWORD' -Data '0'

Write-Output "Don't show the voice typing mic button"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\input\Settings' -ValueName 'IsVoiceTypingKeyEnabled' -Type 'REG_DWORD' -Data '0'

Write-Output "Disable switch input languages"
New-ActiveSetupRegistryEntry 'reg.exe add "HKCU\Keyboard Layout\Toggle" /v Hotkey /t REG_SZ /d 3 /f' -Name 'Disable switch input languages'
New-ActiveSetupRegistryEntry 'reg.exe add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_SZ /d 3 /f' -Name 'Disable switch input languages'

Write-Output "Disable switch keyboard layout"
New-ActiveSetupRegistryEntry 'reg.exe add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_SZ /d 3 /f' -Name 'Disable switch keyboard layout'

Write-Output "Disable Narrator shortcut"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Narrator\NoRoam' -ValueName 'WinEnterLaunchEnabled' -Type 'REG_DWORD' -Data '0'

Write-Output "Disable custom inking and typing dictionary"
# ------> https://www.tenforums.com/tutorials/118127-turn-off-inking-typing-personalization-windows-10-a.html
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization' -ValueName 'Value' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\InputPersonalization' -ValueName 'RestrictImplicitInkCollection' -Type 'REG_DWORD' -Data '1'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\InputPersonalization' -ValueName 'RestrictImplicitTextCollection' -Type 'REG_DWORD' -Data '1'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\InputPersonalization\TrainedDataStore' -ValueName 'HarvestContacts' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Personalization\Settings' -ValueName 'AcceptedPrivacyPolicy' -Type 'REG_DWORD' -Data '0'