$csv = "C:\temp\teste.csv"
$arquivo = Import-Csv $csv

$arquivo.foreach({
    $oldName = Get-ADUser -Identity $_.user -Properties DisplayName | select DisplayName
    Set-ADUser -Identity $_.user -DisplayName ("LAYOFF - " + $oldName.DisplayName)
    Disable-ADAccount -Identity $_.user
})