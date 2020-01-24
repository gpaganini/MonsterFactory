# Specify target OU. 
  $TargetOU = "OU=Deletar,OU=Desabilitados,DC=rqr,DC=com,DC=br" 
   
 # Read user sAMAccountNames from csv file (field labeled "Name"). 
  Import-Csv -Path "C:\Users\gustavo.loge\OneDrive - COMPANHIA THERMAS DO RIO QUENTE\Documentos\Scripts\usernamecomdominio.csv" | ForEach-Object { 
      # Retrieve DN of User. 
      $UserDN = (Get-ADUser -Identity $_.Name).distinguishedName 
   
     # Move user to target OU. 
      Move-ADObject -Identity $UserDN -TargetPath $TargetOU 
  } 