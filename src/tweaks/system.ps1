#Requires -Version 5.1

Write-Output "Hide messages when Windows system requirements are not met"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -ValueName 'HideUnsupportedHardwareNotifications' -Type 'REG_DWORD' -Data '1'

Write-Output "Disabling Reserved Storage:"
# https://techcommunity.microsoft.com/blog/windows-itpro-blog/managing-reserved-storage-in-windows-10-environments/1297070
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager' -ValueName 'ShippedWithReserves' -Type 'REG_DWORD' -Data '0'

Write-Output "Disable by policy BitLocker automatic device encryption"
# https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-bitlocker#disable-bitlocker-automatic-device-encryption
# https://support.microsoft.com/en-us/windows/device-encryption-in-windows-cf7e2b6f-3e70-4882-9532-18633605b7df#ID0EDD
Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Control\BitLocker' -ValueName 'PreventDeviceEncryption' -Type 'REG_DWORD' -Data '1'

Write-Output "Allow MS accounts"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -ValueName 'NoConnectedUser' -Type 'REG_DWORD' -Data '0'

Write-Output "Remove Shortcut Text"
# Removes '- Shortcut' text appended onto the end of shortcuts for QoL
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates' -ValueName 'ShortcutNameTemplate' -Type 'REG_SZ' -Data '"%s.lnk"'

Write-Output "Improve Legacy Print Dialog startup"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Print\UnifiedPrintDialog' -ValueName 'PreferLegacyPrintDialog' -Type 'REG_DWORD' -Data '1'

Write-Output "Enable Clipboard History"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Clipboard' -ValueName 'EnableClipboardHistory' -Type 'REG_DWORD' -Data '1'

Write-Output 'В загрузочном меню по F8 восстановлен пункт "Last Known Good Configuration"'
# http://www.monkrus.ws/2025/10/windows-11-v25h2-rus-eng-20in1-hwid-act.html
Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Control\Session Manager\Configuration Manager\LastKnownGood' -ValueName 'Enabled' -Type 'REG_DWORD' -Data '1'

Write-Output "Limit reservable bandwidth"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\Psched' -ValueName 'NonBestEffortLimit' -Type 'REG_DWORD' -Data '0'

#region Power Settings
    Write-Output "Disable Fast Startup"
    # https://learn.microsoft.com/en-us/windows-hardware/test/assessments/onoff-transition-performance#effect-of-fast-startup-on-boot-performance
    # https://learn.microsoft.com/en-us/windows/configuration/unified-write-filter/hibernate-once-resume-many-horm#how-to-disable-fast-startup
    Set-RegistryValue 'HKEY_LOCAL_MACHINE\zSYSTEM\ControlSet001\Control\Session Manager\Power' -ValueName 'HiberbootEnabled' -Type 'REG_DWORD' -Data '0'

    Write-Output "Disable the hibernate feature"
    # https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/compact-os?view=windows-11#ram-pagefilesys-and-hiberfilsys
    #
    # A hiberfile (Hiberfil.sys) is a file that the operating system creates when the
    # computer enters hibernate mode. When the computer is turned on, Windows uses this
    # file to return the system to its pre-hibernate state.
    Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Control\Power' -ValueName 'HibernateEnabled' -Type 'REG_DWORD' -Data '0'
    # Zero Hibernation File
    Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Control\Power' -ValueName 'HiberFileSizePercent' -Type 'REG_DWORD' -Data '0'
#endregion