	<# 
		.Synopsis
         Deleta arquivos mais antigos que 7 dias da pasta escolhida.
		.Description
         Deleta arquivos mais antigos que 7 dias da pasta escolhida.
		.Example
		.\Delete-OldFiles.ps1
		.Notes
		NAME: Delete-OldFiles.ps1
		AUTHOR: Giovani Paganini
		CREATIONDATE: 15 September 2023
		LASTEDIT: 15 September 2023
		VERSION: 1.0
		
		Change Log		
		v1.0, 01/03/2023 - Initial Version.
	#>

#BEGIN

#PARAMETERS
$Path = "D:\Unidade - Rio Quente Resorts\Publico"
$Days = "7"
$CutoffDate = (Get-Date).AddDays(-$Days)
$CutoffDate

#EXECUTE
Get-ChildItem -Path $Path -Recurse -File | `
Where-Object {$_.LastWriteTime -lt $CutoffDate} | `Remove-Item -Force -Verbose >> C:\Scripts\Delete-OldFiles.log#REMOVE EMPTY FOLDERSGet-ChildItem -Path $Path -Force -Recurse -Directory |
    Where-Object { (Get-ChildItem -Path $_.FullName -Recurse -File -EA SilentlyContinue | 
        Measure-Object).Count -eq 0 } | Remove-Item -Force -Recurse

#EOF