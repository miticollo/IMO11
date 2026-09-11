#Requires -Version 5.1

# https://forums.mydigitallife.net/threads/which-windows-10-services-you-guys-disable.75202/page-3#post-1382080

Write-Output "Add 'open' verb to Windows Photo Viewer"
Set-RegistryValue 'HKLM\zSOFTWARE\Classes\Applications\photoviewer.dll\shell\open' -ValueName 'MuiVerb' -Type 'REG_SZ' -Data '@photoviewer.dll,-3043'
Set-RegistryValue 'HKLM\zSOFTWARE\Classes\Applications\photoviewer.dll\shell\open\command' -Type 'REG_EXPAND_SZ' -Data '%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1'
Set-RegistryValue 'HKLM\zSOFTWARE\Classes\Applications\photoviewer.dll\shell\open\DropTarget' -ValueName 'Clsid' -Type 'REG_SZ' -Data '{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}'

Write-Output "Add 'open' verb to default (old) ProgIds for File Association with Windows Photo Viewer"
$('jpeg', 'pjpeg', 'png', 'gif', 'wdp', 'dds' | ForEach-Object -Process {"${_}file"}) + 'Paint.Picture' | ForEach-Object -Process {
    Set-RegistryValue "HKLM\zSOFTWARE\Classes\$_\shell\open" -ValueName 'MuiVerb' -Type 'REG_EXPAND_SZ' -Data '@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043'
    Set-RegistryValue "HKLM\zSOFTWARE\Classes\$_\shell\open\command" -Type 'REG_EXPAND_SZ' -Data '%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1'
    Set-RegistryValue "HKLM\zSOFTWARE\Classes\$_\shell\open\DropTarget" -ValueName 'Clsid' -Type 'REG_SZ' -Data '{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}'
}

# TODO(miticollo): dng