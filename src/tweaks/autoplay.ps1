#Requires -Version 5.1

Write-Output "Configure AutoPlay"
'UserChosenExecuteHandlers', 'EventHandlersDefaultSelection' | ForEach-Object -Process {
    Set-RegistryValue -KeyName "HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\$_\StorageOnArrival" -Type 'REG_SZ' -Data 'MSPromptEachTime'
    Set-RegistryValue -KeyName "HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\$_\CameraAlternate\ShowPicturesOnArrival" -Type 'REG_SZ' -Data 'MSPromptEachTime'
    Set-RegistryValue -KeyName "HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\$_\PlayDVDMovieOnArrival" -Type 'REG_SZ' -Data 'MSPromptEachTime'
    Set-RegistryValue -KeyName "HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\$_\PlayEnhancedDVDOnArrival" -Type 'REG_SZ' -Data 'MSPromptEachTime'
    Set-RegistryValue -KeyName "HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\$_\HandleDVDBurningOnArrival" -Type 'REG_SZ' -Data 'MSTakeNoAction'
    Set-RegistryValue -KeyName "HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\$_\PlayDVDAudioOnArrival" -Type 'REG_SZ' -Data 'MSPromptEachTime'
    Set-RegistryValue -KeyName "HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\$_\PlayBluRayOnArrival" -Type 'REG_SZ' -Data 'MSPromptEachTime'
    Set-RegistryValue -KeyName "HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\$_\HandleBDBurningOnArrival" -Type 'REG_SZ' -Data 'MSTakeNoAction'
    Set-RegistryValue -KeyName "HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\$_\PlayCDAudioOnArrival" -Type 'REG_SZ' -Data 'MSPromptEachTime'
    Set-RegistryValue -KeyName "HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\$_\PlayEnhancedCDOnArrival" -Type 'REG_SZ' -Data 'MSPromptEachTime'
    Set-RegistryValue -KeyName "HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\$_\HandleCDBurningOnArrival" -Type 'REG_SZ' -Data 'MSTakeNoAction'
    Set-RegistryValue -KeyName "HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\$_\PlayVideoCDMovieOnArrival" -Type 'REG_SZ' -Data 'MSPromptEachTime'
    Set-RegistryValue -KeyName "HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\$_\PlaySuperVideoCDMovieOnArrival" -Type 'REG_SZ' -Data 'MSPromptEachTime'
    Set-RegistryValue -KeyName "HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\$_\AutorunINFLegacyArrival" -Type 'REG_SZ' -Data 'MSPromptEachTime'
}