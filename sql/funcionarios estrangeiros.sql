SELECT
    p.nome,
    pa.nomepais AS Pais,
    f.matricula AS Matricula
  FROM
    funcionario f
    join pessoa p ON f.idpessoa = p.idpessoa
    join pessoafisica pf ON p.idpessoa = pf.idpessoa
    join pais pa ON pf.idpais = pa.idpais
  WHERE
    pa.idpais <> 1
  AND
    f.idsitfunc = 1