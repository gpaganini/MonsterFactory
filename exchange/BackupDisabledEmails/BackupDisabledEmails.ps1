$CSV = "C:\Users\giovani.paganini\powershellson\exchange\BackupDisabledEmails\desabilitados_12022021.csv" #caminho do arquivo csv que possui os UserPrincipalNames dos usuarios
$arquivo = Import-CSV $CSV -Delimiter ";"

function credO365 {
    $usuario = 'gpaganini@aviva.com.br'
    $senha = Get-Content 'C:\Users\giovani.paganini\powershellson\exchange\BackupDisabledEmails\o365pass.txt'

    $secureSenha = $senha | ConvertTo-SecureString

    $userCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $usuario, $secureSenha

    return $userCredential
	
	Write-Host "Credenciais O365 OK" -ForegroundColor Green
}

function credExchOnprem {
    $usuario = 'aviva\adm.giovani'
    $senha = Get-Content 'C:\Users\giovani.paganini\powershellson\exchange\BackupDisabledEmails\onprempass.txt'

    $secureSenha = $senha | ConvertTo-SecureString

    $userCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $usuario, $secureSenha

    return $userCredential
	
	Write-Host "Credenciais Exchange OnPremise OK" -ForegroundColor Green
}

function conectaExchOnline {
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential (credO365) -Authentication Basic -AllowRedirection
	Import-PSSession $Session
	
	Write-Host "Conectado no Exchange Online" -ForegroundColor Green
}

function conectaExchOnprem {
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://SRVRQE940021/PowerShell/ -Authentication Kerberos -Credential (credExchOnprem)
    Import-PSSession $Session
	
	Write-Host "Conectado no Exchange OnPremise" -ForegroundColor Green
}

function conectaO365 {
    Connect-MsolService -Credential (credO365)
	
	Write-Host "Conectado no Office 365" -ForegroundColor Green
}

function converteCaixa {
	conectaExchOnline
	
	$i = 0
	
	$arquivo | ForEach {
        $mailbox = (Get-Mailbox -Identity $_.upn)
        $isShared = $mailbox.RecipientTypeDetails.Equals("SharedMailbox") #verificando se a caixa ja e compartilhada ou nao

        if($isShared -eq $True) { #se isShared retornar True, entao a caixa ja e compartilhada
            Write-Host "A caixa de $($_.upn) ja esta compartilhada." -ForegroundColor Yellow
        } else {
            Set-Mailbox -Identity $_.upn -Type Shared #se nao, converte a caixa para Shared Mailbox
            if(!$?) {
                Write-Host "Erro convertendo a caixa de $($_.upn)" -ForegroundColor Red
            } else {
                Write-Host "Convertido caixa de $($_.upn)" -ForegroundColor Green
            }
        }
		
		$i++
		Write-Progress -Activity "Convertendo caixas . . ." -Status "Convertido: $i de $($arquivo.Count)" -PercentComplete ($i/$arquivo.Count*100)					
	}
	
	Write-Host "Fechando conector com o exchange online" -ForegroundColor Cyan
	Get-PSSession | Remove-PSSession
}

function ocultaEndereco {
	conectaExchOnprem
	
	$i = 0

	$arquivo | foreach {
		$mailbox = (Get-RemoteMailbox -Identity $_.upn)
		$isHidden = $mailbox.HiddenFromAddressListsEnabled

		if($isHidden -eq $True) {
			Write-Host "A Caixa de $($_.upn) ja esta oculta da lista global de enderecos!" -ForegroundColor Yellow
		} else {
			Set-RemoteMailbox -Identity $_.upn -HiddenFromAddressListsEnabled $true
			if(!$?){
				Write-Host "Erro ocultando o email de $($_.upn)" -ForegroundColor Red
			} else {
				Write-Host "Ocultado a caixa de $($_.upn)" -ForegroundColor Green
			}
		}
		
		$i++
		Write-Progress -Activity "Ocultando caixas . . ." -Status "Ocultado: $i de $($arquivo.Count)" -PercentComplete ($i/$arquivo.Count*100)
	}
	
	Write-Host "Fechando conector com o exchange OnPremise" -ForegroundColor Cyan
	Get-PSSession | Remove-PSSession
}

function removeLicenca {
	conectaO365
	
	$i = 0
	
	$arquivo | ForEach {
		$msolUser = (Get-MsolUser -UserPrincipalName $_.upn)
		$isLicensed = $msolUser.isLicensed #verifica se o usuario esta licenciado
		
		if($isLicensed){
			$license = $msolUser.Licenses | Select -ExpandProperty AccountSkuId #se esta licenciado pega todas as licencas do usuario e as remove
			Set-MsolUserLicense -UserPrincipalName $_.upn -RemoveLicenses $license
			
			if(!$?){
				Write-Host "Erro removendo licencaa do $($_.upn)" -ForegroundColor Red
			} else {
				Write-host "Removido $license de $($_.upn)" -ForegroundColor Green
			}
		} else {
            Write-Host "Usuario $($_.upn) nao possui licenca" -ForegroundColor Yellow
        }
		
		$i++
		Write-Progress -Activity "Removendo licencas . . ." -Status "Removido: $i de $($arquivo.Count)" -PercentComplete ($i/$arquivo.Count*100)
	}

	Write-Host "Fechando conector com o office 365" -ForegroundColor Cyan
	Get-PSSession | Remove-PSSession
}

converteCaixa
removeLicenca
ocultaEndereco

#v1.5 @gpaganini