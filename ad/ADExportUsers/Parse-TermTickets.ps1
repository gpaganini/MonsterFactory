<#
.SYNOPSIS
    PARSE TERMINATION TICKETS EXPORTED FROM JIRA INTO READABLE CONTENT TO BE USED IN ANOTHER SCRIPTS
.DESCRIPTION
    PARSE TERMINATION TICKETS EXPORTED FROM JIRA INTO READABLE CONTENT TO BE USED IN ANOTHER SCRIPTS
.EXAMPLE
    .\Parse-TermTickets.ps1 -InputFile .\JiraExport.csv
.NOTES
    NAME: Parse-TermTickets
    AUTHOR: Giovani Paganini <giovani.paganini@wexinc.com>
    CREATED: 12/17/2024
    MODIFIED: 12/17/2024
    CHANGELOG:
        v1.0, 12/17/2024 - Initial Version
#>

# Define the input and output files
param (
    [Parameter(Mandatory = $true)]
    [string]$InputFile
)

$OutputFile = ".\termtickets_parsed.csv"

if (-not $InputFile.EndsWith('.csv')){
    Write-Host "Not a valid CSV file"
    exit
}

# Import the CSV and process the 'Description' column
Import-Csv -Path $InputFile |
    ForEach-Object {
        # Extract relevant fields from the 'Description' column
        $DescriptionText = $_.Description
        $Ticket = $_.'Issue Key'

        # Use regex to extract key details
        $Name = if ($DescriptionText -match "Name:\s*(.+)") { $matches[1].Trim() } else { "" }
        $WID = if ($DescriptionText -match "WID:\s*(.+)") { $matches[1].Trim() } else { "" }
        $Email = if ($DescriptionText -match "Email:\s*(.+)") { $matches[1].Trim() } else { "" }
        $EffectiveDate = if ($DescriptionText -match "Effective Date:\s*(.+)") { $matches[1].Trim() } else { "" }
        $Manager = if ($DescriptionText -match "Manager:\s*(.+)") { $matches[1].Trim() } else { "" }

        # Output as a custom object
        [PSCustomObject]@{
            Ticket         = $Ticket
            Name           = $Name
            WID            = $WID
            Email          = $Email
            'Effective Date' = $EffectiveDate
            Manager        = $Manager
        }
    } |
    # Export to a new CSV
    Export-Csv -Path $OutputFile -NoTypeInformation -Delimiter ";" -Encoding UTF8

Write-Output "Filtered data saved to $OutputFile"
