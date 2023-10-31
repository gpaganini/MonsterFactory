	<# 
		.Synopsis
         Detecta e atualiza o 7z Instalado na máquina.
		.Description
         Detecta e atualiza o 7z Instalado na máquina.
		.Example
		.\Update-7z.ps1
		.Notes
		NAME: Update-7z.ps1
		AUTHOR: Giovani Paganini
		CREATIONDATE: 03 October 2023
		LASTEDIT: 03 October 2023
		VERSION: 1.0
		
		Change Log
		v1.0, 03/10/2023 - Initial Version.
	#>

#Vars
$7zpath = 'C:\Program Files\7-Zip\7z.exe'
$7zversion = (Get-Item -Path $7zpath).VersionInfo.FileVersion

If ([Environment]::Is64BitProcess -eq $true) {
    If (Test-Path -Path 'C:\Program Files\7-Zip') {
        if ($7zversion -le '23.00') {
            echo "Update version"
            Start-Process msiexec.exe -Wait -ArgumentList '/I "\\aviva.com.br\NETLOGON\7z\7z.msi" /qn /norestart'
        } else {
            echo "Already latest version."
            exit 0
        }
    } else {
        echo "Not installed. Will not install!"
        exit 0
    }
}