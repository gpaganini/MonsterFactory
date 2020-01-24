SELECT
  i.numero ingresso,
  a.nome,
  To_Char(i.datahora,'dd/mm/yyyy hh24:mi:ss')
FROM
  ingresso i
  join consignacaoingresso ci
    ON i.numero = ci.ingresso
  join consignacao c
    ON ci.consignacao = c.numero
  join agente a
    ON c.agenteconsignatario = a.id
WHERE
  i.status = 'C'
  AND ci.datadevolucao IS NULL
  AND ci.origem = 2
ORDER BY
  i.datahora DESC,
  a.nome,
  i.numero;
