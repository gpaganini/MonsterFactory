$CSV = ".\layoff_redirect-fernanda.csv"
$arquivo = Import-CSV $csv

$i = 0

$arquivo.foreach({
	Set-MailboxAutoReplyConfiguration -identity $_.user `
	-AutoReplyState Scheduled `
	-StartTime "03/28/2020" `
	-EndTime "06/01/2020" `
	-InternalMessage "Ola! Estarei ausente do trabalho de 28/03 a 31/05/2020. Precisa de ajuda? Envie email para  atendimentoagencia@aviva.com.br que vamos auxiliar voce! ;)" `
	-ExternalMessage "Ola! Estarei ausente do trabalho de 28/03 a 31/05/2020. Precisa de ajuda? Envie email para  atendimentoagencia@aviva.com.br que vamos auxiliar voce! ;)"

    $i++

    Write-Progress -Activity "Configurando ausencia temporaria..." `
    -Status "Configurado $i de $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
})