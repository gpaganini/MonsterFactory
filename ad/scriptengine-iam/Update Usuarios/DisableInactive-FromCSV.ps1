Import-Module ActiveDirectory

$csv = "C:\Users\giovani.paganini\powershellson\ad\scriptengine-iam\Update Usuarios\Inactive last 90 days.csv"
$arquivo = Import-Csv -Path $csv -Delimiter ";"

$i = 0

foreach ($user in $arquivo) {
    $aduser = Get-ADUser -Identity $user.Usuario -Properties *      

    #echo "Desativando usuário $($aduser.samaccountname) localizado em $($aduser.distinguishedname)"
    
    Set-ADUser -Identity $user.Usuario -HomePhone "DESATIVADO - NAO LOGA HA 90 DIAS"
    Disable-ADAccount -Identity $user.Usuario

$i++

    Write-Progress -Activity "Disabling inactive users..." `
    -Status "Disabled $i of $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
}

##trash

#Set-ADUser -Identity $user.Usuario -Replace @{'extensionAttribute1'=$user.CPF;}
#Set-ADUser -Identity $user.Usuario -Department $user.Departamento -Title $user.Cargo -Description $user.Cargo -StreetAddress "Rodovia BA-099 - KM 76, 000, Costa do Sauipe, Sauipe" -City "Mata de São João" -PostalCode "48282-970" -State "BA" -Country "BR" -Office "Costa do Sauipe" -Company "www.aviva.com.br"