#region Disclaimer
<#
.SYNOPSIS
    EXPORTS A CSV REPORT CONTAINING ALL USERS IN ACTIVE DIRECTORY DOMAINS
.DESCRIPTION
    EXPORTS A CSV REPORT CONTAINING ALL USERS IN ACTIVE DIRECTORY DOMAINS.
    It may be required to configure WinRM TrustedHosts for the domains. See example:

    Set-Item WSMan:\localhost\Client\TrustedHosts -Value "domain1.local,domain2.local"
.EXAMPLE
    .\ExportADUsers.ps1
    It will generate a CSV file with all AD Users for the domain you're logged in.
.NOTES
    NAME: ExportADUsers
    AUTHOR: Giovani Paganini <giovanipaganini@outlook.com>
    CREATED: 04/08/2020
    MODIFIED: 12/17/2024
    CHANGELOG:
       - V1.2, 12/17/2024 - Added support to multiple domains, overall script optimization
       - v1.1, 02/03/2021 - Removed useless comments; Added filter ignoring system and default AD accounts
       - v1.0, 04/08/2020 - Initial Version
    TODO:
       - Work on local domain extraction script, for now has been deprecated.
       - Test if it is possible to use stored credentials on Windows Credential Manager.
#>
#endregion

############## TODO
<# param (
    [Parameter()]
    [switch]$GetAdUsers,

    [Parameter()]
    [switch]$GetRemoteAdUsers
) #>

#region Domains

# Placeholder example:
<# $Domains = @(
    'contoso.com',
    'fabrikam.com',
    'endurance.uk',
    'acme.org'
) #>

# Lab environment
<# $Credential = New-Object pscredential("gpaganini\da-gpaganini",(ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force))
$Domains = @(
    @{Domain = 'gpaganini.local'; JumpServer = "GP-DEMO-WS01.gpaganini.local"; Credential = $Credential}
) #>

$Domains = @(
    #@{Domain = 'wexprodr.wexglobal.com'; JumpServer = "DC2-WSUS-01.wexprodr.wexglobal.com"; Credential = Get-Credential -Message "WEXPRODR Creds"},
    #@{Domain = 'phoenix.retaildecisions.com.au'; JumpServer = "SY4WFAWSUS01P.phoenix.retaildecisions.com.au"; Credential = Get-Credential -message "PHOENIX Creds"},
    #@{Domain = 'encprimary.com'; JumpServer = "DC2-ENCWSUS-01.encprimary.com"; Credential = Get-Credential -message "ENCPRIMARY Creds"},
    #@{Domain = 'floridacore.local'; JumpServer = "SE4-FLCWSUS-01.floridacore.local"; Credential = Get-Credential -message "FLORIDACORE Creds"},
    @{Domain = 'pws.local'; JumpServer = "DC2-PWSWSUS-01.pws.local"; Credential = Get-Credential -Message "PWS Creds"},
    @{Domain = 'pwsdemo.local'; JumpServer = "SE4-PWSDTWUS-01.pwsdemo.local"; Credential = Get-Credential -Message "PWS DEMO Creds"}
)
#endregion

#region Attributes
$Attributes = @(
    "CN",
    "Name",
    "DisplayName",
    "GivenName",
    "sn",
    "EmployeeNumber",
    "SamAccountName",
    "UserPrincipalName",
    "Mail",
    "Description",
    "Enabled",
    "DistinguishedName",
    "CanonicalName"
) #endregion

