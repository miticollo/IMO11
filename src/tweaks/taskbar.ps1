#Requires -Version 5.1

Write-Output "Hide the search on the taskbar"
# https://learn.microsoft.com/en-us/answers/questions/1726171/trying-to-hid-the-search-bar-for-all-users-using-r#question-answer1-1557418-moreThan
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Search' -ValueName 'SearchboxTaskbarMode' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Search' -ValueName 'SearchboxTaskbarModeCache' -Type 'REG_DWORD' -Data '0'

Write-Output "Disable Task View on Taskbar"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'ShowTaskViewButton' -Type 'REG_DWORD' -Data '0'

Write-Output "Set Taskbar to Align Left"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'TaskbarAl' -Type 'REG_DWORD' -Data '0'

Write-Output "Hide Emoji and More Icon on Taskbar System Tray"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\TabletTip\1.7' -ValueName 'EmojiAndMoreIconVisibilityState' -Type 'REG_DWORD' -Data '0'

Write-Output "Turn on Hidden icon menu"
New-ActiveSetupRegistryEntry 'reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v SystemTrayChevronVisibility /t REG_DWORD /d 1 /f' -Name 'Turn on Hidden icon menu'

Write-Output "Configure the applications pinned to the taskbar"
# https://learn.microsoft.com/en-us/windows/configuration/taskbar/pinned-apps?tabs=gpo&pivots=windows-11#deploy-the-taskbar-configuration
Set-RegistryValue 'HKLM\zNTUSER\Software\Policies\Microsoft\Windows\Explorer' -ValueName 'StartLayoutFile' -Type 'REG_EXPAND_SZ' -Data '%WINDIR%\OEM\TaskbarLayoutModification.xml'
Set-RegistryValue 'HKLM\zNTUSER\Software\Policies\Microsoft\Windows\Explorer' -ValueName 'LockedStartLayout' -Type 'REG_DWORD' -Data '1'