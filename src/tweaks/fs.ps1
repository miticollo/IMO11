#Requires -Version 5.1

Write-Output "Disable 8dot3 name creation on all volumes on the system"
# https://github.com/cschneegans/unattend-generator/issues/418#issuecomment-4644118805
Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Control\FileSystem' -ValueName 'NtfsDisable8dot3NameCreation' -Type 'REG_DWORD' -Data '1'

Write-Output "Enable long paths"
# Disables the default path length limit
Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Control\FileSystem' -ValueName 'LongPathsEnabled' -Type 'REG_DWORD' -Data '1'