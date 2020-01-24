$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://SRVRQE940020/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session