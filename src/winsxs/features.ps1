#Requires -Version 5.1

#region Features where package and payload will remain in WinSxS if disabled
    Write-Output "Disabling with Payload Removed WorkFolders-Client..."
    # https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/dn265974(v=ws.11)
    # https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/sysmon#:~:text=Starting,Windows%2011
    Disable-WindowsOptionalFeature -Path "$ScratchDisk\scratchdir" -FeatureName WorkFolders-Client -Remove -NoRestart -ErrorAction Continue

    dism /English /Image:"$ScratchDisk\scratchdir" /Get-Features /Format:Table | Select-String '^(.*?)\s*\|\s*Disabled\s*$' | ForEach-Object -Process {
        $featureName = $_.Matches[0].Groups[1].Value.TrimEnd()
        Write-Output "Disabling with Payload Removed $featureName..."
        Disable-WindowsOptionalFeature -Path "$ScratchDisk\scratchdir" -FeatureName "$featureName" -Remove -NoRestart
    }

    Write-Output "Disabling with Payload Removed Recall..."
    # https://learn.microsoft.com/en-us/windows/client-management/manage-recall#what-is-recall
    Disable-WindowsOptionalFeature -Path "$ScratchDisk\scratchdir" -FeatureName 'Recall' -Remove -NoRestart -ErrorAction Continue

    Get-WindowsOptionalFeature -Path "$ScratchDisk\scratchdir" | Where-Object {$_.State -eq [Microsoft.Dism.Commands.FeatureState]::Disabled} | ForEach-Object -Process {
        Write-Output "Disabling with Payload Removed $($_.FeatureName)..."
        Disable-WindowsOptionalFeature -Path "$ScratchDisk\scratchdir" -FeatureName $_.FeatureName -Remove -NoRestart
    }

    # If you want to install .NET Framework 3.5 go to https://github.com/abbodi1406/dotNetFx35W10/releases/latest
#endregion