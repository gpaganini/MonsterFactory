# Function to calculate Levenshtein distance for approximate matching
function Get-LevenshteinDistance {
    param ([string]$String1, [string]$String2)

    $Length1 = $String1.Length
    $Length2 = $String2.Length
    $Matrix = @()

    # Initialize matrix
    for ($i = 0; $i -le $Length1; $i++) {
        $Matrix += ,(0..$Length2)
        $Matrix[$i][0] = $i
    }
    for ($j = 0; $j -le $Length2; $j++) {
        $Matrix[0][$j] = $j
    }

    # Calculate distance
    for ($i = 1; $i -le $Length1; $i++) {
        for ($j = 1; $j -le $Length2; $j++) {
            $Cost = If ($String1[$i - 1] -eq $String2[$j - 1]) { 0 } Else { 1 }
            $Matrix[$i][$j] = [Math]::Min(
                [Math]::Min($Matrix[$i - 1][$j] + 1, $Matrix[$i][$j - 1] + 1),
                $Matrix[$i - 1][$j - 1] + $Cost
            )
        }
    }
    return $Matrix[$Length1][$Length2]
}

# Import input files
$TermTicketsCsv = "C:\Users\giova\powershellson\ad\ADExportUsers\termtickets_parsed.csv"
$TermTicketsData = Import-Csv -Path $TermTicketsCsv  # File with user data to process
$OutputFile = "C:\Users\giova\powershellson\ad\ADExportUsers\termtickets_processed_v2.csv"
$Domains = @(
    'C:\Users\giova\powershellson\ad\ADExportUsers\phoenix.retaildecisions.com.au.csv',
    'C:\Users\giova\powershellson\ad\ADExportUsers\wexprodr.wexglobal.com.csv')  # Domain files
$DomainsData = @()

# Load all domain CSV files into memory
foreach ($Domain in $Domains) {
    $ImportedData = Import-Csv -Path $Domain -Delimiter ";"
    foreach ($row in $ImportedData) {
        #$row.PSObject.Properties.Add((New-Object PSNoteProperty -Name "SourceDomain" -Value $Domain))
        $row | Add-Member -MemberType NoteProperty -Name 'SourceDomain' -Value $Domain
    }
    $DomainsData += $ImportedData
}

# Initialize variables for output and tracking matched users
$MatchedUsers = @{}
$OutputResults = @()

foreach ($Domain in $Domains) {
    $AdUsers = $DomainsData | Where-Object {$_.SourceDomain -eq $Domain}

    foreach ($Term in $TermTicketsData) {
        $TermName = $Term.Name
        $WID = $Term.WID
        $Email = $Term.Email
        $MailName = $Term.Email -split '@' | Select-Object -First 1
        $FirstName, $MiddleName, $LastName = $TermName -split " ", 3

        # Normalize names for better comparison
        $NormalizedTermName = $TermName -replace ",", ""
        $NormalizedFirstName = $FirstName -replace ",", ""
        $NormalizedLastName = $LastName -replace ",", ""

        # Check for exact matches
        $ExactMatch = $AdUsers | Where-Object {
            ($_.Name -eq $NormalizedTermName -or $_.DisplayName -eq $NormalizedTermName) -or
            ($WID -and ($WID -eq $_.SamAccountName -or $_.UserPrincipalName -like "*$WID*")) -or
            ($WID -and $_.Description -like "*$WID*") -or
            ($Email -and $_.UserPrincipalName -eq ($Email -replace '@.*$'))
        }

        if ($ExactMatch) {
            # Handle exact match
            $Status = if ($ExactMatch.Enabled -eq "True") { "Enabled" } else { "Disabled" }
            $MatchedUsers[$TermName] = $ExactMatch.Name
            $UserDomainStatus[$Domain] = "Found: $($ExactMatch.Name) ($Status)"

            # Add result to output
            $OutputResults += [PSCustomObject]@{
                TermName  = $TermName
                Domain    = $Domain
                MatchType = "Exact"
                Status    = $Status
            }

            continue  # Skip approximate matching for this user
        }

        # Approximate matching logic
        $BestMatch = $null
        $LowestDistance = [int]::MaxValue

        foreach ($ADUser in $AdUsers) {
            $DistanceName = Get-LevenshteinDistance -String1 $NormalizedTermName -String2 ($ADUser.Name -replace ",", "")
            $DistanceDisplayName = Get-LevenshteinDistance -String1 $NormalizedTermName -String2 ($ADUser.DisplayName -replace ",", "")
            $DistanceFirstName = if ($NormalizedFirstName) { Get-LevenshteinDistance -String1 $NormalizedFirstName -String2 $ADUser.GivenName } else { [int]::MaxValue }
            $DistanceMiddleName = if ($MiddleName) { Get-LevenshteinDistance -String1 $MiddleName -String2 $ADUser.GivenName } else { [int]::MaxValue }
            $DistanceLastName = if ($NormalizedLastName) { Get-LevenshteinDistance -String1 $NormalizedLastName -String2 $ADUser.sn } else { [int]::MaxValue }

            $Distances = @($DistanceName, $DistanceDisplayName, $DistanceFirstName, $DistanceMiddleName, $DistanceLastName)
            $CurrentLowest = ($Distances | Measure-Object -Minimum).Minimum

            #$CurrentLowest = [Math]::Min($DistanceName, $DistanceDisplayName, $DistanceFirstName, $DistanceMiddleName, $DistanceLastName)

            if ($CurrentLowest -lt $LowestDistance) {
                $LowestDistance = $CurrentLowest
                $BestMatch = $ADUser
            }
        }

        if ($BestMatch -and $LowestDistance -le 3) {  # Threshold for approximate match
            $Status = if ($BestMatch.Enabled -eq "True") { "Enabled" } else { "Disabled" }
            $UserDomainStatus[$Domain] = "Found: $($BestMatch.Name) ($Status)"

            # Add result to output
            $OutputResults += [PSCustomObject]@{
                TermName  = $TermName
                Domain    = $Domain
                MatchType = "Approximate"
                Status    = $Status
            }
        }
        else {
            $UserDomainStatus[$Domain] = "Not Found"

            # Add result to output
            $OutputResults += [PSCustomObject]@{
                TermName  = $TermName
                Domain    = $Domain
                MatchType = "Not Found"
                Status    = "Not Found"
            }
        }
    }
}

# Export the final output to CSV
$OutputResults | Export-Csv -Path $OutputFile -Delimiter ";" -NoTypeInformation -Encoding UTF8
