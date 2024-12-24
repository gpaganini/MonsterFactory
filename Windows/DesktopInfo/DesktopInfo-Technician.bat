@echo off
pushd "%~dp0"

IF %PROCESSOR_ARCHITECTURE% == x86 (IF NOT DEFINED PROCESSOR_ARCHITEW6432 goto bit32)
set dti=DesktopInfo64.exe
goto cont
:bit32
set dti=DesktopInfo32\DesktopInfo32.exe
:cont

start %dti% /f /ini=sample-config\desktopinfo-advanced.ini
popd