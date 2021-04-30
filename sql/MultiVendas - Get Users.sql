select u.id,
	c.UserName,
	u.Name,
	u.Cpf,
	u.Code,	
	case 
		when c.IsActive = '1' then 'Ativo'
		when c.IsActive = '0' then 'Inativo'
	end as Status
from users u join credentials c on u.id = c.id
order by Name asc

select u.Name,
	c.UserName,
	u.Code,
	c.IsActive,
	g.Name
from users u
	join credentials c on u.id = c.id
	left join CredentialGroups cg on c.id = cg.Credential
	join Groups g on cg.[Group] = g.id
where g.Name like ''
	order by 1,5;