Import-Module ActiveDirectory

$adUsers = Get-ADUser -Filter * -Properties *

foreach($user in $adUsers) {
    if(($user.Office -notlike "Rio Quente" -and $user.Office -notlike "Costa do Sauipe") -and `
    ($user.StreetAddress -notlike "Rua Particular, Complexo Turístico Rio Quente Resorts S/N" -and $user.StreetAddress -notlike "Rodovia BA-099 - KM 76, 000, Costa do Sauipe, Sauipe") -and `
    ($user.City -notlike "Rio Quente" -and $user.city -notlike "Mata de São João")) {
        Write-Host $user.Office $user.StreetAddress $user.City
    }
}

foreach ($user in $adUsers) {
    if ($user.ipPhone -ne $null) {
        echo $user.Name $user.ipPhone
    }
}