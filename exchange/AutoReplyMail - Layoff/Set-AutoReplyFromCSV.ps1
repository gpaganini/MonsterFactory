<# 	
	.Notes
	NOME: Set-AutoReplyFromCSV.ps1
	AUTHOR: Giovani Paganini
	CREATIONDATE: 31 March 2020
	LASTEDIT: 31 March 2020
	VERSION: 1.0
	
	Change Log
	v1.0, 31/03/2020 - Initial Version
    v1.0.1, 01/04/2020 - Created Rollback script
	
#>

..\exchonlineconn.ps1

$csv = ".\layoff-fernanda.csv"
$arquivo = import-csv $csv -Delimiter ";"

$i = 0

foreach ($user in $arquivo) {

try {
    Set-MailboxAutoReplyConfiguration `
    -Identity ($user.mail) `
    -AutoReplyState Enabled `
    -InternalMessage "$($user.message)" `
    -ExternalMessage "$($user.message)"
    } catch [Microsoft.Exchange.Management.StoreTasks.SetMailboxAutoReplyConfiguration],[ManagementObjectNotFoundException] {
        Write-Host -BackgroundColor Red -ForegroundColor White "Erro ao aplicar configuracao no usuario $($user.mail)"
    }
    
    $i++

    Write-Progress -Activity "Configurando ausencia temporaria..." `
    -Status "Configurado $i de $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
}

    
<#foreach ($user in $arquivo) {
    try {
        Set-MailboxAutoReplyConfiguration `
        -Identity ($user.mail)`
        -AutoReplyState Disabled `
        -InternalMessage $null `
        -ExternalMessage $null
    } catch [Microsoft.Exchange.Management.StoreTasks.SetMailboxAutoReplyConfiguration],[ManagementObjectNotFoundException] {
        Write-Host -BackgroundColor Red -ForegroundColor White "Erro ao aplicar configuracao no usuario $($user.mail)"
    }
    
    $i++

    Write-Progress -Activity "Configurando ausencia temporaria..." `
    -Status "Configurado $i de $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
}#>



