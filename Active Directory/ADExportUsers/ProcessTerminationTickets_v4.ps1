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
    MODIFIED: 12/31/2024
    CHANGELOG:
        V1.2, 12/31/2024 - Script optimization, cleanup and parameters included.
        V1.1, 12/23/2024 - Added support to multiple domains, overall script optimization.
        v1.0, 12/17/2024 - Initial Version
#>
<# [CmdletBinding()]
param (
    [Parameter(Mandatory=$true,HelpMessage="You must provide an input csv file for processing.")]
    [string]$LegacyDomainCsv,

    [Parameter(Mandatory=$true,HelpMessage="You must provide an input csv file for processing.")]
    [string]$ProdDomainCsv,

    [Parameter(Mandatory=$true,HelpMessage="You must provide an output csv file for processing.")]
    [string]$OutputFile
) #>

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

$LegacyDomainCsv = '.\encprimary.csv'
$ProdDomainCsv = '.\wexprodr.csv'
$OutputFile = ".\ENCPrimary_Processed.csv"

$LegacyDomain = Import-Csv -Path $LegacyDomainCsv -Delimiter ";"
$ProdDomain = Import-Csv -Path $ProdDomainCsv -Delimiter ";"

$ProdHashBySam = @{}
$ProdHashByEmployeeId = @{}
$ProdHashByName = @{}
$ProdHashByDisplayName = @{}

Foreach ($ProdUser in $ProdDomain) {
    $ProdSam = $ProdUser.SamAccountName
    $ProdId = $ProdUser.EmployeeNumber
    $ProdName = $ProdUser.Name
    $ProdDName = $ProdUser.DisplayName

    if ($ProdSam) {
        $ProdHashBySam[$ProdSam] = $ProdUser
    }
    if ($ProdId) {
        $ProdHashByEmployeeId[$ProdId] = $ProdUser
    }
    if ($ProdName) {
        $ProdHashByName[$ProdName] = $ProdUser
    }
    if ($ProdDName) {
        $ProdHashByDisplayName[$ProdDName] = $ProdUser
    }
}

