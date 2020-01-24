cd "C:\Users\giovani.paganini\OneDrive - COMPANHIA THERMAS DO RIO QUENTE\Documents\scriptator\Exchange\ConvertMailboxToShared"
$CSV = "e5_25_11_2019.csv" #caminho do arquivo csv que possui os UserPrincipalNames dos usuarios
$arquivo = Import-CSV $CSV 


function credO365 {
    $usuario = 'gpaganini@aviva.com.br'
    $senha = Get-Content '.\trustyPassword.txt'

    $secureSenha = $senha | ConvertTo-SecureString

    $userCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $usuario, $secureSenha

    return $userCredential
}

function credExchOnprem {
    $usuario = 'rqr\giovani.paganini'
    $senha = Get-Content '.\trustyPassword.txt'

    $secureSenha = $senha | ConvertTo-SecureString

    $userCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $usuario, $secureSenha

    return $userCredential
}


function conectaExchOnline {
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential (credO365) -Authentication Basic -AllowRedirection
	Import-PSSession $Session
}


function conectaExchOnprem {
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://SRVRQE940020/PowerShell/ -Authentication Kerberos -Credential (credExchOnprem)
    Import-PSSession $Session
}

function conectaO365 {
    Connect-MsolService -Credential (credO365)
}

conectaExchOnprem

$arquivo | foreach {
    $mailbox = (Get-RemoteMailbox -Identity $_.upn)
    $isHidden = $mailbox.HiddenFromAddressListEnabled.Equals("True")

    if($isHidden) {
        Write-Host "A Caixa Remota já está oculta da lista global de endereços!" -ForegroundColor Yellow
    } else {
        Set-RemoteMailbox -Identity $_.upn -HiddenFromAddressListsEnabled $true
        if(!$?){
            Write-Host "Erro ocultando o email remoto!" -ForegroundColor Red
        } else {
            Write-Host "Ocultado a caixa de $_.upn" -ForegroundColor Green
        }
    }
}