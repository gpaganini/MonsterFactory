Add-ADGroupMember -Identity 'New Group' -Members (Get-ADGroupMember -Identity 'Old Group' -Recursive)

