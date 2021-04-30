#Import MSOline Module
 import-module MSOnline
 #Import Exchange Online Module
 Import-Module ExchangeOnlineManagement


#Set admin UPN
$UPN = 'gpaganini@aviva.com.br'

#This connects to Azure Active Directory & Exchange Online
Connect-MsolService

$startDate = (Get-Date).AddDays(-30).ToString('MM/dd/yyyy')
$endDate = (Get-Date).ToString('MM/dd/yyyy')

$allUsers = @()
$allUsers = Get-MsolUser -All -EnabledFilter EnabledOnly | Select UserPrincipalName

$loggedOnUsers = @()
$loggedOnUsers = Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate -Operations UserLoggedIn, PasswordLogonInitialAuthUsingPassword, UserLoginFailed -ResultSize 5000

$inactiveInLastThreeMonthsUsers = @()
$inactiveInLastThreeMonthsUsers = $allUsers.UserPrincipalName | where {$loggedOnUsers.UserIds -NotContains $_}

Write-Output "The following users have no logged in for the last 90 days:"
Write-Output $inactiveInLastThreeMonthsUsers
$inactiveInLastThreeMonthsUsers.Count