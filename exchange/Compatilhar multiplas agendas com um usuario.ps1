# colocar as mailboxes que receberão a permissão do usuario em um arquivo csv em uma unica coluna como no exemplo:


#alias
#usuario1@rioquenteresorts.com.br
#usuario2@rioquenteresorts.com.br
#usuario3@rioquenteresorts.com.br
#[...]


#Import-Csv C:\scripts\mailbox.CSV | ForEach-Object {Add-MailboxFolderPermission -Identity "$($_.alias):\Calendário" -User usuario@rioquenteresorts.com.br -AccessRights editor -SharingPermissionFlags delegate}

$csv = ".\agenda-gerentes.csv"
$arquivo = Import-Csv -Path $csv

$arquivo | foreach {
    $id = $_.alias + ':\Calendário'
    $export = Get-MailboxFolderPermission -Identity $id

    if ($export) {
        #write-host -BackgroundColor Green "BR" $id
    } else {
        $id = $_.alias + ':\Calendar'
        $export = Get-MailboxFolderPermission -Identity $id
        #Write-Host -BackgroundColor Red "murica" $id
    }

  
}


<#$arquivo | foreach {

    $id = $_.alias + ':\Calendário'
    $export = Get-MailboxFolderPermission -Identity $id

    if ($export) {
        #write-host -BackgroundColor Green "BR" $id
    } else {
        $id = $_.alias + ':\Calendar'
        $export = Get-MailboxFolderPermission -Identity $id
        #Write-Host -BackgroundColor Red "murica" $id
    }

    Write-Host "Mailbox:" $id

    $export | % {
        #echo "Mailbox" $id
        # Verificar se permissões padrões já existem e ignorá-las.
        if ($_.User -like "Anonymous" -or $_.User -like "Default" -or $_.User -like "GGS_CSC_AdminAgendas_RQR") {
            Write-Host -BackgroundColor Cyan -ForegroundColor DarkBlue $_.User "= PADRAO, NAO ALTERANDO"
            
            # Se usuário anonimo existir, força sua permissão para nenhum acesso
            if ($_.User -like "Anonymous") {
                Set-MailboxFolderPermission -Identity $id -User Anonymous -AccessRights None
            }
            
            if ($_.User -like "Default") {
                Set-MailboxFolderPermission -Identity $id -User Default -AccessRights AvailabilityOnly
            }

            if ($_.User -like "GGS_CSC_AdminAgendas_RQR") {
                Set-MailboxFolderPermission -Identity $id -User GGS_CSC_AdminAgendas_RQR@aviva.com.br -AccessRights Owner
            }

        } else { # Caso não seja padrão, remove todos os outros e força a inserção do grupo de administração e do usuario anonimo.
            Write-Host -BackgroundColor Magenta -ForegroundColor White "Removendo permissao de" $_.User "com a permissao" $_.AccessRights $_.SharingPermissionFlags
            $convert = $_.User
            
            Remove-MailboxFolderPermission -Identity $id -User $convert.ToString() -Confirm:$false #remove as permissoes dos demais usuarios            
        }

        Add-MailboxFolderPermission -Identity $id -User ggs_csc_adminagendas_rqr@aviva.com.br -AccessRights Owner #força grupo admin de agenda
        Add-MailboxFolderPermission -Identity $id -User Anonymous -AccessRights None #força permissao nula para anonimo

    } #*>> ".\agendas.log"
}#>