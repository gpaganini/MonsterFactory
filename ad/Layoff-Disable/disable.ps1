Import-Module ActiveDirectory

$csv = "C:\Users\giovani.paganini\powershellson\ad\Layoff-Disable\office365-correct.csv"
$arquivo = Import-Csv -Path $csv -Delimiter ";"

$i = 0

<#foreach($user in $arquivo) {
    Get-MsolUser -UserPrincipalName $user.'User principal name' | select DisplayName
}#>

foreach ($user in $arquivo) {
    $oldname = Get-MsolUser -UserPrincipalName $user.'User principal name' | select DisplayName
    if ($oldname.DisplayName -like "*AUSENTE*") {
        $newName = $oldname.DisplayName -replace ("AUSENTE ","")        
        Set-MsolUser -UserPrincipalName $user.'User principal name' -DisplayName $newName
        $oldname.DisplayName = $newName
    }

    if ($oldname.DisplayName -like "*AFASTADO*") {
        $newName = $oldname.DisplayName -replace ("AFASTADO - ","")
        Set-MsolUser -UserPrincipalName $user.'User principal name' -DisplayName $newName
        $oldname.DisplayName = $newName
    }

    if ($oldname.DisplayName -like "*FERIAS*") {        
        $newName = $oldname.DisplayName -replace ("FERIAS - ","")        
        Set-MsolUser -UserPrincipalName $user.'User principal name' -DisplayName $newName
        $oldname.DisplayName = $newName
    }

    if ($oldname.DisplayName -like "*DESATIVADO*"){        
        $newName = $oldname.DisplayName -replace ("DESATIVADO - ","")        
        Set-MsolUser -UserPrincipalName $user.'User principal name' -DisplayName $newName
        $oldname.DisplayName = $newName
    }

    if ($oldname.DisplayName -like "*DESATIVADO*"){        
        $newName = $oldname.DisplayName -replace ("DESATIVADO- ","")        
        Set-MsolUser -UserPrincipalName $user.'User principal name' -DisplayName $newName
        $oldname.DisplayName = $newName
    }

    if ($oldname.DisplayName -like "*DESATIVADO*"){        
        $newName = $oldname.DisplayName -replace ("DESATIVADO-","")        
        Set-MsolUser -UserPrincipalName $user.'User principal name' -DisplayName $newName
        $oldname.DisplayName = $newName
    }

    if ($oldname.DisplayName -like "*DESATIVADO*"){        
        $newName = $oldname.DisplayName -replace ("DESATIVADO -","")        
        Set-MsolUser -UserPrincipalName $user.'User principal name' -DisplayName $newName
        $oldname.DisplayName = $newName
    }

    if ($oldname.DisplayName -like "*DESATIVADO*"){        
        $newName = $oldname.DisplayName -replace ("DESATIVADO ","")        
        Set-MsolUser -UserPrincipalName $user.'User principal name' -DisplayName $newName
        $oldname.DisplayName = $newName
    }

    if ($oldname.DisplayName -like "*DESATIVADO*"){        
        $newName = $oldname.DisplayName -replace (" - DESATIVADO","")        
        Set-MsolUser -UserPrincipalName $user.'User principal name' -DisplayName $newName
        $oldname.DisplayName = $newName
    }

    Set-MsolUser -UserPrincipalName $user.'User principal name' -BlockCredential $true

    $oldname

    $i++

    Write-Progress -Activity "Desativando usuarios..." `
    -Status "Desativado $i de $($arquivo.Count)" `
    -PercentComplete ($i/$arquivo.Count*100)
}
    <#if ($user.'Status Folha' -like "Demitido*") {
        $newName = "DESATIVADO - " + $oldname.DisplayName
        Set-ADUser -Identity $user.usuario -DisplayName $newName
        $oldname.DisplayName = $newName
        Disable-ADAccount -Identity $user.Usuario
    }#>

    #Set-ADUser -Identity $user.usuario -Replace @{'ipPhone'=$user.MAT}

    #Disable-ADAccount -Identity $user.Usuario