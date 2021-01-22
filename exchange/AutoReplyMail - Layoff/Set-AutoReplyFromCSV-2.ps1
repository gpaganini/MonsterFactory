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


Set-MailboxAutoReplyConfiguration -Identity pedro.arruda@aviva.com.br `
-AutoReplyState Scheduled `
-StartTime "11/30/2020" `
-EndTime "12/20/2020" `
-InternalMessage "Prezados clientes! <br>
Estarei em período de férias de 30/11/2020 a 20/12/2020, segue abaixo contatos para orçamentos de grupo e individual:<br><br>
Para atendimento de grupos:<br>
 grupos@aviva.com.br<br>
(11) 3512 4875<br><br>
Para atendimento, orçamentos e reservas individuais:<br>
atendimentoagencia@aviva.com.br<br>
(11) 3512 4890<br>
Portal online: agente.aviva.com.br<br><br>
Para dúvidas e urgências:<br>
lizzie.kipper@aviva.com.br<br>
(51) 99517-2319<br>
Abraços!<br>
" `
-ExternalMessage "Prezados clientes! <br>
Estarei em período de férias de 30/11/2020 a 20/12/2020, segue abaixo contatos para orçamentos de grupo e individual:<br><br>
Para atendimento de grupos:<br>
 grupos@aviva.com.br<br>
(11) 3512 4875<br><br>
Para atendimento, orçamentos e reservas individuais:<br>
atendimentoagencia@aviva.com.br<br>
(11) 3512 4890<br>
Portal online: agente.aviva.com.br<br><br>
Para dúvidas e urgências:<br>
lizzie.kipper@aviva.com.br<br>
(51) 99517-2319<br>
Abraços!<br>
" ` -ExternalAudience All