SELECT 
  nomeusuario AS USUARIO,
  p.nome AS NOME,
  nomegrupo AS GRUPO,
  ga.descricao AS DESCRICAOGRUPO,
  f.codcentrocusto,
  cc.nome AS CENTROCUSTO

FROM
  pessoa p
  join usuariosistema us ON p.idpessoa = us.idusuario
  join grupousu gu ON us.idusuario = gu.idusuario
  join grupoacesso ga ON gu.idgrupo = ga.idgrupo
  join funcionario f ON p.idpessoa = f.idpessoa  
  left join centcust cc ON f.idempresa = cc.idempresa AND f.codcentrocusto = cc.codcentrocusto

WHERE 
  nomegrupo LIKE 'REQUISI%'