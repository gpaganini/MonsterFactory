$CSV = "C:\Users\giovani.paganini\powershellson\exchange\EnableRemoteMailbox\LicensedShared_15042021.csv" #caminho do arquivo csv que possui os UserPrincipalNames dos usuarios
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

function atribuiLicenca {
    conectaO365
    
    $i = 0

    foreach ($user in $arquivo) {
        $msolUser = (Get-MsolUser -UserPrincipalName $user.upn)
        $isLicensed = $msolUser.IsLicensed

        if (!$isLicensed) {
            Write-Host "Atribuindo licenca..." -ForegroundColor Cyan
            Set-MsolUser -UserPrincipalName $msolUser.UserPrincipalName -UsageLocation BR
            Set-MsolUserLicense -UserPrincipalName $msolUser.UserPrincipalName -AddLicenses grq:STANDARDPACK,grq:EMS

            if(!$?) {
                Write-Host "Erro atribuindo licenca para $($user.upn)" -BackgroundColor Red -ForegroundColor White
            } else {
                Write-Host "Atribuido licenca para $($user.upn)" -ForegroundColor Green
            }
        } else {
            $licenses = $msolUser.Licenses | select -ExpandProperty AccountSkuId
            Write-Host "$($user.upn) ja possui os produtos $($licenses)" -ForegroundColor Yellow
        }

        $i++
	    Write-Progress -Activity "Atribuindo licencas . . ." -Status "Atribuido: $i de $($arquivo.Count)" -PercentComplete ($i/$arquivo.Count*100)
    }

    Write-Host "Fechando conector com o office 365" -ForegroundColor Cyan
	Get-PSSession | Remove-PSSession
}

function converteCaixa {
	conectaExchOnline
	
	$i = 0

    foreach ($user in $arquivo) {
        $mailbox = (Get-Mailbox -Identity $user.upn)
        $isShared = $mailbox.RecipientTypeDetails.Equals("SharedMailbox")

        if ($isShared -eq $true) {
            Write-Host "Convertendo caixa compartilhada para regular..." -ForegroundColor Cyan
            Set-Mailbox -Identity $mailbox.UserPrincipalName -Type Regular

            if(!$?) {
                Write-Host "Erro convertendo caixa de $($mailbox.UserPrincipalName)" -BackgroundColor Red -ForegroundColor White
            } else {
                Write-Host "Convertido caixa de $($mailbox.UserPrincipalName) para Regular" -ForegroundColor Green
            }
        } else {
            Write-Host "Caixa de $($mailbox.UserPrincipalName) ja esta Regular" -ForegroundColor Yellow
        }
        
        $i++
		Write-Progress -Activity "Convertendo caixas . . ." -Status "Convertido: $i de $($arquivo.Count)" -PercentComplete ($i/$arquivo.Count*100)					        
    }	
	
	Write-Host "Fechando conector com o exchange online" -ForegroundColor Cyan
	Get-PSSession | Remove-PSSession
}

#atribuiLicenca
converteCaixa