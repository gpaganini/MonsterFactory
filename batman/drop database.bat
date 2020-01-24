sqlcmd -S .\sqlexpress -U microsdb -P microsdb
alter login microsdb enable
go 1
drop database datastore
go 1
exit

