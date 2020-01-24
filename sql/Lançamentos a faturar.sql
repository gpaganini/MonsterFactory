SELECT * FROM park2.conta WHERE contavhf IS not NULL AND datahora BETWEEN To_Date('01/01/2010 00:00:00','dd/mm/yyyy hh24:mi:ss') AND
                                                                      To_Date('06/08/2014 23:59:59','dd/mm/yyyy hh24:mi:ss');

SELECT * FROM park2.cliente WHERE id=7622906;

EXEC  CM.PR_INSERECONTRATO (17603308)

select * FROM park2.cartao@dblinktravel WHERE  numero = 8189455;


SELECT * FROM park2.conta where numero = 9506220;

SELECT * FROM park2.lancamentoproduto WHERE conta = 8802364;

SELECT * FROM contasfront WHERE idforcli IN (8183719)  AND dataabertura = TO_DATE('17/08/2017 00:00:00','dd/mm/yyyy hh24:mi:ss');