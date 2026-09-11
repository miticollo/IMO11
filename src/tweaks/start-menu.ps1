#Requires -Version 5.1

Write-Output "Hide recently added apps in Start"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Start' -ValueName 'ShowRecentList' -Type 'REG_DWORD' -Data '0'

Write-Output "Do not show recommendations for tips, shortcuts, new apps, and more in the Start Menu"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'Start_IrisRecommendations' -Type 'REG_DWORD' -Data '0'

Write-Output "Disable Start Menu popup on first logon"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'StartShownOnUpgrade' -Type 'REG_DWORD' -Data '1'

Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Start' -ValueName 'AllAppsViewMode' -Type 'REG_DWORD' -Data '2'

Write-Output "Remove Recommended section from Start Menu"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\Explorer' -ValueName 'HideRecommendedSection' -Type 'REG_DWORD' -Data '1'

#region Pinned section
    # https://forums.mydigitallife.net/threads/windows-11-start-menu-start2-bin-file-format-and-read-procedure.90291/
    # https://www.reddit.com/r/Windows11/s/cw0OElfts6
    # https://www.reddit.com/r/FuckMicrosoft/comments/1t9zolw/i_can_finally_modify_the_start_menu/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

    # https://learn.microsoft.com/en-us/windows/configuration/start/layout?tabs=intune-10%2Cgpo-11&pivots=windows-11#deploy-the-start-layout-configuration
    Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\Explorer' -ValueName 'ConfigureStartPins' -Type 'REG_DWORD' -Data '1'
    Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\Explorer' -ValueName 'ConfigureStartPinsJSON' -Type 'REG_EXPAND_SZ' -Data '%WINDIR%\OEM\LayoutModification.json'
#endregion

#region Power menu
    Write-Output "Shutdown Menu - Sleep - Disabled"
    Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings' -ValueName 'ShowSleepOption' -Type 'REG_DWORD' -Data '0'

    Write-Output "Shutdown Menu - Hibernate - Disabled"
    # ------> https://www.tenforums.com/tutorials/7445-add-remove-hibernate-power-menu-windows-10-a.html
    Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings' -ValueName 'ShowHibernateOption' -Type 'REG_DWORD' -Data '0'

    Write-Output "Shutdown Menu - Lock - Disabled"
    Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings' -ValueName 'ShowLockOption' -Type 'REG_DWORD' -Data '0'
#endregion