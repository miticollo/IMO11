#Requires -Version 5.1

# https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-non-language-fod?view=windows-11
# https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-language-fod?view=windows-11
# https://learn.microsoft.com/en-us/azure/virtual-desktop/windows-11-language-packs#prerequisites

# HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Features on Demand\Removed FOD Markers
$markers = @(
    'Browser.InternetExplorer~',
    'Hello.Face.',
    'Language.Handwriting~',
    'Language.Speech~',
    'Language.TextToSpeech~',
    'MathRecognizer~',
    'Microsoft.Wallpapers.Extended~',
    'Microsoft.Windows.Ethernet.Client.Vmware.Vmxnet3~',
    # deprecated: https://learn.microsoft.com/en-us/windows/whats-new/deprecated-features#:~:text=OneSync%20service
    'OneCoreUAP.OneSync~',
    # deprecated: https://learn.microsoft.com/en-us/windows/whats-new/deprecated-features#:~:text=WMIC
    'WMIC~',
    # remove %WINDIR%\System32\Microsoft-Edge-WebView
    'Edge.Webview2.Platform~',
    # Uninstall Active Directory Lightweight Directory Services (AD LDS)
    'Windows.DirectoryServices.ADAM.Client.Content~',
    'Media.WindowsMediaPlayer~'
)

$set = New-Object System.Collections.Generic.HashSet[string]

reg load HKLM\zSOFTWARE $ScratchDisk\scratchdir\Windows\System32\config\SOFTWARE

Get-Item 'HKLM:\zSOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\CapabilityIndex\*' | ForEach-Object -Process {
    $key = $_
    (Get-Item "Registry::$_").Property | ForEach-Object -Process {
        $value = Get-ItemPropertyValue -Path "Registry::$key" -Name "$_"
        if ($value -cmatch '~~~~' -or $value.StartsWith('Language.')) { $null=$set.Add($value) }
    }
}

Remove-Variable key, value
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
reg unload HKLM\zSOFTWARE

$markers | ForEach-Object -Process {
    $capabilityToRemove = $set -cmatch "${_}*"
    if ($capabilityToRemove) {
        Write-Output "Removing $capabilityToRemove..."
        # https://forums.mydigitallife.net/threads/discussion-windows-11-insider-preview-build-26080-1-pc-canary-dev-ge-release.88155/#post-1828599
        Remove-WindowsCapability -Name "$capabilityToRemove" -Path "$ScratchDisk\scratchdir"
    }
}

Remove-Variable set