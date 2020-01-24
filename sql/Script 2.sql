SELECT nomeusuario AS Usuario,
       p.nome AS Nome,
       nomegrupo AS Grupo,
       ga.descricao AS Descricao,
       us.desativado AS Desativado,
       us.descricao AS Cargo
        FROM
        pessoa p
        join usuariosistema us ON p.idpessoa = us.idusuario
        join grupousu gu ON us.idusuario = gu.idusuario
        join grupoacesso ga ON gu.idgrupo = ga.idgrupo
        WHERE
       ga.idgrupo IN (130,17,81,2,18,123) AND
       us.desativado IN ( 'N', 'N' )
       ORDER BY 3,2;

SELECT
   trim(m.nomeModulo) as modulo,
   ga.nomegrupo AS Grupo,
   ga.idgrupo,
   fp.nomefuncao as funcaoPai,
   F.NOMEFUNCAO AS Funcao,
   O.NOMEOPERACAO AS Operacao,
   a.FLGHABILITA AS Habilitado,
   a.FLGVISUALIZA AS Habilitado
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
--   (o.nomeoperacao) LIKE 'ES%' AND
   a.flghabilita = 'S' AND
   a.flgvisualiza = 'S'
ORDER BY 3,2
