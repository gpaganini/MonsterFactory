$output = @()

$i = 0

$CSVfile = "C:\temp\mbreport_09052023.csv"

$AllMailbox = Get-Mailbox -ResultSize Unlimited

foreach($Mbx in $AllMailbox){
	$Stats = Get-mailboxStatistics -Identity $Mbx.distinguishedname -WarningAction SilentlyContinue
	
    $userObj = New-Object PSObject
    $userObj | Add-Member NoteProperty -Name "Display Name" -Value $mbx.displayname
    $userObj | Add-Member NoteProperty -Name "Alias" -Value $Mbx.Alias
    #$userObj | Add-Member NoteProperty -Name "SamAccountName" -Value $Mbx.SamAccountName
    $userObj | Add-Member NoteProperty -Name "UserPrincipalName" -Value $Mbx.UserPrincipalName
    $userObj | Add-Member NoteProperty -Name "RecipientType" -Value $Mbx.RecipientTypeDetails
    #$userObj | Add-Member NoteProperty -Name "isHidden" -Value $Mbx.HiddenFromAddressListsEnabled
    #$userObj | Add-Member NoteProperty -Name "extensionAttribute1" -Value $Mbx.CustomAttribute1
	$userObj | Add-Member NoteProperty -Name "DataBase" -Value $Mbx.DataBase
	
	if($Stats) {
		$userObj | Add-Member NoteProperty -Name "TotalItemSize" -Value $Stats.TotalItemSize
		$userObj | Add-Member NoteProperty -Name "ItemCount" -Value $Stats.ItemCount
		$userObj | Add-Member NoteProperty -Name "DeletedItemCount" -Value $Stats.DeletedItemCount
		$userObj | Add-Member NoteProperty -Name "TotalDeletedItemSize" -Value $Stats.TotalDeletedItemSize
	}

    $output += $UserObj

    $i++

    if($AllMailbox.count -ge 1) {
        Write-Progress -Activity "Scanning Mailboxes . . ." -Status "Scanned: $i of $($AllMailbox.Count)" -PercentComplete ($i/$AllMailbox.Count*100)
    }
}

$output | Export-csv -Path $CSVfile -NoTypeInformation -Encoding UTF8 -NoClobber