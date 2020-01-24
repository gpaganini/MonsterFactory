# instalar modulo do azureAD

Install-Module -Name AzureAD
Install-Module msonline

Connect-MsolService
Get-MsolDirSyncProvisioningError

# encontrar na lixeira usuarios deletados que podem estar conflitando
Get-MsolUser -ReturnDeletedUsers | ft DisplayName,ProxyAddresses -Wrap

# remover usuarios da lixeira
Get-MsolUser -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin -Force

