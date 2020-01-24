# Deve estar logado no Powershell Remoto do Office 365

#Obter informa��es de permiss�o de uma caixa
get-MailboxFolderPermission -Identity usuario@contoso.com:\"Calend�rio"

#ou caso a caixa esteja em ingl�s
get-MailboxFolderPermission -Identity usuario@contoso.com:\Calendar

#Adicionar permiss�es em uma caixa
Add-MailboxFolderPermission -Identity usuario@contoso.com:\"Calend�rio" -User usuariopermitido@contoso.com -AccessRights Owner

#Remover permiss�es de uma caixa
Remove-MailboxFolderPermission -Identity usuario@rioquenteresorts.com.br:\"Calend�rio" -user usuarioremovido@contoso.com