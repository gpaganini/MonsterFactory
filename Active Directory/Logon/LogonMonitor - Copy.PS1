$filterXml = @"
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[(EventID=4624) and TimeCreated[timediff(@SystemTime) &lt;= 86400000]] and
    EventData[Data[@Name='LogonType'] and Data=10]]</Select>
  </Query>
</QueryList>
"@

$event = Get-WinEvent -FilterXml $filterXml | Select-Object -First 1

$From = "svc.mon@rioquenteresorts.com.br"
$To = "getiinfra@rioquenteresorts.com.br"
$Cc = "giovani.paganini@rioquenteresorts.com.br"
$Subject = "Alerta! Logon detectado no SRVAD-A"
$Body = $event.Message
$SMTPServer = "mail.grq.com.br"
$SMTPPort = "25"

Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -DeliveryNotificationOption OnSuccess -priority High
