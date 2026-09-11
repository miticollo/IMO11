#Requires -Version 5.1

# https://learn.microsoft.com/en-us/windows/win32/lwef/disk-cleanup
# https://forums.mydigitallife.net/threads/help-me-make-a-batch-file-to-clean-temp-files.57730/#post-966293

Write-Output "Using Disk Cleanup with custom configuration"
'Temporary Files',
'Update Cleanup',
'Thumbnail Cache',
'Downloaded Program Files',
'Delivery Optimization Files',
'Device Driver Packages',
'Language Pack',
'Windows Defender', # C:\ProgramData\Microsoft\Windows Defender\LocalCopy|C:\ProgramData\Microsoft\Windows Defender\Support
# 'Recycle Bin',
# 'Old ChkDsk Files',
# 'System error memory dump files', # %WINDIR%\*.dmp
# 'System error minidump files', # %WINDIR%\Minidump\*.dmp
# 'Windows Error Reporting Files', # %ALLUSERSPROFILE%\Microsoft\Windows\WER\
# 'Diagnostic Data Viewer database files',
'Feedback Hub Archive log files', # %ProgramData%\Microsoft\Diagnosis\FeedbackArchive\
'Active Setup Temp Folders', # C:\Windows\msdownld.tmp|?:\msdownld.tmp
'D3D Shader Cache',
'RetailDemo Offline Content', # %ProgramData%\Microsoft\Windows\RetailDemo
'Setup Log Files', # %WINDIR%\setup*.log|setup*.old|setuplog.txt|winnt32.log
'Internet Cache Files' | ForEach-Object -Process {
    Set-RegistryValue "HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$_" -ValueName 'StateFlags' -Type 'REG_DWORD' -Data '1'
}

# LastAccess
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files' -ValueName 'LastAccess' -Type 'REG_DWORD' -Data '1'

# Flags
'Delivery Optimization Files', 'Setup Log Files' | ForEach-Object -Process {
    $null = REG 'DELETE' "HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$_" '/v' 'Flags' '/f'
}
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Defender' -ValueName 'Flags' -Type 'REG_DWORD' -Data '29' # 0x0000001d
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Feedback Hub Archive log files' -ValueName 'Flags' -Type 'REG_DWORD' -Data '541' # 0x0000021d
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files' -ValueName 'Flags' -Type 'REG_DWORD' -Data '256' # 0x00000100
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders' -ValueName 'Flags' -Type 'REG_BINARY' -Data '5c000000'
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\RetailDemo Offline Content' -ValueName 'Flags' -Type 'REG_DWORD' -Data '187' # 0x0000011f
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files' -ValueName 'Flags' -Type 'REG_DWORD' -Data '540' # 0x0000021c
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files' -ValueName 'Flags' -Type 'REG_DWORD' -Data '605' # 0x0000025d
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Files' -ValueName 'Flags' -Type 'REG_DWORD' -Data '93' # 0x0000005d
Set-RegistryValue 'HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Diagnostic Data Viewer database files' -ValueName 'Flags' -Type 'REG_DWORD' -Data '541' # 0x0000021d

# Folder
Set-RegistryValue "HKLM\zSOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" -ValueName 'Folder' -Type 'REG_EXPAND_SZ' -Data '%TEMP%|%WINDIR%\Temp|%WINDIR%\Logs|%WINDIR%\System32\LogFiles|%WINDIR%\SystemTemp|%LOCALAPPDATA%\Microsoft\Windows\TaskManager\LiveKernelDumps|%PROGRAMDATA%\Microsoft\WDF|%WINDIR%\SoftwareDistribution\Download\'