#################################################################
# This script will help to move bulk ad computer accounts into target OU
# Written 08/08/15 Casey, Dedeal
# Fell free to change use any part of this script
# http://www.smtp25.blogspot.com/
#################################################################

#Importing AD Module
Write-Host " Importing AD Module..... "
import-module ActiveDirectory
Write-Host " Importing Move List..... "
# Reading list of computers from csv and loading into variable
$MoveList = Import-Csv -Path ".\ousiterqe.csv"
# defining Target Path
$TargetOU = 'OU=SCCM_OSD,DC=rqr,DC=com,DC=br' 
$countPC    = ($movelist).count
Write-Host " Starting import computers ..."

foreach ($Computer in $MoveList){    
    Write-Host " Moving Computer Accounts..." 
    Get-ADComputer $Computer.CN | Move-ADObject -TargetPath $TargetOU
}

Write-Host " Completed Move List "

Write-Host " $countPC  Computers has been moved "