Import-Module ActiveDirectory

$csv = ".\Usuarios.csv"
$arquivo = Import-Csv -Path $csv -Delimiter ";"

function create {
    foreach ($user in $arquivo) {
        New-ADUser -GivenName $user.FirstName `
        -Surname $user.LastName `
        -SamAccountName $user.Usuario `
        -DisplayName $user.NAME `
        -Name $user.NAME `
        -Description $user.Title `
        -Department $user.Department `
        -Title $user.Title `
        -UserPrincipalName ($user.Usuario+"@aviva.com.br") `
        -Path "OU=Usuarios Novos,OU=Automacao - Autoseg,DC=aviva,DC=com,DC=br" `
        -AccountPassword (ConvertTo-SecureString "Aviva@2020" -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $true
    }
}

function update {
    foreach ($user in $arquivo) {
        $ud = Get-ADUser -Identity $user.Usuario -Properties *

        Set-ADUser -Identity $user.Usuario -Office $user.Office -Company $user.Office -StreetAddress $user.StreetAddress `
        -City $user.City -State $user.State -Country "BR" -PostalCode $user.PostalCode -Replace @{'extensionAttribute1'=$user.cpf;'ipPhone'=$user.mat}   
    }
}

update

<#Import-Csv -Delimiter ";" "C:\path\to\user.CSV" | ForEach-Object {
New-ADUser -GivenName $_.firstName `
-Surname $_.lastName -SamAccountName $_.samAccountName -DisplayName $_.displayName -Name $_.name -Description $_.description -Title $_.title -Department $_.department -EmailAddress $_.emailAddress -UserPrincipalName $_.emailAddress -Path $_.ou-AccountPassword (ConvertTo-SecureString "Aviva12345" -AsPlainText -force) -Enabled $True -ChangePasswordAtLogon $True}
#>