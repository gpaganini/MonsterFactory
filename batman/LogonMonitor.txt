$filterXml = @"
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[(EventID=4624)]]
and
*[EventData[Data[@Name='LogonType'] and Data=10]]</Select>
  </Query>
</QueryList>
"@

$event = Get-WinEvent -FilterXml $filterXml | Select-Object -First 1

$From = "svc.printer.scan@rioquenteresorts.com.br"
$To = "giovani.paganini@rioquenteresorts.com.br"
$Subject = "Alerta! Logon detectado no SRVRQE0110009"
$Body = $event.Message
$SMTPServer = "mail.grq.com.br"
$SMTPPort = "25"

Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -DeliveryNotificationOption OnSuccess -priority High
