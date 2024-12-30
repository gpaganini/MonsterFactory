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

$InputCsv = '.\wexprodr.csv'
$WexUsers = Import-Csv -Path $InputCsv -Delimiter ";"

#$TermTicketsCsv = ".\termtickets_parsed.csv"
$OutputFile = ".\DomainsProcessed.csv"
$LegacyDomains = @(
    '.\phoenix.csv',
    '.\encprimary.csv',
    '.\floridacore.csv',
    '.\pws.csv',
    '.\pwsdemo.csv'
)
#$TermTicketsData = Import-Csv -Path $TermTicketsCsv -Delimiter ';' # File with user data to process

# Organize domain data by domain name for quick lookups
$LegacyDomainDataHash = @{}
foreach ($LegacyDomain in $LegacyDomains) {
    WriteLog -Message "Importing file '$LegacyDomain'..."
    $Domain = [System.IO.Path]::GetFileNameWithoutExtension($LegacyDomain)# -split '\.' | Select-Object -First 1
    $ImportedData = Import-Csv -Path $LegacyDomain -Delimiter ";"
    $LegacyDomainDataHash[$Domain] = $ImportedData
}

Function Invoke-CompareADUsers () {
    $OutputData = @()
    WriteLog -Message "$($WexUsers.Count) users to process."
    foreach ($WexUser in $WexUsers) {
        $OutputInfo = [PSCustomObject]@{
            CN = $WexUser.CN
            Name = $WexUser.Name
            DisplayName = $WexUser.DisplayName
            FirstName = $WexUser.GivenName
            LastName = $WexUser.sn
            EmployeeNumber = $WexUser.EmployeeNumber
            SamAccountName = $WexUser.SamAccountName
            UserPrincipalName = $WexUser.UserPrincipalName
            Mail = $WexUser.Mail
            Description = $WexUser.Description
            Status = $WexUser.Status
            DistinguishedName = $WexUser.DistinguishedName
            CanonicalName = $WexUser.CanonicalName
        }

        foreach ($Domain in $LegacyDomainDataHash.Keys) {
            $LegacyUsers = $LegacyDomainDataHash[$Domain]
            $ExactMatch = $null
            $BestMatch = $null
            $HighestScore = 0

            foreach ($LegacyUser in $LegacyUsers) {
                # Search WID in Description
                if ($LegacyUser.Description -and ($WexUser.EmployeeNumber -like "*$($LegacyUser.Description)*")){
                    WriteLog -Message "Exact match by WID in DESCRIPTION on ${Domain}:$($LegacyUser.Name)"
                    $ExactMatch = $LegacyUser
                } # Search WID in SamAccountName
                elseif ($LegacyUser.SamAccountName -and ($WexUser.EmployeeNumber -like "*$($LegacyUser.SamAccountName)*")) {
                    WriteLog -Message "Exact match by WID in SAMACCOUNTNAME on ${Domain}:$($LegacyUser.Name)"
                    $ExactMatch = $LegacyUser
                } # Search WID in UserPrincipalName
                elseif ($LegacyUser.UserPrincipalName -and ($WexUser.EmployeeNumber -like "*$($LegacyUser.UserPrincipalName)*")) {
                    WriteLog -Message "Exact match by WID in USERPRINCIPALNAME on ${Domain}:$($LegacyUser.Name)"
                    $ExactMatch = $LegacyUser
                }
                elseif ($LegacyUser.Name -and ($WexUser.Name -eq $LegacyUser.Name -or $WexUser.DisplayName -eq $LegacyUser.DisplayName)) {
                    $BestMatch = $LegacyUser
                }

                <# if ($ExactMatch) {
                    WriteLog -Message "Exact match: $($ExactMatch.CN), ${Domain}"
                    break
                } #>
            }

            if ($ExactMatch) {
                $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Username" -Value $ExactMatch.SamAccountName
                $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Status" -Value $ExactMatch.Status
                $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Matchtype" -Value "Exact" -Force
            } elseif ($BestMatch) {
                $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Username" -Value $BestMatch.CN
                $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Status" -Value $BestMatch.Status
                $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Matchtype" -Value "Best Match" -Force
            } else {
                #WriteLog -Message "No match found in ${Domain} for $($WexUser.Name)"
                $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Username" -Value ""
                $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Status" -Value ""
                $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Matchtype" -Value ""
            }
        }
        $OutputData += $OutputInfo
    }

    $OutputData | Export-Csv -Path $OutputFile -Delimiter ";" -NoTypeInformation -Encoding utf8BOM
}
<#
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

    foreach ($Domain in $LegacyDomainDataHash.Keys) {
        $LegacyUsers = $LegacyDomainDataHash[$Domain]
        $ExactMatch = $null
        $BestMatch = $null
        $HighestScore = 0

        foreach ($LegacyUser in $LegacyUsers) {
            if ($Term.Name -eq $LegacyUser.Name -or $Term.Name -eq $LegacyUser.DisplayName) {
                $ExactMatch = $LegacyUser
                WriteLog -Message "Exact match by name or display name in ${Domain}: $($LegacyUser.DisplayName)"
            } elseif ($Term.WID -eq $LegacyUser.SamAccountName -or $LegacyUser.UserPrincipalName -like "*$($Term.WID)*") {
                $ExactMatch = $LegacyUser
                WriteLog -Message "Exact match by WID in username or UPN in ${Domain}: $($LegacyUser.Name)"
            } elseif ($LegacyUser.Description -like "*$($Term.WID)*") {
                $ExactMatch = $LegacyUser
                WriteLog -Message "Exact match by WID in description in ${Domain}: $($LegacyUser.Name)"
            } elseif ($LegacyUser.Mail -like "*$($Term.Email -split '@' | Select-Object -First 1)*") {
                $ExactMatch = $LegacyUser
                WriteLog -Message "Exact match by email in ${Domain}: $($LegacyUser.Name)"
            }

            if ($ExactMatch) {
                WriteLog -Message "Exact match: $($ExactMatch.DisplayName), ${Domain}"
                break
            } else {
                $Score = Get-JaroWinklerDistance $Term.Name $LegacyUser.Name
                if ($Score -ge 0.85 -and $Score -gt $HighestScore) {
                    WriteLog -Message "Score for $($LegacyUser.DisplayName) is ${Score}"
                    $HighestScore = $Score
                    $BestMatch = $LegacyUser
                    WriteLog -Message "Approximate match in ${Domain}: $($BestMatch.DisplayName) with score of ${HighestScore}"
                }
            }
        }

        if ($ExactMatch) {
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Username" -Value $ExactMatch.SamAccountName
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Status" -Value $ExactMatch.Status
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Matchtype" -Value "Exact" -Force
        } elseif ($BestMatch) {
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Username" -Value $($BestMatch.DisplayName)
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Status" -Value $BestMatch.Status
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Matchtype" -Value "Approximate" -Force
        } else {
            WriteLog -Message "No match found in ${Domain} for $($Term.Name)"
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Username" -Value "Not Found"
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Status" -Value "Not Found"
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Matchtype" -Value "Not Found"
        }
    }

    $OutputData += $OutputInfo
}

$OutputData | Export-Csv -Path $OutputFile -Delimiter ";" -NoTypeInformation -Encoding utf8BOM #>

Invoke-CompareADUsers