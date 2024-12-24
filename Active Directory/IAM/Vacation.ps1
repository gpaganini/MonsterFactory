$csv = "C:\Scripts\Vacation-November.csv"
$arquivo = Import-Csv $csv -Encoding UTF8 -Delimiter ";"
$today = Get-Date -Format dd/MM/yyyy

foreach ($user in $arquivo) {
    #$aduser = Get-ADUser -Identity $user.Usuario -Properties *
    
    $dataInicio = [datetime]::ParseExact("$($user.DATAINICIO)", 'dd/MM/yyyy', $null)    
    $dataInicio = Get-Date $dataInicio -Format dd/MM/yyyy    

    $dataFim = [datetime]::ParseExact("$($user.DATAFIM)", 'dd/MM/yyyy', $null)    
    $dataFim = Get-Date $dataFim -Format dd/MM/yyyy    

    #retorna true se entrar de ferias
    if ($dataInicio -eq $today) {
        Write-Host  "$($user.Usuario) FERIAS $($user.DATAINICIO)" -ForegroundColor White -BackgroundColor Green
        Disable-ADAccount -Identity $user.Usuario
    }

    if ($dataFim -eq $today) {
        Write-Host "$($user.Usuario) RETORNO $($user.DATAFIM)" -ForegroundColor White -BackgroundColor Red
        Enable-ADAccount -Identity $user.Usuario
    }
}