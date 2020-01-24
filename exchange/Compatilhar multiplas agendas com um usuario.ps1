# colocar as mailboxes que receber�o a permiss�o do usuario em um arquivo csv em uma unica coluna como no exemplo:


#alias
#usuario1@rioquenteresorts.com.br
#usuario2@rioquenteresorts.com.br
#usuario3@rioquenteresorts.com.br
#[...]


Import-Csv C:\scripts\mailbox.CSV | ForEach-Object {Add-MailboxFolderPermission -Identity "$($_.alias):\Calend�rio" -User usuario@rioquenteresorts.com.br -AccessRights editor -SharingPermissionFlags delegate}

# esse script concede os direitos de Editor com Delega��o ao usuario especificado em -User para todas as mailboxes do CSV

