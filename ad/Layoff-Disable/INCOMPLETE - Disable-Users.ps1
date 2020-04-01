$csv = ".\layoff-disable.csv"
$arquivo = Import-Csv $csv

Import-Module ActiveDirectory

$i = 0

$dc = Get-ADDomainController -DomainName aviva.com.br -Discover -NextClosestSite 

$arquivo.foreach({
    try {
        $oldName = Get-ADUser -Server  -Identity $_.user -Properties DisplayName | select DisplayName    
        Set-ADUser -Server $dc.hostname[0] -Identity $_.user -DisplayName ("AUSENTE - " + $oldName.DisplayName)
        Disable-ADAccount -Server $dc.hostname[0] -Identity $_.user 
    } catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
        Write-Host -BackgroundColor Red -ForegroundColor White "Erro ao aplicar configuracao no usuario $($_.user)"
    }   

    $i++

    Write-Progress -Activity "Desativando usuarios..." `
    -Status "Desativado $i de $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
})

<# rollback

$dc = Get-ADDomainController -DomainName rqr.com.br -Discover -NextClosestSite
$arquivo.foreach({
    $oldName = Get-ADUser -Server $dc.Hostname[0] -Identity $_.user -Properties DisplayName | select DisplayName    
    $newName = $oldName.DisplayName -replace "AUSENTE - ",""
    Set-ADUser -Server $dc.Hostname[0] -Identity $_.user -DisplayName $newName
    #Enable-ADAccount -Server $dc.Hostname[0] -Identity $_.user

    $i++

    Write-Progress -Activity "Desativando usuarios..." `
    -Status "Desativado $i de $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
}) #>


