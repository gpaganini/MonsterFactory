Import-Module ActiveDirectory
$path = "Users.CSV"
$arquivo = Import-Csv $path	

### remove @rioquenteresorts SMTP entry
$arquivo | ForEach { Set-ADUser -identity $_.User -remove @{proxyAddresses="smtp:$($_.User + '@grq.mail.microsoft.com')"}}

$arquivo | ForEach { Set-ADUser -identity $_.User -remove @{proxyAddresses="smtp:$($_.User + '@grq.mail.onmicrosoft.com')"}}

### add @rioquenteresorts.com.br secondary SMTP
$arquivo | ForEach { Set-ADUser -identity $_.User -Add @{proxyAddresses="smtp:$($_.User + '@grq.mail.onmicrosoft.com')"}}

$arquivo | ForEach { Set-ADUser -identity $_.User -Remove @{targetAddress="SMTP:$($_.User + '@grq.mail.microsoft.com')"}}
$arquivo | ForEach { Set-ADUser -identity $_.User -Add @{targetAddress="SMTP:$($_.User + '@grq.mail.onmicrosoft.com')"}}
