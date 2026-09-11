#Requires -Version 5.1

#region Packages (features) selectable per CBS rules ONLY on IoT Enterprise
    # https://forums.mydigitallife.net/threads/removing-features-from-an-online-win10-instalation.79311/#post-1511510
    # https://forums.mydigitallife.net/threads/removing-features-from-an-online-win10-instalation.79311/#post-1511641
    # https://aka.ms/RemovablePackages

    # Desktop Shared Features
    $Desktop_SharedPackages = @(
        # https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize/removable-packages/microsoft-onecore-fonts-desktopfonts-nonleansupplement
        'Microsoft-OneCore-Fonts-DesktopFonts-NonLeanSupplement',
        # Windows Hello Setup UI
        'Microsoft-Windows-BioEnrollment-UX',
        # https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize/removable-packages/microsoft-windows-screensavers-3d
        'Microsoft-Windows-ScreenSavers-3D'
    )
    $removablePackages = $Desktop_SharedPackages

    # https://support.microsoft.com/en-us/topic/media-feature-pack-for-windows-10-n-may-2020-ebbdf559-b84c-0fc2-bd51-e23c9f6a4439
    $Common_RegulatedPackages = @(
        # https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize/removable-packages/microsoft-media-foundation
        'Microsoft-Media-Foundation',
        # https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize/removable-packages/microsoft-windows-media-format
        'Microsoft-Windows-Media-Format',
        # https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize/removable-packages/microsoft-windows-media-streaming
        'Microsoft-Windows-Media-Streaming',
        # https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize/removable-packages/microsoft-windows-mediaplayback-oc
        'Microsoft-Windows-MediaPlayback-OC',
        # https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize/removable-packages/microsoft-windows-webcamexperience
        'Microsoft-Windows-WebcamExperience',
        # https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize/removable-packages/microsoft-windows-winsatmediafiles
        'Microsoft-Windows-WinSATMediaFiles'
    )
    $removablePackages += $Common_RegulatedPackages

    $Client_FeaturesPackages = @(
        # https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize/removable-packages/microsoft-windows-shell-wallpaper-common
        'Microsoft-Windows-Shell-Wallpaper-Common'
    )
    $removablePackages += $Client_FeaturesPackages

    $RecDisc_SDPPackages = @(
        # https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize/removable-packages/microsoft-windows-bootenvironment-dvd
        'Microsoft-Windows-BootEnvironment-Dvd'
    )
    $removablePackages += $RecDisc_SDPPackages

    $OneCore_PointOfServicePackages = @(
        # https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize/removable-packages/microsoft-onecore-pointofservice-camerabarcodescanner
        'Microsoft-OneCore-PointOfService-CameraBarcodeScanner'
    )
    $removablePackages += $OneCore_PointOfServicePackages

    $EditionPack_ProfessionalPackages = @(
        # https://learn.microsoft.com/en-us/microsoft-desktop-optimization-pack/ue-v/uev-getting-started#step-4-test-your-ue-v-evaluation-deployment
        'Microsoft-Windows-AppManagement-UEV'
    )
    $removablePackages += $EditionPack_ProfessionalPackages

    $Required_ShellExperiencesDesktopPackages = @(
        # https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize/removable-packages/microsoft-windows-desktopfileexplorer
        'Microsoft-Windows-DesktopFileExplorer'
    )
    $removablePackages += $Required_ShellExperiencesDesktopPackages

    $removablePackages | ForEach-Object -Process {
        Write-Output "Removing ${_}..."
        Disable-WindowsOptionalFeature -Path "$ScratchDisk\scratchdir" -FeatureName "$_" -PackageName '@Package' -Remove -NoRestart -ErrorAction Continue
    }

    reg load HKLM\zSOFTWARE $ScratchDisk\scratchdir\Windows\System32\config\SOFTWARE
    $packages = (Get-ItemProperty -Path "Registry::${key}Microsoft-Windows-Desktop-Required-ClientOnly-removable-Package~*").PSChildName
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    reg unload HKLM\zSOFTWARE

    Write-Output "Removing Microsoft-Windows-MicrosoftEdgeDevToolsClient..."
    # https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize/removable-packages/microsoft-windows-microsoftedgedevtoolsclient
    $packages | ForEach-Object -Process {
        Disable-WindowsOptionalFeature -Path "$ScratchDisk\scratchdir" -FeatureName 'Microsoft-Windows-MicrosoftEdgeDevToolsClient' -PackageName "$_" -Remove -NoRestart -ErrorAction Continue
    }
#endregion