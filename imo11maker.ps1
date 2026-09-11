#Requires -Version 5.1

<#
.SYNOPSIS
   Scripts to build a trimmed-down Windows 11 image.

.DESCRIPTION
   This is a script created to automate the build of a streamlined Windows 11 image, similar to tiny11.
   My main goal is to use only Microsoft utilities like DISM, and no utilities from external sources.

.PARAMETER ISO
   Drive letter given to the mounted ISO.

.PARAMETER SCRATCH
   Drive letter of the desired scratch disk.

.EXAMPLE
   PS> .\imo11maker.ps1 E D

.EXAMPLE
   PS> .\imo11maker.ps1 -ISO E -SCRATCH D

.EXAMPLE
   PS> .\imo11maker.ps1 -SCRATCH D -ISO E

.EXAMPLE
   PS> .\imo11maker.ps1

.NOTES
   Author : Various artists
   Date   : 09-10-26

.LINK
   https://learn.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services#how-to-configure-each-setting

.LINK
   https://learn.microsoft.com/en-us/windows/privacy/configure-windows-diagnostic-data-in-your-organization#use-group-policy-to-manage-diagnostic-data-collection

.LINK
   https://learn.microsoft.com/en-us/windows-server/remote/remote-desktop-services/remote-desktop-services-vdi-optimize-configuration#virtual-desktop-optimization-categories

.LINK
   https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/use-dism-in-windows-powershell-s14?view=windows-11

.LINK
   https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/09-functions?view=powershell-5.1

.LINK
   https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-null?view=powershell-5.1#isnotnullorempty

.LINK
   https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-null?view=powershell-5.1#assign-to-null

.LINK
   https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions?view=powershell-5.1#variable-substitution

.LINK
   https://github.com/PowerShell/PSScriptAnalyzer/blob/main/docs/Rules/README.md

.LINK
   https://github.com/MicrosoftDocs/PowerShell-Docs/blob/main/reference/5.1/Microsoft.PowerShell.Core/About/about_Comment_Based_Help.md

.LINK
    https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd

.LINK
    https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/rules/shouldprocess?view=ps-modules

.LINK
    https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-5.1#pscmdletshouldprocess

.LINK
    https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/types-of-cmdlet-parameters?view=powershell-5.1#positional-and-named-parameters

.LINK
    https://github.com/MicrosoftDocs/PowerShell-Docs/blob/main/reference/5.1/Microsoft.PowerShell.Core/About/about_Comments.md#code-editor-region-markers

.LINK
    https://github.com/MicrosoftDocs/PowerShell-Docs/blob/main/reference/5.1/Microsoft.PowerShell.Core/About/about_Requires.md#-version-nn

.LINK
    https://helgeklein.com/blog/active-setup-explained/

.LINK
    https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/add-a-custom-script-to-windows-setup

.LINK
    https://learn.microsoft.com/en-us/windows/win32/sysinfo/registry-value-types

.LINK
    https://learn.microsoft.com/en-us/windows/win32/setupapi/run-and-runonce-registry-keys

.LINK
    https://learn.microsoft.com/en-us/windows/win32/shell/fa-file-types#registering-a-file-type

.LINK
    https://learn.microsoft.com/en-us/windows/win32/shell/fa-sample-scenarios

.LINK
    https://learn.microsoft.com/en-us/windows/win32/shell/how-to-register-a-file-type-for-a-new-application

.LINK
    https://learn.microsoft.com/en-us/windows/win32/shell/fa-best-practices#always-wrap-expanding-strings-in-quotation-marks

.LINK
    https://forums.mydigitallife.net/threads/windows-11-imaging-customization-and-deployment.83749/page-4#post-1711733

.LINK
    https://learn.microsoft.com/en-us/troubleshoot/windows-client/performance/view-system-registry-with-64-bit-windows

.LINK
    https://learn.microsoft.com/en-us/sysinternals/downloads/procmon

.LINK
    https://learn.microsoft.com/en-us/windows/win32/winprog64/running-32-bit-applications#:~:text=Note%20that%2064-bit,ERROR_BAD_EXE_FORMAT

.LINK
    https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/capitalization-conventions#capitalization-rules-for-identifiers

.LINK
    https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/validatepattern-attribute-declaration?view=powershell-5.1

