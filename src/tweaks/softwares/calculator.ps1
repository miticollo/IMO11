#Requires -Version 5.1

Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Calc' -ValueName 'ShowHistory' -Type 'REG_DWORD' -Data '1'