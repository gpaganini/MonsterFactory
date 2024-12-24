<# 	
	.Notes
	NOME: MoveDisabledUsersToOu-FromCsv.ps1
	AUTHOR: Giovani Paganini
	CREATIONDATE: 08 May 2020
	LASTEDIT: 08 May 2020
	VERSION: 1.0
	
	Change Log
	v1.0, 08/05/2020 - Initial Version	
#>

Import-Module ActiveDirectory

$csv = "C:\Users\giovani.paganini\powershellson\ad\Move Disabled Obj to OU\disabledUsers.csv"
$arquivo = Import-Csv -Path $csv -Delimiter ";"

$i = 0

foreach ($user in $arquivo) {
    $dn = Get-ADUser -Identity $user.Username -Properties * | select DistinguishedName
    $dn
    Set-ADUser -Identity $user.Username -HomePhone "DESATIVADO - DUPLICADO"
    Disable-ADAccount -Identity $user.Username
    Move-ADObject -Identity $dn.DistinguishedName -TargetPath "OU=Usuarios Duplicados,OU=Automacao - Autoseg,DC=aviva,DC=com,DC=br"

    $i++

    Write-Progress -Activity "Desativando usuarios..." `
    -Status "Desativado $i de $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
}

foreach ($user in $arquivo) {
    Get-ADUser -Identity $user.Username -Properties * | where {$_.Enabled -eq $True} | select name,SamAccountName,Enabled
}