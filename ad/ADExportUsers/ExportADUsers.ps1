<#
.SYNOPSIS
    EXPORTS A CSV REPORT CONTAINING ALL USERS IN ACTIVE DIRECTORY DOMAINS
.DESCRIPTION
.EXAMPLE
    .\ExportADUsers.ps1
.NOTES
    NAME: ExportADUsers
    AUTHOR: Giovani Paganini <giovanipaganini@outlook.com>
    CREATED: 04/08/2020
    MODIFIED: 12/17/2024
    CHANGELOG:
        V1.2, 12/17/2024 - Added support to multiple domains, overall script optimization
        v1.1, 02/03/2021 - Removed useless comments; Added filter ignoring system and default AD accounts
        v1.0, 04/08/2020 - Initial Version
#>

Import-Module ActiveDirectory

$Domains = @(
    'domain.local'
)

$OutputPath = "C:\temp"
$Date = (get-date -f MMddyyyy)

$Attributes = @(
    "Name",
    "DisplayName",
    "GivenName",
    "sn",
    "SamAccountName",
    "UserPrincipalName",
    #"Title",
    "Mail",
    #"Department",
    "Description",
    "Enabled",
    #"LastLogonDate",
    "DistinguishedName"
)

Function Invoke-GetActiveDirectoryUsers {
    ForEach ($Domain in $Domains) {
        $OutputFile = $OutputPath+"\$($Date)_$($Domain).csv"
        
        $AllADUsers = Get-ADUser -Filter * -Properties $Attributes -Server $Domain
    
        $AllADUsers | ForEach-Object {
            [PSCustomObject]@{
                Name                = $_.Name -replace ',', '' -replace '\s+', ' '
                DisplayName         = $_.DisplayName -replace ',', '' -replace '\s+', ' '
                FirstName           = $_.GivenName
                LastName            = $_.sn
                UserName            = $_.SamAccountName
                UserPrincipalName   = $_.UserPrincipalName
                #Title               = $_.Title
                Mail                = $_.Mail
                #Department          = $_.Department
                Description         = $_.Description
                Status              = if ($_.Enabled) {'Enabled'} else {'Disabled'}
                #LastLogonDate       = $_.LastLogonDate
                DN                  = $_.DistinguishedName
            }
        } | Export-Csv -Path $OutputFile -Delimiter ";" -NoTypeInformation -Encoding UTF8
    }
}

Invoke-GetActiveDirectoryUsers