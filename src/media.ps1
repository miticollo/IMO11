#Requires -Version 5.1

Write-Output "Performing final cleanup of installation folder root..."
$isoRoot = "$ScratchDisk\imo11"
$keepList = @('boot', 'efi', 'sources', 'bootmgr', 'bootmgr.efi')
Get-ChildItem -Path "$isoRoot" | Where-Object Name -NotIn $keepList | ForEach-Object -Process {
    Write-Output "Removing non-essential file/folder from ISO root: $($_.Name)"
    Remove-Item -Path $_.FullName -Recurse -Force
}
$keepList = @('boot.wim', 'install.esd', 'Scripts')
Get-ChildItem -Path "$isoRoot\sources" | Where-Object Name -NotIn $keepList | ForEach-Object -Process {
    Write-Output "Removing non-essential file/folder from ISO sources: $($_.Name)"
    Remove-Item -Path $_.FullName -Recurse -Force
}

Write-Output "Creating ISO image..."
New-Iso "$ScratchDisk\imo11" "$RootDir\imo11.iso"