#Requires -Version 5.1

# https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/glossary.html#path
$productName='Adobe Acrobat'
$version='DC'

Write-Output "Do not show the modern viewer"
# https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/AVGeneral.html#idkeyname_1_7055
Set-RegistryValue "HKLM\zNTUSER\Software\Adobe\${productName}\${version}\AVGeneral" -ValueName 'bEnableAV2' -Type 'REG_DWORD' -Data '0'

Write-Output "EULA acceptance"
# https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/AdobeViewer.html?zoom_highlight=EULA#idkeyname_1_1817
Set-RegistryValue "HKLM\zNTUSER\Software\Adobe\${productName}\${version}\AdobeViewer" -ValueName 'EULA' -Type 'REG_DWORD' -Data '1'

Write-Output "Disabling startup tips"
# https://www.adobe.com/devnet-docs/acrobatetk/tools/AdminGuide/basicconfig.html#disabling-startup-tips
# https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/FeatureLockDown.html?zoom_highlight=bToggleFTE#idkeyname_1_10559
Set-RegistryValue "HKLM\zSOFTWARE\Policies\Adobe\${productName}\${version}\FeatureLockDown" -ValueName 'bToggleFTE' -Type 'REG_DWORD' -Data '1'

Write-Output "Do not Show Share Button Label"
Set-RegistryValue "HKLM\zNTUSER\Software\Adobe\${productName}\${version}\AVGeneral" -ValueName 'bHideShareButtonLabel' -Type 'REG_DWORD' -Data '1'

# https://community.adobe.com/questions-9/how-to-set-acrobat-pdfs-to-open-without-side-panels-1260069#post221949
Set-RegistryValue "HKLM\zNTUSER\Software\Adobe\${productName}\${version}\AVGeneral" -ValueName 'aDefaultRHPViewMode_L' -Type 'REG_SZ' -Data 'Collapsed'
Write-Output "Hide or close the RHP by default whenever opening any PDF"
# https://web.archive.org/web/20250907033356/https://helpx.adobe.com/acrobat/kb/how-to-permanently-close-the-tools-pane-in-adobe-acrobat-dc.html
Set-RegistryValue "HKLM\zNTUSER\Software\Adobe\${productName}\${version}\AVGeneral" -ValueName 'bExpandRHPinViewer' -Type 'REG_DWORD' -Data '0'
Write-Output "Remember last state of All tools pane when opening documents"
# https://helpx.adobe.com/acrobat/kb/disable-right-hand-pane-in-acrobat-reader.html
Set-RegistryValue "HKLM\zNTUSER\Software\Adobe\${productName}\${version}\AVGeneral" -ValueName 'bRHPSticky' -Type 'REG_DWORD' -Data '1'

Write-Output "Optimize content so that the printer uses less ink"
# https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/AVGeneral.html#idkeyname_1_5547
Set-RegistryValue "HKLM\zNTUSER\Software\Adobe\${productName}\${version}\AVGeneral" -ValueName 'bPrintSaveToner' -Type 'REG_DWORD' -Data '1'

Write-Output "Add Custom Info Panels for Adobe Acrobat"
New-Item -Path "$ScratchDisk\scratchdir\Program Files (x86)\Common Files\Adobe\Acrobat\DC\XMP\Custom File Info Panels" -ItemType 'Directory'
'TDMRep', 'PDFDeclarationsWindows', 'ISOStandards' | ForEach-Object -Process {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/petervwyatt/AcrobatCustomPanels/refs/heads/main/CustomPanel_${_}.xml" -OutFile "$ScratchDisk\scratchdir\Program Files (x86)\Common Files\Adobe\Acrobat\DC\XMP\Custom File Info Panels\CustomPanel_${_}.xml"
}