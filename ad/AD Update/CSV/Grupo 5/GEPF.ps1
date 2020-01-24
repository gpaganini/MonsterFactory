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
      
$users = Import-Csv -Path C:\Users\gustavo.loge\OneDrive - COMPANHIA THERMAS DO RIO QUENTE\Documentos\Scripts\AD Update\CSV\Grupo 5\GEPF.csv
# Loop through CSV and update users if the exist in CVS file            
            
foreach ($user in $users) {            
#Search in specified OU and Update existing attributes            
 Get-ADUser -Filter "SamAccountName -eq '$($user.samaccountname)'" -Properties * |            
  Set-ADUser -company $($user.company) -DisplayName $($user.DisplayName) -Office $($user.Office) -OfficePhone $($user.OfficePhone) -EmailAddress $($user.EmailAddress) -city $($user.city) -title $($user.title) -department $($user.department) -replace @{IPphone = "$($user.ipphone)"; mailnickname = "$($user.mailnickname)"}
}

Write-Host 'done!' -ForegroundColor Green