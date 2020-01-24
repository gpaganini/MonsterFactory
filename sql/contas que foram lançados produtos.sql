SELECT * FROM park2.lancamentoproduto;

--produtos lançados com usuario que lançou e o numero da conta que foi lançado
SELECT  p.conta, p.pdv, p.memorando, (p.calcvalortotal/p.quantidade) AS valorunitario, p.calcvalortotal AS ValorTotal, p.quantidade, pr.nome AS Produto, p.datahora AS DataLancamento, s.nome AS Usuario, s.nomecompleto FROM park2.lancamentoproduto p join pdv.produto pr ON p.produto = pr.id
join park2.security_systemuser s ON p.security_systemuser = s.id WHERE pr.nome = 'TAXA DE MANUTENCAO PP';


SELECT * FROM park2.produtovendacredito;

SELECT * FROM pdv.produto WHERE id = 9473;

SELECT (calcvalortotal/quantidade) FROM park2.lancamentoproduto WHERE conta = 7372937 AND numero = 26692266;

SELECT * FROM park2.security_systemuser WHERE id = 3123;

SELECT * FROM pdv.produto WHERE nome LIKE '%TAXA DE MANUTEN%';


SELECT Sum(l.quantidade) FROM park2.lancamentoproduto l join pdv.produto p ON l.produto = p.id WHERE l.produto = 6255 ORDER BY dtinclusao;

SELECT * FROM park2.produtovendacredito;