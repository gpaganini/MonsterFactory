$filterXml = @"
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[(EventID=4624) and TimeCreated[timediff(@SystemTime) &lt;= 86400000]] and
    EventData[Data[@Name='LogonType'] and Data=10 or Data=3 or Data=8]]</Select>
  </Query>
</QueryList>
"@

function cred {
    $usuario = 'ladiesman21745@hotmail.com'
    $senha = Get-Content '.\ladiesman.txt'

    $secureSenha = $senha | ConvertTo-SecureString

    $userCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $usuario, $secureSenha

    return $userCredential	
}
	

$event = Get-WinEvent -FilterXml $filterXml | Select-Object -First 1

$From = "ladiesman21745@hotmail.com"
$To = "do.not.reply.dharma@gmail.com"
$Subject = "Alerta! Logon detectado no RQE-101120-NB"
$Body = $event.Message
$SMTPServer = "smtp.office365.com"
$SMTPPort = "587"

Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -DeliveryNotificationOption OnSuccess -priority High -UseSsl -Credential (cred)

