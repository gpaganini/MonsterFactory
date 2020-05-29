	<# 
		.Synopsis
        Exporta um relatório de usuários do AD em CSV
		.Description
        Exporta um relatório detalhado de todos os usuários do AD para um arquivo CSV. O diretório de busca pode ser especificado na variável $searchBase e o dominio na variável $domain
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

<#[CmdletBinding()]
Param(
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]    
    [string]$Dominio = 'Dominio',
    [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]    
    [string]$searchBase = 'SearchBase'
)#>


$path = Split-Path -Parent "C:\Users\giovani.paganini.AVIVA\Documents\powershellson\ad\ADExportUsers\*.*"
$LogDate = get-date -f ddMMyyyy-hhmm

$csvfile = $path + "\ADUsers_$LogDate.csv"

#$searchBase = "OU=Usuarios,OU=TI,OU=Unidade Rio Quente,DC=aviva,DC=com,DC=br"

Import-Module ActiveDirectory

Function Main {
    #$GetAdminact = Get-Credential

    #$dc = Get-ADDomainController -DomainName $Dominio -Discover -NextClosestSite

    #$adServer = $dc.Hostname[0]

    $AllADUsers = Get-ADUser -Filter * -Properties * 

    $AllADUsers | 
    Select-Object @{Label = "Nome";Expression = {$_.Name}},
    @{Label = "DisplayName";Expression = {$_.DisplayName}},
    @{Label = "FirstName";Expression = {$_.GivenName}},
    @{Label = "LastName";Expression = {$_.sn}},
    @{Label = "Usuario";Expression = {$_.SamAccountName}},
    @{Label = "Matricula";Expression = {$_.IPPhone}},
    @{Label = "CPF";Expression = {$_.extensionAttribute1}},
    @{Label = "Cargo";Expression = {$_.Title}},
    @{Label = "Email";Expression = {$_.Mail}},
    @{Label = "Status";Expression = {if (($_.Enabled -eq 'TRUE')  ) {'Ativo'} Else {'Inativo'}}},
    @{Label = "LastLogonDate";Expression = {$_.LastLogonDate}},
    @{Label = "DN";Expression = {$_.DistinguishedName}} |

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

<#| Where-Object {$_.DistinguishedName -notlike "OU=Servidores,DC=aviva,DC=com,DC=br" -and ` 
        $_.DistinguishedName -notlike "OU=Usuarios Terceiros,OU=Unidade Costa do Sauipe,DC=aviva,DC=com,DC=br" -and ` 
        $_.DistinguishedName -notlike "OU=Usuarios Terceiros,OU=Unidade Rio Quente,DC=aviva,DC=com,DC=br" -and `
        $_.DistinguishedName -notlike "OU=Usuarios Servico - Exchange,OU=Unidade Rio Quente,DC=aviva,DC=com,DC=br"}#>