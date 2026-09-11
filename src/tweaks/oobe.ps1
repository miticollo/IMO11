#Requires -Version 5.1

# https://forums.mydigitallife.net/threads/multi-oem-retail-project-mrp-mk3.71555/page-398#post-1724745
# https://ntlite.com/community/threads/how-does-ntlite-fake-setupcomplete-cmd-with-an-oem-key.3985/post-39211

Write-Output "Enable built-in Administrator"
# https://ntlite.com/community/threads/how-does-ntlite-fake-setupcomplete-cmd-with-an-oem-key.3985/post-39202
# https://learn.microsoft.com/archive/technet-wiki/13813.localized-names-for-administrator-account-in-windows
Set-RegistryValue 'HKLM\zSYSTEM\Setup\FirstBoot\PreOobe' -ValueName '00' -Type 'REG_SZ' -Data 'cmd.exe /c powershell -ep unrestricted -nop -c "Set-CimInstance -Query ''''Select * from Win32_UserAccount WHERE SID LIKE ''''''''S-1-5-_%-500'''''''''''' -Property @{Disabled=0}" &exit /b 0 '

Write-Output "Do not show first sign-in animation"
# A waste CPU time: https://www.hexacorn.com/blog/2022/01/16/windows-installation-animation/
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -ValueName 'EnableFirstLogonAnimation' -Type 'REG_DWORD' -Data '0'

Write-Output "Prevent the use of security questions for local accounts"
Set-RegistryValue 'HKLM\zSOFTWARE\Policies\Microsoft\Windows\System' -ValueName 'NoLocalPasswordResetQuestions' -Type 'REG_DWORD' -Data '1'

Write-Output "Do not let Microsoft and apps use your location"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -ValueName 'Value' -Type 'REG_SZ' -Data 'Deny'

Write-Output "Do not get personalized offers from Windows"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\Privacy' -ValueName 'PersonalizedOffersEnabled' -Type 'REG_DWORD' -Data '0'

Write-Output "Do not back up your files with OneDrive"
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\OneDrive' -ValueName 'OOBEOptIn' -Type 'REG_DWORD' -Data '0'
Set-RegistryValue 'HKLM\zNTUSER\Software\Microsoft\Windows\CurrentVersion\OOBE\AppSettings' -ValueName 'OneDrive-AutomaticUploadOptions' -Type 'REG_DWORD' -Data '0'

#region Change Account Type to Standard
    Write-Output "Change Account Type to Standard"

    Copy-Item -Path "$RootDir\deployment\GroupPolicy\gpt.ini" -Destination "$ScratchDisk\scratchdir\Windows\System32\GroupPolicy\gpt.ini" -Force

    New-Item -Path "$RootDir\scratchdir\Windows\System32\GroupPolicy\User\Scripts\Logoff" -ItemType "Directory"
    Copy-Item -Path "$RootDir\deployment\GroupPolicy\psscripts.ini" -Destination "$ScratchDisk\scratchdir\Windows\System32\GroupPolicy\User\Scripts\psscripts.ini" -Force
    Copy-Item -Path "$RootDir\deployment\GroupPolicy\scripts.ini" -Destination "$ScratchDisk\scratchdir\Windows\System32\GroupPolicy\User\Scripts\scripts.ini" -Force

    Copy-Item -Path "$RootDir\deployment\GroupPolicy\SetupLogoff.ps1" -Destination "$ScratchDisk\scratchdir\SetupLogoff.ps1" -Force
#endregion