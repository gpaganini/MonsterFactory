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

$LegacyDomainCsv = '.\phoenix.csv'
$LegacyDomain = Import-Csv -Path $LegacyDomainCsv -Delimiter ";"

$ProdDomainCsv = '.\wexprodr.csv'
$ProdDomain = Import-Csv -Path $ProdDomainCsv -Delimiter ";"

$OutputFile = ".\DomainsProcessed.csv"

#$WexUsers = Import-Csv -Path $InputCsv -Delimiter ";"

#$TermTicketsCsv = ".\termtickets_parsed.csv"


<# $LegacyDomains = @(
    '.\phoenix.csv',
    '.\encprimary.csv',
    '.\floridacore.csv',
    '.\pws.csv',
    '.\pwsdemo.csv'
) #>

# Organize domain data by domain name for quick lookups
<# $LegacyDomainDataHash = @{}
foreach ($LegacyDomain in $LegacyDomains) {
    WriteLog -Message "Importing file '$LegacyDomain'..."
    $Domain = [System.IO.Path]::GetFileNameWithoutExtension($LegacyDomain)# -split '\.' | Select-Object -First 1
    $ImportedData = Import-Csv -Path $LegacyDomain -Delimiter ";"
    $LegacyDomainDataHash[$Domain] = $ImportedData
} #>

Function Invoke-CompareUsers () {
    $OutputData = @()
    $i = 0
    $y = 0
    foreach ($LegacyUser in $LegacyDomain) {
        $OutputInfo = [PSCustomObject]@{
            CN = $LegacyUser.CN
            Name = $LegacyUser.Name
            DisplayName = $LegacyUser.DisplayName
            FirstName = $LegacyUser.GivenName
            LastName = $LegacyUser.sn
            EmployeeNumber = $LegacyUser.EmployeeNumber
            SamAccountName = $LegacyUser.SamAccountName
            UserPrincipalName = $LegacyUser.UserPrincipalName
            Mail = $LegacyUser.Mail
            Description = $LegacyUser.Description
            Status = $LegacyUser.Status
            DistinguishedName = $LegacyUser.DistinguishedName
            CanonicalName = $LegacyUser.CanonicalName
        }

        $ExactMatch = $null
        $BestMatch = $null

        foreach ($ProdUser in $ProdDomain) {
            $Domain = $ProdUser.CanonicalName -split '\.' | Select-Object -First 1

            # Search WID in EmployeeNumber
            if ($ProdUser.EmployeeNumber -and ($ProdUser.EmployeeNumber -eq $LegacyUser.EmployeeNumber)) {
                WriteLog -Message "Exact match by WID in EmployeeNumber ${Domain}:$($ProdUser.Name)"
                $ExactMatch = $ProdUser
            } # Search Exact Username
            elseif ($Produser.SamAccountName -eq $LegacyUser.SamAccountName) {
                WriteLog -Message "Exact match by SAMACCOUNTNAME on ${Domain}:$($ProdUser.Name)"
                $ExactMatch = $ProdUser
            } # Search WID in Description
            elseif ($ProdUser.EmployeeNumber -and ($LegacyUser.Description -like "*$($ProdUser.EmployeeNumber)*")){
                WriteLog -Message "Exact match by WID in DESCRIPTION on ${Domain}:$($ProdUser.Name)"
                $ExactMatch = $ProdUser
            } <# # Search WID in SamAccountName
            elseif ($ProdUser.EmployeeNumber -and ($ProdUser.EmployeeNumber -match ($LegacyUser.SamAccountName -replace '^y-'))) {
                WriteLog -Message "Exact match by WID in SAMACCOUNTNAME on ${Domain}:$($ProdUser.Name)"
                $ExactMatch = $ProdUser
            } #> # Search WID in SamAccountName - New
            elseif ($ProdUser.EmployeeNumber -and ($LegacyUser.SamAccountName -like "*$($ProdUser.EmployeeNumber)*")) {
                WriteLog -Message "Exact match by WID in SAMACCOUNTNAME on ${Domain}:$($ProdUser.Name)"
                $ExactMatch = $ProdUser
            } # Search WID in UserPrincipalName
            elseif (($ProdUser.UserPrincipalName -and $ProdUser.EmployeeNumber) -and ($LegacyUser.UserPrincipalName -like "*$($ProdUser.EmployeeNumber)*")) {
                WriteLog -Message "Exact match by WID in USERPRINCIPALNAME on ${Domain}:$($ProdUser.Name)"
                $ExactMatch = $ProdUser
            }
            elseif ($LegacyUser.Name -and ($LegacyUser.Name -eq $ProdUser.Name -or $LegacyUser.DisplayName -eq $ProdUser.DisplayName)) {
                WriteLog -Message "Exact match by NAME on ${Domain}:$($ProdUser.Name)"
                $BestMatch = $ProdUser
            }

            $y++
            Write-Progress -Activity "Comparing users..." -Status "Compared: $i of $($ProdDomain.Count)" -PercentComplete ($i/$ProdDomain.Count*100)
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

        $OutputData += $OutputInfo
        $i++
        Write-Progress -Activity "Processing legacy users..." -Status "Processed: $i of $($LegacyDomain.Count)" -PercentComplete ($i/$LegacyDomain.Count*100)
    }
    $OutputData | Export-Csv -Path $OutputFile -Delimiter ";" -NoTypeInformation -Encoding utf8BOM
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

Invoke-CompareUsers