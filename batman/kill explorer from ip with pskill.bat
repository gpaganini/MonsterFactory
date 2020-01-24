@ECHO OFF
SET /P machinaip=Digite o IP da maquina:
IF "%machinaip%"=="" GOTO Error
pskill -t \\%machinaip% explorer
:Error
ECHO "Endereço IP não digitado!"
:End