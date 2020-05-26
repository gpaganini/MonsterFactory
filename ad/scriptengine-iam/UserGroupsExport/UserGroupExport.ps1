Import-Module ActiveDirectory

$path = ".\"

$folderDate = get-date -f dd-MM-yyyy
$logDate = Get-Date -F "dd-MM-yyyy hh:mm:ss"

$rqrFolder = $path + "AD_RQR_$folderDate"
$saoFolder = $path + "AD_SAO_$folderDate"
$cdsFolder = $path + "AD_CDS_$folderDate"

Function GetRqrGroupMembership {
    md $rqrFolder

    echo "$(get-date) Pasta $($rqrFolder) criada" >> "$($path)\executionlog.log"

    echo "$(get-date) Carregando usuarios para a variavel" >> "$($path)\executionlog.log"
    $adRqrUsers = Get-ADUser -Filter * -Properties * -SearchBase "OU=Unidade Rio Quente,DC=aviva,DC=com,DC=br" -SearchScope Subtree | select Name, SamAccountName | ` 
        Where-Object {$_.DistinguishedName -notcontains "OU=Usuarios Servico - Exchange,OU=Unidade Rio Quente,DC=aviva,DC=com,DC=br" -and ` 
            $_.DistinguishedName -notcontains "OU=Usuarios Terceiros,OU=Unidade Rio Quente,DC=aviva,DC=com,DC=br"}
    echo "$(get-date) Variável carregada" >> "$($path)\executionlog.log"


    echo "$(get-date) Criando arquivos" >> "$($path)\executionlog.log"
    foreach ($adUser in $adRqrUsers) {
        echo "========== USUARIO $($adUser.name) ==========" >> "$rqrFolder\$($adUser.samaccountname).txt"
        echo "========== REGISTRO EM $($logDate) ==========" >> "$rqrFolder\$($adUser.samaccountname).txt"
        echo "" >> "$rqrFolder\$($adUser.samaccountname).txt"
        echo "========== GRUPOS DO USUARIO ==========" >> "$rqrFolder\$($adUser.samaccountname).txt"

        Get-ADPrincipalGroupMembership -Identity $adUser.samaccountname | Sort-Object | select name,samaccountname >> "$rqrFolder\$($adUser.samaccountname).txt"

        echo "========== FIM DO REGISTRO ===========" >> "$rqrFolder\$($adUser.samaccountname).txt"
    }
    echo "$(get-date) Arquivos criados" >> "$($path)\executionlog.log"
    echo "$(get-date) Script finalizado." >> "$($path)\executionlog.log"
}

Function GetSaoGroupMembership {
    md $saoFolder

    echo "$(get-date) Pasta $($saoFolder) criada" >> "$($path)\executionlog.log"

    echo "$(get-date) Carregando usuarios para a variavel" >> "$($path)\executionlog.log"

    $adSaoUsers = Get-ADUser -Filter * -Properties * -SearchBase "OU=Unidade Sao Paulo,DC=aviva,DC=com,DC=br" -SearchScope Subtree | select Name, SamAccountName
    
    echo "$(get-date) Variável carregada" >> "$($path)\executionlog.log"


    echo "$(get-date) Criando arquivos" >> "$($path)\executionlog.log"

    foreach ($adUser in $adSaoUsers) {
        echo "========== USUARIO $($adUser.name) ==========" >> "$saoFolder\$($adUser.samaccountname).txt"
        echo "========== REGISTRO EM $($logDate) ==========" >> "$saoFolder\$($adUser.samaccountname).txt"
        echo "" >> "$saoFolder\$($adUser.samaccountname).txt"
        echo "========== GRUPOS DO USUARIO ==========" >> "$saoFolder\$($adUser.samaccountname).txt"

        Get-ADPrincipalGroupMembership -Identity $adUser.samaccountname | Sort-Object | select name,samaccountname >> "$saoFolder\$($adUser.samaccountname).txt"

        echo "========== FIM DO REGISTRO ===========" >> "$saoFolder\$($adUser.samaccountname).txt"
    }
    echo "$(get-date) Arquivos criados" >> "$($path)\executionlog.log"
    echo "$(get-date) Script finalizado." >> "$($path)\executionlog.log"
}

Function GetCdsGroupMembership {
    md $cdsFolder

    echo "$(get-date) Pasta $($cdsFolder) criada" >> "$($path)\executionlog.log"

    echo "$(get-date) Carregando usuarios para a variavel" >> "$($path)\executionlog.log"

    $adCdsUsers = Get-ADUser -Filter * -Properties * -SearchBase "OU=Unidade Costa do Sauipe,DC=aviva,DC=com,DC=br" -SearchScope Subtree | select Name, SamAccountName
    
    echo "$(get-date) Variável carregada" >> "$($path)\executionlog.log"


    echo "$(get-date) Criando arquivos" >> "$($path)\executionlog.log"

    foreach ($adUser in $adCdsUsers) {
        echo "========== USUARIO $($adUser.name) ==========" >> "$cdsFolder\$($adUser.samaccountname).txt"
        echo "========== REGISTRO EM $($logDate) ==========" >> "$cdsFolder\$($adUser.samaccountname).txt"
        echo "" >> "$cdsFolder\$($adUser.samaccountname).txt"
        echo "========== GRUPOS DO USUARIO ==========" >> "$cdsFolder\$($adUser.samaccountname).txt"

        Get-ADPrincipalGroupMembership -Identity $adUser.samaccountname | Sort-Object | select name,samaccountname >> "$cdsFolder\$($adUser.samaccountname).txt"

        echo "========== FIM DO REGISTRO ===========" >> "$cdsFolder\$($adUser.samaccountname).txt"
    }
    echo "$(get-date) Arquivos criados" >> "$($path)\executionlog.log"
    echo "$(get-date) Script finalizado." >> "$($path)\executionlog.log"
}

GetRqrGroupMembership
GetSaoGroupMembership
GetCdsGroupMembership


<#

if (!($folder | test-path)) {
    write-host "Diretório já existe"
} else {
    md $folder
}


$adUsers = Get-ADUser -Filter * -SearchBase "OU=Usuarios,OU=TI,OU=Unidade Rio Quente,DC=aviva,DC=com,DC=br" -Properties * | select samaccountname,name

foreach ($adUser in $adUsers) {
    echo "========== USUARIO $($adUser.name) ==========" >> "$folder\$($adUser.samaccountname).txt"
    echo "========== REGISTRO EM $($logDate) ==========" >> "$folder\$($adUser.samaccountname).txt"

    echo "========== GRUPOS DO USUARIO ==========" >> "$folder\$($adUser.samaccountname).txt"

    Get-ADPrincipalGroupMembership -Identity $adUser.samaccountname | Sort-Object | select name,samaccountname >> "$folder\$($adUser.samaccountname).txt"

    echo "========== FIM DO REGISTRO ===========" >> "$folder\$($adUser.samaccountname).txt"
}

$adRqrUsers = Get-ADUser -Filter * -Properties * -SearchBase "OU=Unidade Rio Quente,DC=aviva,DC=com,DC=br" -SearchScope Subtree | select Name, SamAccountName | ` 
Where-Object {$_.DistinguishedName -notcontains "OU=Usuarios Servico - Exchange,OU=Unidade Rio Quente,DC=aviva,DC=com,DC=br" -and ` 
        $_.DistinguishedName -notcontains "OU=Usuarios Terceiros,OU=Unidade Rio Quente,DC=aviva,DC=com,DC=br"}

#>