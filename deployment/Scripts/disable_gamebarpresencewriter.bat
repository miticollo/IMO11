@echo off &title Disable GamebarPresenceWriter - proper method

REM https://gist.github.com/AveYo/234d561dec43abc6c41f43d223a87170#file-disable_gamebarpresencewriter-bat

set "acikey=Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter"  
set "reg64=HKLM\SOFTWARE" &set "reg32=HKLM\SOFTWARE\WOW6432Node" &set "ActivationType=0x0"
reg add "%reg64%\%acikey%" /v "ActivationType" /t REG_DWORD /d %ActivationType% /f >nul 2>nul
reg add "%reg32%\%acikey%" /v "ActivationType" /t REG_DWORD /d %ActivationType% /f >nul 2>nul