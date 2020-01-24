$CSV = "E5toE5.csv" #caminho do arquivo csv que possui os UserPrincipalNames dos usuarios
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

function verificaLicenca{

	$i = 0

	$arquivo | ForEach {
		$msolUser = (Get-MsolUser -UserPrincipalName $_.upn)
		$isLicensed = $msolUser.isLicensed #verifica se o usuario esta licenciado
		
		if($isLicensed){
			Write-Host "Tem licenca" -ForegroundColor Green
		} else {
			Write-Host "$_.upn nao possui licenca"
		}				
		
		$i++
		Write-Progress -Activity "Verificando licencas . . ." -Status "Verificado: $i of $($arquivo.Count)" -PercentComplete ($i/$arquivo.Count*100)
	}
}

conectaO365
verificaLicenca