Function Invoke-CompareUsersOptimized () {
    WriteLog -Message "========== SCRIPT STARTED =========="
    $start = Get-Date
    $OutputData = @()
    $i = 0

    $MatchById = 0
    $MatchBySam = 0
    $MatchByName = 0
    $MatchByDisplayName = 0
    $MatchByWidDescription = 0
    $MatchByWidSam = 0
    $MatchByWidUpn = 0

    foreach ($LegacyUser in $LegacyDomain) {
        $LegacyId           = $LegacyUser.EmployeeNumber
        $LegacySam          = $LegacyUser.SamAccountName
        $LegacyName         = $LegacyUser.Name
        $LegacyDName        = $LegacyUser.DisplayName
        $LegacyDescription  = $LegacyUser.Description
        $LegacyUPN          = $LegacyUser.UserPrincipalName

        $ExactMatch         = $null
        $BestMatch          = $null

        # Match by EmployeeNumber
        if ($null -ne $LegacyId -and $ProdHashByEmployeeId.ContainsKey($LegacyId)) {
            $MatchById++
            $ExactMatch = $ProdHashByEmployeeId[$LegacyId]
            WriteLog -Message "Exact match by WID in EmployeeNumber ${Domain}:$($ExactMatch.Name)"
        } # Match by SamAccountName
        elseif ($null -ne $LegacySam -and $ProdHashBySam.ContainsKey($LegacySam)) {
            $MatchBySam++
            $ExactMatch = $ProdHashBySam[$LegacySam]
            WriteLog -Message "Exact match by SAMACCOUNTNAME ${Domain}:$($ExactMatch.Name)"
        } # Match by Name
        elseif ($null -ne $LegacyName -and $ProdHashByName.ContainsKey($LegacyName)) {
            $MatchByName++
            $ExactMatch = $ProdHashByName[$LegacyName]
            WriteLog -Message "Exact match by Name ${Domain}:$($ExactMatch.Name)"
        } # Match by DisplayName
        elseif ($null -ne $LegacyDName -and $ProdHashByDisplayName.ContainsKey($LegacyDName)) {
            $MatchByDisplayName++
            $ExactMatch = $ProdHashByDisplayName[$LegacyDName]
            WriteLog -Message "Exact match by DisplayName ${Domain}:$($ExactMatch.Name)"
        }

        # For non exact matches, loop the rest of the Production Domain
        foreach ($ProdUser in $ProdDomain) {
            #$ProdSam = $ProdUser.SamAccountName
            $ProdId = $ProdUser.EmployeeNumber
            $ProdName = $ProdUser.Name
            #$ProdDName = $ProdUser.DisplayName
            $ProdUPN = $ProdUser.UserPrincipalName

            if (-not $ExactMatch) {
                # Search for WID in Description
                if ($ProdId -and ($LegacyDescription -like "*$($ProdId)*")){
                    $MatchByWidDescription++
                    $BestMatch = $ProdUser
                    WriteLog -Message "Best match by WID in Description ${Domain}:$($ProdName)"
                } # Search for WID in SamAccountName
                elseif ($ProdId -and ($LegacySam -like "*$($ProdId)*")) {
                    $MatchByWidSam++
                    $BestMatch = $ProdUser
                    WriteLog -Message "Best match by WID in SamAccountName ${Domain}:$($ProdName)"
                } # Search for WID in UserPrincipalName
                elseif (($ProdUPN -and $ProdId) -and ($LegacyUPN -like "*$($ProdId)*")) {
                    $MatchByWidUpn++
                    $BestMatch = $ProdUser
                    WriteLog -Message "Best match by WID in UserPrincipalName ${Domain}:$($ProdName)"
                }
            }
        }

        # Prepares output information
        $OutputInfo = [PSCustomObject]@{
            CN = $LegacyUser.CN
            Name = $LegacyUser.Name
            DisplayName = $LegacyUser.DisplayName
            #FirstName = $LegacyUser.GivenName
            #LastName = $LegacyUser.sn
            EmployeeNumber = $LegacyUser.EmployeeNumber
            SamAccountName = $LegacyUser.SamAccountName
            UserPrincipalName = $LegacyUser.UserPrincipalName
            Mail = $LegacyUser.Mail
            Description = $LegacyUser.Description
            Status = $LegacyUser.Status
            #DistinguishedName = $LegacyUser.DistinguishedName
            #CanonicalName = $LegacyUser.CanonicalName
            ProdEmployeeNumber = $ExactMatch ? $ExactMatch.EmployeeNumber : ($BestMatch ? $BestMatch.EmployeeNumber: "")
            ProdName = $ExactMatch ? $ExactMatch.Name : ($BestMatch ? $BestMatch.Name: "")
            ProdSamAccountName = $ExactMatch ? $ExactMatch.SamAccountName : ($BestMatch ? $BestMatch.SamAccountName : "")
            ProdEmail = $ExactMatch ? $ExactMatch.Mail : ($BestMatch ? $BestMatch.Mail: "")
            ProdStatus = $ExactMatch ? $ExactMatch.Status : ($BestMatch ? $BestMatch.Status : "")
            ProdDescription = $ExactMatch ? $ExactMatch.Description : ($BestMatch ? $BestMatch.Description : "")
            MatchType = $ExactMatch ? "Exact" : ($BestMatch ? "Approximate" : "None")
        }
        $OutputData += $OutputInfo

        $i++
        if ($i % 50 -eq 0) {
            Write-Progress -Activity "Processing users..." -Status "Processed $i users of $($LegacyDomain.Count)" -PercentComplete ($i / $LegacyDomain.Count * 100)
        }
    }

    $OutputData | Export-Csv -Path $OutputFile -Delimiter ";" -NoTypeInformation -Encoding utf8BOM

    $stop = Get-Date
    $elapsed = $stop - $start
    Write-Output "Elapsed: $elapsed"

    Write-Output "Match by ID: $MatchById"
    Write-Output "Match by SAM: $MatchBySam"
    Write-Output "Match by NAME: $MatchByName"
    Write-Output "Match by DISPLAYNAME: $MatchByDisplayName"
    Write-Output "Total Exact Matches: $($MatchBySam + $MatchById + $MatchByName + $MatchByDisplayName)"

    Write-Output "Match by WID in Description: $MatchByWidDescription"
    Write-Output "Match by WID in SAM: $MatchByWidSam"
    Write-Output "Match by WID in UPN: $MatchByWidUpn"
    Write-Output "Total Partial Matches: $($MatchByWidDescription + $MatchByWidSam + $MatchByWidUpn)"

    WriteLog -Message "========== SCRIPT FINISHED =========="
}

