#Requires -Version 5.1

Set-Variable -Name 'bootFiles' -Option Constant -Scope Global -Value @(
[PSCustomObject]@{
    'PlatformLabel'   = 'x86'
    'PlatformId'      = 0 # PlatformId.PlatformX86
    'File'            = 'boot\etfsboot.com'
},
[PSCustomObject]@{
    'PlatformLabel'   = 'EFI/UEFI'
    'PlatformId'      = 0xef # PlatformId.PlatformEFI
    'File'            = 'efi\microsoft\boot\efisys.bin'
}
)

function New-Iso {
<#
.SYNOPSIS
    .

.DESCRIPTION
    .

.PARAMETER SourceDirectory
    Directory of files to burn.

.PARAMETER IsoPath
    .

.PARAMETER Label
    The volume name for this file system image.

.EXAMPLE
     New-Iso "$ScratchDisk\imo11" "$PSScriptRoot\imo11.iso"

.INPUTS
   None. You can't pipe objects to New-Iso.

.NOTES
    Author:  Lorenzo Ferron
    Twitter: @miticollo

.LINK
    https://learn.microsoft.com/en-us/windows/win32/imapi/creating-a-multisession-disc

.LINK
    https://learn.microsoft.com/en-us/windows/win32/api/imapi2fs/

.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/new-object?view=powershell-5.1

.LINK
    https://learn.microsoft.com/en-us/office/client-developer/access/desktop-database-reference/stream-object-ado-reference

.LINK
    https://learn.microsoft.com/en-us/windows/win32/api/objidl/nn-objidl-istream#:~:text=Release

.LINK
    https://devblogs.microsoft.com/scripting/powertip-release-com-object-in-powershell/#post-7721
#>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateScript({
            if(Test-Path "$_" -PathType Container) {
                return $true
            }
            elseif(Test-Path "$_" -PathType Leaf) {
                throw 'The SourceDirectory parameter must be a folder. File paths are not allowed.'
            }
            throw 'Invalid File Path'
        })]
        [string]$SourceDirectory,
        [Parameter(Mandatory=$true,Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$IsoPath,
        [ValidatePattern('^[a-z0-9_\.]{0,15}$', Options = 'IgnoreCase')]
        [string]$Label = 'imo11'
    )

    $code = @"
using System;
using System.IO;
using System.Runtime.Interop`Services;
using System.Runtime.Interop`Services.ComTypes;

/// <summary>
/// export directory as (bootable) udf iso - lean and mean snippet by AveYo, 2021
/// </summary>
public class dir2iso {
    [DllImport("shlwapi.dll", CharSet=CharSet.Unicode, PreserveSig=false)]
    internal static extern void SHCreateStreamOnFileEx(string pszFile, uint grfMode, uint dwAttributes, bool fCreate, IStream pstmTemplate, out IStream ppstm);

    public static int Create(string file, ref object stream, int bs, int tb) {
        IStream dir = (IStream)stream, iso;

        try {
            SHCreateStreamOnFileEx(file, 0x1001, 0x80, true, null, out iso);
        } catch(Exception e) {
            Console.WriteLine(e.Message);
            return 1;
        }

        int d=tb>1024 ? 1024 : 1, pad=tb%d, block=bs*d, total=(tb-pad)/d, c=total>100 ? total/100 : total, i=1, MB=(bs/1024)*tb/1024;
        Console.Write("\r\n{0,2}%  {1}MB  MakeISO", 0, MB);
        if (pad > 0) dir.CopyTo(iso, pad * block, Int`Ptr.Zero, Int`Ptr.Zero);
        while (total-- > 0) {
            dir.CopyTo(iso, block, Int`Ptr.Zero, Int`Ptr.Zero);
            if (total % c == 0) Console.Write("\r{0,2}%",i++);
        }
        iso.Commit(0);
        Console.WriteLine("\r{0,2}%  {1}MB  MakeISO", 100, MB);
        return 0;
    }
}
"@
    & {
        # https://github.com/PowerShell/PowerShell/issues/21070
        $CompilerParameters = [System.CodeDom.Compiler.CompilerParameters]::new("System.dll")
        $CompilerParameters.TempFiles = [System.CodeDom.Compiler.TempFileCollection]::new($env:TEMP, $false)
        $CompilerParameters.GenerateInMemory = $true #:: ` used to silence ps eventlog
        (New-Object Microsoft.CSharp.CSharpCodeProvider).CompileAssemblyFromSource($CompilerParameters, $code)

        $BOOT = @()

        # -------- Adding Boot Image Code -----
        $bootFiles | ForEach-Object -Process {
            Write-Output "Creating BootOptions ($(${_}.PlatformLabel))"
            $bootOptions = New-Object -ComObject 'IMAPI2FS.BootOptions'
            $bootOptions.Manufacturer = "Microsoft"
            $bootOptions.PlatformId   = ${_}.PlatformId

            # Need a stream for the boot image file
            $bootStream = New-Object -ComObject 'ADODB.Stream'
            # Path and filename of boot image
            $bootFile = Join-Path ${SourceDirectory} -child ${_}.File
            Write-Output "Creating IStream for file $bootFile"
            $bootStream.Mode = 3 # adModeReadWrite
            $bootStream.Type = 1 # adTypeBinary
            $bootStream.Open()
            # Load the file into the stream
            $bootStream.LoadFromFile("$bootFile")

            $bootOptions.AssignBootImage($bootStream.psobject.BaseObject)

            # Override the previously assigned EmulationType value
            $bootOptions.Emulation    = 0 # EmulationType.EmulationNone

            $BOOT += $bootOptions.psobject.BaseObject
        }

        # Create a new file system image object
        $FSI = New-Object -ComObject 'IMAPI2FS.MsftFileSystemImage'
        $FSI.ChooseImageDefaultsForMediaType(0xc) # IMAPI_MEDIA_PHYSICAL_TYPE.IMAPI_MEDIA_TYPE_DISK

        # Add the boot directories and their contents to the file system
        $FSI.BootImageOptionsArray = $BOOT

        # Add the directory and its contents to the file system
        Write-Output "Adding $SourceDirectory directory to the disc..."
        $FSI.Root.AddTree($SourceDirectory, $false)

        $FSI.VolumeName = "${Label}"

        # Create an image from the file system image object
        $result = $FSI.CreateResultImage()

        $BOOT | ForEach-Object -Process {
            ${_}.BootImage.Close()
            $null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject(${_}.BootImage)
            $null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject(${_})
        }

        $null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject($FSI)
        Remove-Variable FSI

        $stream = $result.ImageStream

        Write-Output ' '
        Write-Output "Saving $IsoPath..."

        if ($PSCmdlet.ShouldProcess('Create File', "Destination: $IsoPath")) {
            $ret = [dir2iso]::Create($IsoPath, [ref]$stream, $result.BlockSize, $result.TotalBlocks)
        } else {
            $ret = 0
        }

        $null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject($stream)
        Remove-Variable stream

        $null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject($result)
        Remove-Variable result
    }
    # call garbage collection to free up memory
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    return $ret
}