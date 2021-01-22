Import-Module ActiveDirectory

$adUsers = Get-ADUser -Filter * -Properties *

foreach($user in $adUsers) {
    if(($user.Office -notlike "Rio Quente" -and $user.Office -notlike "Costa do Sauipe") -or ($user.ipPhone -eq $null)) {
        echo "$($user.Name) - $($user.Office)"
    }
}

foreach ($user in $adUsers) {
    if ($user.ipPhone -eq $null) {
        echo $user.Name $user.ipPhone
    }
}