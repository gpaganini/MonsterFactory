Import-Module ActiveDirectory

$csv = "C:\Users\giovani.paganini\powershellson\ad\Layoff-Disable\disable-27052020.csv"
$arquivo = Import-Csv -Path $csv -Delimiter ";"

$i = 0

foreach ($user in $arquivo) {
    #$oldname = Get-ADUser -Identity $user.usuario -Properties * | select DisplayName,IPPhone
    <#if ($oldname.DisplayName -like "*AUSENTE*") {
        $newName = $oldname.DisplayName -replace ("AUSENTE - ","")
        Set-ADUser -Identity $user.usuario -DisplayName $newName
        $oldname.DisplayName = $newName
    }

    if ($oldname.DisplayName -like "*FERIAS*") {
        $newName = $oldname.DisplayName -replace ("FERIAS - ","")
        Set-ADUser -Identity $user.usuario -DisplayName $newName
        $oldname.DisplayName = $newName
    }

    if ($oldname.DisplayName -like "*DESATIVADO*"){
        $newName = $oldname.DisplayName -replace ("DESATIVADO - ","")
        Set-ADUser -Identity $user.usuario -DisplayName $newName
        $oldname.DisplayName = $newName
    }

    $newName = "DESATIVADO - " + $oldname.DisplayName
    Set-ADUser -Identity $user.usuario -DisplayName $newName
    $oldname.DisplayName = $newName    

    Set-ADUser -Identity $user.usuario -Replace @{'ipPhone'=$user.MAT}
    $oldname
    #>
    Disable-ADAccount -Identity $user.usuario

    $i++

    Write-Progress -Activity "Desativando usuarios..." `
    -Status "Desativado $i de $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
}



$usuarios = Get-ADUser -Filter 'DisplayName -like "AUSENTE *" -and DisplayName -notlike "AUSENTE - *"' -Properties * | select DisplayName,SamAccountName

foreach ($usuario in $usuarios) {
    $oldname = $usuario.DisplayName
    Write-Host "Antes: "$oldname -ForegroundColor White -BackgroundColor Green $usuario.SamAccountName

    if ($oldname -like 'AUSENTE *') {
        $newName = $oldname -replace ("AUSENTE ","AUSENTE - ")
        Write-Host "Depois: "$newName -ForegroundColor White -BackgroundColor Magenta
        
        Set-ADUser -Identity $usuario.SamAccountName -DisplayName $newName
    }
}