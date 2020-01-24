SELECT *
FROM park2.lancamentoproduto where
datahora between to_date('01/05/2014 00:00:00','dd/mm/yyyy hh24:mi:ss') and to_date('30/05/2014 23:59:59','dd/mm/yyyy hh24:mi:ss') AND
datahoraintegracao IS NULL  AND (calcvalortotal <>0 OR valor <>0);

ORDER BY datahora;


select * from park2.lancamentoproduto where valor=0 and calcvalortotal=0 and datahoraintegracao is null and extract(year from datahora)=2014;



SELECT * FROM park2.security_systemuser WHERE  id=10024;

SELECT *
FROM park2.lancamentoproduto where
datahora between to_date('01/05/2014 00:00:00','dd/mm/yyyy hh24:mi:ss') and to_date('30/06/2014 23:59:59','dd/mm/yyyy hh24:mi:ss') AND
datahoraintegracao IS NULL

ORDER BY datahora;