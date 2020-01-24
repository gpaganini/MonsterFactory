--Saber fechamento passando numeor da conta
select * from park2.contaagente where conta in (8585643,
8585733,
8585673,
8578800,
8577793,
8585769,
8562540,
8562588,
8562619,
8585757,
8556762,
8559570,
8578971,
8559406,
8577703,
8585643,
8577536,
8563333,
8555624,
8555422,
8496824,
8553071,
8555544,
8537340,
8538910,
8543283,
8557530,
8555641,
8561206,
8562848,
8562476,
8564389,
8543784,
8556290,
8556303,
8559603,
8559483,
8565212,
8553003,
8559445
);

--se a datafechamento for maior que a data reabertura é porque ela ja entrou em outro fechamento
select
f.id,
ca.conta,
to_char(f.data, 'dd/mm/yyyy hh24:mi:ss') datafechamento,
to_char(h.datahora, 'dd/mm/yyyy hh24:mi:ss') datareabertura
from
park2.fechamentoconsignacao f
join park2.contaagente ca
on f.id = ca.fechamento
join park2.historico h
on h.origem = ca.conta
where
ca.conta in (8553003)
and h.tipo = 'C'
and h.operacao = 'S'
and h.nomeoriginal = 'E';

--se a datafechamento for maior que a data reabertura é porque ela ja entrou em outro fechamento
select
f.id,
ca.conta,
to_char(f.data, 'dd/mm/yyyy hh24:mi:ss') datafechamento,
to_char(h.datahora, 'dd/mm/yyyy hh24:mi:ss') datareabertura
from
park2.fechamentoconsignacao f
join park2.contaagente ca
on f.id = ca.fechamento
join park2.historico h
on h.origem = ca.conta
where
ca.conta in (8553003)
and h.tipo = 'C'
and h.operacao = 'S'
and h.nomeoriginal = 'E'
AND f.data > h.datahora;
