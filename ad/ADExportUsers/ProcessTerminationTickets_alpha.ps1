#Import-Module ActiveDirectory

# Define the CSV file and domains
$TermTickets = "C:\Users\giova\powershellson\ad\ADExportUsers\termtickets_parsed.csv"
$OutputFile = "C:\Users\giova\powershellson\ad\ADExportUsers\termtickets_processed.csv"
$Domains = @(
    'C:\Users\giova\powershellson\ad\ADExportUsers\phoenix.retaildecisions.com.au.csv',
    'C:\Users\giova\powershellson\ad\ADExportUsers\wexprodr.wexglobal.com.csv'
)

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

$InputData = Import-Csv -Path $TermTickets
$InputDomains = @()

Foreach ($file in $Domains) {
    if (Test-Path $file) {
        Write-Host "Processing file '$file'" -ForegroundColor Green
        $DomainData = Import-Csv -Path $file -Delimiter ";"
        foreach ($row in $DomainData) {
            $row | Add-Member -MemberType NoteProperty -Name 'SourceDomain' -Value $File
            $InputDomains += $row
        }
    } else {
        Write-Host "File not found: '$file'" -ForegroundColor Red
    }
    
 #   $InputDomains += Import-Csv -Path $file
}

$OutputData = @()

foreach ($User in $InputData) {
    $TermName = $User.Name
    $MailName = $user.Email -split '@' | Select-Object -First 1
    #Write-Output "Checking user: '$TermName'..."
    
    $NameParts = $TermName -split '\s+'
    $FirstName = $NameParts[0]
    $LastName = $NameParts[-1]
    $MiddleName = if ($NameParts.Count -ge 3) {$NameParts[1]} else {""}

    $UserDomainStatus = @{}

    foreach ($file in $Domains) {
        $AdUsers = $InputDomains | Where-Object {$_.SourceDomain -eq $file}        
        $BestMatch = $null
        $LowestDistance = [int]::MaxValue

        foreach ($ADUser in $AdUsers) {
            #If TermName matches AD Name or Display Name
            if ($User.Name -eq $ADUser.Name -or $User.Name -eq $ADUser.DisplayName) {
                $BestMatch = $ADUser
                break
            }

            #If WID is in Description
            if ($User.WID -and ($ADUser.Description -like "*$($User.WID)*")) {
                $BestMatch = $ADUser
                break
            }

            if ($user.WID -and ($ADUser.UserName -eq $user.WID -or $ADUser.UserPrincipalName -like "*$($User.WID)*")) {
                $BestMatch = $ADUser
                break
            }

            if ($MailName -like $ADUser.Mail -or $MailName -like $aduser.UserPrincipalName) {
                $BestMatch = $ADUser
                break
            }

            $DistanceName = Get-LevenshteinDistance -String1 $TermName -String2 $ADUser.Name
            $DistanceDisplayName = Get-LevenshteinDistance -String1 $TermName -String2 $ADUser.DisplayName
            $DistanceFirstName = if ($FirstName) { Get-LevenshteinDistance -String1 $FirstName -String2 $AdUser.GivenName } else { [int]::MaxValue }
            $DistanceMiddleName = if ($MiddleName) { Get-LevenshteinDistance -String1 $MiddleName -String2 $AdUser.GivenName } else { [int]::MaxValue }
            $DistanceLastName = if ($LastName) { Get-LevenshteinDistance -String1 $LastName -String2 $AdUser.sn } else { [int]::MaxValue }

            $Distances = @($DistanceName, $DistanceDisplayName, $DistanceFirstName, $DistanceMiddleName, $DistanceLastName)
            
            $CurrentLowest = ($Distances | Measure-Object -Minimum).Minimum
            
            #$CurrentLowest = [Math]::Min($DistanceName, $DistanceDisplayName,$DistanceFirstName,$DistanceMiddleName,$DistanceLastName)

            if ($CurrentLowest -lt $LowestDistance) {
                $LowestDistance = $CurrentLowest
                $BestMatch = $AdUser
            }
        }

        if ($BestMatch -and $LowestDistance -le 4) {  # Threshold for approximate match
            $Status = if ($BestMatch.Enabled -eq "True") { "Enabled" } else { "Disabled" }
            $UserDomainStatus[$File] = "Found: $($BestMatch.Name) ($Status)"
        }
        else {
            $UserDomainStatus[$File] = "Not Found"
        }
    }
    
    $UpdatedInfo = [PSCustomObject]@{
        Name                = $User.Name
        WID                 = $User.WID
        Email               = $User.Email
        'Effective Date'    = $User.'Effective Date'
        Manager             = $User.Manager
    }

    foreach ($File in $Domains) {
        $DomainName = [System.IO.Path]::GetFileNameWithoutExtension($File)
        $UpdatedInfo | Add-Member -MemberType NoteProperty -Name $DomainName -Value $UserDomainStatus[$File]
    }
    $OutputData += $UpdatedInfo
}

$OutputData | Export-Csv -Path $OutputFile -Delimiter ";" -NoTypeInformation -Encoding UTF8