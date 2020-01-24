--Script para saber se os flags do filtro estão habilitados para qual grupo no CM
SELECT
   trim(m.nomeModulo) as modulo,
   ga.nomegrupo,
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
   (fp.nomefuncao)   LIKE '%Cadastro%'       AND  --Menu no CM
   (f.nomefuncao)   LIKE 'Insu%'  AND    --Submenu no CM
   a.flghabilita = 'S' AND
   a.flgvisualiza = 'S'

order by 2,4,5;




