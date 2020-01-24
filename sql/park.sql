-- Contas  para abertura

SELECT
    *
FROM
    park2.conta c
    join park2.lancamentoproduto lp ON c.numero=lp.conta
    join park2.lancamentorecebimento lr ON c.numero=lr.conta
WHERE
    lp.datahora BETWEEN Trunc(SYSDATE) AND SYSDATE AND
    lr.datahora BETWEEN Trunc(SYSDATE) AND SYSDATE AND
    NOT EXISTS (SELECT sc.conta FROM socios.socioconta sc WHERE sc.conta=c.numero);

--teste conta

SELECT
    Min(c.datahora)
FROM
    park2.conta c
    join park2.lancamentoproduto lp ON c.numero=lp.conta
    join park2.lancamentorecebimento lr ON c.numero=lr.conta
WHERE
   lp.datahora BETWEEN To_Date('01/05/2015 00:00:00','dd/mm/yyyy hh24:mi:ss') AND
                        To_Date('31/05/2015 23:59:59','dd/mm/yyyy hh24:mi:ss') AND

    lr.datahora BETWEEN To_Date('01/05/2015 00:00:00','dd/mm/yyyy hh24:mi:ss') AND
                        To_Date('31/05/2015 23:59:59','dd/mm/yyyy hh24:mi:ss') AND

                        c.contavhf = 0

    NOT EXISTS (SELECT sc.conta FROM socios.socioconta sc WHERE sc.conta=c.numero);

-- Descontos negativos

SELECT
    lp.numero,
    lp.integrado,
    hd.*
  FROM
    park2.lancamentoproduto lp
    join park2.historicodesconto hd ON lp.historicodesconto=hd.numero
  WHERE
    lp.datahora BETWEEN Trunc(SYSDATE) AND SYSDATE AND
    hd.valor <0 AND
    lp.integrado=0;

--Desabilitar produtos com desconto negativo para integração

EXEC park2.pr_DesabIntegDescNegativo;

--Total de contas encerradas
SELECT Count(*) FROM park2.encerramento WHERE datahora BETWEEN Trunc(SYSDATE) AND SYSDATE;

--Total de entrada no Park
      SELECT
        atr.nome AS atracao,
        Count(il.ROWID)
      FROM
        park2.ingressolancamento il
        join park2.ingresso i ON il.ingresso=i.numero
        join park2.tipoingresso ti ON i.tipo=ti.id
        join park2.atracao atr ON ti.atracao=atr.id
      WHERE
        datahorabaixa BETWEEN Trunc(SYSDATE) AND SYSDATE
      GROUP BY
        atr.nome;

--Total produtos pesquisando por data

SELECT
    CASE WHEN lp.datahoraintegracao IS NULL THEN 'N' ELSE 'S' END AS integrado,
      Count(lp.ROWID) AS qtd,
      Sum(Nvl(lp.calcvalortotal,lp.valor)) AS total
  FROM
    park2.lancamentoproduto lp
  WHERE
    lp.datahora BETWEEN To_Date('02/01/2017 00:00:00','dd/mm/yyyy hh24:mi:ss') AND
                        To_Date('02/01/2017 23:59:59','dd/mm/yyyy hh24:mi:ss') AND
    naoiraintegrar IS null
  GROUP BY
    CASE WHEN lp.datahoraintegracao IS NULL THEN 'N' ELSE 'S' END ;

--Total recebimentos por data

SELECT
    CASE WHEN lr.datahoraintegracao IS NULL THEN 'N' ELSE 'S' END AS integrado,
    count(lr.rowid) AS qtd,
    Sum(lr.valor) AS total
  FROM
    park2.lancamentorecebimento lr
  WHERE
    lr.datahora BETWEEN To_Date('02/01/2017 00:00:00','dd/mm/yyyy hh24:mi:ss') AND
                        To_Date('02/01/2017 23:59:59','dd/mm/yyyy hh24:mi:ss') AND
    lr.naoiraintegrar IS null
  GROUP BY
    CASE WHEN lr.datahoraintegracao IS NULL THEN 'N' ELSE 'S' END ;

