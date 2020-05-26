Import-Module ActiveDirectory

$csv = "C:\Users\giovani.paganini\powershellson\ad\scriptengine-iam\Update Usuarios\LoadAD-NoCpf_25052020.csv"
$arquivo = Import-Csv -Path $csv -Delimiter ";"

foreach ($user in $arquivo) {
    $aduser = Get-ADUser -Identity $user.Usuario -Properties *

    Set-ADUser -Identity $user.Usuario -Replace @{'extensionAttribute1'=$user.CPF;'ipPhone'=$user.Matricula}
}