#region Functions
Function Invoke-GetActiveDirectoryUsers {
    Import-Module ActiveDirectory

    # Get all users from Active Directory
    $AllADUsers = Get-ADUser -Filter * -Properties $Attributes | Sort-Object Name

    # Formats the information to be output properly
    $AllADUsersInfo = $AllADUsers | Select-Object -Property @{
        Name       = 'CN'
        Expression = { $_.CN -replace ',', '' -replace '\s+', ' ' }
    }, @{
        Name       = 'Name'
        Expression = { $_.Name -replace ',', '' -replace '\s+', ' ' }
    }, @{
        Name       = 'DisplayName'
        Expression = { $_.DisplayName -replace ',', '' -replace '\s+', ' ' }
    }, 'GivenName', 'sn', 'EmployeeNumber', 'SamAccountName', 'UserPrincipalName', 'Mail', 'Description', @{
        Name       = 'Status'
        Expression = { if ($_.Enabled) { 'Enabled' } else { 'Disabled' } }
    }, 'DistinguishedName', @{
        Name       = 'CanonicalName'
        Expression = { $_.CanonicalName -replace ',', '' -replace '\s+', ' ' }
    }

    # Output to CSV File
    $AllADUsersInfo | Export-Csv -Path ".\ad-export.csv" -Delimiter ";" -NoTypeInformation
}

Function Invoke-GetRemoteActiveDirectoryUsers {
    $RemoteFolder = "C:\temp\TermTickets"
    $LocalFolder = "C:\temp\TermTickets"
    ForEach ($DomainInfo in $Domains) {
        $Domain = $DomainInfo.Domain
        $JumpServer = $DomainInfo.JumpServer
        $DomainCredential = $DomainInfo.Credential
        $DomainName = $DomainInfo.Domain -split '\.' | Select-Object -First 1
        $RemoteOutputFile = "$RemoteFolder\$($DomainName).csv"
        $LocalOutputFile = "$LocalFolder\$($DomainName).csv"

        Write-Output "Executing remote command on server: $($JumpServer)"
        Invoke-Command -ComputerName $JumpServer -Credential $DomainCredential -ScriptBlock {
            param ($Domain, $DomainCredential, $Attributes, $RemoteFolder, $RemoteOutputFile)

            if (-not (Test-Path $RemoteFolder)) {
                New-Item -ItemType Directory -Path $RemoteFolder
            }

            $AllADUsers = Get-ADUser -Filter * -Properties $Attributes -Server $Domain -Credential $DomainCredential | Sort-Object Name

            $AllADUsersInfo = $AllADUsers | Select-Object -Property @{
                Name       = 'CN'
                Expression = { $_.CN -replace ',', '' -replace '\s+', ' ' }
            }, @{
                Name       = 'Name'
                Expression = { $_.Name -replace ',', '' -replace '\s+', ' ' }
            }, @{
                Name       = 'DisplayName'
                Expression = { $_.DisplayName -replace ',', '' -replace '\s+', ' ' }
            }, 'GivenName', 'sn', 'EmployeeNumber', 'SamAccountName', 'UserPrincipalName', 'Mail', 'Description', @{
                Name       = 'Status'
                Expression = { if ($_.Enabled) { 'Enabled' } else { 'Disabled' } }
            }, 'DistinguishedName', @{
                Name       = 'CanonicalName'
                Expression = { $_.CanonicalName -replace ',', '' -replace '\s+', ' ' }
            }
            $AllADUsersInfo | Export-Csv -Path $RemoteOutputFile -Delimiter ";" -NoTypeInformation
        } -ArgumentList $Domain, $DomainCredential, $Attributes, $RemoteFolder, $RemoteOutputFile

        if (-not (Test-Path $LocalFolder)) {
            New-Item -ItemType Directory -Path $LocalFolder
        }

        # Copy results to local computer
        $Session = New-PSSession -ComputerName $JumpServer -Credential $DomainCredential
        Copy-Item -Path $RemoteOutputFile -Destination $LocalOutputFile -FromSession $Session

        # Remove source items from remote computer
        Invoke-Command -Session $Session -ScriptBlock {
            param ($RemoteFolder)
            if (Test-Path $RemoteFolder) {
                Remove-Item -Path $RemoteFolder -Recurse -Force
            } else {
                Write-Output "File $RemoteFolder not found."
            }
        } -ArgumentList $RemoteFolder
        Get-PSSession | Remove-PSSession
    }
} #endregion

#region Execution
Invoke-GetActiveDirectoryUsers
#Invoke-GetRemoteActiveDirectoryUsers