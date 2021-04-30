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
		LASTEDIT: 31 March 2021
		VERSION: 1.0
		
		Change Log        
		v1.0, 08/04/2020 - Initial Version		
	#>

Import-Module ActiveDirectory

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
        Time = (Get-Date -Format "HH:mm:ss")
        Message = $Message
        Severity = $Severity
    } | Export-Csv -Path "C:\Scripts\Exchange-HideUnhide-Log.csv" -Append -NoTypeInformation -Encoding UTF8 -Delimiter ";"
}

function Credentials {
    $userLogin = 'aviva\svc.asg.o365'
    $userPwd = Get-Content "C:\Scripts\ASGCred.txt"

    $securePwd = $userPwd | ConvertTo-SecureString

    $userCred = New-Object System.Management.Automation.PSCredential -ArgumentList $userLogin, $securePwd

    return $userCred

    Write-Log -Message "Credenciais OK." -Severity Info
}

function ConnectExchange {
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://SRVRQE940021/PowerShell/ -Authentication Kerberos -Credential (Credentials)
    Import-PSSession $Session

    Write-Log -Message "Conectado ao Exchange OnPremise" -Severity Info
}

function CloseSession {
    Get-PSSession | Remove-PSSession
    Write-Log -Message "Fechando conexao com o exchange" -Severity Info
}

function Get-DisabledUsers {
    Write-Log -Message "Buscando usuarios inativos." -Severity Info
    $DisabledUsers = Get-ADUser -Filter {Enabled -eq $false}
    return $DisabledUsers
}

function Get-EnabledUsers {
    Write-Log -Message "Buscando usuarios ativos." -Severity Info
    $EnabledUsers = Get-ADUser -Filter {Enabled -eq $true}
    return $EnabledUsers
}

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

HideDisabledMailboxes
UnhideEnabledMailboxes