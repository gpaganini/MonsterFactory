	<# 
		.Synopsis
        Realiza a ativação da caixa de email remota
		.Description
        Realiza a ativação da caixa de email remota pelo Remote Shell do Exchange.
		.Example
		.\EnableRemoteMailbox.ps1
		.Notes
		NAME: EnableRemoteMailbox
		AUTHOR: Giovani Paganini
		CREATIONDATE: 10 November 2020
		LASTEDIT: 10 November 2020
		VERSION: 1.0
		
		Change Log
		v1.0, 10/11/2020 - Initial Version		
	#>

Write-Host "
.__................._.............___.........._....
/._\.___._.____..._(_).___.___.../...\___..___|.|.__
\.\./._.\.'__\.\././.|/.__/._.\././\./._.\/.__|.|/./
_\.\..__/.|...\.V./|.|.(_|..__//./_//..__/\__.\...<.
\__/\___|_|....\_/.|_|\___\___/___,'.\___||___/_|\_\
....................................................
.............Exchange Mailbox Script 1.0 by PaganoiS
" -ForegroundColor Green -BackgroundColor Black




Write-Host "
1. Habilitar caixa de usuário
999. Sair
" -ForegroundColor Cyan

$number = Read-Host "Selecione a opção"
$output = @()

switch($number) {
    1{
        Write-Host "Digite suas credenciais no formato aviva\usuario..." -ForegroundColor Green
        $UserCredential = Get-Credential

        Write-Host "Inicializando conexão com o Exchange Local..." -ForegroundColor Green

        try {
            $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://SRVRQE940021/PowerShell/ -Authentication Kerberos -Credential $UserCredential -ErrorAction Stop
        } catch {
            Write-Host "Autenticação falhou, verifique suas credenciais" -ForegroundColor Red
            break;
        }

        Write-Host "Conexão OK, importando sessão" -ForegroundColor Green
        Import-PSSession $Session

        $user = Read-Host "Digite o nome de usuário"
        Write-Host "Habilitando caixa para $($user)@grq.mail.onmicrosoft.com" -ForegroundColor Cyan
        try {
            Enable-RemoteMailbox -Identity $user -RemoteRoutingAddress ($user+"@grq.mail.onmicrosoft.com") -ErrorAction Stop
        } catch [System.Management.Automation.RemoteException] {
            Write-Host $_.Exception -ForegroundColor White -BackgroundColor Red
        }        
    ;break}

    999{
        Write-Host "Fechando conexões e encerrando o script..." -ForegroundColor Cyan
        Get-PSSession | Remove-PSSession        
    ;break}

    Default {Write-Host "Opção selecionada incorreta. Selecione uma opção da lista!" -ForegroundColor White -BackgroundColor Red}
}

#aways close conection when script ends, regardless

Get-PSSession | Remove-PSSession

write-host "
       _
      (\\
       \||
     `__`(_`";
    /    \
   `{`}___`)\`)_

Follow the white rabbit...          
" -ForegroundColor green -BackgroundColor Black