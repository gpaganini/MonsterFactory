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
       - V1.2, 12/17/2024 - Added support to multiple domains, overall script optimization
       - v1.1, 02/03/2021 - Removed useless comments; Added filter ignoring system and default AD accounts
       - v1.0, 04/08/2020 - Initial Version
    TODO:
       - Work on local domain extraction script, for now has been deprecated.
       - Test if it is possible to use stored credentials on Windows Credential Manager.
#>

# Placeholder example:
<# $Domains = @(
    'contoso.com',
    'fabrikam.com',
    'endurance.uk',
    'acme.org'
) #>

# Test environment
<# $Credential = New-Object pscredential("gpaganini\da-gpaganini",(ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force))
$Domains = @(
    @{Domain = 'gpaganini.local'; JumpServer = "GP-DEMO-WS01.gpaganini.local"; Credential = $Credential}
) #>

$Domains = @(
    @{Domain = 'wexprodr.wexglobal.com'; JumpServer = "DC2-WSUS-01.wexprodr.wexglobal.com"; Credential = Get-Credential -Message "WEXPRODR Creds"},
    @{Domain = 'phoenix.retaildecisions.com.au'; JumpServer = "SY4WFAWSUS01P.phoenix.retaildecisions.com.au"; Credential = Get-Credential -message "PHOENIX Creds"},
    @{Domain = 'encprimary.com'; JumpServer = "DC2-ENCWSUS-01.encprimary.com"; Credential = Get-Credential -message "ENCPRIMARY Creds"},
    @{Domain = 'floridacore.local'; JumpServer = "SE4-FLCWSUS-01.floridacore.local"; Credential = Get-Credential -message "FLORIDACORE Creds"}
)

$Attributes = @(
    "Name",
    "DisplayName",
    "GivenName",
    "sn",
    "SamAccountName",
    "UserPrincipalName",
    "Mail",
    "Description",
    "Enabled",
    "DistinguishedName"
)

Function Invoke-GetActiveDirectoryUsers {
    Import-Module ActiveDirectory
    ForEach ($DomainInfo in $Domains) {
        $Domain = $DomainInfo.Domain
        $DomainCredential = $DomainInfo.Credential
        $OutputFile = $OutputPath+"\$($Domain).csv"

        $AllADUsers = Get-ADUser -Filter * -Properties $Attributes -Server $Domain -Credential $DomainCredential | Sort-Object Name
        $AllADUsersInfo = $AllADUsers | Select-Object -Property @{
            Name       = 'Name'
            Expression = { $_.Name -replace ',', '' -replace '\s+', ' ' }
        }, @{
            Name       = 'DisplayName'
            Expression = { $_.DisplayName -replace ',', '' -replace '\s+', ' ' }
        }, 'GivenName', 'sn', 'SamAccountName', 'UserPrincipalName', 'Mail', 'Description', @{
            Name       = 'Status'
            Expression = { if ($_.Enabled) { 'Enabled' } else { 'Disabled' } }
        }, 'DistinguishedName'

        $AllADUsersInfo | Export-Csv -Path $OutputFile -Delimiter ";" -NoTypeInformation
    }
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
                Name       = 'Name'
                Expression = { $_.Name -replace ',', '' -replace '\s+', ' ' }
            }, @{
                Name       = 'DisplayName'
                Expression = { $_.DisplayName -replace ',', '' -replace '\s+', ' ' }
            }, 'GivenName', 'sn', 'SamAccountName', 'UserPrincipalName', 'Mail', 'Description', @{
                Name       = 'Status'
                Expression = { if ($_.Enabled) { 'Enabled' } else { 'Disabled' } }
            }, 'DistinguishedName'

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
}

Invoke-GetRemoteActiveDirectoryUsers