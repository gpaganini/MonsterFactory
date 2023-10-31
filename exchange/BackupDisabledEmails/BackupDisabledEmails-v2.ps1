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
[CmdletBinding()]
param (
    [switch]$Offboard,    
    [Parameter(Mandatory=$false)]
    [string]$Usuario,
    [Parameter(Mandatory=$false)]
    [string]$Csv
)

function connectM365Graph {
    try {
        Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All        
    } catch {
        Write-Host "Falha na conexão com o Tenant..." -BackgroundColor Red -ForegroundColor White
    }
}

function connectEXO {
    try {
        Connect-ExchangeOnline
    } catch {
        Write-Host "Falha na conexão com o Exchange Online" -BackgroundColor Red -ForegroundColor White
    }    
}

function connectExOnprem {
    try {        
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://SRVRQE940021/PowerShell/ -Authentication Kerberos -Credential (Get-Credential)
        Import-PSSession $Session    
    } catch {
        Write-Host "Falha na conexão com o Exchange Server" -BackgroundColor Red -ForegroundColor White
    }
}

function convertM365Mailbox {
    if ($User) {
        
    }
    
    connectEXO
    $file | foreach
}

function removeM365UserLicense {
    $i = 0

    $file | foreach {
        try{
            $m365User = Get-MgUser -UserId $_.upn -ErrorAction Stop
        } catch {
            Write-Host "Usuário $($m365User.UserPrincipalName) não encontrado, pulando..." -BackgroundColor Red -ForegroundColor White
        }

        $SKUS = @(Get-MgUserLicenseDetail -UserId $m365User.Id)
        if (!$SKUS) {
            Write-Host "Nenhuma licença encontrada para o usuario $($m365User.UserPrincipalName), pulando..." -BackgroundColor Red -ForegroundColor White
        }

        foreach ($SKU in $SKUS) {
            Write-Host "Removendo licença $($SKU.SkuPartNumber) do usuário $($m365User.UserPrincipalName)" -BackgroundColor DarkGreen -ForegroundColor White
            try {
                Set-MgUserLicense -UserId $m365User.Id -AddLicenses @() -RemoveLicenses $SKU.SkuId #-WhatIf
            } catch {
                $_ | fl * -Force; continue
            }
        }
        
        $i++
        Write-Progress -Activity "Removendo licenças..." -Status "Removido $i de $($file.Count)" -PercentComplete ($i/$file.Count*100)
    }

    Disconnect-MgGraph
}

if ($Offboard) {
    #connectEXO

    if ($Usuario) {
        try {
            $userMailbox = Get-Mailbox -Identity $Usuario -ErrorAction SilentlyContinue
        } <#catch [Microsoft.Exchange.Configuration.Tasks.ManagementObjectNotFoundException] {
            Write-Host "exceção tratada"
        }#>
        
        catch {
            Write-Host "Mailbox de $($Usuario) não encontrada, pulando..." -BackgroundColor Red -ForegroundColor White
        }

        if ($userMailbox -ne $null) {
            $isShared = $userMailbox.RecipientTypeDetails.Equals("SharedMailbox")
        }

        #$isShared = $userMailbox.RecipientTypeDetails.Equals("SharedMailbox")

        if($isShared -ne $true){
            try {
                Write-Host "Convertendo caixa de $($userMailbox.Name)..." -BackgroundColor DarkGreen -ForegroundColor White
                Set-Mailbox -Identity $Usuario -Type Shared -WhatIf
            } catch {
                Write-Host "Falha ao converter caixa de $($userMailbox.Name)" -BackgroundColor Red -ForegroundColor White
            }
        } else {
            Write-Host "Caixa de $($userMailbox.Name) já está compartilhada" -BackgroundColor Yellow -ForegroundColor Black
        }
    } elseif ($Csv) {
        $File = Import-Csv -Path $Csv -Delimiter ";"

        $File | foreach {
            try {
                $userMailbox = Get-Mailbox -Identity $_.upn -ErrorAction Continue                
            } catch [Microsoft.Exchange.Configuration.Tasks.ManagementObjectNotFoundException] {
                Write-Host "Mailbox $($_.upn) não encontrada, pulando..." -BackgroundColor Red -ForegroundColor White; continue
            } catch [System.Management.Automation.MethodInvocationException] {
                Write-Host "Ocorreu um erro: O método foi chamado em uma expressão nula."
            }
            catch {
                #echo $_.Upn
                Write-Host "Mailbox $($_.upn) não encontrada, pulando..." -BackgroundColor Red -ForegroundColor White; continue
            }

            $isShared = $userMailbox.RecipientTypeDetails.Equals("SharedMailbox")

            if($isShared -ne $true){
                try {
                    Write-Host "Convertendo caixa de $($userMailbox.DisplayName)..." -BackgroundColor DarkGreen -ForegroundColor White
                    Set-Mailbox -Identity $userMailbox.UserPrincipalName -Type Shared -WhatIf
                } catch {
                    Write-Host "Falha ao converter caixa de $($userMailbox.DisplayName)" -BackgroundColor Red -ForegroundColor White
                }
            } else {
                Write-Host "Caixa de $($userMailbox.DisplayName) já está compartilhada" -BackgroundColor Yellow -ForegroundColor Black
            }
        }
    }
}