.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/set-variable?view=powershell-5.1#example-2-set-a-global-read-only-variable

.LINK
    https://learn.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-12?view=powershell-5.1#12314-the-validatepattern-attribute

.LINK
    https://learn.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-04?view=powershell-5.1#4264-regular-expression-option-type

.LINK
    https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/07-working-with-wmi?view=powershell-5.1

.LINK
    https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-identifiers#well-known-sids

.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-itempropertyvalue?view=powershell-5.1

.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/remove-variable?view=powershell-5.1#-name

.LINK
    https://learn.microsoft.com/en-us/powershell/module/dism/disable-windowsoptionalfeature?view=windowsserver2025-ps#-remove

.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/where-object?view=powershell-5.1

.LINK
    https://learn.microsoft.com/en-us/windows/win32/wmisdk/like-operator

.LINK
    https://stackoverflow.com/q/11246068

.LINk
    https://forums.mydigitallife.net/threads/windows-8-1-services-performance-thread.53153/page-3#post-1421384

.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-5.1#script-scope-and-dot-sourcing

.LINK
    https://learn.microsoft.com/windows/deployment/update/media-dynamic-update
#>

#---------[ Parameters ]---------#
param (
    [ValidatePattern('^[c-z]$', Options = 'IgnoreCase')]
    [string]$ISO,
    [ValidatePattern('^[c-z]$', Options = 'IgnoreCase')]
    [string]$SCRATCH
)

# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-5.1
# If any exception occurs it will stop the script execution or it will execute Catch
$erroractionPreference = "stop"
$Global:InformationPreference = 'Continue'

$RootDir = $PSScriptRoot -replace '[\\]+$', ''

# Ensures that Invoke-WebRequest uses TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (-not $SCRATCH) {
    $ScratchDisk = $RootDir
} else {
    $ScratchDisk = $SCRATCH + ":"
}

. "$PSScriptRoot\src\lib\functions.ps1"

#---------[ Execution ]---------#
$policy = Get-ExecutionPolicy -Scope Process
if ($policy -eq 'Restricted' -or $policy -eq 'AllSigned') {
    Write-Warning "Current execution policy ($policy) may prevent running this script."
    $response = $Host.UI.PromptForChoice('', 'Do you want to change it to RemoteSigned?', @('&Yes'; '&No'), 0)
    if ($response -eq 0) {
        Set-ExecutionPolicy RemoteSigned -Scope Process -Force
    } else {
        Write-Output "The script cannot be run without changing the execution policy. Exiting..."
        exit 1
    }
}

