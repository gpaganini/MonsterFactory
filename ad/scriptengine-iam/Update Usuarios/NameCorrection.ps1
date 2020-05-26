Import-Module ActiveDirectory

$csv = "C:\Users\giovani.paganini\powershellson\ad\scriptengine-iam\Update Usuarios\NameCorrect.csv"
$arquivo = Import-Csv -Path $csv -Delimiter ";"


Function ChangeUserCN {
    foreach ($user in $arquivo) {
        Rename-ADObject -Identity $user.DN -NewName $user.Nome
    }
}


Function ChangeUserFirstName {
    foreach ($user in $arquivo) {
        $aduser = Get-ADUser -Identity $user.Usuario -Properties *
        Set-ADUser -Identity $user.Usuario -GivenName $user.FirstName
    }
}

ChangeUserCN
ChangeUserFirstName
