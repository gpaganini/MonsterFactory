<#[CmdletBinding()]
Param(
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]    
    [string]$Dominio = 'Dominio',
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]    
    [string]$csvPath = 'CSVPath'
) #>

$csvPath = ".\test.csv"
$arquivo = Import-Csv $csvPath
$Dominio = "rqr.com.br"

Import-Module ActiveDirectory

$GetAdminact = Get-Credential
$dc = Get-ADDomainController -DomainName $Dominio -Discover -NextClosestSite
$adServer = $dc.HostName[0]

$i = 0

$arquivo.foreach({
    try {
        $oldName = Get-ADUser -Server $adServer -Credential $GetAdminact -Identity $_.user -Properties * | select DisplayName

        if ($oldName.DisplayName -like "AUSENTE") {
            $newName = $oldName -replace ("AUSENTE - ","")
            Set-ADUser -Server $dc.Hostname[0] -Identity $_.user -DisplayName $newName
        } elseif ($oldName.DisplayName -like "AFASTADO") {
            $newName = $oldName -replace ("AFASTADO - ","")
            Set-ADUser -Server $dc.Hostname[0] -Identity $_.user -DisplayName $newName
        } elseif ($oldName.DisplayName -like "FERIAS") {
            $newName = $oldName -replace ("FERIAS - ","")
            Set-ADUser -Server $dc.Hostname[0] -Identity $_.user -DisplayName $newName
        }
        
        if ($oldName.DisplayName -notlike "DESATIVADO") {            
            Set-ADUser -Server $adServer -Identity $_.user -DisplayName ("DESATIVADO - " + $oldName.DisplayName)
            Write-Host -BackgroundColor Blue -ForegroundColor White "$($oldName.DisplayName)"
        }
                
        #Disable-ADAccount -Server $adServer -Identity $_.user
    } catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
        Write-Host -BackgroundColor Red -ForegroundColor White "Erro ao aplicar configuracao no usuario $_.user"
    }   

    $i++

    Write-Progress -Activity "Desativando usuarios..." `
    -Status "Desativado $i de $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
})


<# $arquivo.foreach({
    $oldName = Get-ADUser -Server $adServer `
    -Credential $GetAdminact `
    -Identity $_.user -Properties DisplayName | select DisplayName    

    $newName = $oldName.DisplayName -replace "AUSENTE - ",""
    Set-ADUser -Server $dc.Hostname[0] -Identity $_.user -DisplayName $newName
    Write-Host -BackgroundColor Blue -ForegroundColor White "$($oldName.DisplayName)"
    Write-Host -BackgroundColor Green -ForegroundColor White "$($newName)"
    #Enable-ADAccount -Server $dc.Hostname[0] -Identity $_.user

    $i++

    Write-Progress -Activity "Desativando usuarios..." `
    -Status "Desativado $i de $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
})#>


