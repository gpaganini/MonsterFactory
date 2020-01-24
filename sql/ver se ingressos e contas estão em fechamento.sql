SELECT * FROM park2.contaagente WHERE conta in (8905134,8905052);

SELECT * FROM park2.consignacaoingresso;

select ci.fechamento, ci.fechamentoantigo, i.status from park2.consignacaoingresso ci join park2.ingressolancamento il on ci.ingresso = il.ingresso
join park2.ingresso i on i.numero= il.ingresso join park2.lancamentoproduto lp on il.lancamento = lp.numero
where lp.conta = 8963350;