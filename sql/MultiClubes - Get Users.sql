select id,
	UserName,
	Name,
	Code,
	case 
		when IsActive = '1' then 'Ativo'
		when IsActive = '0' then 'Inativo'
	end as Status	
from Users
order by name asc