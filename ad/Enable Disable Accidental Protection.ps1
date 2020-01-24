## Protect all AD objects from accidental deletion
Get-ADobject -filter * | Set-ADObject -ProtectedFromAccidentalDeletion $true

## UnProtect all AD objects from accidental deletion
Get-ADobject -filter * | Set-ADObject -ProtectedFromAccidentalDeletion $false

## Mover usuarios desativados para OU
$moveToOU = "OU=Usuarios,OU=Desabilitados,DC=rqr,DC=com,DC=br"

Get-ADUser -filter {Enabled -eq $false } | Foreach-object {
  Move-ADObject -Identity $_.DistinguishedName -TargetPath $moveToOU
}

##########

## Protect all AD organizational units from accidental deletion
Get-ADOrganizationalUnit -filter * | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $true

## UnProtect all AD organizational units from accidental deletion
Get-ADOrganizationalUnit -filter * | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false

