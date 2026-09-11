#Requires -Version 5.1

# https://networkdog.blogspot.com/2011/04/internet-explorer-9-configurations_12.html

Write-Output "Send Do Not Track requests to sites you visit in Internet Explorer"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Internet Explorer\Main' -ValueName 'DoNotTrack' -Type 'REG_DWORD' -Data '1'

Write-Output "Underline links: Never"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Internet Explorer\Main' -ValueName 'Anchor Underline' -Type 'REG_SZ' -Data 'no'