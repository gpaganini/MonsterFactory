--ver ingresso com problema

SELECT
ag.nome as agente,
i.numero as ingresso,
ti.quantidadedias,
ti.baixasdia,
Count(*) AS baixas
FROM
park2.consignacao c
join park2.consignacaoingresso ci
ON c.numero = ci.consignacao
join park2.ingresso i
ON ci.ingresso = i.numero
join park2.tipoingresso ti
ON i.tipo = ti.id
join park2.ingressolancamento il
ON i.numero = il.ingresso
join park2.agente ag
on c.agenteconsignatario=ag.id
where
 exists (SELECT ag.id FROM PARK2.AGENTE ag WHERE ag.id = c.agenteconsignatario and UPPER(ag.NOME) LIKE 'MARIA DE FATIMA ESPIRITO GOULART%') AND
ci.datadevolucao IS NULL
AND i.status IN ('B','P')
GROUP BY
ag.nome,
i.numero,
ti.quantidadedias,
ti.baixasdia
HAVING
  COUNT(*)>TI.BAIXASDIA*TI.QUANTIDADEDIAS
ORDER BY
  ti.baixasdia DESC,i.numero;

--ver lançamentos

select * from park2.ingressolancamento where ingresso=10483010;

--ver a conta

select conta,numero as lancamento from park2.lancamentoproduto where numero in(31120538,31120536);