Function Invoke-CompareUsers () {
    $Start = Get-Date
    $OutputData = @()
    $i = 0

    $MatchById = 0
    $MatchBySam = 0
    $MatchByName = 0
    $MatchByDisplayName = 0
    $MatchByWidDescription = 0
    $MatchByWidSam = 0
    $MatchByWidUpn = 0

    foreach ($LegacyUser in $LegacyDomain) {
        $LegacyId           = $LegacyUser.EmployeeNumber
        $LegacySam          = $LegacyUser.SamAccountName
        $LegacyName         = $LegacyUser.Name
        $LegacyDName        = $LegacyUser.DisplayName
        $LegacyDescription  = $LegacyUser.Description
        $LegacyUPN          = $LegacyUser.UserPrincipalName

        $ExactMatch = $null
        $BestMatch = $null
        $MatchFound = $false

        foreach ($ProdUser in $ProdDomain) {
            if ($MatchFound) { break }  # Exit loop once a match is found
            $ProdSam = $ProdUser.SamAccountName
            $ProdId = $ProdUser.EmployeeNumber
            $ProdName = $ProdUser.Name
            $ProdDName = $ProdUser.DisplayName
            $ProdUPN = $ProdUser.UserPrincipalName

            # Match by EmployeeNumber
            if ($ProdId -and ($ProdId -eq $LegacyId)) {
                $MatchById++
                $ExactMatch = $ProdUser
                $MatchFound = $true
            } # Match by SamAccountName
            elseif ($ProdSam -and ($ProdSam -eq $LegacySam)) {
                $MatchBySam++
                $ExactMatch = $ProdUser
                $MatchFound = $true
            } # Match by Name
            elseif (($ProdName -and $LegacyName) -and ($ProdName -eq $LegacyName)) {
                $MatchByName++
                $ExactMatch = $ProdUser
                $MatchFound = $true
            } # Match by DisplayName
            elseif (($ProdDName -and $LegacyDName) -and ($ProdDName -eq $LegacyDName)) {
                $MatchByDisplayName++
                $ExactMatch = $ProdUser
                $MatchFound = $true
            }

            if (-not $ExactMatch) {
                # Match by WID In Description
                if ($ProdId -and ($LegacyDescription -like "*$($ProdId)*")) {
                    $MatchByWidDescription++
                    $BestMatch = $ProdUser
                    $MatchFound = $true
                } # Match by WID in SAM
                elseif ($ProdId -and ($LegacySam -like "*$($ProdId)*")) {
                    $MatchByWidSam++
                    $BestMatch = $ProdUser
                    $MatchFound = $true
                } # Match by WID in UPN
                elseif (($ProdId -and $ProdUPN) -and ($LegacyUPN -like "*$($ProdId)*")) {
                    $MatchByWidUpn++
                    $BestMatch = $ProdUser
                    $MatchFound = $true
                }
            }
        }

        $OutputInfo = [PSCustomObject]@{
            CN = $LegacyUser.CN
            Name = $LegacyUser.Name
            DisplayName = $LegacyUser.DisplayName
            #FirstName = $LegacyUser.GivenName
            #LastName = $LegacyUser.sn
            EmployeeNumber = $LegacyUser.EmployeeNumber
            SamAccountName = $LegacyUser.SamAccountName
            UserPrincipalName = $LegacyUser.UserPrincipalName
            #Mail = $LegacyUser.Mail
            #Description = $LegacyUser.Description
            Status = $LegacyUser.Status
            #DistinguishedName = $LegacyUser.DistinguishedName
            #CanonicalName = $LegacyUser.CanonicalName
            #MatchedType = $ExactMatch ? "Exact" : "None"
            #MatchedUser = $ExactMatch ? $ExactMatch.SamAccountName : ""
            MatchedType = $ExactMatch ? "Exact" : ($BestMatch ? "Best Match" : "None")
            MatchedUser = $ExactMatch ? $ExactMatch.SamAccountName : ($BestMatch ? $BestMatch.SamAccountName : "")
            MatchedStatus = $ExactMatch ? $ExactMatch.Status : ($BestMatch ? $BestMatch.Status : "")
        }
        $OutputData += $OutputInfo

        $i++
        if ($i % 20 -eq 0) {
            Write-Progress -Activity "Processing users..." -Status "Processed $i users of $($LegacyDomain.Count)" -PercentComplete ($i / $LegacyDomain.Count * 100)
        }
    }
    $OutputData | Export-Csv -Path $OutputFile -Delimiter ";" -NoTypeInformation -Encoding utf8BOM

    $stop = Get-Date
    $elapsed = $stop - $start
    Write-Output "Elapsed: $elapsed"

    Write-Output "Match by ID: $MatchById"
    Write-Output "Match by SAM: $MatchBySam"
    Write-Output "Match by NAME: $MatchByName"
    Write-Output "Match by DISPLAYNAME: $MatchByDisplayName"
    Write-Output "Total Exact Matches: $($MatchBySam + $MatchById + $MatchByName + $MatchByDisplayName)"

    Write-Output "Match by WID in Description: $MatchByWidDescription"
    Write-Output "Match by WID in SAM: $MatchByWidSam"
    Write-Output "Match by WID in UPN: $MatchByWidUpn"
    Write-Output "Total Partial Matches: $($MatchByWidDescription + $MatchByWidSam + $MatchByWidUpn)"
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
            #$HighestScore = 0 NOT USING FOR NOW

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

Invoke-CompareUsersOptimized
#Invoke-CompareUsers