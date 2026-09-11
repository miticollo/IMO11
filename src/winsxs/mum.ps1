#Requires -Version 5.1

$mum = @(
    'Microsoft-Windows-EditionPack-Professional-removable-Package~',
    'Microsoft-Windows-Required-ShellExperiences-Desktop-removable-Package~',

    # https://learn.microsoft.com/en-us/windows-server/networking/branchcache/branchcache#bkmk_what
    # https://learn.microsoft.com/en-us/windows/deployment/update/waas-branchcach
    'Microsoft-Windows-Dedup-ChunkLibrary-Package~',
    'Microsoft-Windows-PeerDist-Client-',

    'Microsoft-OneCore-PointOfService-removable-Package~',

    'Microsoft-Windows-Client-AssignedAccess-'
)

New-Item -ItemType Directory -Force -Path "$env:PUBLIC\packages"

$mum | ForEach-Object -Process {
    Get-Item "$ScratchDisk\scratchdir\Windows\servicing\Packages\${_}*~~*.mum" | Where-Object {"$_" -cmatch '^(?:(?!-WOW64-Package~).)*$'} | ForEach-Object -Process {
        $doc = [xml](Get-Content -Path "$_")
        if ($doc.assembly.package.update.package) {
            # https://learn.microsoft.com/en-us/dotnet/api/system.xml.xmldocument.createelement?view=netframework-4.8.1#system-xml-xmldocument-createelement(system-string)
            $elem = $doc.CreateElement('selectable')
            # https://learn.microsoft.com/en-us/dotnet/api/system.xml.xmlelement.setattribute?view=netframework-4.8.1#system-xml-xmlelement-setattribute(system-string-system-string)ù
            $elem.SetAttribute('disposition', 'absent')
            # https://learn.microsoft.com/en-us/dotnet/api/system.xml.xmlelement.innerxml?view=netframework-4.8.1#system-xml-xmlelement-innerxml
            $elem.InnerXml = '<detectNone default="true"/>'
            $doc.assembly.package.update | ForEach-Object -Process {
                if (True) {
                    # https://learn.microsoft.com/en-us/dotnet/api/system.xml.xmlnode.insertbefore?view=netframework-4.8.1
                    ${_}.InsertBefore($elem.Clone(), ${_}.package)
                }
            }

            $doc.Save("$env:PUBLIC\packages\$($_.Name)")
        }
    }
}

# TODO(miticollo):

Remove-Item "$env:PUBLIC\packages" -Recurse -Force