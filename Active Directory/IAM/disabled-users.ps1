Import-Module ActiveDirectory

$csv = "C:\Users\giovani.paganini\powershellson\ad\scriptengine-iam\AdUsers-15042021.csv"
$arquivo = Import-Csv -Path $csv -Encoding UTF8 -Delimiter ";"

$demitidos = $arquivo | ? {$_.Status -eq "Inativo" -and $_.'Status Folha' -like "Demitido*" -and $_.DN -notlike "*Contas Desabilitadas*"}

foreach ($user in $demitidos) {
    Move-ADObject -Identity $user.DN -TargetPath "OU=Contas Desabilitadas,OU=Automacao - Autoseg,DC=aviva,DC=com,DC=br"  
}