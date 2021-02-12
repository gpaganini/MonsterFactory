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
		LASTEDIT: 03 February 2021
		VERSION: 1.1
		
		Change Log
        v1.1, 03/02/2021 - Removed useless comments; Added filter ignoring system and default AD accounts
		v1.0, 08/04/2020 - Initial Version		
	#>

$ignoreUsers = Import-Csv -Path "C:\Scripts\ADExportUsers\Ignore.csv"

$path = Split-Path -Parent "C:\Scripts\ADExportUsers\*.*"
$LogDate = get-date -f ddMMyyyy-hhmm

$csvfile = $path + "\ADUsers_$LogDate.csv"

Import-Module ActiveDirectory

Function Main {    

    $AllADUsers = Get-ADUser -Filter * -Properties * 

    foreach ($user in $ignoreUsers) {
        $AllADUsers = $AllADUsers | where {$_.Name -ne $user.Nome}
    }

    $AllADUsers | 
    Select-Object @{Label = "Nome";Expression = {$_.Name}},
    @{Label = "DisplayName";Expression = {$_.DisplayName}},
    @{Label = "FirstName";Expression = {$_.GivenName}},
    @{Label = "LastName";Expression = {$_.sn}},
    @{Label = "Usuario";Expression = {$_.SamAccountName}},
    @{Label = "UPN";Expression = {$_.UserPrincipalName}},
    @{Label = "Matricula";Expression = {$_.IPPhone}},
    @{Label = "CPF";Expression = {$_.extensionAttribute1}},
    @{Label = "Cargo";Expression = {$_.Title}},
    @{Label = "Email";Expression = {$_.Mail}},
    @{Label = "Departamento";Expression = {$_.Department}},
    @{Label = "Description";Expression = {$_.Description}},
    @{Label = "Office";Expression = {$_.Office}},
    @{Label = "PhoneNumber";Expression = {$_.telephoneNumber}},
    @{Label = "Street";Expression = {$_.streetAddress}},
    @{Label = "City";Expression = {$_.city}},
    @{Label = "State";Expression = {$_.State}},
    @{Label = "PostalCode";Expression = {$_.postalCode}},
    @{Label = "Country";Expression = {$_.country}},
    @{Label = "Company";Expression = {$_.Company}},
    @{Label = "Status";Expression = {if (($_.Enabled -eq 'TRUE')  ) {'Ativo'} Else {'Inativo'}}},
    @{Label = "LastLogonDate";Expression = {$_.LastLogonDate}},
    @{Label = "DN";Expression = {$_.DistinguishedName}} |

    Export-Csv -Path $csvfile -NoTypeInformation -Encoding UTF8
}

. Main