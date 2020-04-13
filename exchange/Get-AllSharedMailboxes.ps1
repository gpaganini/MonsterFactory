	<# 
		.Synopsis
		.Description
		.Example
		
		.Notes
		NAME: Get-AllSharedMailboxes
		AUTHOR: Giovani Paganini
		CREATIONDATE: 07 April 2020
		LASTEDIT: 07 April 2020
		VERSION: 1.0
		
		Change Log
		v1.0, 24/01/2020 - Initial Version
		
	#>

$outputFile = "SharedMailboxes.csv"

Function Main {
    #Clear all Sessions
    Get-PSSession | Remove-PSSession

    ConnectTo-ExchangeOnline
    
    Out-File -FilePath $outputFile -InputObject "Identity,User,AccessRights" -Encoding UTF8

    $objUsers = Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize:100 | select UserPrincipalName
    
    foreach ($objUser in $objUsers) {
        $objUserMailBox = Get-MailboxPermission -Identity $($objUser.UserPrincipalName)| select User,AccessRights  | where {($_.User -like '*@*')}

        $strUserPrincipalName = $objUser.UserPrincipalName
        $strUserDelegate = $objUserMailBox.User
        $strUserAccess = $objUserMailBox.AccessRights

        $srtUserDetails = "$strUserPrincipalName,$strUserDelegate,$strUserAccess"

        #Out-File -FilePath $outputFile -InputObject $srtUserDetails -Encoding UTF8 -Append

        Write-Host $srtUserDetails
    }
        
    #Clear all Sessions
    Get-PSSession | Remove-PSSession
}

Function ConnectTo-ExchangeOnline {
    $UserCredential = Get-Credential
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
    Import-PSSession $Session -AllowClobber | Out-Null
}

. Main
. ConnectTo-ExchangeOnline