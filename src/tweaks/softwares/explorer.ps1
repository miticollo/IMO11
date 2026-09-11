#Requires -Version 5.1

Write-Output "Do not group files and folder in the Downloads folder"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -ValueName 'ColumnList' -Type 'REG_SZ' -Data 'System.Null'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -ValueName 'GroupBy' -Type 'REG_SZ' -Data 'System.Null'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -ValueName 'LogicalViewMode' -Type 'REG_DWORD' -Data '1'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -ValueName 'Name' -Type 'REG_SZ' -Data 'NoName'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -ValueName 'Order' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -ValueName 'PrimaryProperty' -Type 'REG_SZ' -Data 'System.ItemNameDisplay'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -ValueName 'SortByList' -Type 'REG_SZ' -Data 'prop:System.ItemNameDisplay'

Write-Output "Don't show encrypted or compressed NTFS files in color (only for Windows XP)"
# https://winaero.com/show-compressed-encrypted-files-color-windows-10/#comment-56691
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'ShowCompColor' -Type 'REG_DWORD' -Data '0'

Write-Output "Allow all uppercase names (only for Windows 98)"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'DontPrettyPath' -Type 'REG_DWORD' -Data '1'

Write-Output "Show pop-up description for folder and desktop items"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'ShowInfoTip' -Type 'REG_DWORD' -Data '1'

Write-Output "Use Windows classic folders (only for Windows XP)"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'WebView' -Type 'REG_DWORD' -Data '0'

Write-Output "Disable check boxes in File Explorer to select items"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'AutoCheckSelect' -Type 'REG_DWORD' -Data '0'

Write-Output "Always show icons, never thumbnails"
# or "Show thumbnails instead of icons" in Performance Options
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'IconsOnly' -Type 'REG_DWORD' -Data '1'

Write-Output "Show status bar"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'ShowStatusBar' -Type 'REG_DWORD' -Data '1'

Write-Output "Configure File Explorer to open to This PC instead of Quick Access"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'LaunchTo' -Type 'REG_DWORD' -Data '1'

Write-Output "Hide recent items in Quick Access for privacy"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer' -ValueName 'ShowRecent' -Type 'REG_DWORD' -Data '0'

Write-Output "Hide frequent items in Quick Access for privacy"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer' -ValueName 'ShowFrequent' -Type 'REG_DWORD' -Data '0'

Write-Output "Display file icon on thumbnails"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'ShowTypeOverlay' -Type 'REG_DWORD' -Data '0'

Write-Output "Show hidden files, folders, and drive"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'Hidden' -Type 'REG_DWORD' -Data '1'

Write-Output "Show empty drives"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'HideDrivesWithNoMedia' -Type 'REG_DWORD' -Data '0'

Write-Output "Show extensions for known file types"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'HideFileExt' -Type 'REG_DWORD' -Data '0'

Write-Output "Show folder merge conflicts"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'HideMergeConflicts' -Type 'REG_DWORD' -Data '0'

Write-Output "Show hide protected operating system files"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'ShowSuperHidden' -Type 'REG_DWORD' -Data '1'

Write-Output "Hide preview handlers in preview pane"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'ShowPreviewHandlers' -Type 'REG_DWORD' -Data '1'

Write-Output "Disable Automatic Folder Discovery"
# Improves performance in File Explorer by not automatically determining the folder 'type' (such as pictures) for each folder's content.
# ------> Disabling it fixes the 'folder always loading' issue when a folder contains a lot of media files.
# ------> https://www.windowslatest.com/2024/03/04/windows-11-can-open-big-folders-in-file-explorer-faster-if-you-turn-off-folder-discovery/
New-ActiveSetupRegistryEntry 'reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType /t REG_SZ /d NotSpecified /f' -Name 'Disable Automatic Folder Discovery'

Write-Output "Hide Gallery in File Explorer"
# Hides the new 23H2 'Gallery' in File Explorer for viewing pictures
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}' -ValueName 'HiddenByDefault' -Type 'REG_DWORD' -Data '1'
Set-RegistryValue 'HKLM\zSOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}' -ValueName 'HiddenByDefault' -Type 'REG_DWORD' -Data '1'

Write-Output "Show More Details by Default on Transfers"
# Shows more details by default on file transfers such as exact speed of files copying,
# moving, deleting, etc.
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager' -ValueName 'EnthusiastMode' -Type 'REG_DWORD' -Data '1'

Write-Output "Remove CD Burning features"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -ValueName 'NoCDBurning' -Type 'REG_DWORD' -Data '1'

#region  Ribbon
    Write-Output "Restore Classic File Explorer with Ribbon"
    New-ActiveSetupRegistryEntry 'reg.exe add "HKCU\Software\Classes\CLSID\{2aa9162e-c906-4dd9-ad0b-3d24a8eef5a0}\InProcServer32" /ve /t REG_SZ /d "-" /f' -Name 'Restore Classic File Explorer with Ribbon'
    New-ActiveSetupRegistryEntry 'reg.exe add "HKCU\Software\Classes\CLSID\{6480100b-5a83-4d1e-9f69-8ae5a88e9a33}\InProcServer32" /ve /t REG_SZ /d "-" /f' -Name 'Restore Classic File Explorer with Ribbon'
    Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Internet Explorer\Toolbar\ShellBrowser' -ValueName 'ITBar7Layout' -Type 'REG_BINARY' -Data '13000000000000000000000020000000100001000000000001000000010700005e01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'

    Write-Output "Minimize the ribbon when File Explorer is opened the first time"
    Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\Explorer' -ValueName 'ExplorerRibbonStartsMinimized' -Type 'REG_DWORD' -Data '3'
#endregion