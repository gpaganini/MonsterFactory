@echo off

echo "............................................................................"
echo "............................................................................"
echo "........GGGGGGGGGGGGGEEEEEEEEEEEEEEEEEEEEEETTTTTTTTTTTTTTTTTTTTTTTIIIIIIIIII"
echo ".....GGG::::::::::::GE::::::::::::::::::::ET:::::::::::::::::::::TI::::::::I"
echo "...GG:::::::::::::::GE::::::::::::::::::::ET:::::::::::::::::::::TI::::::::I"
echo "..G:::::GGGGGGGG::::GEE::::::EEEEEEEEE::::ET:::::TT:::::::TT:::::TII::::::II"
echo ".G:::::G.......GGGGGG..E:::::E.......EEEEEETTTTTT..T:::::T..TTTTTT..I::::I.."
echo "G:::::G................E:::::E.....................T:::::T..........I::::I.."
echo "G:::::G................E::::::EEEEEEEEEE...........T:::::T..........I::::I.."
echo "G:::::G....GGGGGGGGGG..E:::::::::::::::E...........T:::::T..........I::::I.."
echo "G:::::G....G::::::::G..E:::::::::::::::E...........T:::::T..........I::::I.."
echo "G:::::G....GGGGG::::G..E::::::EEEEEEEEEE...........T:::::T..........I::::I.."
echo "G:::::G........G::::G..E:::::E.....................T:::::T..........I::::I.."
echo ".G:::::G.......G::::G..E:::::E.......EEEEEE........T:::::T..........I::::I.."
echo "..G:::::GGGGGGGG::::GEE::::::EEEEEEEE:::::E......TT:::::::TT......II::::::II"
echo "...GG:::::::::::::::GE::::::::::::::::::::E......T:::::::::T......I::::::::I"
echo ".....GGG::::::GGG:::GE::::::::::::::::::::E......T:::::::::T......I::::::::I"
echo "........GGGGGG...GGGGEEEEEEEEEEEEEEEEEEEEEE......TTTTTTTTTTT......IIIIIIIIII"
echo "............................................................................"
echo "............................................................................"
echo "============================================================================"
echo "===================INSTALACAO REMOTA DO VNC v1.3 by EDUARDO================="
echo "========================================Revisaoo by pagan0x================="
echo "============================================================================"
echo:
echo ".__................._.............___.........._...."
echo "/._\.___._.____..._(_).___.___.../...\___..___|.|.__"
echo "\.\./._.\.'__\.\././.|/.__/._.\././\./._.\/.__|.|/./"
echo "_\.\..__/.|...\.V./|.|.(_|..__//./_//..__/\__.\...<."
echo "\__/\___|_|....\_/.|_|\___\___/___,'.\___||___/_|\_\"
echo "...................................................."

:Start
SET /P var="Digite o IP: "
md \\%var%\c$\VNC\
copy "\\10.1.1.14\util$\Aplicativos\VNC\*.*" "\\%var%\c$\VNC\

echo Selecione a arquitetura do sistema: 
choice /C 12 /N /M "Selecione [1] para x64 e [2] para x32 bits"

if %errorlevel%==1 goto:x64

if %errorlevel%==2 goto:x32

:x64
echo Instalacao de 64bits
psexec \\%var% msiexec /i "C:\VNC\VNCserver64.msi" /quiet /norestart SET_USEVNCAUTHENTICATION=1 VALUE_OF_USEVNCAUTHENTICATION=1 SET_PASSWORD=1 VALUE_OF_PASSWORD=12345678 SET_VIEWONLYPASSWORD=1 VALUE_OF_VIEWONLYPASSWORD=12345678 SET_USECONTROLAUTHENTICATION=1 VALUE_OF_USECONTROLAUTHENTICATION=1 SET_CONTROLPASSWORD=1 VALUE_OF_CONTROLPASSWORD=12345678
rmdir /S /Q \\%var%\c$\VNC\

:x32
echo Instalacao de 32bits
psexec \\%var% msiexec /i "C:\VNC\VNCserver32.msi" /quiet /norestart SET_USEVNCAUTHENTICATION=1 VALUE_OF_USEVNCAUTHENTICATION=1 SET_PASSWORD=1 VALUE_OF_PASSWORD=12345678 SET_VIEWONLYPASSWORD=1 VALUE_OF_VIEWONLYPASSWORD=12345678 SET_USECONTROLAUTHENTICATION=1 VALUE_OF_USECONTROLAUTHENTICATION=1 SET_CONTROLPASSWORD=1 VALUE_OF_CONTROLPASSWORD=12345678
rmdir /S /Q \\%var%\c$\VNC\

pause