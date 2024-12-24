##pega o nome de usuario a partir de um CSV contendo o nome completo


$aResults = @()
$List = Get-Content C:\scr\getadusuarios.txt

foreach($Item in $List){
    $Item = $Item.trim()
    $User = Get-ADUser -filter{displayName -like $Item} -Properties samaccountname

    $hItemDetails = New-Object -TypeName psobject -Property @{
        FullName = $Item
        UserName = $User.SamAccountName
    }

    $aResults += $hItemDetails
}

$aResults | Export-Csv "C:\scr\results.csv"