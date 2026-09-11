@echo off
rem https://forums.mydigitallife.net/threads/multi-oem-retail-project-mrp-mk3.71555/page-398#post-1724745
rem https://forums.mydigitallife.net/threads/multi-oem-retail-project-mrp-mk3.71555/page-239#post-1504607
rem https://forums.mydigitallife.net/threads/repo-how-to-chat-audit-sysprep-generalize-setupcomplete-firstlogon-silent-install.73131/page-2#post-1343314

rem Remove copies of the unattend file to avoid information disclosure
del %WINDIR%\Panther\unattend.xml %SYSTEMDRIVE%\unattend.xml

rd /s /q %WINDIR%\Logs\ReAgent

rem Remove %SystemRoot%\Setup\Scripts\*
rem https://forums.mydigitallife.net/threads/repo-how-to-chat-audit-sysprep-generalize-setupcomplete-firstlogon-silent-install.73131/page-6#post-1596684
cd \
(goto) 2>nul & (if "%~dp0"=="%SystemRoot%\Setup\Scripts\" rd /s /q "%~dp0")