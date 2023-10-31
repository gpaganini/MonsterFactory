	<# 
		.Synopsis
         Atualizador de releases do MultiClubes/MultiVendas para o ambiente de RDS
		.Description
         Atualiza as releases a partir da última versão disponibilizada no servidor de produção.
		.Example
		.\Update-MultiReleases.ps1
		.Notes
		NAME: Update-MultiReleases.ps1
		AUTHOR: Giovani Paganini
		CREATIONDATE: 01 March 2023
		LASTEDIT: 01 March 2022
		VERSION: 1.0
		
		Change Log		
		v1.0, 01/03/2023 - Initial Version.
	#>

#BEGIN

# Delete old folders if exists
If (Test-Path -Path 'C:\Aviva\MultiClubes_App.bak') {
    Remove-Item 'C:\Aviva\MultiClubes_App.bak' -Recurse
}

# Delete old folders if exists
If (Test-Path -Path 'C:\Aviva\MultiVendas_App.bak') {
    Remove-Item 'C:\Aviva\MultiVendas_App.bak' -Recurse
}

# Delete old folders if exists
If (Test-Path -Path 'C:\Aviva\Multiclubes_Access_Monitor\AccessMonitor.bak') {
    Remove-Item 'C:\Aviva\Multiclubes_Access_Monitor\AccessMonitor.bak' -Recurse
}

# Backup folders of the current version
Rename-Item C:\Aviva\MultiClubes_App C:\Aviva\MultiClubes_App.bak
Rename-Item C:\Aviva\MultiVendas_App C:\Aviva\MultiVendas_App.bak
Rename-Item C:\Aviva\Multiclubes_Access_Monitor\AccessMonitor C:\Aviva\Multiclubes_Access_Monitor\AccessMonitor.bak

# Download new version
ROBOCOPY \\srvrqe941059\MultiClubesReleases$\MultiVendas\MultiVendas C:\Aviva\MultiVendas_App /E /DCOPY:DAT
ROBOCOPY \\srvrqe941059\MultiClubesReleases$\MultiClubes\MultiClubes C:\Aviva\MultiClubes_App /E /DCOPY:DAT
ROBOCOPY \\srvrqe941059\MultiClubesReleases$\MultiClubes\AccessMonitor C:\Aviva\Multiclubes_Access_Monitor\AccessMonitor /E /DCOPY:DAT

#EOF