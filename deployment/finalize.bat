@(echo off% <#%)
set "0=%~f0"&powershell -nop -c iex ([io.file]::ReadAllText($env:0)) &exit /b ||#>)[1]
## just copy-paste into powershell - it's a standalone hybrid script

Function Check-Internet
{
    While (([Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]‘{DCB00C01-570F-4A9B-8D69-199FDBA5723B}’)).IsConnectedToInternet) -eq $False)
    {
        Write-Output "No internet connection detected. Retrying in 60 seconds..." | Receive-Output -Color Yellow -LogLevel 2 -LineNumber "$($Invocation.MyCommand.Name):$( & {$MyInvocation.ScriptLineNumber})"
        Start-Sleep -Seconds 60
    }
}

$decision = $Host.UI.PromptForChoice('', 'Do you want to enable Custom Balanced power plan (by miticollo)?', @('&Yes'; '&No'), 1)
if ($decision -eq 0) {
    powercfg /s "$([regex]::Matches($(powercfg /L | Select-String 'Custom Balanced'),'\w{8}-\w{4}-\w{4}-\w{4}-\w{12}')[0].Value)"
}
Write-Output ' '

# https://forums.mydigitallife.net/threads/discussion-windows-11-insider-preview-build-22557-1-pc-dev-channel-ni_release.84990/page-6#post-1723629
Start-Process -FilePath 'net' -ArgumentList 'user DEFAULTUSER0 /delete' -Verb RunAs

# Ensures that Invoke-WebRequest uses TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Check-Internet
& ([ScriptBlock]::Create((irm https://get.activated.win))) /Z-Windows /Z-SCID

# Get the latest 7-Zip download URL
$Parameters = @{
	Uri             = 'https://sourceforge.net/projects/sevenzip/best_release.json'
	UseBasicParsing = $true
	Verbose         = $true
}
$bestRelease = (Invoke-RestMethod @Parameters).platform_releases.windows.filename.replace('exe', 'msi')

# Download the latest 7-Zip x64
$DownloadsFolder = Get-ItemPropertyValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name '{374DE290-123F-4565-9164-39C4925E467B}'
# https://sourceforge.net/p/forge/documentation/Downloading%20files%20via%20the%20command%20line/
$Parameters = @{
	Uri             = "https://sourceforge.net/projects/sevenzip/files$($bestRelease)/download"
	OutFile         = "$DownloadsFolder\7-Zip.msi"
	UserAgent	= 'wget'
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

Start-Process -FilePath "$DownloadsFolder\7-Zip.msi" -Wait

Remove-Item -Path "$DownloadsFolder\7-Zip.msi" -Force

Write-Output ' '
$decision = $Host.UI.PromptForChoice('', 'Do you want to install Firefox?', @('&Yes'; '&No'), 0)
if ($decision -eq 0) {
    irm https://raw.githubusercontent.com/farag2/Utilities/refs/heads/master/Download/Firefox_Setup.msi.ps1 | iex
}

Write-Output ' '
$decision = $Host.UI.PromptForChoice('', 'Do you want to install Google Chrome?', @('&Yes'; '&No'), 1)
if ($decision -eq 0) {
    irm https://raw.githubusercontent.com/farag2/Utilities/refs/heads/master/Download/Chrome_Setup.msi.ps1 | iex
}

# https://wiki.dbzer0.com/genp-guides/guide/#wiki-toc-1-hosts-file-block-list-updated-regularly
# In Notepad (Win32), use PagUp or PagDown to select and the replace old domains!
Start-Process -FilePath 'powershell' -ArgumentList '-ep unrestricted -nop -c "irm https://raw.githubusercontent.com/ignaciocastro/a-dove-is-dumb/refs/heads/main/list.txt | Out-File -Encoding ASCII -Append $env:WINDIR\System32\drivers\etc\hosts"' -Verb RunAs -Wait

Write-Output ' '
$decision = $Host.UI.PromptForChoice('', 'Do you want to add Adobe Acrobat DC (by m0nkrus) to Windows Defender exclusion paths?', @('&Yes'; '&No'), 1)
if ($decision -eq 0) {
    # https://w18.monkrus.ws/2026/06/adobe-acrobat-2026-v26121691-x64.html#cc-113668191
    # https://w18.monkrus.ws/2026/06/adobe-acrobat-2026-v26121691-x64.html#cc-113668158
    # https://w18.monkrus.ws/2026/06/adobe-acrobat-2026-v26121667-x64.html#cc-113654832
    # https://w18.monkrus.ws/2026/06/adobe-acrobat-2026-v26121662-x64.html#cc-113631873
    # https://w18.monkrus.ws/2026/06/adobe-acrobat-2026-v26121662-x64.html#cc-113632474
    # https://w18.monkrus.ws/2026/06/adobe-acrobat-2026-v26121662-x64.html#cc-113629842
    # https://w18.monkrus.ws/2026/06/adobe-acrobat-2026-v26121662-x64.html#cc-113627931
    # https://w18.monkrus.ws/2026/06/adobe-acrobat-2026-v26121651-x64.html#cc-113609187
    # https://w18.monkrus.ws/2026/05/adobe-acrobat-2026-v26121563-x64.html#cc-113547130 this workflow because https://w18.monkrus.ws/2026/04/adobe-acrobat-2026-v26121367-x64.html#cc-113412441
    # https://w18.monkrus.ws/2026/04/adobe-acrobat-2026-v26121367-x64.html#cc-113411871
	# https://w18.monkrus.ws/2024/04/adobe-acrobat-pro-2024-v24120643-x64.html#cc-110170699
	# https://w18.monkrus.ws/2024/07/adobe-acrobat-pro-2024-v24220933-x64.html#cc-110696246

    # HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths
    Start-Process -FilePath 'powershell' -ArgumentList '-ep unrestricted -nop -c "Add-MpPreference -ExclusionPath ''%ProgramFiles%\Adobe\Acrobat DC\''"' -Verb RunAs -Wait

    $DesktopFolder = Get-ItemPropertyValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Desktop'
    Invoke-WebRequest -Uri 'https://live.sysinternals.com/Procmon64.exe' -OutFile "$DesktopFolder\Procmon64.exe" -Verbose
}

if ($decision -eq 1) {
    Write-Output ' '
    # This question is useless because answer is always YES. But it becomes useful when you test the current ISO!
    $decision = $Host.UI.PromptForChoice('', 'Do you want to install Adobe Reader DC?', @('&Yes'; '&No'), 0)
    if ($decision -eq 0) {
        irm https://raw.githubusercontent.com/farag2/Utilities/refs/heads/master/Download/Acrobat_Reader_DC_x64.ps1 | iex
        Invoke-Item -Path "$DownloadsFolder\AcroRdrDCx64"
    }
}

Write-Output ' '
$decision = $Host.UI.PromptForChoice('', 'Do you want to add a new account?', @('&Yes'; '&No'), 1)
if ($decision -eq 0) {
    # During OOBE you can create an account without password.
    # Before giving back this PC, you can require that owner will set a new password during next login!
    Start-Process -FilePath 'lusrmgr.msc' -Verb RunAs
}

Remove-Item "$env:PUBLIC\Desktop\finalize.bat"
