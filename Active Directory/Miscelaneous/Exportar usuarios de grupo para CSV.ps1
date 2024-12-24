Exportar usuarios de grupo para CSV

Get-ADGroupMember -identity “Name of Group” -recursive | select name | Export-csv -path C:\Output\Groupmembers.csv -NoTypeInformation