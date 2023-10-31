@ECHO ON

::Check if already installed
IF EXIST "C:\Program Files\CoSoSys\Endpoint Protector" GOTO END

echo "EPP already installed" >> c:\temp\EPP_Install.log

::INSTALL

::Set working directory
pushd "\\aviva.com.br\NETLOGON\EndpointProtector"

::Install Falcon Sensor
msiexec /i EPPClientSetup.msi WSIP=10.94.1.146 /qn /norestart

::Remove working directory
popd

::End of File
:END