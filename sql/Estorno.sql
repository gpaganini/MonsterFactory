--Ver dados da reserva
SELECT
  rf.numreserva,
  cf.idconta,
  cf.designacao,
  lf.documento,
  lf.idlancamento,
  lf.idnotaspdv,
  lf.vlrlancamento

  FROM
  lancamentosfront lf,
  contasfront cf,
  reservasfront rf

  WHERE
  rf.idreservasfront = cf.idreservasfront AND
  lf.idconta = cf.idconta AND
  lf.idnotaspdv IS NOT NULL AND
  --AND rf.idreservasfront =
  rf.numreserva =
  ORDER BY vlrlancamento ;

--Verificar se o produto está cadastrado
SELECT
    H.NOME AS HOTEL,
    pi.CODARTIGO,
    pr.descprod as produto,
    DC.DESCRICAO AS PDV,
    LP.IDMOTIVODEVOLUCAO
  FROM
    LANCAMENTOSPDV LP
    JOIN PESSOA H ON LP.IDHOTEL=h.IDPESSOA
    JOIN TIPODEBCREDHOTEL DC ON LP.IDTIPODEBCRED=DC.IDTIPODEBCRED and lp.idhotel=dc.idhotel
    LEFT JOIN PDVITEM PI ON LP.IDHOTEL=PI.IDHOTEL AND LP.IDTIPODEBCRED=PI.IDTIPODEBCRED AND LP.CODARTIGO=PI.CODARTIGO
    left JOIN PRODUTO PR ON pi.CODARTIGO=PR.CODPRODUTO
  WHERE
    idnotaspdv=39874821;

--Corrige erro ao estornar todos os itens de uma conta no VHF
EXEC cm.pr_estornocontafront(NUMERO DA CONTA);

--Corrige erro ao estornar item no VHF
EXEC cm.pr_estornoitemfront(IDNOTAPDV);

