#Requires -Version 5.1

$wimFilePath = "$ScratchDisk\imo11\sources\boot.wim"

if (Test-Path -Path "$RootDir\win10\boot.wim") {
    Remove-Item -Path "$wimFilePath" -Force
    Copy-Item -Path "$RootDir\win10\boot.wim" -Destination "$wimFilePath"
}

Write-Output "Mounting boot image:"
$null = takeown '/F' "$wimFilePath" 2>&1
icacls "$wimFilePath" '/grant' "$($adminGroup.Value):(F)" 2>&1
Set-ItemProperty -Path $wimFilePath -Name IsReadOnly -Value $false
if (Test-Path -Path "$RootDir\win10\boot.wim") {
    $name = 'Microsoft Windows PE (x64)'
} else {
    $name = 'Microsoft Windows PE (amd64)'
}
Mount-WindowsImage -ImagePath $wimFilePath -Name "$name" -Path $ScratchDisk\scratchdir

if (Test-Path -Path "$RootDir\win10\*.cab") {
    $directory = 'win10'
} elseif (Test-Path -Path "$RootDir\LCU\*.msu") {
    $directory = 'LCU'
}
# -------------- Add cumulative update (CU) to boot image
# https://learn.microsoft.com/en-us/windows/deployment/customize-boot-image?tabs=command-line#step-7-add-cumulative-update-cu-to-boot-image
# https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/commercialization/iot-ent-customize-the-reference-device-in-audit-mode#download-an-update
If ($null -ne $directory) {
    Write-Output "Add Latest Cumulative Update (LCU) to boot image"
    try {
        Add-WindowsPackage -Path "$ScratchDisk\scratchdir" -PackagePath "$RootDir\$directory" -NoRestart
    } catch {
        $theError = $_
        Write-Output "$theError"

        If ($theError.Exception -like '*0x8007007e*') {
            Write-Output 'This failure is a known issue with combined cumulative update, we can ignore.'
        } ElseIf ($theError.Exception -like '*0x800f0823*') {
            Write-Output 'This failure is a known issue with combined cumulative update, we need to try install same package again'
            Write-Output 'Re-installing the cumulative update...'
            Add-WindowsPackage -Path "$ScratchDisk\scratchdir" -PackagePath "$RootDir\$directory" -NoRestart
            Start-Sleep 2
        } else {
            throw
        }
    }
}

# ------Copy startnet.cmd
Copy-Item -Path "$RootDir\winpe\startnet.cmd" -Destination "$RootDir\scratchdir\windows\system32\startnet.cmd" -Force

# -------------- Fix Target Path
dism "/Image:$ScratchDisk\scratchdir" '/Set-TargetPath:X:\' 2>&1

# -------------- Clean up and unmount
Write-Output "Loading registry..."
reg load HKLM\zSOFTWARE $ScratchDisk\scratchdir\Windows\System32\config\SOFTWARE

# limit or disable CBSPersist_*.log
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\SideBySide\Configuration' -ValueName 'NumCBSPersistLogs' -Type 'REG_DWORD' -Data '0'

Write-Output "Unmounting Registry..."
reg unload HKLM\zSOFTWARE

Write-Output "Optimize the Windows PE image"
dism.exe /Image:$ScratchDisk\scratchdir /NoRestart /Cleanup-Image /StartComponentCleanup /ResetBase 2>&1
Remove-Item -Path "$ScratchDisk\scratchdir\Windows\inf\setupapi.offline*.log" -ErrorAction Continue
Write-Output "Unmount the Windows PE image"
Dismount-WindowsImage -Path $ScratchDisk\scratchdir -Save

Write-Output "Export the Windows PE image to reduce wim size"

Export-WindowsImage -SourceImagePath "$wimFilePath" -SourceName "$name" -DestinationImagePath "$ScratchDisk\scratchdir\boot2.wim" -DestinationName 'Microsoft Windows PE (amd64)' -CompressionType 'max' -Setbootable
Remove-Item $wimFilePath -ErrorAction Continue
Move-Item -Path "$ScratchDisk\scratchdir\boot2.wim" -Destination "$wimFilePath"