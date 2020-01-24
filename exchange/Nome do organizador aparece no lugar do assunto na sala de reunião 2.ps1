# Deve estar logado no Powershell remoto do Office 365

# Lista configurações do calendario
Get-CalendarProcessing -Identity calendar@contoso.com | Format-List *

# Remove a configuração que adicionar o nome do organizador no campo de assunto
Set-CalendarProcessing -Identity calendar@contoso.com -AddOrganizerToSubject $false

# Remove a configuração que deleta o assunto
Set-CalendarProcessing -Identity calendar@contoso.com -DeleteSubject $False

