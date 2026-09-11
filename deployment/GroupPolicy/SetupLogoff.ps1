#Requires -Version 5.1

<#
.SYNOPSIS
   This script runs before logoff from defaultuser0.

.DESCRIPTION
   This script runs before LogonUI.exe is invoked to autologon the created user during OOBE.
   This solution is helpful to change account type to standard before first autologon after OOBE.
   An old solution that required a logoff after first autologon can be found:
   https://gist.github.com/miticollo/72e9a71e3cc93d311fe3e2634682fc65

.INPUTS
   None. You can't pipe objects to this script.

.NOTES
    Author:  Lorenzo Ferron
    Twitter: @miticollo

.LINK
   https://learn.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services#how-to-configure-each-setting

.LINK
    https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/gpupdate#parameters

.LINK
    https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-azod/ecc7dfba-77e1-4e03-ab99-114b349c7164#:~:text=Windows%20allocates%20RIDs%20starting%20at%201,000

.LINK
    https://aesdlab.com/articles/how-to-set-up-group-policy-scripts-programmatically
#>

$Name = (Get-CimInstance -Class Win32_UserAccount -Filter 'SID LIKE "S-1-5-_%-1001"' -Property Name).Name
if ($Name) {
  net.exe localgroup administrators "$Name" /delete
  net.exe localgroup users "$Name" /add
}