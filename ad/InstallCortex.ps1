$software = "Cortex*"

$checkInstall = (
    Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | where {
        $_.DisplayName -like $software
    }
) -ne $null

if (-not $checkInstall) {
    echo "Cortex não instalado. Realizando a instalação..."
    Start-Process msiexec.exe -Wait -argumentlist '/I "\\aviva.com.br\netlogon\Instalar Traps\AgenteWin771_x64.msi" /qn /norestart'
} else {
    echo "Cortex já instalado, abortando!"
}