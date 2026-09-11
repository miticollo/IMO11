@ECHO off
ECHO == Setting high-performance power scheme to speed deployment ==
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
rem https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-identify-drive-letters?view=windows-11
for %%# in (C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,T,U,V,Y,Z) do (
if exist "%%#:\sources\Scripts\" set "SCRIPTSDRIVE=%%#"
)
%SCRIPTSDRIVE%:
CD sources\Scripts
%SCRIPTSDRIVE%:\sources\Scripts\WinPEMenu.cmd