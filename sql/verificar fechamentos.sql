Select
      Bbb.Id as numBoleto,
      Bbb.Recebido as recebidoBoleto,
      Bbb.Vencimento,
      Bbb.Valor,
      fc.id as numFechamento,
      fc.recebido as recebidoFechamento
    From
      Park2.Boletobancobrasil Bbb
      join park2.fechamentoConsignacao fc on bbb.fechamento=fc.id
    Where
     -- bbb.fechamento in (select f.id from park2.fechamentoconsignacao f where f.agente = 21369) and
      fc.recebido is  null and bbb.recebido is null AND fc.id = 4247
    Order By
      bbb.datahora;