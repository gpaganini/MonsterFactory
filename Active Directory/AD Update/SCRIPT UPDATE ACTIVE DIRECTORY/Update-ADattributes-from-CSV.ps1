#-----------------------------------------------------------------------------------------------
# Script created by Chris Steding 
#
# This script will update AD attributes for users imported from csv file
#
# csv file format:
# SamAccountName,Title,MobilePhone,OfficePhone,city,EmailAddress,Department,Office
#
# Remember to edit the -SearchBase to the correct domain name. 
#-----------------------------------------------------------------------------------------------

# Import AD Module             
Import-Module ActiveDirectory            

write-Host 'Starting to update AD Attributes.......' -NoNewline -ForegroundColor Yellow            
# Import CSV into variable $users           
      
$users = Import-Csv -Path C:\Intel\adusersteste.csv          
# Loop through CSV and update users if the exist in CVS file            
            
foreach ($user in $users) {            
#Search in specified OU and Update existing attributes            
 Get-ADUser -Filter "SamAccountName -eq '$($user.samaccountname)'" -Properties * |            
  Set-ADUser -company $($user.company) -givenName $($user.givenName) -surname $($user.surname) -DisplayName $($user.DisplayName) -Office $($user.Office) -OfficePhone $($user.OfficePhone) -EmailAddress $($user.EmailAddress) -streetAddress $($user.streetAddress) -city $($user.city) -state $($user.state) -postalcode $($user.postalcode) -title $($user.title) -department $($user.department) -description $($user.description) -manager $($user.manager) -replace @{IPphone = "$($user.ipphone)"; mailnickname = "$($user.mailnickname)"}
}

Write-Host 'done!' -ForegroundColor Green