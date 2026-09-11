#Requires -Version 5.1

Write-Output "Configure 7-Zip options"
Set-RegistryValue 'HKLM\zNTUSER\Software\7-Zip\FM' -ValueName 'Editor' -Type 'REG_SZ' -Data 'notepad.exe'
# Show ".."item
Set-RegistryValue 'HKLM\zNTUSER\Software\7-Zip\FM' -ValueName 'ShowDots' -Type 'REG_DWORD' -Data '0'
# Show real file icons
Set-RegistryValue 'HKLM\zNTUSER\Software\7-Zip\FM' -ValueName 'ShowRealFileIcons' -Type 'REG_DWORD' -Data '1'
# Single-click to open an item
Set-RegistryValue 'HKLM\zNTUSER\Software\7-Zip\FM' -ValueName 'SingleClick' -Type 'REG_DWORD' -Data '0'
# Alternative selection mode
Set-RegistryValue 'HKLM\zNTUSER\Software\7-Zip\FM' -ValueName 'AlternativeSelection' -Type 'REG_DWORD' -Data '0'
# Full row select
Set-RegistryValue 'HKLM\zNTUSER\Software\7-Zip\FM' -ValueName 'FullRow' -Type 'REG_DWORD' -Data '1'
# Show system menu
Set-RegistryValue 'HKLM\zNTUSER\Software\7-Zip\FM' -ValueName 'ShowSystemMenu' -Type 'REG_DWORD' -Data '1'
# Show grid lines
Set-RegistryValue 'HKLM\zNTUSER\Software\7-Zip\FM' -ValueName 'ShowGrid' -Type 'REG_DWORD' -Data '0'
# Context Menu items
Set-RegistryValue 'HKLM\zNTUSER\Software\7-Zip\Options' -ValueName 'ContextMenu' -Type 'REG_DWORD' -Data '3221239095'

Set-RegistryValue 'HKLM\zNTUSER\Software\7-Zip\Extraction' -ValueName 'ShowPassword' -Type 'REG_DWORD' -Data '1'