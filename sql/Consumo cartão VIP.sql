SELECT
  *
  FROM
    mvlive.v_consumosCartaoVip
  WHERE
    cartao in (50024016)
  AND
    datahora
  BETWEEN
    To_Date('20/08/2017 00:00:00','dd/mm/yyyy hh24:mi:ss') AND
    To_Date('24/08/2017 23:59:59','dd/mm/yyyy hh24:mi:ss')
  order BY 1,2