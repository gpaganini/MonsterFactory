
####################################### habilita caixa de email remota para multiplos usuarios a partir de um CSV
$path = ".\timeshare.csv"

$arquivo = Import-Csv $path

$arquivo | ForEach { Enable-RemoteMailbox -Identity $_.User -RemoteRoutingAddress ($_.User+'@grq.mail.onmicrosoft.com') }


$arquivo | foreach {
#    $users = Get-MsolUser -
    #Set-MsolUser -UserPrincipalName $_.User -UsageLocation BR
    Set-MsolUserLicense -UserPrincipalName $_.User -AddLicenses grq:O365_BUSINESS_ESSENTIALS
}
####################################### habilita caixa de email remota para multiplos usuarios a partir de uma OU especifica.

## 


#Get-ADUser -Filter * -SearchBase "OU=Transporte,OU=Site BA,OU=Rio Quente Resorts,DC=rqr,DC=com,DC=br" | ForEach { Enable-RemoteMailbox -Identity $_.samaccountname -RemoteRoutingAddress ($_.samaccountname+'@grq.mail.microsoft.com') }