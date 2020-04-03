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


$csv = ".\layoff_redirect-adm.csv"
$arquivo = import-csv $csv -Delimiter ";"

$i = 0

<# foreach ($user in $arquivo) {

try {
    Set-MailboxAutoReplyConfiguration `
    -Identity ($user.mail) `
    -AutoReplyState Scheduled `
    -StartTime "04/02/2020" `
    -EndTime "05/31/2020" `
    -InternalMessage "Olá, estou ausente. Por favor, encaminhe sua mensagem para $($user.destinatary)" `
    -ExternalMessage "Olá, estou ausente. Por favor, encaminhe sua mensagem para $($user.destinatary)"
    } catch [Microsoft.Exchange.Management.StoreTasks.SetMailboxAutoReplyConfiguration],[ManagementObjectNotFoundException] {
        Write-Host -BackgroundColor Red -ForegroundColor White "Erro ao aplicar configuracao no usuario $($user.mail)"
    }
    
    $i++

    Write-Progress -Activity "Configurando ausencia temporaria..." `
    -Status "Configurado $i de $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
}#>

    
foreach ($user in $arquivo) {
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
}



