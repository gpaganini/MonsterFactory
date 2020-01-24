## Executar no Exchange Shell do servidor OnPrem se ambiente = Hibrido

Import-Module ActiveDirectory
Get-ADUser -Filter * -SearchBase "OU=Usuarios,OU=Desabilitados,DC=rqr,DC=com,DC=br" | ForEach { Set-RemoteMailbox -Identity $_.samaccountname -HiddenFromAddressListsEnabled $true }