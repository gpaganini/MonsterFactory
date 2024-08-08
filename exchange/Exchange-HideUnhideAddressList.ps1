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
        v2.0, 08/08/2024 - Major script refactoration:
                            -   Changed the way that credentials are encrypted and used by implementing key encryption.
                            -   Functions optimized and better treated.
                            -   New WriteLog function version.
                            -   Functions rewritten to better understanding.
		v1.0, 19/12/2022 - Added explanatory comments to functions.
		v1.0, 10/11/2020 - Initial Version.
	#>

param (
    [string]$userLogin = 'aviva\svc.ada'
)

# Importa o módulo do AD
Import-Module ActiveDirectory

#Função de escrita de log
$logFile = ".\AddressListsLog_$(get-date -f dd-MM-yyyy).log"
function WriteLog {
    param (
        [string]$message,
        [string]$logLevel = "INFO"
    )

    $logEntry = "[{0}]{1}{2}" -f (get-date -f 'dd/MM/yyyy HH:mm:ss'), "[$loglevel]", $message
    $logEntry | Out-File -Append -FilePath $logFile
    Write-Host $logEntry
}

#Função que define as credenciais de conexão com o Exchange On-Premises
function Credentials {
    $key = Get-Content ".\ada.bin"
    $encryptedPassword = Get-Content ".\ada.txt"
    $securePwd = $encryptedPassword | ConvertTo-SecureString -Key $key

    $userCred = New-Object System.Management.Automation.PSCredential -ArgumentList $userLogin, $securePwd

    return $userCred

    WriteLog -message "Credenciais importadas com sucesso!"
}

# Define o conector com o servidor do exchange.
function ConnectExchange {
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://SRVRQE940021/PowerShell/ -Authentication Kerberos -Credential (Credentials)
    Import-PSSession $Session -AllowClobber

    WriteLog -message "Conectado ao Exchange OnPremise!"
}

#Fecha a sessão do exchange após a execução
function CloseSession {
    Get-PSSession | Remove-PSSession
    WriteLog -Message "Fechando conexao com o exchange!"
}

function DisposeCreds {
    if ($null -ne $userCred) {
        $userCred.Dispose()
        WriteLog -message "Credentials disposed!"
    }
}

#Armazena todos os usuarios desativados do AD em uma variável
function Get-DisabledUsers {
    param (
        [string]$logMessage = "Buscando usuários inativos...",
        [string[]]$properties = @('SamAccountName','Enabled','Name')
    )
    
    WriteLog -message $logMessage

    try {
        $DisabledUsers = Get-ADUser -Filter {Enabled -eq $false} -Properties $properties
        WriteLog -message "Usuários inativos encontrados: $($DisabledUsers.Count)"

        return $DisabledUsers
    }
    catch {
        WriteLog -message "Erro ao buscar usuários inativos: $_" -logLevel "ERROR"        
    }
}

#Armazena todos os usuarios ativos do AD em uma variável
function Get-EnabledUsers {
    param (
        [string]$logMessage = "Buscando usuários ativos...",
        [string[]]$properties = @('SamAccountName','Enabled','Name')
    )
    WriteLog -Message $logMessage

    try {
        $EnabledUsers = Get-ADUser -Filter {Enabled -eq $true} -Properties $properties
        WriteLog -message "Usuários ativos encontrados: $($EnabledUsers.Count)"
    }
    catch {
        WriteLog -message "Erro ao buscar usuários ativos: $_" -logLevel "ERROR" 
    }

    return $EnabledUsers
}

# Função principal que coloca tudo junto e executa o comando
function HideDisabledMailboxes {
    ConnectExchange    

    $DisabledUsers = Get-DisabledUsers

    WriteLog -Message "Ocultando usuários desabilitados do catálogo."

    foreach ($user in $DisabledUsers) {
        try {            
            Set-RemoteMailbox -Identity $user.SamAccountName -HiddenFromAddressListsEnabled $true
            #WriteLog -message "Usuário $($user.SamAccountName) ocultado com sucesso."
        }
        catch {
            WriteLog -message "Falha ao buscar usuarios." -logLevel "ERROR"
        }        
    }

    CloseSession
    DisposeCreds
}

function UnhideEnabledMailboxes {
    ConnectExchange

    $EnabledUsers = Get-EnabledUsers    

    WriteLog -Message "Exibindo usuários ativos no catálogo."

    foreach ($user in $EnabledUsers) {
        try {
            Set-RemoteMailbox -Identity $user.SamAccountName -HiddenFromAddressListsEnabled $false
            #WriteLog -message "Usuário $($user.SamAccountName) exibido com sucesso."
        }
        catch {
            WriteLog -message "Falha ao buscar usuarios." -logLevel "ERROR"
        }        
    }

    CloseSession
    DisposeCreds
}

#Chama as funções e as executa.
WriteLog -message "START"
HideDisabledMailboxes
UnhideEnabledMailboxes
WriteLog -message "END"