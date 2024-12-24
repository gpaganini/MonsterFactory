@ECHO ON

::Check if already installed
IF EXIST "C:\Windows\System32\Drivers\CrowdStrike" GOTO END

::INSTALL

::Set working directory
pushd "\\aviva.com.br\NETLOGON\Crowdstrike"

::Install Falcon Sensor
WindowsSensor.MaverickGyr.exe /install /quiet /norestart CID=0D4C550C62BA47098CA9FE1676016E5F-4D

::Remove working directory
popd

::End of File
:END