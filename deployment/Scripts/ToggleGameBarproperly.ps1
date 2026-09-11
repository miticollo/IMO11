#Requires -Version 5.1

# https://github.com/AveYo/Gaming/blob/main/ToggleGameBarproperly.bat

$GameBarPresenceWriter="$env:systemroot\System32\systray.exe"
$key='HKLM:\SOFTWARE\Microsoft\WindowsRuntime\Server\Windows.Gaming.GameBar.Internal.PresenceWriterServer'
if (test-path $key) {
    Set-ItemProperty -Path $key -Name 'ExePath' -Value $GameBarPresenceWriter -Force -ea 0
}

if (test-path 'HKLM:\SOFTWARE\Classes\PackagedCom\ClassIndex\{FD06603A-2BDF-4BB1-B7DF-5DC68F353601}') {
    $GameBarFTServer='systray.exe'
    $app=(Get-ChildItem 'HKLM:\SOFTWARE\Classes\PackagedCom\ClassIndex\{FD06603A-2BDF-4BB1-B7DF-5DC68F353601}').PSChildName
    $key="HKLM:\SOFTWARE\Classes\PackagedCom\Package\$app\Server\0"
    if (test-path $key) {
        Set-ItemProperty -Path $key -Name 'Executable' -Value $GameBarFTServer -Force -ea 0
    }
}

## stop processes
'GameBar','GamebarPresenceWriter','GameBarFTServer' | ForEach-Object -Process { Stop-Process -Force -Name $_ -ea 0 }