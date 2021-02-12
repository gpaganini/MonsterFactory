$csv = "C:\Users\giovani.paganini\powershellson\ad\scriptengine-iam\Protheus.csv"
$arquivo = Import-Csv -Path $csv -Encoding UTF8 -Delimiter ";"

$demitidos = $arquivo | where {$_.SITUACAO -eq "Demitido"}
$ativos = $arquivo | where {$_.SITUACAO -ne "Demitido"}

foreach ($ativo in $ativos) {
    # code for update #    

    #check se tem registro de demissao
    $demitidoCheck = $demitidos | where {$_.CPF -eq $ativo.CPF -and $_.SITUACAO -eq "Demitido"}
    
    if ($demitidoCheck) {
        "Encontrados {0} registros de demissao do empregado {1}, removendo das demissões" -f @($demitidoCheck).Count,$ativo.NOME

        $demitidos = $demitidos | where {$_.CPF -ne $ativo.CPF -and $_.SITUACAO -eq "Demitido"}
    }
}

if ($demitidos) {
    foreach ($demitido in $demitidos) {
        "Processando {0} para {1}" -f $demitido.SITUACAO,$demitido.CPF
    }
} else {
    "Nenhuma demissão para processar"
}

$termCheck = $demissoes | where {$_.CPF -eq $updates.CPF -and $_.SITUACAO -eq "Demitido"}

foreach ($update in $updates) {
    $demissaoCheck = $demissoes | where {$_.CPF -eq $update.CPF -and $_.SITUACAO -eq "Demitido"}
    if ($demissaoCheck) {
        "found {0} terminate request employee {1}, removing from terminations" -f @($demissaoCheck).Count,$update.CPF

        #$demissoes = $demissoes | where {$_.CPF -ne $update.CPF -and $_.SITUACAO -eq "Demitido"}
    }
}

if ($demissoes) {
    foreach ($demissao in $demissoes) {
        "Processing {0} of {1}" -f $demissao.SITUACAO, $demissao.CPF
        "Realizando demissão de {0}" -f $demissao.CPF
    }
} else {
    "No terminations to process"
}

function getUsuario($cpf) {
    get-aduser -Filter * | select samaccountname | where {$_.extensionAttribute1 -like $cpf}
}

getUsuario("09154321964")