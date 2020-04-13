<#[CmdletBinding()]
Param(
    [Paramenter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [switch]$Disable = $true,
    [Parameter(Mandatory=$false,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [String]$Rename='Rename',
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [String]$csv = 'CsvPath'
)



if ($csv -ne "") {
    $objUsers = Import-Csv $csv
} else {
    $objUsers = Get-ADUser -Server $adServer -Credential $GetAdminact -Properties SamAccountName | select SamAccountName
}

foreach ($objUser in $objUsers) {
    $oldname = Get-ADUser -Identity $objUser.SamAccountName | select DisplayName

}

if($Rename) {
    if ()

} #>

Import-Module ActiveDirectory

$oldname = Get-ADUser -Identity giovani.paganini -Properties * | select HomePhone
Write-Host -BackgroundColor Blue -ForegroundColor White "$($oldname.HomePhone)"

$users = Get-ADUser -Filter * -Properties SamAccountName | select SamAccountName

foreach ($user in $users) {
    $userOldName = Get-ADUser -Identity $user.samaccountname -Properties * | select DisplayName | where {($userOldName.DisplayName -like "*AUSENTE*")}
    #Write-Host -BackgroundColor Blue -ForegroundColor White "$($userOldName.DisplayName)"

    if ($userOldName.DisplayName -like "AUSENTE - FERIAS - ") {
        $newName = $userOldName.DisplayName -replace "FERIAS - ",""
        #Set-ADUser -Identity giovani.paganini -HomePhone $newName           
        Write-Host -BackgroundColor Green -ForegroundColor White "$($newName)"
        $userOldName.DisplayName = $newName
    }

    if($userOldName.DisplayName -like "FERIAS - AUSENTE - ") {
        $newName = $userOldName.DisplayName -replace "FERIAS - ",""    
        #Set-ADUser -Identity giovani.paganini -HomePhone $newName
        Write-Host -BackgroundColor Yellow -ForegroundColor White "$($newName)"
        $userOldName.DisplayName = $newName
    }
}


if($oldname.HomePhone -like "FERIAS - AUSENTE - ") {
    $newName = $oldname.HomePhone -replace "FERIAS - ",""    
    #Set-ADUser -Identity giovani.paganini -HomePhone $newName
    Write-Host -BackgroundColor Yellow -ForegroundColor White "$($newName)"
    $oldname.HomePhone = $newName
}

if($oldname.HomePhone -like "*AFASTADO*") {
    $newName = $oldname.HomePhone -replace "AFASTADO - ",""
    #Set-ADUser -Identity giovani.paganini -HomePhone $newName
    Write-Host -BackgroundColor Magenta -ForegroundColor White "$($newName)"
    $oldname.HomePhone = $newName
}

if ($oldname.HomePhone -notlike "*DESATIVADO*") {
    $newName = ("DESATIVADO - " + $oldname.HomePhone)
   # Set-ADUser -Identity giovani.paganini -HomePhone $newName
    Write-Host -BackgroundColor White -ForegroundColor Black "$($newName)"
}

