#Requires -Version 5.1

Write-Output "Restore Old Context Menu"
# Enables the classic right click context menu in Explorer on Windows 11
New-ActiveSetupRegistryEntry 'reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /f' -Name 'Restore Old Context Menu'

Write-Output "Add 'Terminals' to context menu"
# https://superuser.com/a/1202148
# https://forums.mydigitallife.net/threads/in-open-contextuel-menu.89508/#post-1886270
# https://forums.mydigitallife.net/threads/in-open-contextuel-menu.89508/#post-1886234
'Directory\background', 'Directory', 'Drive', 'LibraryFolder' | ForEach-Object -Process {
    Set-RegistryValue -KeyName "HKLM\zSOFTWARE\Classes\$_\shell\MenuCmd" -ValueName 'MUIVerb' -Type 'REG_SZ' -Data '@shell32.dll,-22022'
    Set-RegistryValue -KeyName "HKLM\zSOFTWARE\Classes\$_\shell\MenuCmd" -ValueName 'Icon' -Type 'REG_SZ' -Data 'cmd.exe'
    Set-RegistryValue -KeyName "HKLM\zSOFTWARE\Classes\$_\shell\MenuCmd" -ValueName 'ExtendedSubCommandsKey' -Type 'REG_SZ' -Data 'Directory\\ContextMenus\\MenuCmd'
}
Set-RegistryValue -KeyName 'HKLM\zSOFTWARE\Classes\Directory\ContextMenus\MenuCmd\shell\open' -ValueName 'MUIVerb' -Type 'REG_SZ' -Data '@shell32.dll,-8506'
Set-RegistryValue -KeyName 'HKLM\zSOFTWARE\Classes\Directory\ContextMenus\MenuCmd\shell\runas' -ValueName 'MUIVerb' -Type 'REG_SZ' -Data '@shell32.dll,-37444'
Set-RegistryValue -KeyName 'HKLM\zSOFTWARE\Classes\Directory\ContextMenus\MenuCmd\shell\runasTI' -ValueName 'MUIVerb' -Type 'REG_SZ' -Data 'Apri prompt dei comandi come &TrustedInstaller'
'runas', 'runasTI' | ForEach-Object -Process {
    Set-RegistryValue -KeyName "HKLM\zSOFTWARE\Classes\Directory\ContextMenus\MenuCmd\shell\$_" -ValueName 'HasLUAShield' -Type 'REG_SZ' # decoration
}
'open', 'runas', 'runasTI' | ForEach-Object -Process {
    Set-RegistryValue -KeyName "HKLM\zSOFTWARE\Classes\Directory\ContextMenus\MenuCmd\shell\$_" -ValueName 'Icon' -Type 'REG_SZ' -Data 'cmd.exe'
}
'open', 'runas' | ForEach-Object -Process {
    Set-RegistryValue -KeyName "HKLM\zSOFTWARE\Classes\Directory\ContextMenus\MenuCmd\shell\$_\command" -Type 'REG_SZ' -Data 'cmd.exe /s /k pushd "%V"'
}
Set-RegistryValue -KeyName "HKLM\zSOFTWARE\Classes\Directory\ContextMenus\MenuCmd\shell\runasTI\command" -Type 'REG_SZ' -Data 'powershell.exe -ep bypass -win 1 -nop -c iex((10..41|%%{(gp ''''Registry::HKCR\\RunAsTI'''' $_ -ea 0).$_})-join[char]10); # --%% cmd.exe /s /k pushd "%V"'

Write-Output "Remove 'Extract' from Context Menu"
'b8cdcb65-b1bf-4b42-9428-1dfdb7ee92af', 'BD472F60-27FA-11cf-B8B4-444553540000',
'D12E3394-DE4B-4777-93E9-DF0AC88F8584', 'EE07CEF5-3441-4CFB-870A-4002C724783A' | ForEach-Object -Process {
    Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -ValueName "{${_}}" -Type 'REG_SZ'
    Set-RegistryValue 'HKLM\zSOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -ValueName "{${_}}" -Type 'REG_SZ'
}

Write-Output "Add 'Edit' verb to .theme file type"
Set-RegistryValue 'HKLM\zSOFTWARE\Classes\themefile\shell\edit\command' -Type 'REG_EXPAND_SZ' -Data '%SystemRoot%\system32\notepad.exe "%1"'

# TODO(miticollo): Add 'Open' and 'Edit' verb to .mof file type
# https://learn.microsoft.com/en-us/windows/win32/wmisdk/managed-object-format--mof-

Write-Output 'Remove "Add to Favorites" Context Menu'
Set-RegistryValue -KeyName "HKLM\zSOFTWARE\Classes\*\shell\pintohomefile" -ValueName 'ProgrammaticAccessOnly' -Type 'REG_SZ'

Write-Output 'Debloat Send-To Context Menu'
$item = Get-Item -LiteralPath "$ScratchDisk\scratchdir\Users\Default\AppData\Roaming\Microsoft\Windows\SendTo\Compressed (zipped) Folder.ZFSendToTarget" -Force
$item.Attributes = $item.Attributes -bor [System.IO.FileAttributes]::Hidden

Write-Output "Remove Bitmap Image from 'New' Context Menu"
Remove-RegistryItem 'HKLM\zSOFTWARE\Classes\.bmp\ShellNew'