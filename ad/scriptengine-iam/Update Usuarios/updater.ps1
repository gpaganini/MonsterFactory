Import-Module ActiveDirectory

$csv = "C:\Users\giovani.paganini\powershellson\ad\scriptengine-iam\Update Usuarios\Update_16092020.csv"
$arquivo = Import-Csv -Path $csv -Delimiter ";"

$i = 0

foreach ($user in $arquivo) {
    $aduser = Get-ADUser -Identity $user.Usuario -Properties *

    Set-ADUser -Identity $user.Usuario -Replace @{'extensionAttribute1'=$user.CPF;}
    #Set-ADUser -Identity $user.Usuario -Department $user.Departamento -Title $user.Cargo -Description $user.Cargo -StreetAddress "Rodovia BA-099 - KM 76, 000, Costa do Sauipe, Sauipe" -City "Mata de São João" -PostalCode "48282-970" -State "BA" -Country "BR" -Office "Costa do Sauipe" -Company "www.aviva.com.br"

$i++

    Write-Progress -Activity "Updating User Attributes..." `
    -Status "Updated $i de $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)

}