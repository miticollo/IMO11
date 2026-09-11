#Requires -Version 5.1

#region Date & Time
    Write-Output "Configure Time Servers"
    Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\W32Time\Parameters' -ValueName 'NtpServer' -Type 'REG_SZ' -Data '0.it.pool.ntp.org 1.it.pool.ntp.org 2.it.pool.ntp.org 3.it.pool.ntp.org'
    Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Services\W32Time\Parameters' -ValueName 'Type' -Type 'REG_SZ' -Data 'NTP'

    Write-Output "Set Coordinated Universal Time (UTC) time"
    # ------> Sets default time to UTC to fix Windows and Linux showing different Times when dual booting and to provide a more universal Time configuration. Most Linux distros use UTC by default.
    Set-RegistryValue 'HKLM\zSYSTEM\ControlSet001\Control\TimeZoneInformation' -ValueName 'RealTimeIsUniversal' -Type 'REG_DWORD' -Data '1'
#endregion

#region Formats
    Write-Output "Number format: setting (space) as digit grouping symbol"
    New-ActiveSetupRegistryEntry 'reg.exe add "HKCU\Control Panel\International" /v sThousand /t REG_SZ /d " " /f' -Name 'Number format: setting (space) as digit grouping symbol'

    Write-Output "Currency format: setting (space) as digit grouping symbol"
    New-ActiveSetupRegistryEntry 'reg.exe add "HKCU\Control Panel\International" /v sMonThousandSep /t REG_SZ /d " " /f' -Name 'Currency format: setting (space) as digit grouping symbol'
#endregion