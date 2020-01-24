Set-PSDebug -Trace 1

$organizationalUnit = 'OU=Suprimentos,OU=Site BA,OU=Rio Quente Resorts,DC=rqr,DC=com,DC=br'

Import-Module ActiveDirectory


### remove primary smtp address
Get-ADUser -Filter * -SearchBase $organizationalUnit | ForEach-Object { Set-ADUser -identity $_.samaccountname -remove @{proxyAddresses="SMTP:$($_.UserPrincipalName)"}}

### remove @rioquenteresorts SMTP entry
Get-ADUser -Filter * -SearchBase $organizationalUnit | ForEach-Object { Set-ADUser -identity $_.samaccountname -remove @{proxyAddresses="SMTP:$($_.SamAccountName + '@rioquenteresorts.com.br')"}}

### add @aviva.com.br primary SMTP
Get-ADUser -Filter * -SearchBase $organizationalUnit | ForEach-Object { Set-ADUser -identity $_.samaccountname -Add @{proxyAddresses="SMTP:$($_.UserPrincipalName)"}}

### add @rioquenteresorts.com.br secondary SMTP
Get-ADUser -Filter * -SearchBase $organizationalUnit | ForEach-Object { Set-ADUser -identity $_.samaccountname -Add @{proxyAddresses="smtp:$($_.SamAccountName + '@rioquenteresorts.com.br')"}}

### change users mail address
Get-ADUser -Filter * -SearchBase $organizationalUnit | ForEach-Object { Set-ADUser -identity $_.samaccountname -Email ($_.UserPrincipalName)}

