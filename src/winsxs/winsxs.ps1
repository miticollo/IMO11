#Requires -Version 5.1

. "$PSScriptRoot\dism.ps1"

#region Microsoft Edge
    Write-Output "Removing Edge:"
    # https://forums.mydigitallife.net/threads/abbodi1406s-batch-scripts-repo.74197/page-206#post-1910556
    # https://forums.mydigitallife.net/threads/25h2-uninstall-edge-with-command-lines.89751/#post-1893149
    DISM.exe "/Image:$ScratchDisk\scratchdir" /Remove-Edge 2>&1
#endregion

# Progress bar can significantly impact cmdlet performance
# https://github.com/PowerShell/PowerShell/issues/2138
$Global:ProgressPreference = "SilentlyContinue"

. "$PSScriptRoot\apps.ps1"
. "$PSScriptRoot\fod.ps1"
. "$PSScriptRoot\features.ps1"

# %WINDIR%\Logs\CBS\CBS.log
$key = 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\'

. "$PSScriptRoot\packages.ps1"
. "$PSScriptRoot\forced.ps1"
#. "$PSScriptRoot\mum.ps1"

Write-Output "Optimize installed apps"
Optimize-AppXProvisionedPackages -Path "$ScratchDisk\scratchdir"

$Global:ProgressPreference = "Continue"