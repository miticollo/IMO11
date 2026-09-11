#Requires -Version 5.1

<#
.NOTES
    Author:  Lorenzo Ferron
    Twitter: @miticollo

.LINK
    https://github.com/abbodi1406/BatUtil/blob/master/Tel_W10_Block/W10-Block.cmd

.LINK
    https://forums.mydigitallife.net/threads/windows-8-1-services-performance-thread.53153/page-2#post-1375467

.LINK
    https://forums.mydigitallife.net/threads/which-windows-10-services-you-guys-disable.75202/#post-1375431
#>

# Xbox Live Game Save (removes the entire folder and all tasks within it)
schtasks /Change /DISABLE /TN "\Microsoft\XblGameSave\XblGameSaveTask"
schtasks /Delete /F /TN "\Microsoft\XblGameSave\XblGameSaveTask"

# Program Data Updater
schtasks /Change /DISABLE /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
schtasks /Delete /F /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater"

# Windows Error Reporting (QueueReporting)
schtasks /Change /DISABLE /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
schtasks /Delete /F /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting"

schtasks /Change /DISABLE /TN "\Microsoft\Windows\Speech\SpeechModelDownloadTask"
schtasks /Delete /F /TN "\Microsoft\Windows\Speech\SpeechModelDownloadTask"

SCHTASKS /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /DISABLE

SCHTASKS /Change /TN "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /DISABLE

SCHTASKS /Change /TN "Microsoft\Windows\RecoveryEnvironment\VerifyWinRE" /DISABLE

# https://learn.microsoft.com/en-us/windows/win32/winsat/windows-system-assessment-tool-portal#purpose
SCHTASKS /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /DISABLE

# https://www.hexacorn.com/blog/2025/11/16/1-or-more-little-secrets-of-disksnapshot-exe/
# options :j:v:d:o:cisuepzk?h
SCHTASKS /Change /TN "Microsoft\Windows\DiskFootprint\Diagnostics" /DISABLE

# https://learn.microsoft.com/en-us/windows/apps/develop/launch/web-to-app-linking#test-in-a-local-validation-tool
SCHTASKS /Change /TN "Microsoft\Windows\ApplicationData\appuriverifierdaily" /DISABLE
SCHTASKS /Change /TN "Microsoft\Windows\ApplicationData\appuriverifierinstall" /DISABLE

# https://ntlite.com/community/threads/data-integrity-scan-causes-the-firewall-to-not-work.4735/post-46096
SCHTASKS /Change /TN "Microsoft\Windows\Data Integrity Scan\Data Integrity Scan" /DISABLE
SCHTASKS /Change /TN "Microsoft\Windows\Data Integrity Scan\Data Integrity Scan for Crash Recovery" /DISABLE

# Why does it REG QUERY AllowTelemetry?
SCHTASKS /Change /TN "Microsoft\Windows\Device Information\Device" /DISABLE

SCHTASKS /Change /TN "Microsoft\Windows\Maps\MapsUpdateTask" /DISABLE

# https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/dn789160(v=ws.11)#how-storage-tiers-optimize-performance
SCHTASKS /Change /TN "Microsoft\Windows\Storage Tiers Management\Storage Tiers Optimization" /DISABLE

SCHTASKS /Change /TN "Microsoft\Windows\WindowsUpdate\Scheduled Start" /DISABLE

#region Task Scheduler > Customer Experience Program
    # Application Compatibility Appraiser
    schtasks /Change /DISABLE /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
    schtasks /Delete /F /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
    schtasks /Change /DISABLE /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser Exp"
    schtasks /Delete /F /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser Exp"

    # Customer Experience Improvement Program (removes the entire folder and all tasks within it)
    schtasks /Change /DISABLE /TN "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM"
    schtasks /Change /DISABLE /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
    schtasks /Change /DISABLE /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
    schtasks /Change /DISABLE /TN "\Microsoft\Windows\Customer Experience Improvement Program\TelTask"
    schtasks /Change /DISABLE /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
    schtasks /Delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM"
    schtasks /Delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
    schtasks /Delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
    schtasks /Delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\TelTask"
    schtasks /Delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"

    schtasks /Change /DISABLE /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
    schtasks /Delete /F /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"

    # Chkdsk Proxy
    schtasks /Change /DISABLE /TN "\Microsoft\Windows\Chkdsk\Proxy"
    schtasks /Delete /F /TN "\Microsoft\Windows\Chkdsk\Proxy"
#endregion