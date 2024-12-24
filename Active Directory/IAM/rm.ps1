import-module activedirectory

$csv = ""
$arquivo = import-csv -path $csv -delimiter ";"

foreach ($user in $arquivo) {
    
}