<# 
	.Synopsis
	.Description
	.Example
	
	.Notes
	NOME: MigrateLicenceType
	AUTHOR: Giovani Paganini
	CREATIONDATE: 24 January 2020
	LASTEDIT: 24 January 2020
	VERSION: 1.1
	
	Change Log
	v1.0, 24/01/2020 - Initial Version
	
#>









$CSV = ".\MigrationDone\E3toE3.csv" #caminho do arquivo csv que possui os UserPrincipalNames dos usuarios
$arquivo = Import-CSV $CSV 

$Visio = "grq:VISIOCLIENT"
$Stream = "grq:STREAM"
$E5 = "grq:ENTERPRISEPREMIUM"
$WindowsStore = "grq:WINDOWS_STORE"
$E3 = "grq:ENTERPRISEPACK"
$FlowFree = "grq:FLOW_FREE"
$BusinessCenter = "grq:MICROSOFT_BUSINESS_CENTER"
$Powerapps = "grq:POWERAPPS_VIRAL"
$BusinessPremium = "grq:O365_BUSINESS_PREMIUM"
$PowerBi = "grq:POWER_BI_STANDARD"
$EnterpriseMobility = "grq:EMS"
$BusinessEssentials = "grq:O365_BUSINESS_ESSENTIALS"
$Project = "grq:PROJECTPROFESSIONAL"
$Teams = "grq:TEAMS_COMMERCIAL_TRIAL"
$ATP = "grq:ATP_ENTERPRISE"
$E1 = "grq:STANDARDPACK"

$log = "migrate.log"

function credO365 {
    $usuario = 'gpaganini@aviva.com.br'
    $senha = Get-Content '.\trustyPassword.txt'

    $secureSenha = $senha | ConvertTo-SecureString

    $userCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $usuario, $secureSenha

    return $userCredential
	
	Write-Host "Credenciais O365 OK" -ForegroundColor Green
}

function conectaO365 {
    Connect-MsolService -Credential (credO365)	
	Write-Host "Conectado no Office 365" -ForegroundColor Green
}

<#function removeLicenca {
	$i = 0	
	
	$arquivo | ForEach {
		$msolUser = (Get-MsolUser -UserPrincipalName $_.upn)
		$isLicensed = $msolUser.isLicensed #verifica se o usuario esta licenciado
		
		if($isLicensed){
			$license = $msolUser.Licenses | Select -ExpandProperty AccountSkuId #se esta licenciado pega todas as licencas do usuario e as remove
			Set-MsolUserLicense -UserPrincipalName $_.upn -RemoveLicenses $license
			
			if(!$?){
				Write-Host "Erro removendo licencaa do $_.upn" -ForegroundColor Red 
			} else {
				Write-host "Removido $license de $_.upn" -ForegroundColor Green 
			}
		} else {
            Write-Host "Usuario $_.upn.UPN nao possui licenca" -ForegroundColor Yellow 
        }
		
		$i++
		Write-Progress -Activity "Removendo licencas . . ." -Status "Removido: $i of $($arquivo.Count)" -PercentComplete ($i/$arquivo.Count*100)
	}		
}#>

<#function atribuiLicenca {	
	$i = 0
	
	$arquivo | ForEach {
		$msolUser = (Get-MsolUser -UserPrincipalName $_.upn)
		#$licenseOptions = New-MsolLicenseOptions -AccountSkuId $E1 -DisabledPlans $null
		Set-MsolUserLicense -UserPrincipalName $_.upn -AddLicense $BusinessEssentials
		
		if(!$?) {
			Write-Host "Erro adicionando licenca ao $_.upn" -ForegroundColor Red 
		} else {		
			Write-host "Adicionado licenca ao $_.upn" -ForegroundColor Green 
		}
		
		Write-Progress -Activity "Adicionando licencas . . ." -Status "Licenciado: $i of $($arquivo.Count)" -PercentComplete ($i/$arquivo.Count*100)
	}	
} #>

# IN PROGRESS
function migraLicenca {
	$i = 0
	
	$arquivo | ForEach {
		$msolUser = (Get-MsolUser -UserPrincipalName $_.upn)
		$isLicensed = $msolUser.isLicensed #verifica se o usuario esta licenciado
		
		if($isLicensed){
			$license = $msolUser.Licenses | Select -ExpandProperty AccountSkuId #se esta licenciado pega todas as licencas do usuario e as remove
			Set-MsolUserLicense -UserPrincipalName $_.upn -RemoveLicenses $license
			Set-MsolUserLicense -UserPrincipalName $_.upn -AddLicenses $E3
			
			if(!$?){
				Write-Host "Erro migrando licenca do $_.upn" -ForegroundColor Red 
			} else {
				Write-host "Licenca migrada com sucesso de $_.upn" -ForegroundColor Green				
			}
		} else {
            Write-Host "Usuario $_.upn.UPN nao possui licenca... Atribuindo" -ForegroundColor Yellow
			#Set-MsolUserLicense -UserPrincipalName $_.upn -AddLicenses $E5
        }		
		
		$i++
		Write-Progress -Activity "Migrando licencas . . ." -Status "Migrado: $i of $($arquivo.Count)" -PercentComplete ($i/$arquivo.Count*100)
	}
}
#>

conectaO365 2>> $log
migraLicenca 2>> $log

#v1.1 Atualizado para um unico script de migração
#v1.0.3 adicionado barra de progresso
#v1.0.2 removido logging do write-host uma vez que estava falhando
#v1.0.1 corrigido metodo de atribuicao de licenca, adicionado logging
#v1.0 @gpaganini