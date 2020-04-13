	<# 
		.Synopsis
        Exporta um relatório de usuários do AD em CSV
		.Description
        Exporta um relatório detalhadao de todos os usuários do AD para um arquivo CSV. O diretório de busca pode ser especificado na variável $searchBase e o dominio na variável $domain
		.Example
		.\ExportADUsers.ps1
		.Notes
		NAME: ExportADUsers
		AUTHOR: Giovani Paganini
		CREATIONDATE: 08 April 2020
		LASTEDIT: 08 April 2020
		VERSION: 1.0
		
		Change Log
		v1.0, 08/04/2020 - Initial Version
		
	#>

[CmdletBinding()]
Param(
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]    
    [string]$Dominio = 'Dominio',
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]    
    [string]$searchBase = 'SearchBase'
)


$path = Split-Path -Parent "C:\Users\giovani.paganini\powershellson\ad\ADExportUsers\*.*"
$LogDate = get-date -f ddMMyyyy-hhmm

$csvfile = $path + "\ADUsers_$LogDate.csv"

#$searchBase = "OU=Usuarios,OU=TI,OU=Unidade Rio Quente,DC=aviva,DC=com,DC=br"

Import-Module ActiveDirectory

Function Main {
    $GetAdminact = Get-Credential

    $dc = Get-ADDomainController -DomainName $Dominio -Discover -NextClosestSite

    $adServer = $dc.Hostname[0]

    $AllADUsers = Get-ADUser -Server $adServer `
    -Credential $GetAdminact -SearchBase $searchBase `
    -Filter * -Properties *

    $AllADUsers | 
    Select-Object @{Label = "Nome";Expression = {$_.Name}},
    @{Label = "DisplayName";Expression = {$_.DisplayName}},
    @{Label = "Usuario";Expression = {$_.SamAccountName}},
    @{Label = "Matricula";Expression = {$_.IPPhone}},
    @{Label = "CPF";Expression = {$_.extensionAttribute1}},
    @{Label = "Cargo";Expression = {$_.Title}},
    @{Label = "Email";Expression = {$_.Email}},
    @{Label = "Status";Expression = {if (($_.Enabled -eq 'TRUE')  ) {'Ativo'} Else {'Inativo'}}} |

    Export-Csv -Path $csvfile -NoTypeInformation -Encoding UTF8
}

. Main



<#$fN = "Name"
$dN = "DisplayName"
$mail = "Email"
$usuario = "SamAccountName"
$matricula = "IPPhone"
$cpf = "extensionAttribute1"

$oUser = Get-ADUser -Identity giovani.paganini -Properties * | select $fN,$dN,$mail,$usuario,$matricula,$cpf
#>


