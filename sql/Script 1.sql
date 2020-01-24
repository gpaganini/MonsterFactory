SELECT
   trim(m.nomeModulo) as modulo,
   ga.nomegrupo,
   ga.idgrupo,
   fp.nomefuncao as funcaoPai,
   F.NOMEFUNCAO,
   O.NOMEOPERACAO,
   a.FLGHABILITA,
   a.FLGVISUALIZA,
   ga.idgrupo
FROM
   AUTORIZA a
   join OPERFUNC opf on a.IDOPERFUNC = opf.IDOPERFUNC
   left join funcao f on f.idfuncao=opf.idfuncao
   left join operacao o on opf.idoperacao=o.idoperacao
   join grupoacesso ga on a.IDESPACESSO=ga.IDESPACESSO
   left join funcao fp on f.idfuncaopai = fp.idfuncao
   join modulo m on opf.idmodulo=m.idmodulo
WHERE
--   (opf.IDMODULO = 2) AND
--   (a.IDESPACESSO = 5) AND
   (a.IDPESSOA = 1)          AND
   (fp.nomefuncao)   LIKE '%Plan%'       AND  --Menu no CM
   (f.nomefuncao)   LIKE 'Lan%'  AND    --Submenu no CM
   (o.nomeoperacao) LIKE 'INSER%' AND
   a.flghabilita = 'S' AND
   a.flgvisualiza = 'S'

order by 2,4,5;


SELECT nomeusuario AS Usuario,
       p.nome AS Nome,
       nomegrupo AS Grupo,
       ga.descricao AS Descricao,
       us.desativado AS Desativado
        FROM
        pessoa p
        join usuariosistema us ON p.idpessoa = us.idusuario
        join grupousu gu ON us.idusuario = gu.idusuario
        join grupoacesso ga ON gu.idgrupo = ga.idgrupo
        WHERE
       ga.idgrupo IN (130,17,81,2,18,123) AND
       us.desativado IN ( 'N', 'N' )
       ORDER BY 3,2;

SELECT * FROM grupousu;

SELECT
    ga.nomegrupo AS Grupo,
    ga.descricao,
    p.nome
FROM
    grupoacesso ga join grupousu gu
ON
    ga.idgrupo = gu.idgrupo
    join pessoa p ON gu.idusuario = p.idpessoa
WHERE
    ga.idgrupo IN (173,186,205,12)
ORDER BY 1,3;

SELECT * FROM grupoacesso WHERE nomegrupo LIKE '%ALMOXA%'



SELECT
  U.IDUSUARIO,
  U.NOMEUSUARIO,
  P.NOME,
  U.IDESPACESSO,
  U.DESCRICAO,
  U.DESATIVADO
 FROM
  PESSOA P,
  USUARIOSISTEMA U
 WHERE
  U.IDUSUARIO = P.IDPESSOA AND
  U.DESATIVADO IN ( 'S', 'S' )
   AND NOMEUSUARIO  LIKE 'GIOVANI.PAGANINI%'
ORDER BY
  P.NOME