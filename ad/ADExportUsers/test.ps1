$oldname = Get-ADUser -Identity giovani.paganini -Properties * | select HomePhone
$oldname

if ($oldName.HomePhone -like "FERIAS") {
    $newName = $oldname.HomePhone -replace "FERIAS - ",""
    $newName
    Set-ADUser -Identity giovani.paganini -HomePhone $newName
} elseif($oldname.HomePhone -like "AUSENTE") {
    $newName = $oldname.HomePhone -replace "AUSENTE - ",""
    Set-ADUser -Identity giovani.paganini -HomePhone $newName
}