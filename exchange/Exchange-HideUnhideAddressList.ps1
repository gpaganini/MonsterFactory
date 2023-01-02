	<# 
		.Synopsis
         Automaticamente Oculta e Reexibe usuarios inativos e ativos, respectivamente, do catálogo de endereços do Exchange On-Premise.
		.Description
         Automaticamente Oculta e Reexibe usuarios inativos e ativos, respectivamente, do catálogo de endereços do Exchange On-Premise, setando o parâmetro HiddenFromAddressListEnabled.
		.Example
		.\Exchange-HideUnhideAddressList.ps1
		.Notes
		NAME: Exchange-HideUnhideAddressList
		AUTHOR: Giovani Paganini
		CREATIONDATE: 31 March 2021
		LASTEDIT: 19 December 2022
		VERSION: 1.0
		
		Change Log
		v1.0, 19/12/2022 - Added explanatory comments to functions.
		v1.0, 10/11/2020 - Initial Version.
	#>

# Importa o módulo do AD
Import-Module ActiveDirectory

#Função de escrita de log
function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Message,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Info','Warning','Error')]
        [string]$Severity = 'Info'
    )

    [pscustomobject]@{
        Time = (Get-Date -Format "dd/mm/yyyy HH:mm:ss")
        Message = $Message
        Severity = $Severity
    } | Export-Csv -Path "C:\Scripts\Exchange-HideUnhide-Log.csv" -Append -NoTypeInformation -Encoding UTF8 -Delimiter ";" ## Defina o caminho de onde salvará o log.
}

#Função que define as credenciais de conexão com o Exchange On-Premises
function Credentials {
    $userLogin = 'aviva\svc.asg.o365'
    $userPwd = Get-Content "C:\Scripts\ASGCred.txt" #Arquivo que contém a senha criptografada conforme o guia: https://www.pdq.com/blog/secure-password-with-powershell-encrypting-credentials-part-1/

    $securePwd = $userPwd | ConvertTo-SecureString

    $userCred = New-Object System.Management.Automation.PSCredential -ArgumentList $userLogin, $securePwd

    return $userCred

    Write-Log -Message "Credenciais OK." -Severity Info
}

# Define o conector com o servidor do exchange.
function ConnectExchange {
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://SRVRQE940021/PowerShell/ -Authentication Kerberos -Credential (Credentials)
    Import-PSSession $Session

    Write-Log -Message "Conectado ao Exchange OnPremise" -Severity Info
}

#Fecha a sessão do exchange após a execução
function CloseSession {
    Get-PSSession | Remove-PSSession
    Write-Log -Message "Fechando conexao com o exchange" -Severity Info
}

#Armazena todos os usuarios desativados do AD em uma variável
function Get-DisabledUsers {
    Write-Log -Message "Buscando usuarios inativos." -Severity Info
    $DisabledUsers = Get-ADUser -Filter {Enabled -eq $false}
    return $DisabledUsers
}

#Armazena todos os usuarios ativos do AD em uma variável
function Get-EnabledUsers {
    Write-Log -Message "Buscando usuarios ativos." -Severity Info
    $EnabledUsers = Get-ADUser -Filter {Enabled -eq $true}
    return $EnabledUsers
}

# Função principal que coloca tudo junto e executa o comando
function HideDisabledMailboxes {
    ConnectExchange

    Write-Log -Message "Buscando usuarios inativos do AD." -Severity Info
    $DisabledUsers = Get-ADUser -Filter {Enabled -eq $false}

    Write-Log -Message "Ocultando usuarios desabilitados do catálogo." -Severity Info

    foreach ($user in $DisabledUsers) {
        Set-RemoteMailbox -Identity $user.SamAccountName -HiddenFromAddressListsEnabled $true
    }

    CloseSession
}

function UnhideEnabledMailboxes {
    ConnectExchange

    Write-Log -Message "Buscando usuarios ativos do AD." -Severity Info
    $EnabledUsers = Get-ADUser -Filter {Enabled -eq $true}

    Write-Log -Message "Re-exibindo usuarios ativos no catálogo." -Severity Info

    foreach ($user in $EnabledUsers) {
        Set-RemoteMailbox -Identity $user.SamAccountName -HiddenFromAddressListsEnabled $false
    }

    CloseSession
}

#Chama as funções e as executa.
HideDisabledMailboxes
UnhideEnabledMailboxes