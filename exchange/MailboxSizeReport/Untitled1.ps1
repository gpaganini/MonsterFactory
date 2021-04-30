$output = @()
$log = Get-MessageTrackingLog -EventId Expand -Start 01/01/2021 -ResultSize Unlimited

foreach ($entry in $log) {    
    $recipient = New-Object psobject
    $recipient | Add-Member NoteProperty -Name "TimeStamp" -Value $entry.Timestamp.Date.ToShortDateString()
    $recipient | Add-Member NoteProperty -Name "Group" -Value $entry.RelatedRecipientAddress
    
    $output += $recipient    
}

$output | Export-Csv -Path C:\temp\dlreport.csv -NoTypeInformation -Encoding UTF8 -NoClobber