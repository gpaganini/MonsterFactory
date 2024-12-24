Import-Module ActiveDirectory

$rqe = Import-Csv -Path "C:\Users\giovani.paganini\powershellson\ad\scriptengine-iam\Update Usuarios\Usuarios Rio Quente.csv" -Delimiter ";" -Encoding UTF8
$sao = import-csv -Path "C:\Users\giovani.paganini\powershellson\ad\scriptengine-iam\Update Usuarios\Usuarios Sao Paulo.csv" -Delimiter ";" -Encoding UTF8
$cds = import-csv -Path "C:\Users\giovani.paganini\powershellson\ad\scriptengine-iam\Update Usuarios\Usuarios Sauipe.csv" -Delimiter ";" -Encoding UTF8
$cnv = import-csv -Path "C:\Users\giovani.paganini\powershellson\ad\scriptengine-iam\Update Usuarios\Usuarios Caldas.csv" -Delimiter ";" -Encoding UTF8


foreach ($rquser in $rqe) {
    Add-ADGroupMember -Identity "Associados Rio Quente" -Members $rquser.Usuario -Confirm:$false
    Add-ADGroupMember -Identity "Associados Rio Quente Geral" -Members $rquser.Usuario -Confirm:$false
    Remove-ADGroupMember -Identity "Associados Sao Paulo" -Members $rquser.Usuario -Confirm:$false
    Remove-ADGroupMember -Identity "Associados Sauipe" -Members $rquser.Usuario -Confirm:$false
    Remove-ADGroupMember -Identity "Associados Caldas Novas" -Members $rquser.Usuario -Confirm:$false
}

foreach ($spuser in $sao) {
    Add-ADGroupMember -Identity "Associados Rio Quente Geral" -Members $spuser.Usuario -Confirm:$false
    Add-ADGroupMember -Identity "Associados Sao Paulo" -Members $spuser.Usuario -Confirm:$false
    Remove-ADGroupMember -Identity "Associados Sauipe" -Members $spuser.Usuario -Confirm:$false
    Remove-ADGroupMember -Identity "Associados Caldas Novas" -Members $spuser.Usuario -Confirm:$false
    Remove-ADGroupMember -Identity "Associados Rio Quente" -Members $spuser.Usuario -Confirm:$false

}

foreach ($bauser in $cds) {
    Add-ADGroupMember -Identity "Associados Rio Quente Geral" -Members $bauser.Usuario -Confirm:$false
    Add-ADGroupMember -Identity "Associados Sauipe" -Members $bauser.Usuario -Confirm:$false
    Remove-ADGroupMember -Identity "Associados Caldas Novas" -Members $bauser.Usuario -Confirm:$false
    Remove-ADGroupMember -Identity "Associados Rio Quente" -Members $bauser.Usuario -Confirm:$false
    Remove-ADGroupMember -Identity "Associados Sao Paulo" -Members $bauser.Usuario -Confirm:$false
}

foreach ($cnuser in $cnv) {
    Add-ADGroupMember -Identity "Associados Rio Quente Geral" -Members $rquser.Usuario -Confirm:$false
    Add-ADGroupMember -Identity "Associados Caldas Novas" -Members $cnuser.Usuario -Confirm:$false
    Remove-ADGroupMember -Identity "Associados Rio Quente" -Members $cnuser.Usuario -Confirm:$false
    Remove-ADGroupMember -Identity "Associados Sao Paulo" -Members $cnuser.Usuario -Confirm:$false
    Remove-ADGroupMember -Identity "Associados Sauipe" -Members $cnuser.Usuario -Confirm:$false
}