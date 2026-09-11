# WinPE

Place the `boot.wim` file from Windows 10 (x64) in this directory. If present, the script will use it as WinPE. You can also add the LCU for that Windows version!

## Requirements

1. Download Windows 10 IoT Enterprise LTSC 2021.
   According to the [Microsoft Lifecycle page](https://learn.microsoft.com/en-us/lifecycle/products/windows-10-iot-enterprise-ltsc-2021), it will be supported until January 13, 2032.
2. Extract `source\boot.wim` from the Windows 10 ISO.
3. Run `retrieve.ps1`.
