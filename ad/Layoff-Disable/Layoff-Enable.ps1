[CmdletBinding()]
Param(
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]    
    [string]$csv = 'Csv'    
)

Import-Module ActiveDirectory

#$csv = "C:\Users\giovani.paganini\powershellson\ad\Layoff-Disable\layoff-enable-16062020.csv"
$arquivo = Import-Csv -Path $csv -Delimiter ";"
$today = Get-Date -Format "dd-MM-yyyy"

function pegaData() {
    Get-Date -Format "dd/MM/yyyy HH:mm:ss"
}


foreach ($user in $arquivo) {
    $adusuario = Get-ADUser -Identity $user.usuario -Properties * | select DisplayName,SamAccountName

    if ($adusuario.DisplayName -like "AUSENTE*") {
        echo "$(pegaData) Renomeando usuário $($adusuario.DisplayName)" *>> "enable-layoff_$today.log"
        Write-Host "Antes: " $adusuario.DisplayName -ForegroundColor White -BackgroundColor Magenta
        
        $newname = $adusuario.DisplayName -replace ("AUSENTE - ","")
        echo "$(pegaData) Novo nome: $($newname)" *>> "enable-layoff_$today.log"

        Write-Host "Depois: " $newname -ForegroundColor White -BackgroundColor DarkGreen

        echo "$(pegaData) Executando renomear..." *>> "enable-layoff_$today.log"
        Set-ADUser -Identity $adusuario.SamAccountName -DisplayName $newname *>> "enable-layoff_$today.log"

        echo "$(pegaData) Habilitando usuario $($adusuario.SamAccountName)" *>> "enable-layoff_$today.log"
        Enable-ADAccount -Identity $adusuario.SamAccountName *>> "enable-layoff_$today.log"
        
        echo "$(pegaData) Finalizado." *>> "enable-layoff_$today.log"
    } else {
        echo "$(pegaData) Usuário não precisa ser renomeado, habilitando..." *>> "enable-layoff_$today.log"
        Enable-ADAccount -Identity $adusuario.SamAccountName *>> "enable-layoff_$today.log"

        echo "$(pegaData) Usuário Habilitado!" *>> "enable-layoff_$today.log"
    }
}
