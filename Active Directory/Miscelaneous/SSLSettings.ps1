###################################################################################################################
# TLS 1.0
###################################################################################################################
<#
if (-not (Test-Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server')){
    Write-Host "TLSv1.0 Server Settings are not present. Creating..." -ForegroundColor Red -BackgroundColor Black
    
    #New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -Name 'Enabled' -value '0' -PropertyType 'DWord' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -Name 'DisabledByDefault' -value 1 -PropertyType 'DWord' -Force | Out-Null

    Write-Host "TLSv1.0 Server Settings created!" -ForegroundColor Cyan -BackgroundColor Blue
} else {
    if ((Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -Name Enabled | where Enabled -eq 0) -and `
    (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -Name DisabledByDefault | where DisabledByDefault -eq 1)){
        Write-Host "TLSv1.0 Server is Disabled!" -ForegroundColor Green -BackgroundColor DarkGreen
    } else {
        Write-Host "TLSv1.0 Server Settings are Enabled and should be disabled for security purposes!" -ForegroundColor Red -BackgroundColor Black
    }
}

if (-not (Test-Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client')){
    Write-Host "TLSv1.0 Client Settings are not present. Creating..." -ForegroundColor Red -BackgroundColor Black
    
    #New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -Name 'Enabled' -value '0' -PropertyType 'DWord' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -Name 'DisabledByDefault' -value 1 -PropertyType 'DWord' -Force | Out-Null

    Write-Host "TLSv1.0 Client Settings created!" -ForegroundColor Cyan -BackgroundColor Blue
} else {
    if ((Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -Name Enabled | where Enabled -eq 0) -and `
    (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -Name DisabledByDefault | where DisabledByDefault -eq 1)){
        Write-Host "TLSv1.0 Client is Disabled!" -ForegroundColor Green -BackgroundColor DarkGreen
    } else {
        Write-Host "TLSv1.0 Server Settings are Enabled and should be disabled for security purposes!" -ForegroundColor Red -BackgroundColor Black
    }
}

###################################################################################################################
# TLS 1.1
###################################################################################################################

if (-not (Test-Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server')){
    Write-Host "TLSv1.1 Server Settings are not present. Creating..." -ForegroundColor Red -BackgroundColor Black
    
    #New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' -Name 'Enabled' -value '0' -PropertyType 'DWord' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' -Name 'DisabledByDefault' -value 1 -PropertyType 'DWord' -Force | Out-Null

    Write-Host "TLSv1.1 Server Settings created!" -ForegroundColor Cyan -BackgroundColor Blue
} else {
    if ((Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' -Name Enabled | where Enabled -eq 0) -and `
    (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' -Name DisabledByDefault | where DisabledByDefault -eq 1)){
        Write-Host "TLSv1.1 Server is Disabled!" -ForegroundColor Green -BackgroundColor DarkGreen
    } else {
        Write-Host "TLSv1.1 Server Settings are Enabled and should be disabled for security purposes!" -ForegroundColor Red -BackgroundColor Black
    }
}

if (-not (Test-Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client')){
    Write-Host "TLSv1.1 Client Settings are not present. Creating..." -ForegroundColor Red -BackgroundColor Black
    
    #New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client' -Name 'Enabled' -value '0' -PropertyType 'DWord' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client' -Name 'DisabledByDefault' -value 1 -PropertyType 'DWord' -Force | Out-Null

    Write-Host "TLSv1.1 Client Settings created!" -ForegroundColor Cyan -BackgroundColor Blue
} else {
    if ((Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client' -Name Enabled | where Enabled -eq 0) -and `
    (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client' -Name DisabledByDefault | where DisabledByDefault -eq 1)){
        Write-Host "TLSv1.1 Client is Disabled!" -ForegroundColor Green -BackgroundColor DarkGreen
    } else {
        Write-Host "TLSv1.1 Server Settings are Enabled and should be disabled for security purposes!" -ForegroundColor Red -BackgroundColor Black
    }
}

###################################################################################################################
# TLS 1.2
###################################################################################################################

if (-not (Test-Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server')){
    Write-Host "TLSv1.2 Server Settings are not present. Creating..." -ForegroundColor Red -BackgroundColor Black
    
    New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Force | Out-Null
    New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Name 'Enabled' -value '1' -PropertyType 'DWord' -Force | Out-Null
    New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Name 'DisabledByDefault' -value 0 -PropertyType 'DWord' -Force | Out-Null

    Write-Host "TLSv1.2 Server Settings created!" -ForegroundColor Cyan -BackgroundColor Blue
} else {
    if ((Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Name Enabled | where Enabled -eq 1) -and `
    (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Name DisabledByDefault | where DisabledByDefault -eq 0)){
        Write-Host "TLSv1.2 Server is Enabled!" -ForegroundColor Green -BackgroundColor DarkGreen
    } else {
        Write-Host "TLSv1.2 Server Settings are only partially enabled or disabled. Ensure that correct settings are applied!" -ForegroundColor Red -BackgroundColor Black
    }
}

if (-not (Test-Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client')){
    Write-Host "TLSv1.2 Client Settings are not present. Creating..." -ForegroundColor Red -BackgroundColor Black
    
    New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Force | Out-Null
    New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -Name 'Enabled' -value '1' -PropertyType 'DWord' -Force | Out-Null
    New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -Name 'DisabledByDefault' -value 0 -PropertyType 'DWord' -Force | Out-Null

    Write-Host "TLSv1.2 Client Settings created!" -ForegroundColor Cyan -BackgroundColor Blue
} else {
    if ((Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -Name Enabled | where Enabled -eq 1) -and `
    (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -Name DisabledByDefault | where DisabledByDefault -eq 0)){
        Write-Host "TLSv1.2 Client is Enabled!" -ForegroundColor Green -BackgroundColor DarkGreen
    } else {
        Write-Host "TLSv1.2 Client Settings are only partially enabled or disabled. Ensure that correct settings are applied!" -ForegroundColor Red -BackgroundColor Black
    }
}
#>
###################################################################################################################
# TLS 1.2 for .NET 3.5
###################################################################################################################

if(-not (Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727' -Name 'SystemDefaultTlsVersions' -ErrorAction SilentlyContinue) -and `
    -not (Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727' -Name 'SchUseStrongCrypto' -ErrorAction SilentlyContinue)){
    Write-Host "TLSv1.2 .NET 3.5 x64 Settings are not present. Creating..." -ForegroundColor Red -BackgroundColor Black

    #New-Item 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727' -Name 'SystemDefaultTlsVersions' -value '1' -PropertyType 'DWord' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727' -Name 'SchUseStrongCrypto' -value '1' -PropertyType 'DWord' -Force | Out-Null
} 

if (-not (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727' -Name 'SystemDefaultTlsVersions' -ErrorAction SilentlyContinue) -and `
    -not (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727' -Name 'SchUseStrongCrypto' -ErrorAction SilentlyContinue)){
    Write-Host "TLSv1.2 .NET 3.5 x86 Settings are not present. Creating..." -ForegroundColor Red -BackgroundColor Black

    #New-Item 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727' -Name 'SystemDefaultTlsVersions' -value '1' -PropertyType 'DWord' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727' -Name 'SchUseStrongCrypto' -value '1' -PropertyType 'DWord' -Force | Out-Null
        
} else {
    if ((Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727' -Name 'SystemDefaultTlsVersions' | where SystemDefaultTlsVersions -eq 1) -and `
    (Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727' -Name 'SchUseStrongCrypto' | where SchUseStrongCrypto -eq 1)){
        Write-Host "TLSv1.2 for .NET 3.5 x64 is Enabled" -ForegroundColor Green -BackgroundColor DarkGreen
    } else {
        Write-Host "TLSv1.2 for .NET 3.5 x64 is Disabled or only partially enabled. Ensure that correct settings are applied!" -ForegroundColor Red -BackgroundColor Black
    }

    if ((Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727' -Name 'SystemDefaultTlsVersions' | where SystemDefaultTlsVersions -eq 1) -and `
    (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727' -Name 'SchUseStrongCrypto' | where SchUseStrongCrypto -eq 1)){
        Write-Host "TLSv1.2 for .NET 3.5 x86 is Enabled" -ForegroundColor Green -BackgroundColor DarkGreen
    } else {
        Write-Host "TLSv1.2 for .NET 3.5 x86 is Disabled or only partially enabled. Ensure that correct settings are applied!" -ForegroundColor Red -BackgroundColor Black
    }
}

###################################################################################################################
# TLS 1.2 for .NET 4.0
###################################################################################################################

if(-not (Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319' -Name 'SystemDefaultTlsVersions' -ErrorAction SilentlyContinue) -and `
    -not (Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -ErrorAction SilentlyContinue)){
    Write-Host "TLSv1.2 .NET 4.0 x64 Settings are not present. Creating..." -ForegroundColor Red -BackgroundColor Black

    #New-Item 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319' -Name 'SystemDefaultTlsVersions' -value '1' -PropertyType 'DWord' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -value '1' -PropertyType 'DWord' -Force | Out-Null
} 

if (-not (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' -Name 'SystemDefaultTlsVersions' -ErrorAction SilentlyContinue) -and `
    -not (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -ErrorAction SilentlyContinue)){
    Write-Host "TLSv1.2 .NET 4.0 x86 Settings are not present. Creating..." -ForegroundColor Red -BackgroundColor Black

    #New-Item 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' -Name 'SystemDefaultTlsVersions' -value '1' -PropertyType 'DWord' -Force | Out-Null
    #New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -value '1' -PropertyType 'DWord' -Force | Out-Null
        
} else {
    if ((Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319' -Name 'SystemDefaultTlsVersions' | where SystemDefaultTlsVersions -eq 1) -and `
    (Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319' -Name 'SchUseStrongCrypto' | where SchUseStrongCrypto -eq 1)){
        Write-Host "TLSv1.2 for .NET 4.0 x64 is Enabled" -ForegroundColor Green -BackgroundColor DarkGreen
    } else {
        Write-Host "TLSv1.2 for .NET 4.0 x64 is Disabled or only partially enabled. Ensure that correct settings are applied!" -ForegroundColor Red -BackgroundColor Black
    }

    if ((Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' -Name 'SystemDefaultTlsVersions' | where SystemDefaultTlsVersions -eq 1) -and `
    (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' -Name 'SchUseStrongCrypto' | where SchUseStrongCrypto -eq 1)){
        Write-Host "TLSv1.2 for .NET 4.0 x86 is Enabled" -ForegroundColor Green -BackgroundColor DarkGreen
    } else {
        Write-Host "TLSv1.2 for .NET 4.0 x86 is Disabled or only partially enabled. Ensure that correct settings are applied!" -ForegroundColor Red -BackgroundColor Black
    }
}