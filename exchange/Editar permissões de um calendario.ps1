# Deve estar logado no Powershell Remoto do Office 365

#Obter informações de permissão de uma caixa
get-MailboxFolderPermission -Identity usuario@contoso.com:\"Calendário"

#ou caso a caixa esteja em inglês
get-MailboxFolderPermission -Identity usuario@contoso.com:\Calendar

#Adicionar permissões em uma caixa
Add-MailboxFolderPermission -Identity usuario@contoso.com:\"Calendário" -User usuariopermitido@contoso.com -AccessRights Owner

#Remover permissões de uma caixa
Remove-MailboxFolderPermission -Identity usuario@rioquenteresorts.com.br:\"Calendário" -user usuarioremovido@contoso.com