# Check and run the script as admin if required
$adminSID = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
$adminGroup = $adminSID.Translate([System.Security.Principal.NTAccount])
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
if (! $myWindowsPrincipal.IsInRole($adminRole))
{
    Write-Output "Restarting IMO11 image creator as admin in a new window, you can close this one."
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = "-ExecutionPolicy RemoteSigned -File `"$($myInvocation.MyCommand.Definition)`"";
    $newProcess.Verb = "runas";
    [System.Diagnostics.Process]::Start($newProcess);
    exit
}

# Start the transcript and prepare the window
Start-Transcript -Path "$PSScriptRoot\imo11_$(get-date -f yyyyMMdd_HHmms).log"

$Host.UI.RawUI.WindowTitle = "IMO11 image creator"
Clear-Host
Write-Output "Welcome to the IMO11 image creator! Release: 09-10-26"

do {
    if (-not $ISO) {
        $DriveLetter = Read-Host "Please enter the drive letter for the Windows 11 image"
    } else {
        $DriveLetter = $ISO
    }
    if ($DriveLetter -imatch '^[c-z]$') {
        $DriveLetter = $DriveLetter + ":"
        Write-Output "Drive letter set to $DriveLetter"
    } else {
        Write-Output "Invalid drive letter. Please enter a letter between C and Z."
    }
} while ($DriveLetter -notmatch '^[c-zC-Z]:$')

$null=New-Item -ItemType Directory -Force -Path "$ScratchDisk\imo11\sources"

if (-not ($(Test-Path "$DriveLetter\sources\boot.wim") -and $(Test-Path "$DriveLetter\sources\install.wim"))) {
    if (Test-Path "$DriveLetter\sources\install.esd") {
        Write-Output "Found install.esd, converting to install.wim..."
        Get-WindowsImage -ImagePath $DriveLetter\sources\install.esd
        $index = Read-Host "Please enter the image index"
        Write-Output ' '
        Write-Output 'Converting install.esd to install.wim. This may take a while...'
        Export-WindowsImage -SourceImagePath $DriveLetter\sources\install.esd -SourceIndex $index -DestinationImagePath $ScratchDisk\imo11\sources\install.wim -Compressiontype Maximum -CheckIntegrity
    } else {
        Write-Output "Can't find Windows OS Installation files in the specified Drive Letter.."
        Write-Output "Please enter the correct DVD Drive Letter.."
        exit
    }
}

Write-Output "Copying Windows image..."
$null = Copy-Item -Path "$DriveLetter\*" -Destination "$ScratchDisk\imo11" -Recurse -Force
Set-ItemProperty -Path "$ScratchDisk\imo11\sources\install.esd" -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue
Remove-Item "$ScratchDisk\imo11\sources\install.esd" -ErrorAction SilentlyContinue
Write-Output "Copy complete!"
Start-Sleep -Seconds 2
Write-Output "Ejecting Iso drive"
Get-Volume -DriveLetter $DriveLetter[0] | Get-DiskImage | Dismount-DiskImage
Write-Output "Iso drive ejected"
Clear-Host
Write-Output "Getting image information:"
$ImagesIndex = (Get-WindowsImage -ImagePath $ScratchDisk\imo11\sources\install.wim).ImageIndex
while ($ImagesIndex -notcontains $index) {
    Get-WindowsImage -ImagePath $ScratchDisk\imo11\sources\install.wim
    $index = Read-Host "Please enter the image index"
}
Write-Output "Mounting Windows image. This may take a while."
$wimFilePath = "$ScratchDisk\imo11\sources\install.wim"
takeown "/F" "$wimFilePath" 2>&1
icacls "$wimFilePath" "/grant" "$($adminGroup.Value):(F)" 2>&1
try {
    Set-ItemProperty -Path $wimFilePath -Name IsReadOnly -Value $false
} catch {
    # This block will catch the error and suppress it.
	Write-Error "$wimFilePath not found"
}
$null = New-Item -ItemType Directory -Force -Path "$ScratchDisk\scratchdir"
Mount-WindowsImage -ImagePath "$ScratchDisk\imo11\sources\install.wim" -Index $index -Path "$ScratchDisk\scratchdir"

$imageIntl = dism /English /Get-Intl /image:"$ScratchDisk\scratchdir"
$languageLine = $imageIntl -split '\n' | Where-Object { $_ -match 'Default system UI language : ([a-zA-Z]{2}-[a-zA-Z]{2})' }

if ($languageLine) {
    $languageCode = $Matches[1]
    Write-Output "Default system UI language code: $languageCode"
} else {
    Write-Output "Default system UI language code not found."
}

$Arch = dism /English /image:"$ScratchDisk\scratchdir" /Get-DriverInfo /driver:hal.inf | findstr Architecture
$Arch = $Arch.Split(':')[1]
$Arch = $Arch.Trim()
Write-Output "Architecture: $Arch"

Write-Output "Mounting complete!"

Set-WindowsEdition -Path "$ScratchDisk\scratchdir" -Edition 'IoTEnterpriseS'

# https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/commercialization/iot-ent-customize-the-reference-device-in-audit-mode#download-an-update
# aka.ms/WindowsTargetVersioninfo
# https://www.cobalt.io/blog/decoding-windows-cbs-manifests-reversing-the-dcm/pa30-delta-format
# https://forums.mydigitallife.net/threads/windows-10-hotfix-repository.57050/page-32#post-1109777
if (Test-Path -Path "$PSScriptRoot\LCU\*.msu") {
    Write-Output "Add Latest Cumulative Update (LCU) to system image"
    Add-WindowsPackage -Path "$ScratchDisk\scratchdir" -PackagePath "$PSScriptRoot\LCU" -NoRestart

    Write-Output 'Update ISO boot files bootmgr/efisys.bin from install.wim'
    # https://github.com/abbodi1406/BatUtil/blob/584c25fae3b5d67e3314c1303c537ab1ddceb17b/W10UI/W10UI.cmd#L2825-L2851
    Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\DVD\PCAT\BCD" -Destination "$ScratchDisk\imo11\boot\bcd" -Force
    Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\DVD\PCAT\boot.sdi" -Destination "$ScratchDisk\imo11\boot\boot.sdi" -Force
    Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\DVD\PCAT\etfsboot.com" -Destination "$ScratchDisk\imo11\boot\etfsboot.com" -Force
    Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\DVD\PCAT\$languageCode\bootfix.bin" -Destination "$ScratchDisk\imo11\boot\bootfix.bin" -Force
    $null = takeown '/F' "$ScratchDisk\imo11\boot\memtest.exe" 2>&1
    icacls "$ScratchDisk\imo11\boot\memtest.exe" '/grant' "$($adminGroup.Value):(F)" 2>&1
    Remove-Item "$ScratchDisk\imo11\boot\memtest.exe" -Force
    Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\DVD\EFI\BCD" -Destination "$ScratchDisk\imo11\efi\microsoft\boot\bcd" -Force
    if (Test-Path -Path "$ScratchDisk\scratchdir\Windows\Boot\DVD_EX\EFI\en-US\efisys_EX.bin") {
        Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\DVD_EX\EFI\en-US\efisys_EX.bin" -Destination "$ScratchDisk\imo11\efi\microsoft\boot\efisys.bin" -Force
        Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\DVD_EX\EFI\en-US\efisys_noprompt_EX.bin" -Destination "$ScratchDisk\imo11\efi\microsoft\boot\efisys_noprompt.bin" -Force
    } else {
        Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\DVD\EFI\en-US\efisys.bin" -Destination "$ScratchDisk\imo11\efi\microsoft\boot\efisys.bin" -Force
        Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\DVD\EFI\en-US\efisys_noprompt.bin" -Destination "$ScratchDisk\imo11\efi\microsoft\boot\efisys_noprompt.bin" -Force
    }
    # Copy boot.stl from boot.wim, even if it doesn't exist in the new media.
    # https://support.microsoft.com/en-US/servicing/os/windows-11/2026/08/kb5121003-windows-11-24h2-25h2-security-update#deployment
    Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\EFI\boot.stl" -Destination "$ScratchDisk\imo11\efi\microsoft\boot\boot.stl" -Force
    # Add/Update boot.pnd.stl to the iso media along with boot.stl
    Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\EFI\boot.pnd.stl" -Destination "$ScratchDisk\imo11\efi\microsoft\boot\boot.pnd.stl" -Force -ErrorAction SilentlyContinue
    if (Test-Path -Path "$ScratchDisk\scratchdir\Windows\Boot\EFI_EX\bootmgr_EX.efi") {
        Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\EFI_EX\bootmgr_EX.efi" -Destination "$ScratchDisk\imo11\bootmgr.efi" -Force
    } else {
        Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\EFI\bootmgr.efi" -Destination "$ScratchDisk\imo11\bootmgr.efi" -Force
    }
    if (Test-Path -Path "$ScratchDisk\scratchdir\Windows\Boot\EFI_EX\bootmgfw_EX.efi") {
        Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\EFI_EX\bootmgfw_EX.efi" -Destination "$ScratchDisk\imo11\efi\boot\bootx64.efi" -Force
    } else {
        Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\EFI\bootmgfw.efi" -Destination "$ScratchDisk\imo11\efi\boot\bootx64.efi" -Force
    }
    Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\EFI\memtest.efi" -Destination "$ScratchDisk\imo11\efi\microsoft\boot\memtest.efi" -Force
    Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\EFI\winsipolicy.p7b" -Destination "$ScratchDisk\imo11\efi\microsoft\boot\winsipolicy.p7b" -Force
    Remove-Item -Path "$ScratchDisk\imo11\efi\microsoft\boot\fonts\*.ttf" -Force
    if (Test-Path -Path "$ScratchDisk\scratchdir\Windows\Boot\Fonts_EX\*_EX.ttf") {
        Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\Fonts_EX\*.ttf" -Destination "$ScratchDisk\imo11\efi\microsoft\boot\fonts\" -Force
        Get-ChildItem -Path "$ScratchDisk\imo11\efi\microsoft\boot\fonts\*.ttf" | ForEach-Object -Process { Rename-Item -Path "$_" -NewName $_.Name.Replace('_EX', '') }
    } else {
        Copy-Item -Path "$ScratchDisk\scratchdir\Windows\Boot\Fonts\*.ttf" -Destination "$ScratchDisk\imo11\efi\microsoft\boot\fonts\" -Force
    }
}

. "$PSScriptRoot\src\winsxs\winsxs.ps1"

Write-Output "Removing WinRE:"
attrib -S -H -I "$ScratchDisk\scratchdir\Windows\System32\Recovery\winre.wim" 2>&1
Remove-Item -Path "$ScratchDisk\scratchdir\Windows\System32\Recovery\winre.wim" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$ScratchDisk\scratchdir\Recovery\WindowsRE\winre.wim" -Recurse -Force -ErrorAction SilentlyContinue
Write-Output "Removal complete!"
Start-Sleep -Seconds 2
Clear-Host
Write-Output "Loading registry..."
reg load HKLM\zCOMPONENTS $ScratchDisk\scratchdir\Windows\System32\config\COMPONENTS
reg load HKLM\zDEFAULT $ScratchDisk\scratchdir\Windows\System32\config\default
reg load HKLM\zNTUSER $ScratchDisk\scratchdir\Users\Default\ntuser.dat
reg load HKLM\zSOFTWARE $ScratchDisk\scratchdir\Windows\System32\config\SOFTWARE
reg load HKLM\zSYSTEM $ScratchDisk\scratchdir\Windows\System32\config\SYSTEM

Write-Output "Prevent inbox packages from being registered..."
# https://forums.mydigitallife.net/threads/msmg-toolkit.50572/page-52#post-1307366
# https://learn.microsoft.com/en-us/powershell/module/appx/add-appxpackage?view=windowsserver2025-ps#-register

$AppxPreRegisterPackagePrefixes = 'E2A4F912-2574-4A75-9BB0-0D023378592B',
'Microsoft.Windows.AssignedAccessLockApp',
'Microsoft.Win32WebViewHost', # Credit belong to aveyo (AKA BAU) from MDL
'microsoft.asynctextservice',
'ContentDeliveryManager', # https://forums.mydigitallife.net/threads/discussion-windows-11-final-build-226x1-2-3-4-5-pc-22-3h2-retail-beta-rp-channel-ni_release.85327/page-218#post-1779657
'Microsoft.ECApp',
'Microsoft.MicrosoftEdgeDevToolsClient',
'1527c705-839a-4832-9118-54d4Bd6a0c89',
'narratorquickstart',
'ncsiuwpapp',
'OOBENetworkCaptivePortal',
'OOBENetworkConnectionFlow',
'ParentalControls',
'PeopleExperienceHost',
'microsoft.windows.pinningconfirmationdialog',
'holocamera',
'holoitemplayerapp',
'HoloShell',
'AppRep.ChxApp',
'Holograms',
'HolographicFirstRun',
'Cortana',
'PPIProjection',
'SecondaryTileExperience',
'SecureAssessmentBrowser',
'XboxGameCallableUI',
'microsoftwindows.client.aix',
'PrintDialog' # Restore the Legacy Print Dialog
$key='HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications'
foreach ($prefix in $AppxPreRegisterPackagePrefixes) {
    $subkey=(Get-ItemProperty "Registry::${key}\*" | Where-Object PSChildName -Like "*${prefix}*").PSChildName
    if ($subkey) { Remove-RegistryItem "${key}\$subkey" }
}
Remove-Variable subkey

Write-Output "Disabling Sponsored Apps:"
Set-RegistryValue 'HKLM\zNTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -ValueName 'OemPreInstalledAppsEnabled' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -ValueName 'PreInstalledAppsEnabled' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -ValueName 'SilentInstalledAppsEnabled' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\CloudContent' -ValueName 'DisableWindowsConsumerFeatures' -Type 'REG_DWORD' -Data '1'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -ValueName 'ContentDeliveryAllowed' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -ValueName 'FeatureManagementEnabled' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -ValueName 'PreInstalledAppsEverEnabled' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -ValueName 'SoftLandingEnabled' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -ValueName 'SubscribedContentEnabled' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -ValueName 'RotatingLockScreenEnabled' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -ValueName 'RotatingLockScreenOverlayEnabled' -Type 'REG_DWORD' -Data '0'
'202913', '202914', '280797', '280811', '280812', '280813', '280814',
'280815', '280810', '280817', '310091', '310092', '310093', '310094',
'314558', '314559', '314562', '314563', '314566', '314567', '338380',
'338387', '338381', '338388', '338382', '338389', '338386', '338393',
'346480', '346481', '353694', '353695', '353696', '353697', '353698',
'353699', '88000044', '88000045', '88000105', '88000106', '88000161',
'88000162', '88000163', '88000164', '88000165', '88000166', '88000326' | ForEach-Object -Process {
    Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -ValueName "SubscribedContent-${_}Enabled" -Type 'REG_DWORD' -Data '0'
}
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -ValueName 'SystemPaneSuggestionsEnabled' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\PushToInstall' -ValueName 'DisablePushToInstall' -Type 'REG_DWORD' -Data '1'
Remove-RegistryItem 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptions'
Remove-RegistryItem 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps'
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\CloudContent' -ValueName 'DisableConsumerAccountStateContent' -Type 'REG_DWORD' -Data '1'
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\CloudContent' -ValueName 'DisableCloudOptimizedContent' -Type 'REG_DWORD' -Data '1'
# https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-setup-automation-overview?view=windows-11#sensitive-data-in-answer-files
New-Item -Path "$ScratchDisk\scratchdir\Windows\" -Name "Panther" -ItemType "Directory"
Copy-Item -Path "$PSScriptRoot\deployment\unattend.xml" -Destination "$ScratchDisk\scratchdir\Windows\Panther\unattend.xml" -Force
Copy-Item -Path "$PSScriptRoot\deployment\Scripts" -Destination "$ScratchDisk\scratchdir\Windows\Setup\Scripts" -Recurse
Copy-Item -Path "$PSScriptRoot\deployment\OEM" -Destination "$ScratchDisk\scratchdir\Windows\OEM" -Recurse

Write-Output "Hiding Chat icon:"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\Windows Chat' -ValueName 'ChatIcon' -Type 'REG_DWORD' -Data '2'
Set-RegistryValue 'HKLM\zNTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ValueName 'TaskbarMn' -Type 'REG_DWORD' -Data '0'
Write-Output "Prevent OneDrive from generating network traffic until the user signs in to OneDrive"
Set-RegistryValue -KeyName "HKLM\zSOFTWARE\Microsoft\OneDrive" -ValueName "PreventNetworkTrafficPreUserSignIn" -Type "REG_DWORD" -Data "1"
Write-Output "Disabling Telemetry:"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -ValueName 'Enabled' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Privacy' -ValueName 'TailoredExperiencesWithDiagnosticDataEnabled' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy' -ValueName 'HasAccepted' -Type 'REG_DWORD' -Data '0'

## Prevents installation of DevHome and Outlook
Write-Output "Prevents installation of DevHome and Outlook:"
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate' -ValueName 'workCompleted' -Type 'REG_DWORD' -Data '1'
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\OutlookUpdate' -ValueName 'workCompleted' -Type 'REG_DWORD' -Data '1'
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\DevHomeUpdate' -ValueName 'workCompleted' -Type 'REG_DWORD' -Data '1'
# ------> https://learn.microsoft.com/en-us/microsoft-365-apps/outlook/get-started/control-install#block-new-outlook-preinstall-on-windows
Remove-RegistryItem 'HKLM\zSOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate'
Remove-RegistryItem 'HKLM\zSOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate'
Write-Output "Disabling Copilot"
# They also disable Search Highlights automatically
Set-RegistryValue 'HKLM\zNTUSER\Software\Policies\Microsoft\Windows\WindowsCopilot' -ValueName 'TurnOffWindowsCopilot' -Type 'REG_DWORD' -Data '1'
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Edge' -ValueName 'HubsSidebarEnabled' -Type 'REG_DWORD' -Data '0'
# Find results in Web
Set-RegistryValue 'HKLM\zNTUSER\Software\Policies\Microsoft\Windows\Explorer' -ValueName 'DisableSearchBoxSuggestions' -Type 'REG_DWORD' -Data '1'
Write-Output "Prevent installation of New Outlook:"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\Windows Mail' -ValueName 'PreventRun' -Type 'REG_DWORD' -Data '1'

. "$PSScriptRoot\src\tweaks\tweaks.ps1"
. "$PSScriptRoot\src\privacy.ps1"
. "$PSScriptRoot\src\utilities.ps1"

Write-Output "Unmounting Registry..."
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
reg unload HKLM\zCOMPONENTS
reg unload HKLM\zDEFAULT
reg unload HKLM\zNTUSER
reg unload HKLM\zSOFTWARE
reg unload HKLM\zSYSTEM

Write-Output "Teams: Never perform automatically install regardless of default policies"
Use-WindowsUnattend -Path "$ScratchDisk\scratchdir" -UnattendPath "$PSScriptRoot\deployment\unattend.xml" -NoRestart

Write-Output 'Set the default timezone'
DISM.exe /Image:$ScratchDisk\scratchdir /Set-TimeZone:"W. Europe Standard Time" 2>&1

Write-Output 'Import a set of default application associations'
# https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/export-or-import-default-application-associations?view=windows-11
# %windir%\system32\oemdefaultassociations.xml
Dism.exe /Image:$ScratchDisk\scratchdir /Import-DefaultAppAssociations:"$PSScriptRoot\deployment\AppAssoc.xml" 2>&1

DISM.exe /Image:"$ScratchDisk\scratchdir" /Cleanup-Image /AnalyzeComponentStore 2>&1

. "$PSScriptRoot\src\cleanup-image.ps1"

DISM.exe /Image:"$ScratchDisk\scratchdir" /Cleanup-Image /AnalyzeComponentStore 2>&1

Write-Output ' '

Write-Output "Copy Files for WinPE..."
# https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/oem-deployment-of-windows-desktop-editions-sample-scripts?view=windows-11
Copy-Item -Path "$PSScriptRoot\winpe\Scripts" -Destination "$ScratchDisk\imo11\sources\Scripts" -Recurse
New-Item -Path "$ScratchDisk\imo11\sources\Scripts" -Name "${languageCode}" -ItemType "Directory"
'choice', 'findstr', 'timeout', 'reagentc', 'where' | ForEach-Object -Process {
    Write-Output "Add ${_}.exe to WinPE"
    Copy-Item -Path "$ScratchDisk\scratchdir\Windows\System32\${_}.exe" -Destination "$ScratchDisk\imo11\sources\Scripts\${_}.exe"
    # https://learn.microsoft.com/en-us/windows/win32/debug/system-error-codes--12000-15999-#ERROR_MUI_FILE_NOT_LOADED
    Copy-Item -Path "$ScratchDisk\scratchdir\Windows\System32\${languageCode}\${_}.exe.mui" -Destination "$ScratchDisk\imo11\sources\Scripts\${languageCode}\${_}.exe.mui"
}
Write-Output "Add Coreinfo64.exe to WinPE"
Invoke-WebRequest -Uri 'https://live.sysinternals.com/Coreinfo64.exe' -OutFile "$ScratchDisk\imo11\sources\Scripts\Coreinfo64.exe"
if (Test-Path -Path "$RootDir\win10\boot.wim") {
    'ReAgent', 'wdscore', 'dbgcore', 'ServicingCommon' | ForEach-Object -Process {
        Write-Output "Add ${_}.dll to WinPE"
        Copy-Item -Path "$ScratchDisk\scratchdir\Windows\System32\${_}.dll" -Destination "$ScratchDisk\imo11\sources\Scripts\${_}.dll"
    }
}

Write-Output ' '

Write-Output "Unmounting image..."
Dismount-WindowsImage -Path "$ScratchDisk\scratchdir" -Save
Write-Output "Exporting final image to highly compressed ESD format..."
dism '/Export-Image' "/SourceImageFile:$ScratchDisk\imo11\sources\install.wim" /SourceIndex:$index "/DestinationImageFile:$ScratchDisk\imo11\sources\install.esd" '/Compress:recovery' 2>&1
Remove-Item "$ScratchDisk\imo11\sources\install.wim" -ErrorAction Continue
Write-Output "Windows image completed. Continuing with boot.wim."
Start-Sleep -Seconds 2
Clear-Host
. "$PSScriptRoot\src\boot-img.ps1"

Clear-Host
Write-Output "The imo11 image is now completed. Proceeding with the making of the ISO..."

. "$PSScriptRoot\src\media.ps1"

# Finishing up
Write-Output "Creation completed!"

. "$PSScriptRoot\src\cleanup.ps1"

# Stop the transcript
Stop-Transcript

exit
