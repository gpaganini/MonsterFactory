 select securitysy0_.NOME as x0_0_, securitysy2_.NOME as x1_0_ from Park2.SECURITY_SYSTEMUSER securitysy0_, Park2.SECURITY_SYSTEMGRUPOUSER securitysy1_, Park2.SECURITY_SYSTEMGRUPO securitysy2_ where (securitysy1_.SECURITY_SYSTEMUSER=securitysy0_.ID )and(securitysy2_.NUMERO=securitysy1_.SECURITY_SYSTEMGRUPO )and(securitysy1_.SECURITY_SYSTEMGRUPO=39 );

SELECT
*
FROM
park2.security_systemuser u
join park2.security_systemgrupouser g
ON u.id = g.security_systemuser
WHERE
u.status = 'I'
AND g.security_systemgrupo = 39
ORDER BY 3;

SELECT * FROM park2.security_systemuser WHERE nome = 'ana.k';


SELECT * FROM park2.security_systemgrupoagente WHERE agente = 15774;

SELECT * FROM park2.security_systemgrupouser WHERE security_systemgrupo = 39;

SELECT * FROM park2.security_systemgrupouser WHERE security_systemuser = 15774;

SELECT * FROM park2.security_systemuseragente WHERE security_systemuser = 15774;

SELECT * FROM park2.agente WHERE nome LIKE '%ANA KAROLINE%';

SELECT * FROM park2.security_systemgrupo;

SELECT * FROM park2.security_systemuser;

SELECT * FROM park2.agente;

SELECT id,nome FROM park2.agente a join park2.security_systemgrupouser s
ON a.security_systemuser = s.security_systemuser
WHERE s.security_systemgrupo = 39 ORDER BY 2;

SELECT * FROM park2.agente;

SELECT * FROM park2.security_systemgrupousuario;

SELECT * FROM park2.gruporecebimento;


