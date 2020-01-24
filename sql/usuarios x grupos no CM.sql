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

    SELECT * FROM grupoacesso WHERE nomegrupo LIKE '%ALMOXA%';




















