select
i.*
from
park2.consignacaoingresso ci
join park2.ingresso i
on ci.ingresso = i.numero
where
ci.datadevolucao is null
and ci.origem = 2
and i.status = 'C'
order by
ingresso;