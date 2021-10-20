--Lista de grupos no CM e quais pessoas est�o associadas a este grupo, lembrando que deve-se apagar o "--" para habilitar o filtro
SELECT nomeusuario AS Usuario,
       p.nome AS Nome,
       nomegrupo AS Grupo,
       ga.descricao AS Descricao
        FROM
        pessoa p
        join usuariosistema us ON p.idpessoa = us.idusuario
        join grupousu gu ON us.idusuario = gu.idusuario
        join grupoacesso ga ON gu.idgrupo = ga.idgrupo
        WHERE
        --p.nome LIKE '%LOAMY%' -- Pegando por nome do usuario
       --ga.idgrupo IN (12,157,132,173,27,20,143,13,14,120,136,17,170,2,190,18,51,68,92,33,35,122,21)  --Pegando por id do grupo
       ORDER BY 3,2;
