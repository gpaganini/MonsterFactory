@ECHO ON

::Check if already installed
REG QUERY HKLM\SOFTWARE\WOW6432Node\Absolute
IF %ERRORLEVEL% EQU 0 GOTO END

::INSTALL

::Set working directory
pushd "\\aviva.com.br\NETLOGON\Absolute"

::Install Falcon Sensor
msiexec /i AbsoluteFullAgent.msi /q

::Remove working directory
popd

::End of File
:END