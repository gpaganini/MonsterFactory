Import-Module VMware.PowerCLI
Connect-VIServer srvrqebkp01.aviva.com.br

$VMHosts = get-vmhost | Sort-Object

foreach ($VMHost in $VMHosts) {
    $esxcli = Get-EsxCli -VMHost $VMHost
    try {
        $key = $esxcli.system.settings.encryption.recovery.list()
        Write-Host "$VMHost;$($key.RecoveryID);$($key.Key)"
    }

    catch {
        
    }
}