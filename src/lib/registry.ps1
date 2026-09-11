#Requires -Version 5.1

function Set-RegistryValue {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$KeyName,
        [string]$ValueName,
        [string]$Type,
        [string]$Data
    )
    try {
        $RegCommand="reg add '$KeyName'"
        if ( -not [string]::IsNullOrEmpty( $ValueName ) ) {
            $RegCommand="$RegCommand /v '$ValueName'"
        } else {
            $RegCommand="$RegCommand /ve"
            $ValueName="(Default)"
        }
        if ( -not [string]::IsNullOrEmpty( $Type ) ) {
            $RegCommand="$RegCommand /t $Type"
        }
        if ( -not [string]::IsNullOrEmpty( $Data ) ) {
            $Data = $Data -replace '"','\"'
            $RegCommand="$RegCommand /d '$Data'"
        }
        $RegCommand="$RegCommand /f"
        Write-Verbose "$RegCommand"

        if ($PSCmdlet.ShouldProcess("$KeyName\$ValueName",'REG ADD')) {
            $null = Invoke-Expression -Command "$RegCommand" 2>&1
        }
        Write-Output "Set registry value: $KeyName\$ValueName"
    } catch {
        Write-Output "$_ ($KeyName\$ValueName)"
    }
}

function Remove-RegistryItem {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
		[string]$KeyName,
        [string]$ValueName
	)
	try {
        $RegCommand="reg delete '$KeyName'"
        if ( -not [string]::IsNullOrEmpty( $ValueName ) ) {
            $RegCommand="$RegCommand /v '$ValueName'"
        }
        $RegCommand="$RegCommand /f"
        Write-Verbose "$RegCommand"

        if ($PSCmdlet.ShouldProcess("$KeyName",'REG DELETE')) {
            $null = Invoke-Expression -Command "$RegCommand" 2>&1
        }
		Write-Output "Removed registry item: $KeyName\$ValueName"
	} catch {
		Write-Output "$_ ($KeyName\$ValueName)"
	}
}

function New-ActiveSetupRegistryEntry {
<#
.SYNOPSIS
    .

.DESCRIPTION
    .

.PARAMETER StubPath
    .

.PARAMETER Version
    .

.PARAMETER Name
    .

.EXAMPLE
     New-ActiveSetupRegistryEntry 'reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /f' -Name 'Restore Old Context Menu'

.INPUTS
   None. You can't pipe objects to New-ActiveSetupRegistryEntry.

.NOTES
    Author:  Lorenzo Ferron
    Twitter: @miticollo

.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/new-guid?view=powershell-5.1

.LINK
    https://learn.microsoft.com/en-us/dotnet/api/system.guid.tostring?view=netframework-4.8.1#system-guid-tostring(system-string)
#>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$StubPath,
        [ValidateNotNullOrEmpty()]
        [string]$Version = '1,0,0,0',
        [string]$Name
    )
    $ActiveSetupRegParentPath = 'HKLM\zSOFTWARE\Microsoft\Active Setup\Installed Components'
    $ActiveSetupRegPath = "$ActiveSetupRegParentPath\$((New-Guid).ToString('B'))"
    if ($PSCmdlet.ShouldProcess("$ActiveSetupRegPath",'REG ADD')) {
        if ( -not [string]::IsNullOrEmpty( $Name ) ) {
            Set-RegistryValue "$ActiveSetupRegPath" -Type 'REG_SZ' -Data "$Name"
        }
        Set-RegistryValue "$ActiveSetupRegPath" -ValueName 'Version' -Type 'REG_SZ' -Data "$Version"
        Set-RegistryValue "$ActiveSetupRegPath" -ValueName 'StubPath' -Type 'REG_SZ' -Data "$StubPath"
    }
}

function reg_own {
<#
.SYNOPSIS
    Change registry security via scripts.

.DESCRIPTION
    No low-level registry functions used.

.PARAMETER key
    .

.PARAMETER recurse
    enable inherited rights / disable / delete entries

.PARAMETER user
    .

.PARAMETER owner
    if ommited, try to preserve existing

.PARAMETER acc
    .

.PARAMETER perm
    .

.PARAMETER list
    to show summary even when regedit fails

.EXAMPLE
     reg_own "key" -recurse Replace -user S-1-5-32-545 -owner S-1-1-0 -acc Allow -perm FullControl

.INPUTS
   None. You can't pipe objects to New-ActiveSetupRegistryEntry.

.NOTES
    Author:  AveYo

.LINK
    https://github.com/AveYo/LeanAndMean#reg_ownps1-or-copy-paste-function-code-in-powershell-admin-console----updated-20220115
#>
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$key,
        [string]$recurse = '',
        $user = 'S-1-5-32-544',
        $owner = '',
        $acc = 'Allow',
        $perm = 'FullControl',
        [switch]$list
    )
    $D1 = [uri].module.gettype('System.Diagnostics.Process')."GetM`ember"('SetPrivilege', 42)[0]
    $u = $user; $o = $owner; $p = 524288
    'SeSecurityPrivilege', 'SeTakeOwnershipPrivilege', 'SeBackupPrivilege', 'SeRestorePrivilege' | ForEach-Object -Process { $D1.Invoke($null, @("$_", 2)) }
    $reg = $key -split ':?\\',2
    $key = $reg -join '\'
    $HK = Get-Item -lit "Registry::$($reg[0])" -force
    $re = $recurse
    $in = (1,0)[$re -eq 'Inherit']
    $own = $o -eq ''
    if ($own) { $o = $u }
    $sid = [Security.Principal.SecurityIdentifier]
    $w = 'S-1-1-0', $u, $o | ForEach-Object -Process { new-object $sid($_) }
    $r = ($w[0], $p, 1, 0, 0), ($w[1], $perm, 1, 0, $acc) | ForEach-Object -Process { new-object Security.AccessControl.RegistryAccessRule($_) }

    function _own($k, $l) {
        $t = $HK.OpenSubKey($k, 2, 'TakeOwnership')
        if($t) {
            try { $n = $t.GetAccessControl(4) } catch { $n = $HK.GetAccessControl(4) }
            $u = $n.GetOwner($sid)
            if ($own -and $u) { $w[2] = $u }
            $n.SetOwner($w[0])
            $t.SetAccessControl($n)
            $d = $HK.GetAccessControl(2)
            $c = $HK.OpenSubKey($k, 2, 'ChangePermissions')
            $b = $c.GetAccessControl(2)
            $d.RemoveAccessRuleAll($r[1])
            $d.ResetAccessRule($r[0])
            $c.SetAccessControl($d)
            if ($re -ne '') {
                $sk = $HK.OpenSubKey($k).GetSubKeyNames()
                foreach ($i in $sk) { _own "$k\$i" $false }
                $b.SetAccessRuleProtection($in, 1)
            }
            $b.ResetAccessRule($r[1])
            if ($re -eq 'Delete') { $b.RemoveAccessRuleAll($r[1]) }
            $c.SetAccessControl($b)
            $b, $n | ForEach-Object -Process { $_.SetOwner($w[2]) }
            $t.SetAccessControl($n)
        }
        if ($l) { return $b | Format-List }
    }

    _own $reg[1] $list

    Remove-Variable -Name HK
    # call garbage collection to free up memory
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
}