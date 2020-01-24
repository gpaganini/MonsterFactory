$moveToOU = "OU=Usuarios,OU=Desabilitados,DC=rqr,DC=com,DC=br"

Get-ADUser -filter {Enabled -eq $false } | Foreach-object {
  Move-ADObject -Identity $_.DistinguishedName -TargetPath $moveToOU
}