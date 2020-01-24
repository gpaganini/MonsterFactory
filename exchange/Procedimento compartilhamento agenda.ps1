Remove-MailboxFolderPermission -Identity USERID@rioquenteresorts.com.br:\"Calendário" -user "USERID" 

add-MailboxFolderPermission -Identity USERID@rioquenteresorts.com.br:\"Calendário" -User USERID@rioquenteresorts.com.br -AccessRights Owner

get-MailboxFolderPermission -Identity kelcilene.lucas@rioquenteresorts.com.br:\"Calendário"

Se a permissão ja existe para o usuario Default, use o comando set:
Comando para liberar leitura de compromissos (permissão padrão)
set-MailboxFolderPermission -Identity USERID@rioquenteresorts.com.br:\"Calendário" -User "Default" -AccessRights AvailabilityOnly
_____________

ANOTAÇÕES:
Criar grupo universal no AD
Enable-DistributionGroup GrupoDoAD

Dar as permissões para o grupo
add-MailboxFolderPermission -Identity kelcilene.lucas@rioquenteresorts.com.br:\"Calendário" -User csc@rioquenteresorts.com.br -AccessRights Owner

add-MailboxFolderPermission -Identity kelcilene.lucas@rioquenteresorts.com.br:\"Calendário" -User suzana@rioquenteresorts.com.br -AccessRights Owner
add-MailboxFolderPermission -Identity kelcilene.lucas@rioquenteresorts.com.br:\"Calendário" -User eliana.santos@rioquenteresorts.com.br -AccessRights Owner
add-MailboxFolderPermission -Identity kelcilene.lucas@rioquenteresorts.com.br:\"Calendário" -User iane.silva@rioquenteresorts.com.br -AccessRights Owner

add-MailboxFolderPermission -Identity kelcilene.lucas@rioquenteresorts.com.br:\"Calendário" -User testecalendario@rioquenteresorts.com.br -AccessRights Owner

The user  is either not valid SMTP address, or there is no matching information.


add-MailboxFolderPermission -Identity raphael.borges@rioquenteresorts.com.br:\"Calendário" -Use
testecalendario@rioquenteresorts.com.br -AccessRights Owner