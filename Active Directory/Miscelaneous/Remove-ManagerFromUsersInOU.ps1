Import-Module ActiveDirectory
$disabledUsersOu = "OU=Contas Desabilitadas,OU=Automacao - Autoseg,DC=aviva,DC=com,DC=br"

Get-ADUser -Filter {Enabled -eq $false} -Properties Name,SamAccountName,Manager -SearchBase $disabledUsersOu | Set-ADUser -Manager $null