--Estornos por data

SELECT
    CASE WHEN e.datahoraintegracao IS NULL THEN 'N' ELSE 'S' END AS integrado,
    Count(e.rowid) AS qtd
  FROM
    park2.estorno e
  WHERE
    e.datahora BETWEEN To_Date('01/06/2015 00:00:00','dd/mm/yyyy hh24:mi:ss') AND
                       To_Date('30/06/2015 23:59:59','dd/mm/yyyy hh24:mi:ss') AND
    e.naoiraintegrar IS NULL
  GROUP BY
    CASE WHEN e.datahoraintegracao IS NULL THEN 'N' ELSE 'S' END ;

--Status integração

--Produtos

SELECT
    CASE WHEN lp.datahoraintegracao IS NULL THEN 'N' ELSE 'S' END AS integrado,
      Count(lp.ROWID) AS qtd,
      Sum(Nvl(lp.calcvalortotal,lp.valor)) AS total
  FROM
    park2.lancamentoproduto lp
  WHERE
    lp.datahora BETWEEN Trunc(SYSDATE) AND SYSDATE AND
    naoiraintegrar IS null
  GROUP BY
    CASE WHEN lp.datahoraintegracao IS NULL THEN 'N' ELSE 'S' END ;

--Produtos não integrados

SELECT *
  FROM
    park2.lancamentoproduto lp
  WHERE
    lp.datahora BETWEEN To_Date('10/06/2014 00:00:00','dd/mm/yyyy hh24:mi:ss') AND
                        To_Date('10/06/2014 23:59:59','dd/mm/yyyy hh24:mi:ss') AND
    naoiraintegrar IS null   AND lp.datahoraintegracao IS NULL;

SELECT * FROM park2.conta WHERE numero=8090565;


--Recebimentos

SELECT
    CASE WHEN lr.datahoraintegracao IS NULL THEN 'N' ELSE 'S' END AS integrado,
    count(lr.rowid) AS qtd,
    Sum(lr.valor) AS total
  FROM
    park2.lancamentorecebimento lr
  WHERE
    lr.datahora BETWEEN Trunc(SYSDATE) AND SYSDATE AND
    lr.naoiraintegrar IS null
  GROUP BY
    CASE WHEN lr.datahoraintegracao IS NULL THEN 'N' ELSE 'S' END ;

--Estornos
SELECT
    CASE WHEN e.datahoraintegracao IS NULL THEN 'N' ELSE 'S' END AS integrado,
    Count(e.rowid) AS qtd
  FROM
    park2.estorno e
  WHERE
    e.datahora BETWEEN Trunc(SYSDATE) AND SYSDATE AND
    e.naoiraintegrar IS NULL
  GROUP BY
    CASE WHEN e.datahoraintegracao IS NULL THEN 'N' ELSE 'S' END ;



--Produtos sem cadastro VHF

SELECT distinct
    lp.pdv,
    lp.produto,
    lp.integrado
  FROM
    park2.lancamentoproduto lp
  WHERE
    datahora BETWEEN Trunc(SYSDATE) AND SYSDATE AND
    EXISTS (SELECT p.id FROM pdv.produto p WHERE lp.produto=p.id AND p.customdata IS null);

--Procedimento para corrigir erro de produto sem cadastro no VHF

EXEC park2.pr_DesabProdutoSemCadVHF;

--Ver conta

SELECT * FROM park2.conta WHERE numero=8052316;

SELECT * FROM park2.cliente WHERE id=7667169;

--ver conta passando id de fechamento

SELECT * FROM park2.fechamentoconsignacao WHERE id = 692;

--ver número do cartão passando o número da conta

SELECT numero as cartao, conta from park2.cartao where conta in ();

--tarifa ingreso

SELECT * FROM park2.tarifa where nome = '2014 - B2C';











