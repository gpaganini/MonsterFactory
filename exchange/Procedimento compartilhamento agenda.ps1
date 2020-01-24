Remove-MailboxFolderPermission -Identity USERID@rioquenteresorts.com.br:\"Calend�rio" -user "USERID" 

add-MailboxFolderPermission -Identity USERID@rioquenteresorts.com.br:\"Calend�rio" -User USERID@rioquenteresorts.com.br -AccessRights Owner

get-MailboxFolderPermission -Identity kelcilene.lucas@rioquenteresorts.com.br:\"Calend�rio"

Se a permiss�o ja existe para o usuario Default, use o comando set:
Comando para liberar leitura de compromissos (permiss�o padr�o)
set-MailboxFolderPermission -Identity USERID@rioquenteresorts.com.br:\"Calend�rio" -User "Default" -AccessRights AvailabilityOnly
_____________

ANOTA��ES:
Criar grupo universal no AD
Enable-DistributionGroup GrupoDoAD

Dar as permiss�es para o grupo
add-MailboxFolderPermission -Identity kelcilene.lucas@rioquenteresorts.com.br:\"Calend�rio" -User csc@rioquenteresorts.com.br -AccessRights Owner

add-MailboxFolderPermission -Identity kelcilene.lucas@rioquenteresorts.com.br:\"Calend�rio" -User suzana@rioquenteresorts.com.br -AccessRights Owner
add-MailboxFolderPermission -Identity kelcilene.lucas@rioquenteresorts.com.br:\"Calend�rio" -User eliana.santos@rioquenteresorts.com.br -AccessRights Owner
add-MailboxFolderPermission -Identity kelcilene.lucas@rioquenteresorts.com.br:\"Calend�rio" -User iane.silva@rioquenteresorts.com.br -AccessRights Owner

add-MailboxFolderPermission -Identity kelcilene.lucas@rioquenteresorts.com.br:\"Calend�rio" -User testecalendario@rioquenteresorts.com.br -AccessRights Owner

The user  is either not valid SMTP address, or there is no matching information.


add-MailboxFolderPermission -Identity raphael.borges@rioquenteresorts.com.br:\"Calend�rio" -Use
testecalendario@rioquenteresorts.com.br -AccessRights Owner