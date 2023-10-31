@ECHO ON

::Check if already installed
IF EXIST "C:\Program Files\7-Zip" GOTO INSTALL

::echo "<<app>> already installed" >> c:\temp\<<app>>_Install.log

:INSTALL
::Set working directory
pushd "\\aviva.com.br\NETLOGON\7z"

::Install 7z
msiexec /i 7z.msi /qn /norestart

::Remove working directory
popd

::End of File
:END