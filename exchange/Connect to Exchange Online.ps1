Onprem

$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://SRVRQE940020/PowerShell/ -Authentication Kerberos -Credential $UserCredential

Import-PSSession $Session


__________________________________________

Enable-RemoteMailbox "nome.sobrenome" -RemoteRoutingAddress "nome.sobrenome@grq.mail.onmicrosoft.com”
__________________________________________

Funcionando:

Set-ExecutionPolicy RemoteSigned

$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session
