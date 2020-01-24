SELECT
      p.nome
  FROM
      funcionario f join pessoa p ON p.idpessoa = f.idpessoa
  WHERE
      f.idsitfunc in (1,2)
  AND
      p.email IS NULL;



