Import-Module ActiveDirectory

$csv = '.\DuplicateUsers-Delete2.csv'

$arquivo = Import-Csv $csv

$arquivo | foreach {
    Remove-ADUser -Identity $_.user -Confirm:$false
}