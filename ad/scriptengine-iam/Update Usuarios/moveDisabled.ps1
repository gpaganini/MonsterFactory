Import-Module ActiveDirectory
$csv = ".\disabled-move.csv"
$arquivo = Import-Csv -Path $csv -Delimiter ";"

foreach ($User in $arquivo) {
    Disable-ADAccount -Identity $User.Usuario
    Move-ADObject -Identity $user.DN -TargetPath "OU=Contas Desabilitadas,OU=Automacao - Autoseg,DC=aviva,DC=com,DC=br"
}