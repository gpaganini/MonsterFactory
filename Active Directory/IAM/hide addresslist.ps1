Import-Module ActiveDirectory

$disabledUsers = get-aduser -Filter * -SearchBase "OU=Contas Desabilitadas,OU=Automacao - Autoseg,DC=aviva,DC=com,DC=br"

$disabledUsers.Count

foreach ($mailbox in $disabledUsers) {
    $mbx = (Get-RemoteMailbox -Identity $mailbox.SamAccountName)
    $isHidden = $mbx.HiddenFromAddressListsEnabled

    if ($isHidden -eq $true) {
        write-host "Mailbox de $($mbx.UserPrincipalName) ja esta oculta" -BackgroundColor Yellow
    } else {
        #write-host "Ocultando mailbox de $($mbx.UserPrincipalName)" -BackgroundColor Cyan
        Set-RemoteMailbox -Identity $mbx.UserPrincipalName -HiddenFromAddressListsEnabled $true
        if (!$?) {
            Write-Host "Erro ao ocultar mailbox de $($mailbox.SamAccountName)" -BackgroundColor Red -ForegroundColor White
        } else {
            write-host "Mailbox de $($mbx.UserPrincipalName) ocultada com sucesso" -BackgroundColor Green
        }
    }
}