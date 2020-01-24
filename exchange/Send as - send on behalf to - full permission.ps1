Adding full access permissions
Add-MailboxPermission -Identity noreply@rioquenteresorts.com.br -User svc.smtp.o365@rioquenteresorts.com.br -AccessRights 'Send-As'

Adding Send As permissions
Get-Mailbox "noreply" | Add-ADPermission -User "svc.smtp.o365" -ExtendedRights "Send As"


Get-DistributionGroup "GRUPO" | Add-AdPermission –ExtendedRights Send-As –User "USUARIO" –AccessRights ExtendedRight


Add-MailboxPermission -Identity noreply@rioquenteresorts.com.br -User svc.smtp.o365@rioquenteresorts.com.br -ExtendedRights 'Send-As'

Set-Mailbox -Identity noreply@rioquenteresorts.com.br -GrantSendOnBehalfTo svc.smtp.o365@rioquenteresorts.com.br

Add-ADPermission -Identity noreply -User svc.smtp.o365@rioquenteresorts.com.br -ExtendedRights "Send As"





https://practical365.com/exchange-server/exchange-2010-grant-send-behalf-permissions-distribution-group/
https://practical365.com/exchange-server/exchange-2010-send-as-permissions-distribution-group/
