SELECT p.nome,us.nomeusuario AS usuario,f.matricula,p.numdocumento AS cpf,cg.titulo AS cargo, f.idsitfunc AS situacao
	FROM 
		usuariosistema us
		JOIN pessoa p ON us.idusuario=p.idpessoa
		JOIN pessoafisica pf ON p.idpessoa=pf.idpessoa 
		LEFT JOIN funcionario f ON p.idpessoa=f.idpessoa
		LEFT JOIN cargo cg ON f.idcargo=cg.idcargo
	--WHERE
   -- p.nome LIKE 'ABRAAO%'
		-- f.idsitfunc <>3;

    ORDER BY nome

SELECT f.matricula, p.nome, p.numdocumento AS cpf, cg.titulo AS cargo
    FROM 
    pessoa p join pessoafisica pf ON p.idpessoa=pf.idpessoa
    left join funcionario f ON p.idpessoa=f.idpessoa
    left join cargo cg ON f.idcargo=cg.idcargo
    WHERE
    f.idsitfunc <>3   
    ORDER BY p.nome
