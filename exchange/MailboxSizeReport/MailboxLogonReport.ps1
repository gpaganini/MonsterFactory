$i = 0

$path = Split-Path -Parent "C:\Users\giovani.paganini\powershellson\exchange\MailboxSizeReport\*.*"
$logdate = get-date -Format ddMMyyyy-hhmm

$csv = $path + "\SizeReport_$logdate.csv"

$allMailbox = get-mailbox -resultsize unlimited

$output = @()

foreach ($mbx in $allMailbox) {
    $stats = Get-MailboxStatistics -Identity $mbx.UserPrincipalName -WarningAction silentlycontinue

    $userobj = New-Object PSObject

    $userobj | Add-Member NoteProperty -Name "Display Name" -Value $mbx.DisplayName
    $userobj | Add-Member NoteProperty -Name "Alias" -Value $mbx.Alias
    $userobj | Add-Member NoteProperty -Name "UserPrincipalName" -Value $mbx.UserPrincipalName
    $userobj | Add-Member NoteProperty -Name "Cpf" -Value $mbx.CustomAttribute1
    $userobj | Add-Member NoteProperty -Name "RecipientType" -Value $mbx.RecipientType
    $userobj | Add-Member NoteProperty -Name "AccountDisabled" -Value $mbx.AccountDisabled
    $userobj | Add-Member NoteProperty -Name "DirSync" -Value $mbx.IsDirSynced 
    $userobj | Add-Member NoteProperty -Name "LastLogonDate" -Value $stats.LastLogonTime

    $output += $userobj

    $i++

    if ($allMailbox.count -ge 1) {
        Write-Progress -Activity "Scanning mailboxes..." -Status "Scanned: $i of $($allMailbox.count)" -PercentComplete ($i/$allMailbox.count*100)
    }
}

$output | Export-Csv -Path $csv -NoTypeInformation -Encoding UTF8