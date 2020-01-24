select
   lp.conta,
   il.ingresso
 from
   park2.ingressoLancamento il
   join park2.lancamentoproduto lp on il.lancamento=lp.numero
 where
   lp.conta IN (8890078);

--ver se o ingresso foi impresso no pos passando o numero da conta

select
   lp.conta,
   il.ingresso
 from
   park2.ingressoLancamento il
   join park2.lancamentoproduto lp on il.lancamento=lp.numero
   join park2.ingressoimpressopos pos ON il.ingresso = pos.ingresso
    where
   lp.conta IN (8890078);
