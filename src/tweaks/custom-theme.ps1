#Requires -Version 5.1

# https://www.reddit.com/r/Windows11/comments/1fw7xvs/comment/lrcvbws/
# https://learn.microsoft.com/en-us/windows/win32/controls/themesfileformat-overview
# https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-admx-controlpaneldisplay#cpl_personalization_settheme

New-Item -Path "$ScratchDisk\scratchdir\Users\Default\AppData\Local\Microsoft\Windows" -Name "Themes" -ItemType "Directory"
Copy-Item -Path "$RootDir\deployment\oem.theme" -Destination "$ScratchDisk\scratchdir\Users\Default\AppData\Local\Microsoft\Windows\Themes\oem.theme" -Force