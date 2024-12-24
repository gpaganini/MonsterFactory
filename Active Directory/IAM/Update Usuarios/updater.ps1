Import-Module ActiveDirectory

$csv = "C:\Users\giovani.paganini\powershellson\ad\scriptengine-iam\Update Usuarios\Update Usuarios - 07062021.csv"
$arquivo = Import-Csv -Path $csv -Encoding UTF8 -Delimiter ";"

$i = 0

foreach ($user in $arquivo) {
    $aduser = Get-ADUser -Identity $user.Usuario -Properties *
    Set-ADUser -Identity $user.Usuario -Replace @{'ipPhone'=$user.Mat}

    $i++

    Write-Progress -Activity "Updating User Attributes..." `
    -Status "Updated $i de $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
}

#$i = 0


<# foreach ($user in $arquivo) {
    #$aduser = Get-ADUser -Identity $user.Usuario -Properties *

    #Move-ADObject -Identity $user.DN -TargetPath $user.OU
    
    #Set-ADUser -Identity $user.Usuario -Replace @{'extensionAttribute1'=$user.CPF;}
    #Set-ADUser -Identity $user.Usuario -Department $user.Departamento -Title $user.Cargo -Description $user.Cargo -StreetAddress "Rodovia BA-099 - KM 76, 000, Costa do Sauipe, Sauipe" -City "Mata de São João" -PostalCode "48282-970" -State "BA" -Country "BR" -Office "Costa do Sauipe" -Company "www.aviva.com.br"

$i++

    Write-Progress -Activity "Updating User Attributes..." `
    -Status "Updated $i de $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
} #>

<#function updateAddress {
    foreach ($user in $arquivo) {
        $ud = Get-ADUser -Identity $user.Usuario -Properties *
        
        Set-ADUser -Identity $user.Usuario -Office $user.Office -Company $user.Company -StreetAddress $user.Street `
        -City $user.City -State $user.State -Country $user.Country -PostalCode $user.PostalCode

        $i++

        Write-Progress -Activity "Updating Address..." `
        -Status "Updated $i of $($arquivo.Count)" `
        -PercentComplete ($i/$arquivo.Count*100)
    }
}

updateAddress#>