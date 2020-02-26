$CSV = "lit.csv" #caminho do arquivo csv que possui os UserPrincipalNames dos usuarios
$arquivo = Import-CSV $CSV 


$arquivo | foreach {
	get-mailbox -identity $_.upn | select name, litigationholdenabled
}