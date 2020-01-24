Import-Module ActiveDirectory
$path = ".\Users.CSV"
$users = get-content $path


$users | ForEach { Set-ADUser -identity $_.samaccountnanme -remove @{proxyaddresses="SMTP:$($_.UserPrincipalName)"}}

foreach ($user in $users) { 
	get-aduser -filter "SamAccountName -eq '$user'" | ForEach-object {set-aduser -identity $_.SamAccountName -remove @{proxyAddresses="SMTP:$($_.UserPrincipalName)"} }}
	
Set-PSDebug -Trace 1

### remove primary smtp address
$arquivo | ForEach { Set-ADUser -identity $_.User -remove @{proxyAddresses="SMTP:$($_.UserPrincipalName)"}}

### remove @rioquenteresorts SMTP entry
$arquivo | ForEach { Set-ADUser -identity $_.User -remove @{proxyAddresses="SMTP:$($_.User + '@rioquenteresorts.com.br')"}}

### add @aviva.com.br primary SMTP
$arquivo | ForEach { Set-ADUser -identity $_.User -Add @{proxyAddresses="SMTP:$($_.UserPrincipalName)"}}

### add @rioquenteresorts.com.br secondary SMTP
$arquivo | ForEach { Set-ADUser -identity $_.User -Add @{proxyAddresses="smtp:$($_.User + '@rioquenteresorts.com.br')"}}

### change users mail address
$arquivo | ForEach { Set-ADUser -identity $_.User -Email ($_.UserPrincipalName)}