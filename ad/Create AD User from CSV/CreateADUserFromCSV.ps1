Import-Module ActiveDirectory

$csv = "C:\Users\giovani.paganini\powershellson\ad\Create AD User from CSV\Usuarios-25092020.csv"
$arquivo = Import-Csv -Path $csv -Encoding Default -Delimiter ";"

function create {
    foreach ($user in $arquivo) {
        New-ADUser -GivenName $user.FirstName `
        -Surname $user.LastName `
        -SamAccountName $user.Usuario `
        -DisplayName $user.NAME `
        -Name $user.NAME `
        -Description $user.Description `
        -Department $user.Department `
        -Title $user.Title `
        -UserPrincipalName ($user.UserPrincipalName) `
        -Path "OU=UNITONO,OU=Usuarios Terceiros,OU=Unidade Rio Quente,DC=aviva,DC=com,DC=br" `
        -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $false
    }
}

function update {
    foreach ($user in $arquivo) {
        $ud = Get-ADUser -Identity $user.Usuario -Properties *

        Set-ADUser -Identity $user.Usuario -Office $user.Office -Company $user.Office -StreetAddress $user.StreetAddress `
        -City $user.City -State $user.State -Country "BR" -PostalCode $user.PostalCode -Replace @{'ipPhone'=$user.mat}   
    }
}

function update2 {
    foreach ($user in $arquivo) {
        $ud = Get-ADUser -Identity $user.Usuario -Properties *

        Set-ADUser -Identity $user.Usuario -Office $user.Office -Company $user.Office -StreetAddress $user.StreetAddress `
        -City $user.City -State $user.State -Country "BR" -PostalCode $user.PostalCode -Department $user.Department -Replace @{'ipPhone'=$user.mat;'telephoneNumber'=$user.PhoneNumber}   
    }
}

update2
#create
#update

<#Import-Csv -Delimiter ";" "C:\path\to\user.CSV" | ForEach-Object {
New-ADUser -GivenName $_.firstName `
-Surname $_.lastName -SamAccountName $_.samAccountName -DisplayName $_.displayName -Name $_.name -Description $_.description -Title $_.title -Department $_.department -EmailAddress $_.emailAddress -UserPrincipalName $_.emailAddress -Path $_.ou-AccountPassword (ConvertTo-SecureString "Aviva12345" -AsPlainText -force) -Enabled $True -ChangePasswordAtLogon $True}
#>