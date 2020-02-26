$CSV = ".\computadores.csv" #caminho do arquivo csv que possui os UserPrincipalNames dos usuarios
$arquivo = Import-CSV $CSV 

$arquivo | foreach {
	psexec \\"$_.computer" -s cmd.exe
	\\srvrqescm01\apps\cyf\CYF-Installer\SetupWin7.bat
}