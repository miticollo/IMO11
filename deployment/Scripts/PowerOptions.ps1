#Requires -Version 5.1

$g = (New-Guid).ToString('D')
powercfg /duplicatescheme SCHEME_BALANCED $g
powercfg /changename $g 'Custom Balanced' 'Balanced Power Plan Customized by miticollo'

#region Display settings
    # https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/display-settings

    # https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/display-settings-display-idle-timeout
    powercfg /setacvalueindex $g SUB_VIDEO VIDEOIDLE 0
    powercfg /setdcvalueindex $g SUB_VIDEO VIDEOIDLE 0

    powercfg /setacvalueindex $g SUB_VIDEO ADAPTBRIGHT 1
    powercfg /setdcvalueindex $g SUB_VIDEO ADAPTBRIGHT 1
#endregion

#region Display settings
    # https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/sleep-settings

    # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-power#turnoffhybridsleeponbattery
    powercfg /setacvalueindex $g SUB_SLEEP HYBRIDSLEEP 0
    powercfg /setdcvalueindex $g SUB_SLEEP HYBRIDSLEEP 0
#endregion

#region Power button and lid settings
    # https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/power-button-and-lid-settings

    # https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/power-button-and-lid-settings-power-button-action
    powercfg /setacvalueindex $g SUB_BUTTONS PBUTTONACTION 3
    powercfg /setdcvalueindex $g SUB_BUTTONS PBUTTONACTION 3
#endregion

#region Energy Saver settings
    # https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/energy-saver-settings

    # https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/battery-threshold
    powercfg /setdcvalueindex $g SUB_ENERGYSAVER ESBATTTHRESHOLD 0
#endregion

# https://support.microsoft.com/en-us/topic/you-may-experience-connectivity-issues-or-performance-issues-when-you-connect-a-mobile-pc-that-is-running-windows-to-a-wireless-access-point-e9d8416f-34e9-6926-839e-0f5c728aa6c2#:~:text=This change reduces,running time
powercfg /setdcvalueindex $g 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
