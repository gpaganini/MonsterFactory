
####################################### habilita caixa de email remota para multiplos usuarios a partir de um CSV
$csv = "C:\Users\giovani.paganini\powershellson\exchange\Enable_25112020.csv"
$arquivo = Import-Csv $csv -Encoding Default -Delimiter ";"

function enableFromCsv {
    foreach ($mbx in $arquivo) {
        Enable-RemoteMailbox -Identity $mbx.Usuario -RemoteRoutingAddress ($mbx.Usuario+'@grq.mail.onmicrosoft.com')
    }
}


#$arquivo | ForEach { Enable-RemoteMailbox -Identity $_.User -RemoteRoutingAddress ($_.User+'@grq.mail.onmicrosoft.com') }

function enableFromOu {
    foreach ($mbx in $arquivo) {
        #Get-ADUser -Filter * -SearchBase "OU=Transporte,OU=Site BA,OU=Rio Quente Resorts,DC=rqr,DC=com,DC=br" | ForEach { Enable-RemoteMailbox -Identity $_.samaccountname -RemoteRoutingAddress ($_.samaccountname+'@grq.mail.microsoft.com') }
    }
}

function enableLicense {
    foreach ($mbx in $arquivo) {
        Set-MsolUserLicense -UserPrincipalName $mbx.UserPrincipalName -AddLicenses grq:O365_BUSINESS_ESSENTIALS
    }
}

enableFromCsv

<# $arquivo | foreach {
#    $users = Get-MsolUser -
    #Set-MsolUser -UserPrincipalName $_.User -UsageLocation BR
    Set-MsolUserLicense -UserPrincipalName $_.User -AddLicenses grq:O365_BUSINESS_ESSENTIALS
} #>