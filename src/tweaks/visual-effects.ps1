#Requires -Version 5.1

Write-Output "Disable transparency"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -ValueName 'EnableTransparency' -Type 'REG_DWORD' -Data '0'

# Open "Performance Options" dialog from CMD or Run: https://stackoverflow.com/a/2435452

Write-Output "Don't animate windows when minimizing and maximizing"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\AnimateMinMax' -ValueName 'DefaultValue' -Type 'REG_DWORD' -Data '0'

Write-Output "Disable Peek"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DWMAeroPeekEnabled' -ValueName 'DefaultValue' -Type 'REG_DWORD' -Data '0'

Write-Output "Don't animate controls and elements inside windows"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ControlAnimations' -ValueName 'DefaultValue' -Type 'REG_DWORD' -Data '0'

Write-Output "Don't fade or slide menus into view"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\MenuAnimation' -ValueName 'DefaultValue' -Type 'REG_DWORD' -Data '0'

Write-Output "Don't fade or slide ToolTips into view"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TooltipAnimation' -ValueName 'DefaultValue' -Type 'REG_DWORD' -Data '0'

Write-Output "Don't fade out menu items after clicking"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\SelectionFade' -ValueName 'DefaultValue' -Type 'REG_DWORD' -Data '0'

Write-Output "Hide shadows under mouse pointer"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\CursorShadow' -ValueName 'DefaultValue' -Type 'REG_DWORD' -Data '0'

Write-Output "Don't show thumbnails instead of icons"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ThumbnailsOrIcon' -ValueName 'DefaultValue' -Type 'REG_DWORD' -Data '0'

Write-Output "Hide shadows under windows"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DropShadow' -ValueName 'DefaultValue' -Type 'REG_DWORD' -Data '0'

Write-Output "Don't slide open combo boxes"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ComboBoxAnimation' -ValueName 'DefaultValue' -Type 'REG_DWORD' -Data '0'

Write-Output "Don't smooth-scroll list boxes"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListBoxSmoothScrolling' -ValueName 'DefaultValue' -Type 'REG_DWORD' -Data '0'

Write-Output "Don't show a translucent selection rectangle"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListviewAlphaSelect' -ValueName 'DefaultValue' -Type 'REG_DWORD' -Data '0'

Write-Output "Set custom performance options"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -ValueName 'VisualFXSetting' -Type 'REG_DWORD' -Data '3'

Write-Output "Disable animations in the taskbar"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TaskbarAnimations' -ValueName 'DefaultValue' -Type 'REG_DWORD' -Data '0'

Write-Output "Do not allow window animations"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\DWM' -ValueName 'DisallowAnimations' -Type 'REG_DWORD' -Data '1'