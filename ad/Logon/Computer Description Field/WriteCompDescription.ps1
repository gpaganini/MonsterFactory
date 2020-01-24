    $wqlQuery = "Select IdentifyingNumber,Name,SKUNumber,UUID,Vendor from Win32_ComputerSystemProduct"
    
    $EthernetMac = Get-NetAdapter | Where-Object {($_.Name -eq "Ethernet")} | foreach { $_.MacAddress }
    $WiFiMac = Get-NetAdapter | Where-Object {($_.Name -eq "Wi-Fi")} | foreach { $_.MacAddress }

    $wqlObjectSet = Get-WmiObject -namespace "ROOT\CIMV2"  -Impersonation 3  -Query $wqlQuery
    if ($wqlObjectSet -eq $null)

        {
        Write-Host "WMI Object not found..."
        return;
    }
    
    if (@($wqlObjectSet).Count -gt 0)
    {
        foreach ($objWMIClass in $wqlObjectSet)
        {
            Write-Host
            Write-Host " -------------------------------- "
            
            Write-Host " Identifying Number:  " $objWMIClass.IdentifyingNumber
            Write-Host " Name: .............. " $objWMIClass.Name
            Write-Host " SKU Number: ........ " $objWMIClass.SKUNumber
            Write-Host " UUID: .............. " $objWMIClass.UUID
            Write-Host " Vendor: ............ " $objWMIClass.Vendor
            Write-Host " User:............... " $env:USERNAME
            Write-Host " Computername:....... " $env:COMPUTERNAME
            Write-Host " EthernetMac:........ " $EthernetMac
            Write-Host " WiFiMac:............ " $WiFiMac

            $CurrentADComputerInfo = Get-ADComputer -Identity $env:COMPUTERNAME

            $NewADComputerInfoDescription = $env:USERNAME+"|"+$objWMIClass.Name+"|"+$objWMIClass.IdentifyingNumber+"|"+$(((get-date)).ToString("dd/MM/yyyy|hh:mm:ss"))+"|"+$EthernetMac+"|"+$WiFiMac
            $CurrentADComputerInfo.Description
            $NewADComputerInfoDescription
            if ($CurrentADComputerInfo.Description -ne $NewADComputerInfoDescription)
            {
            #If new description is different to current description then Update ADComputer Description
            Set-ADComputer -Identity $env:COMPUTERNAME -Description $NewADComputerInfoDescription
            Write-Host " Description has changed .e.g. user:"
            }
            else
            {
            #If new description is same  to current description then do nothing
            Write-Host " Description has NOT changed:"
            }
        }
    }
    else
    {
        Write-Host "No instance."
    }