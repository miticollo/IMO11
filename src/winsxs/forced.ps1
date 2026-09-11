#Requires -Version 5.1

#region Package: Forced Method
    # https://forums.mydigitallife.net/threads/msmg-toolkit.50572/page-110#post-1344080
    # https://ntlite.com/community/threads/components-question-system-apps.4133/post-40438
    # https://ntlite.com/community/threads/how-can-i-delete-a-folder-with-protection-such-as-windows-apps-but-with-batch-or-cmd.3456/post-34130
    # https://ntlite.com/community/threads/updates-when-using-uup-dump.2578/#post-39817
    # https://stackoverflow.com/a/76731469
    # https://forums.mydigitallife.net/threads/removing-features-from-an-online-win10-instalation.79311/#post-1511749
    $ForcedRemovedPackages = @(
        # deprecated: https://devblogs.microsoft.com/powershell/windows-powershell-2-0-deprecation/#what-does-this-mean-for-me
        # removed: https://support.microsoft.com/en-us/topic/powershell-2-0-removal-from-windows-fe6d1edc-2ed2-4c33-b297-afe82a64200a
        'Microsoft-Windows-PowerShell-V2-Client-Package~',

        'Microsoft-Windows-Client-Features-removable-Package~',
        'Microsoft-Windows-RecDisc-SDP-removable-Package~',

        'Microsoft-Windows-MicrosoftEdgeDevToolsClient-Package~',
        'Microsoft-Windows-BootEnvironment-Dvd-Package~',

        'Microsoft-Windows-PowerShell-ISE-FOD-Package-Wrapper~[a-zA-Z0-9]+~wow64~',
        'Microsoft-Windows-MSPaint-FoD-Package-Wrapper~[a-zA-Z0-9]+~wow64~',
        'Microsoft-Windows-Notepad-FoD-Package-Wrapper~[a-zA-Z0-9]+~wow64~',
        'Microsoft-Windows-StepsRecorder-Package-Wrapper~[a-zA-Z0-9]+~wow64~',

        # Microsoft Kernel Debugger Network Adapter (NDIS 6.20 Miniport)
        'Microsoft-Windows-CoreSystem-DriverSupport-merged-Package~'
    )

    $packagesToRemove = @()

    reg load HKLM\zSOFTWARE $ScratchDisk\scratchdir\Windows\System32\config\SOFTWARE

    $allPackages = (Get-ItemProperty -Path "Registry::${key}*").PSChildName
    $ForcedRemovedPackages | ForEach-Object -Process {
        $packagesToRemove += $allPackages -cmatch "${_}*"
    }
    Remove-Variable ForcedRemovedPackages, allPackages

    $packagesToRemove | ForEach-Object -Process {
        # https://forums.mydigitallife.net/threads/closed-install_wim_tweaker-how-does-it-unhide-hide-the-packages.64563/#post-1129358
        # https://forums.mydigitallife.net/threads/completely-eradicate-telemetry-defender-one-drive-cortana-and-other-things.63734/#post-1112345
        Set-RegistryValue "$key${_}" -ValueName 'Visibility' -Type 'REG_DWORD' -Data '1'
        Remove-RegistryItem "$key${_}\Owners"
    }

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    reg unload HKLM\zSOFTWARE

    $packagesToRemove = $packagesToRemove -cmatch '^.*[0-9]~~[0-9].*$' -cmatch '^(?:(?!-WOW64-Package~).)*$'

    $packagesToRemove | ForEach-Object -Process {
        Write-Output "Removing ${_}..."
        # https://msfn.org/board/topic/152688-win6x_registry_tweak/page/5#comment-1093253_wrap
        Remove-WindowsPackage -Path "$ScratchDisk\scratchdir" -PackageName "$_" -NoRestart -ErrorAction Continue
    }
#endregion