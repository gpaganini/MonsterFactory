select
  i.numero
from
  park2.ingresso i
  join park2.consignacaoingresso ci
    on i.numero = ci.ingresso
  join park2.ingressolancamento il
    on i.numero = il.ingresso
  join park2.lancamentoproduto lp
    on il.lancamento = lp.numero
  join park2.conta c
    on lp.conta = c.numero
where
  i.status in ('P', 'B')
  and c.status = 'E'
  and ci.datadevolucao is null
  and il.datahorabaixa is not null
group by
  i.numero;