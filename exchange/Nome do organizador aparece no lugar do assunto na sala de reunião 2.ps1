# Deve estar logado no Powershell remoto do Office 365

# Lista configura��es do calendario
Get-CalendarProcessing -Identity calendar@contoso.com | Format-List *

# Remove a configura��o que adicionar o nome do organizador no campo de assunto
Set-CalendarProcessing -Identity calendar@contoso.com -AddOrganizerToSubject $false

# Remove a configura��o que deleta o assunto
Set-CalendarProcessing -Identity calendar@contoso.com -DeleteSubject $False

