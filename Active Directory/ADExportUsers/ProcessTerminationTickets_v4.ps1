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
    $OutputData = @()
    $i = 0

    foreach ($LegacyUser in $LegacyDomain) {
        $LegacyId           = $LegacyUser.EmployeeNumber
        $LegacySam          = $LegacyUser.SamAccountName
        $LegacyName         = $LegacyUser.Name
        $LegacyDName        = $LegacyUser.DisplayName
        $LegacyDescription  = $LegacyUser.Description
        $LegacyUPN          = $LegacyUser.UserPrincipalName

        $ExactMatch         = $null
        $BestMatch          = $null

        if ($ProdHashByEmployeeId.ContainsKey($LegacyId)) {
            $ExactMatch = $ProdHashByEmployeeId[$LegacyId]
        } elseif ($ProdHashBySam.ContainsKey($LegacySam)) {
            $ExactMatch = $ProdHashBySam[$LegacySam]
        } elseif ($ProdHashByName.ContainsKey($LegacyName)) {
            $ExactMatch = $ProdHashByName[$LegacyName]
        } elseif ($ProdHashByDisplayName.ContainsKey($LegacyDName)) {
            $ExactMatch = $ProdHashByDisplayName[$LegacyDName]
        }

        foreach ($ProdUser in $ProdDomain) {
            $ProdSam = $ProdUser.SamAccountName
            $ProdId = $ProdUser.EmployeeNumber
            $ProdName = $ProdUser.Name
            $ProdDName = $ProdUser.DisplayName
            $ProdUPN = $ProdUser.UserPrincipalName

            #$Domain = $ProdUser.CanonicalName -split '\.' | Select-Object -First 1
            if (-not $ExactMatch) {
                if ($ProdId -and ($LegacyDescription -like "*$($ProdId)*")){
                    WriteLog -Message "Exact match by WID in DESCRIPTION on ${Domain}:$($ProdName)"
                    $BestMatch = $ProdUser
                } # Search WID in SamAccountName
                elseif ($ProdId -and ($LegacySam -like "*$($ProdId)*")) {
                    WriteLog -Message "Exact match by WID in SAMACCOUNTNAME on ${Domain}:$($ProdName)"
                    $BestMatch = $ProdUser
                } # Search WID in UserPrincipalName
                elseif (($ProdUPN -and $ProdId) -and ($LegacyUPN -like "*$($ProdId)*")) {
                    WriteLog -Message "Exact match by WID in USERPRINCIPALNAME on ${Domain}:$($ProdName)"
                    $BestMatch = $ProdUser
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
            MatchedType = $ExactMatch ? "Exact" : ($BestMatch ? "Best Match" : "None")
            MatchedUser = $ExactMatch ? $ExactMatch.SamAccountName : ($BestMatch ? $BestMatch.Name : "")
        }
        $OutputData += $OutputInfo

        $i++
        if ($i % 10 -eq 0) {
            Write-Progress -Activity "Processing users..." -Status "Processed $i users of $($LegacyDomain.Count)" -PercentComplete ($i / $LegacyDomain.Count * 100)
        }
    }
    $OutputData | Export-Csv -Path $OutputFile -Delimiter ";" -NoTypeInformation -Encoding utf8BOM
}

Function Invoke-CompareUsers () {
    $OutputData = @()
    $i = 0

    foreach ($LegacyUser in $LegacyDomain) {
        $LegacyId           = $LegacyUser.EmployeeNumber
        $LegacySam          = $LegacyUser.SamAccountName
        $LegacyName         = $LegacyUser.Name
        $LegacyDName        = $LegacyUser.DisplayName
        $LegacyDescription  = $LegacyUser.Description
        $LegacyUPN          = $LegacyUser.UserPrincipalName

        $ExactMatch = $null
        #$BestMatch = $null

        $OutputInfo = [PSCustomObject]@{
            CN = $LegacyUser.CN
            Name = $LegacyUser.Name
            DisplayName = $LegacyUser.DisplayName
            #FirstName = $LegacyUser.GivenName
            #LastName = $LegacyUser.sn
            EmployeeNumber = $LegacyUser.EmployeeNumber
            SamAccountName = $LegacyUser.SamAccountName
            #UserPrincipalName = $LegacyUser.UserPrincipalName
            Mail = $LegacyUser.Mail
            #Description = $LegacyUser.Description
            Status = $LegacyUser.Status
            #DistinguishedName = $LegacyUser.DistinguishedName
            #CanonicalName = $LegacyUser.CanonicalName
        }

        foreach ($ProdUser in $ProdDomain) {
            $ProdSam = $ProdUser.SamAccountName
            $ProdId = $ProdUser.EmployeeNumber
            $ProdName = $ProdUser.Name
            $ProdDName = $ProdUser.DisplayName
            $ProdUPN = $ProdUser.UserPrincipalName

            #$Domain = $ProdUser.CanonicalName -split '\.' | Select-Object -First 1

            # Search WID in EmployeeNumber
            if ($ProdId -and ($ProdId -eq $LegacyId)) {
                WriteLog -Message "Exact match by WID in EmployeeNumber ${Domain}:$($ProdName)"
                $ExactMatch = $ProdUser
            } # Search Exact Username
            elseif ($ProdSam -eq $LegacySam) {
                WriteLog -Message "Exact match by SAMACCOUNTNAME on ${Domain}:$($ProdName)"
                $ExactMatch = $ProdUser
            } # Search WID in Description
            elseif ($ProdId -and ($LegacyDescription -like "*$($ProdId)*")){
                WriteLog -Message "Exact match by WID in DESCRIPTION on ${Domain}:$($ProdName)"
                $ExactMatch = $ProdUser
            } <# # Search WID in SamAccountName
            elseif ($ProdUser.EmployeeNumber -and ($ProdUser.EmployeeNumber -match ($LegacyUser.SamAccountName -replace '^y-'))) {
                WriteLog -Message "Exact match by WID in SAMACCOUNTNAME on ${Domain}:$($ProdUser.Name)"
                $ExactMatch = $ProdUser
            } #> # Search WID in SamAccountName - New
            elseif ($ProdId -and ($LegacySam -like "*$($ProdId)*")) {
                WriteLog -Message "Exact match by WID in SAMACCOUNTNAME on ${Domain}:$($ProdName)"
                $ExactMatch = $ProdUser
            } # Search WID in UserPrincipalName
            elseif (($ProdUPN -and $ProdId) -and ($LegacyUPN -like "*$($ProdId)*")) {
                WriteLog -Message "Exact match by WID in USERPRINCIPALNAME on ${Domain}:$($ProDName)"
                $ExactMatch = $ProdUser
            }
            elseif ($LegacyName -and ($LegacyName -eq $ProdName -or $LegacyDName -eq $ProdDName)) {
                WriteLog -Message "Exact match by NAME on ${Domain}:$($ProdName)"
                $ExactMatch = $ProdUser
            }
        }

        if ($ExactMatch) {
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Username" -Value $ExactMatch.SamAccountName
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Status" -Value $ExactMatch.Status
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Matchtype" -Value "Exact" -Force
        } <# elseif ($BestMatch) {
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Username" -Value $BestMatch.CN
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Status" -Value $BestMatch.Status
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Matchtype" -Value "Best Match" -Force
        } #> else {
            #WriteLog -Message "No match found in ${Domain} for $($WexUser.Name)"
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Username" -Value ""
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Status" -Value ""
            $OutputInfo | Add-Member -MemberType NoteProperty -Name "${Domain}_Matchtype" -Value ""
        }

        $OutputData += $OutputInfo
        $i++
        if ($i % 10 -eq 0) {
            Write-Progress -Activity "Processing users..." -Status "Processed $i users of $($LegacyDomain.Count)" -PercentComplete ($i / $LegacyDomain.Count * 100)
        }
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

#Invoke-CompareUsersOptimized
Invoke-CompareUsers