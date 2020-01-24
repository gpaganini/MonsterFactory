SELECT * FROM park2.lancamentoproduto WHERE numero = 35766362;

SELECT * FROM pdv.produto WHERE id = 13337;

SELECT * FROM park2.conta WHERE contavhf in (19906502, 19906667, 19906778, 19906777);

SELECT * FROM park2.lancamentoproduto WHERE conta = 9200887;

SELECT lp.numero, lp.conta, lp.produto, lp.integrado, lp.datahoraintegracao, lp.calcvalortotal, p.nome FROM park2.lancamentoproduto lp join pdv.produto p ON lp.produto = p.id WHERE conta =9200887;

SELECT * FROM pdv.produto;