$path = Split-Path -Parent "C:\Users\giovani.paganini\powershellson\exchange\ExchangeAuditing\*.*"
$logDate = Get-Date -f ddMMyyyy_HHmmss
$monthFolder = Get-Date -f MMM-yyyy

if (!("$path" + "\$monthFolder" | Test-Path)) {
    md "$path\$monthFolder"
}

$csvFile = $path + "\$monthFolder" + "\ExchangeAdminLog_$logDate.csv"

#.\powershellson\exchange\exchonlineconn.ps1

Function SaveLog {
    $AdminLog = Search-AdminAuditLog -StartDate (get-date).ToUniversalTime().AddDays(-1) -EndDate (Get-Date).ToUniversalTime() -ResultSize 250000 |
    Export-Csv -Path $csvFile -NoTypeInformation -Encoding UTF8
}


Function SendMail {
    $cmdlets = "Add-MailboxFolderPermission,Remove-MailboxFolderPermission,Add-MailboxPermission,Remove-MailboxPermission,Remove-Mailbox,Set-Mailbox,Set-MailboxFolderPermission,Add-RecipientPermission,Remove-RecipientPermission"
    $AdminLog = Search-AdminAuditLog -StartDate (get-date).ToUniversalTime().AddHours(-48) -EndDate (Get-Date).ToUniversalTime() -ResultSize 250000

    $report = $AdminLog | Select-Object @{label = "ObjetoModificado";Expression = {$_.ObjectModified}},
        @{label = "Comando";Expression = {$_.CmdletName}},
        @{label = "Parametros";Expression = {$_.CmdletParameters}},
        @{label = "Executado por";Expression = {$_.Caller}},
        @{label = "DataExecucao";Expression = {$_.RunDate}},
        @{label = "IP";Expression = {$_.ClientIP}}

    $htmlbody = $report | ConvertTo-Html -Fragment

    $htmlhead = "<html>
				<style>
				BODY{font-family: Arial; font-size: 8pt;}
				H1{font-size: 22px; font-family: 'Segoe UI Light','Segoe UI','Lucida Grande',Verdana,Arial,Helvetica,sans-serif;}
				H2{font-size: 18px; font-family: 'Segoe UI Light','Segoe UI','Lucida Grande',Verdana,Arial,Helvetica,sans-serif;}
				H3{font-size: 16px; font-family: 'Segoe UI Light','Segoe UI','Lucida Grande',Verdana,Arial,Helvetica,sans-serif;}
				TABLE{border: 1px solid black; border-collapse: collapse; font-size: 8pt;}
				TH{border: 1px solid #969595; background: #dddddd; padding: 5px; color: #000000;}
				TD{border: 1px solid #969595; padding: 5px; }
				td.pass{background: #B7EB83;}
				td.warn{background: #FFF275;}
				td.fail{background: #FF2626; color: #ffffff;}
				td.info{background: #85D4FF;}
				</style>
				<body>
                <p>Report of mailbox audit log entries for $mailbox in the last $hours hours.</p>"
    $htmltail = "</body></html>"
    $htmlreport = $htmlhead + $htmlbody + $htmltail

    $htmlreport | Out-File report.html -Encoding UTF8

} 

SendMail
getLog