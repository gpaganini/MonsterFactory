SELECT
    p.nome,
    T.NUMERO AS TITULO,
    SC.conta,
    c.status
  FROM
    SOCIOS.TITULO T
    JOIN SOCIOS.SOCIO S ON T.ID=S.TITULO
    JOIN CORE.PESSOA P ON S.PESSOA=P.ID
    JOIN SOCIOS.SOCIOCONTA SC ON S.ID=SC.SOCIO
    join park2.conta c on sc.conta=c.numero
  WHERE
    T.NUMERO in (1079) AND
    c.status='A'
  order by 2,1;

