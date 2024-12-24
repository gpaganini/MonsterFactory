
PS C:\Users\giovani.paganini.AVIVA\Documents\powershellson\exchange> $session = New-PSSession -ComputerName SRVRQE0110010.rqr.com.br -Credential $credential -Authentication kerberos
PS C:\Users\giovani.paganini.AVIVA\Documents\powershellson\exchange> Invoke-Command -Session $session -ScriptBlock {Import-Module -Name 'ADSync'}
PS C:\Users\giovani.paganini.AVIVA\Documents\powershellson\exchange> Invoke-Command -Session $session -ScriptBlock {start-adsyncsynccycle -policytype delta}