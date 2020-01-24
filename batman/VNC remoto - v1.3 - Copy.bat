@echo on

echo ".__................._.............___.........._...."
echo "/._\.___._.____..._(_).___.___.../...\___..___|.|.__"
echo "\.\./._.\.'__\.\././.|/.__/._.\././\./._.\/.__|.|/./"
echo "_\.\..__/.|...\.V./|.|.(_|..__//./_//..__/\__.\...<."
echo "\__/\___|_|....\_/.|_|\___\___/___,'.\___||___/_|\_\"
echo "...................................................."
echo "===================================================="
echo "=====INSTALACAO REMOTA DO TRAPS v1.0 by Giovani====="
echo "===================================================="

:Start
SET /P var="Digite o IP: "
md \\%var%\c$\temp\traps
copy "\\10.1.1.14\util$\Aplicativos\Instalar sempre\Instalar Traps\AgenteWindowsTraps_x64.msi" "\\%var%\c$\temp\traps

echo Instalacao de 64bits
psexec -u rqr\sccm.admin \\%var% msiexec /i "C:\temp\traps\AgenteWindowsTraps_x64.msi" /quiet /norestart
rmdir /S /Q \\%var%\c$\temp\traps

pause