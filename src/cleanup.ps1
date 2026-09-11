#Requires -Version 5.1

Write-Output "Performing Cleanup..."

$null = Remove-Item -Path "$ScratchDisk\scratchdir" -Recurse -Force
$null = Remove-Item -Path "$ScratchDisk\imo11" -Recurse -Force

Write-Output "Cleanup check :"
if (Test-Path -Path "$ScratchDisk\imo11") {
    Write-Output "imo11 folder still exists. Attempting to remove it again..."
    Remove-Item -Path "$ScratchDisk\imo11" -Recurse -Force -ErrorAction Continue
    if (Test-Path -Path "$ScratchDisk\imo11") {
        Write-Output "Failed to remove imo11 folder."
    } else {
        Write-Output "imo11 folder removed successfully."
    }
} else {
    Write-Output "imo11 folder does not exist. No action needed."
}
if (Test-Path -Path "$ScratchDisk\scratchdir") {
    Write-Output "scratchdir folder still exists. Attempting to remove it again..."
    Remove-Item -Path "$ScratchDisk\scratchdir" -Recurse -Force -ErrorAction Continue
    if (Test-Path -Path "$ScratchDisk\scratchdir") {
        Write-Output "Failed to remove scratchdir folder."
    } else {
        Write-Output "scratchdir folder removed successfully."
    }
} else {
    Write-Output "scratchdir folder does not exist. No action needed."
}