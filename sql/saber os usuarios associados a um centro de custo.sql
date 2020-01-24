SELECT
  c.codcentrocusto,
  p.nome
FROM
  usccusto c
  join pessoa p ON c.idusuario = p.idpessoa
WHERE
  c.codcentrocusto = 020104;


SELECT * FROM usuariosistema WHERE nomeusuario LIKE '%FERNANDO.RA%';

SELECT * FROM pessoa WHERE idpessoa = 27;

SELECT * FROM centcust WHERE nome LIKE '%SUPRIMENTOS%';

SELECT * FROM pessoa;

SELECT * FROM almox WHERE descalmox LIKE '%OBRAS%';

SELECT
  a.descalmox,
  u.nomeusuario
FROM
  usuxalmox ua
  join almox a ON ua.codalmoxarifado = a.codalmoxarifado
  join usuariosistema u ON ua.idusuario = u.idusuario
WHERE
  ua.codalmoxarifado IN (79,80)
  ORDER BY 1;

  DELETE  FROM usuxalmox WHERE codalmoxarifado IN (79,80);