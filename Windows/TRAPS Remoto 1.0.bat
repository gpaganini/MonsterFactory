@echo off

echo ".__................._.............___.........._...."
echo "/._\.___._.____..._(_).___.___.../...\___..___|.|.__"
echo "\.\./._.\.'__\.\././.|/.__/._.\././\./._.\/.__|.|/./"
echo "_\.\..__/.|...\.V./|.|.(_|..__//./_//..__/\__.\...<."
echo "\__/\___|_|....\_/.|_|\___\___/___,'.\___||___/_|\_\"
echo "...................................................."
echo "===================================================="
echo "=====INSTALACAO REMOTA DO TRAPS v1.0 by GIOVANI====="
echo "===================================================="

:Start
SET /P var="Digite o IP ou nome da maquina: "
md \\%var%\c$\traps\
copy "\\10.1.1.14\util$\Aplicativos\Instalar sempre\Instalar Traps\AgenteWindowsTraps_x64.msi" "\\%var%\c$\traps\

psexec \\%var% msiexec /i "C:\traps\AgenteWindowsTraps_x64.msi" /quiet /norestart 
rmdir /S /Q \\%var%\c$\traps\

pause