SELECT p.nome,pf.datanasc,p.email,us.nomeusuario,f.matricula,
	   f.codcentrocusto,cg.titulo
	FROM 
		usuariosistema us
		JOIN pessoa p ON us.idusuario=p.idpessoa
		JOIN pessoafisica pf ON p.idpessoa=pf.idpessoa 
		LEFT JOIN funcionario f ON p.idpessoa=f.idpessoa
		LEFT JOIN cargo cg ON f.idcargo=cg.idcargo
	WHERE
		f.idsitfunc <>3;