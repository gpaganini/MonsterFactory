$protheusCsv = ".\Protheus.csv"
$rmCsv = ".\RM.csv"

$protheusImport = Import-Csv -Path $protheusCsv -Delimiter ";" -Encoding UTF8 | select * -ExcludeProperty "COD_CARGO"
$rmImport = Import-Csv -Path $rmCsv -Delimiter ";"

$rqrAtv = $protheusImport | where {$_.SITUACAO -ne "Demitido"}
$cdsAtv = $rmImport | where {$_.SITUACAO -ne "Demitidos" -and $_.SITUACAO -ne "Aposentados por Invalidez"}

$rqrDtv = $protheusImport | where {$_.SITUACAO -eq "Demitido"} | sort CPF,DATA_DEMISSAO -Unique
$cdsDtv = $rmImport | where {$_.SITUACAO -eq "Demitidos" -or $_.SITUACAO -eq "Aposentados por Invalidez"} | sort CPF,DATA_DEMISSAO -Unique

$ativos = $null
$desativados = $null

$ativos += $rqrAtv
$ativos += $cdsAtv

$desativados += $rqrDtv
$desativados += $cdsDtv

$ativos.Count
$desativados.Count

foreach ($ativo in $ativos) {
    # code for update #    

    #check se tem registro de demissao
    $demitidoCheck = $desativados | where {$_.CPF -eq $ativo.CPF -and $_.SITUACAO -eq "Demitido"}
    
    if ($demitidoCheck) {
        "Encontrados {0} registros de demissao do empregado {1}, removendo das demissões" -f @($demitidoCheck).Count,$ativo.NOME

        $desativados = $desativados | where {$_.CPF -ne $ativo.CPF -and $_.SITUACAO -eq "Demitido"}
    }
}

$ativos.Count
$desativados.Count

foreach ($ativo in $ativos) {
    $notDemitido = $desativados | where {$_.CPF -eq $ativo.CPF -and $_.SITUACAO -eq "Demitidos" -or $_.SITUACAO -eq "Demitido" -or $_.SITUACAO -eq "Aposentados por Invalidez"}

    if ($notDemitido) {
        $desativados = $desativados | where {$_.CPF -ne $ativo.CPF -and $_.SITUACAO -eq "Demitidos" -or $_.SITUACAO -eq "Demitido" -or $_.SITUACAO -eq "Aposentados por Invalidez"}
    }
}




foreach ($desativado in $desativados) {
    #checa se está ativo
    $notDemitido = $ativos | where {$_.CPF -eq $desativado.CPF -and $_.SITUACAO -ne "Demitido" -or $_.SITUACAO -ne "Demitidos" -or $_.SITUACAO -ne "Aposentados por Invalidez"}

}


foreach ($desativado in $desativados) {
    $desativados = $desativados | Where-Object {$desativado.CPF -ne $ativos.}
}

$ativos.count
$desativados.count

$teste.count

$rmAtv.Count
$rmDtv.count



<#foreach ($active in $rqrAtv) {
    $dtv = $rqrDtv | where {$_.CPF -eq $active.CPF -and $_.SITUACAO -eq "Demitido"}
}#>