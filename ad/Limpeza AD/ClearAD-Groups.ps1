$csv = "C:\Users\giovani.paganini\powershellson\ad\Limpeza AD\Grupos FS CDS Antigo - Lote 01.csv"
$arquivo = Import-Csv -Path $csv -Encoding UTF8

foreach ($grupo in $arquivo) {
    Get-ADGroupMember -Identity $grupo.Grupo | Remove-ADPrincipalGroupMembership -MemberOf $grupo.Grupo -Confirm:$false
}