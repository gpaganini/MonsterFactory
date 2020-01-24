SELECT * FROM
((SELECT 'AGENTE' AS tipo,p.nome,cp.* FROM clientepess cp join pessoa p ON cp.idpessoa=p.idpessoa WHERE cp.idTipoCliente IN (10))
UNION ALl
(SELECT 'EMPRESA',p.nome,cp.* FROM clientepess cp join pessoa p ON cp.idpessoa=p.idpessoa WHERE cp.idTipoCliente IN (2,17,21,25)))

WHERE NOME LIKE 'CHARLES%';


SELECT DESCRICAO FROM TIPOCLIENTE WHERE IDTIPOCLIENTE IN (2,17,21,25,10);