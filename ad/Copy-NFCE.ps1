	<# 
		.Synopsis
         Replica a pasta NFCE para o destino indicado.
		.Description
         Replica a pasta NFCE para o destino indicado usando o Robocopy de forma periódica através de Task Scheduler, para atender o chamado I2206-2452.
		.Example
		.\Copy-NFCE.ps1
		.Notes
		NAME: Copy-NFCE.ps1
		AUTHOR: Giovani Paganini
		CREATIONDATE: 15 September 2023
		LASTEDIT: 20 September 2023
		VERSION: 1.0
		
		Change Log		
		v1.0, 20/09/2023 - Comments edited, no changes made to script.
		v1.0, 15/09/2023 - Initial Version.
	#>

#BEGIN
Robocopy "C:\Triade\MultiVendas\Service\MultiVendas.Services\NFC-e\" "E:\BackupXML" /MIR /LOG:C:\temp\CopyNFCE.log

#EOF