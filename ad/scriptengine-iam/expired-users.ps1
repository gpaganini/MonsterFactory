$csv = "C:\Users\giovani.paganini\expired-users-03112020.csv"
$arquivo = Import-Csv $csv -Encoding Default

$i = 0

foreach ($user in $arquivo) {
    $aduser = Get-ADUser -Identity $user.samaccountname -Properties *
    Set-ADUser -Identity $user.samaccountname -Replace @{'pwdLastSet'="0"}
    Set-ADUser -Identity $user.samaccountname -Replace @{'pwdLastSet'="-1"}

    $i++

    Write-Progress -Activity "Alterando data de expiração" `
    -Status "Alterado $i of $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
}





$usuario = "sabrina.araujo"
Set-ADUser -Identity $usuario -Replace @{'pwdLastSet'="0"}
Set-ADUser -Identity $usuario -Replace @{'pwdLastSet'="-1"}


Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

$expired = get-aduser -Filter {enabled -eq $true} -Properties samaccountname,passwordexpired | select samaccountname,passwordexpired | where {$_.PasswordExpired -eq $true} 
$expired | Export-Csv -Path expired-users-03112020.csv -NoTypeInformation -Encoding UTF8