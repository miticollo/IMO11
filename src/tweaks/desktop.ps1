#Requires -Version 5.1

Write-Output "Set the quality factor of the JPEG desktop wallpapers to maximum"
Set-RegistryValue 'HKLM\zNTUSER\Control Panel\Desktop' -ValueName 'JPEGImportQuality' -Type 'REG_DWORD' -Data '100'

#region Icons
    Write-Output "Show 'This PC' icon on Desktop"
    Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -ValueName '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Type 'REG_DWORD' -Data '0'

    Write-Output "Show 'Network' icon on Desktop"
    Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -ValueName '{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}' -Type 'REG_DWORD' -Data '0'

    Write-Output "Show desktop icons"
    Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'HideIcons' -Type 'REG_DWORD' -Data '0'

    Write-Output "Don't use drop shadows for icon labels on the desktop"
    Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListviewShadow' -ValueName 'DefaultValue' -Type 'REG_DWORD' -Data '0'
#endregion