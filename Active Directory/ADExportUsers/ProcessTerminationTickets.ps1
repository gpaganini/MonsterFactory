<#
.SYNOPSIS
    FIND TERMINATED USERS IN DOMAINS BY SEARCHING AND COMPARING DATA FROM TERMINATION TICKETS
.DESCRIPTION
    FIND TERMINATED USERS IN DOMAINS BY SEARCHING AND COMPARING DATA FROM TERMINATION TICKETS
.EXAMPLE
    .\ProcessTerminationTickets.ps1
.NOTES
    NAME: ProcessTerminationTickets
    AUTHOR: Giovani Paganini <giovani.paganini@wexinc.com>
    CREATED: 12/17/2024
    MODIFIED: 12/23/2024
    CHANGELOG:
        V1.1, 12/23/2024 - Added support to multiple domains, overall script optimization.
        v1.0, 12/17/2024 - Initial Version
#>

Import-Module ".\Logger.psm1" -Force

# REMOVED DUE TO LIMITATIONS TO INSTALLATION ON WEX ENV. INSTALLED AS DOCUMENTED ON https://learn.microsoft.com/en-us/powershell/gallery/how-to/working-with-packages/manual-download?view=powershellget-3.x
<# if (-not (Get-Module -Name "Communary.PASM")) {
    try {
        Install-Module -Name "Communary.PASM"
        WriteLog -Message "Installing dependency package..."
    }
    catch {
        WriteLog -Message "Failed to install Communary Package, make sure its installed before running this script. It may be required to run as admin on  the first time."
        exit 1
    }
} #>

$TermTicketsCsv = ".\termtickets_parsed.csv"
$OutputFile = ".\termtickets_processed.csv"
$Domains = @(
    '.\wexprodr.csv',
    '.\phoenix.csv',
    '.\encprimary.csv',
    '.\floridacore.csv'
)

$OutputData = @()
$TermTicketsData = Import-Csv -Path $TermTicketsCsv -Delimiter ';' # File with user data to process

# Organize domain data by domain name for quick lookups
$DomainDataHash = @{}
foreach ($Domain in $Domains) {
    WriteLog -Message "Importing file '$Domain'..."
    $DomainName = [System.IO.Path]::GetFileNameWithoutExtension($Domain)# -split '\.' | Select-Object -First 1
    $ImportedData = Import-Csv -Path $Domain -Delimiter ";"
    $DomainDataHash[$DomainName] = $ImportedData
}

# Process each Term against all domain data
WriteLog -Message "$($TermTicketsData.Count) tickets to process."
foreach ($Term in $TermTicketsData) {
    WriteLog -Message "Processing User: $($Term.Name)"
    $OutputInfo = [PSCustomObject]@{
        Ticket              = $Term.Ticket
        Name                = $Term.Name
        WID                 = $Term.WID
        Email               = $Term.Email
        'Effective Date'    = $Term.'Effective Date'
        Manager             = $Term.Manager
    }

    foreach ($DomainName in $DomainDataHash.Keys) {
        $ADUsers = $DomainDataHash[$DomainName]
        $ExactMatch = $null
        $BestMatch = $null
        $HighestScore = 0

        foreach ($ADUser in $ADUsers) {
            if ($Term.Name -eq $ADUser.Name -or $Term.Name -eq $ADUser.DisplayName) {
                $ExactMatch = $ADUser
                WriteLog -Message "Exact match by name or display name in ${DomainName}: $($ADUser.DisplayName)"
            } elseif ($Term.WID -eq $ADUser.SamAccountName -or $ADUser.UserPrincipalName -like "*$($Term.WID)*") {
                $ExactMatch = $ADUser
                WriteLog -Message "Exact match by WID in username or UPN in ${DomainName}: $($ADUser.Name)"
            } elseif ($ADUser.Description -like "*$($Term.WID)*") {
                $ExactMatch = $ADUser
                WriteLog -Message "Exact match by WID in description in ${DomainName}: $($ADUser.Name)"
            } elseif ($ADUser.Mail -like "*$($Term.Email -split '@' | Select-Object -First 1)*") {
                $ExactMatch = $ADUser
                WriteLog -Message "Exact match by email in ${DomainName}: $($ADUser.Name)"
            }

            if ($ExactMatch) {
                WriteLog -Message "Exact match: $($ExactMatch.DisplayName), ${DomainName}"
                break
            } else {
                $Score = Get-JaroWinklerDistance $Term.Name $ADUser.Name
                if ($Score -ge 0.85 -and $Score -gt $HighestScore) {
                    WriteLog -Message "Score for $($ADUser.DisplayName) is ${Score}"
                    $HighestScore = $Score
                    $BestMatch = $ADUser
                    WriteLog -Message "Approximate match in ${DomainName}: $($BestMatch.DisplayName) with score of ${HighestScore}"
                }
            }
        }

        if ($ExactMatch) {
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${DomainName}_Username" -Value $ExactMatch.SamAccountName
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${DomainName}_Status" -Value $ExactMatch.Status
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${DomainName}_Matchtype" -Value "Exact" -Force
        } elseif ($BestMatch) {
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${DomainName}_Username" -Value $($BestMatch.DisplayName)
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${DomainName}_Status" -Value $BestMatch.Status
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${DomainName}_Matchtype" -Value "Approximate" -Force
        } else {
            WriteLog -Message "No match found in ${DomainName} for $($Term.Name)"
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${DomainName}_Username" -Value "Not Found"
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${DomainName}_Status" -Value "Not Found"
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${DomainName}_Matchtype" -Value "Not Found"
        }
    }

    $OutputData += $OutputInfo
}

$OutputData | Export-Csv -Path $OutputFile -Delimiter ";" -NoTypeInformation -Encoding utf8BOM