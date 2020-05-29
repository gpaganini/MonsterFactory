Import-Module ActiveDirectory

$csv = "C:\Users\giovani.paganini.AVIVA\Documents\powershellson\ad\Layoff-Disable\layoff-enable-01062020.csv"
$arquivo = Import-Csv -Path $csv -Delimiter ";"

foreach ($user in $arquivo) {
    $adusuario = Get-ADUser -Identity $user.usuario -Properties * | select DisplayName,SamAccountName

    if ($adusuario.DisplayName -like "AUSENTE*") {
        Write-Host "Antes: " $adusuario.DisplayName -ForegroundColor White -BackgroundColor Magenta
        $newname = $adusuario.DisplayName -replace ("AUSENTE - ","")

        Write-Host "Depois: " $newname -ForegroundColor White -BackgroundColor DarkGreen

        Set-ADUser -Identity $adusuario.SamAccountName -DisplayName $newname -WhatIf
        Enable-ADAccount -Identity $adusuario.SamAccountName -WhatIf
    }
}