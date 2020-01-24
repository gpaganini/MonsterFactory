SELECT
p.id idcaixa,
pm.document,
pm.id idrecebimento,
pe.NAME nomepessoa,
(SELECT b.rid FROM travel.batchs@dblinktravel  b WHERE b.id = p.batch AND b.lastversion = 1 AND b.trash = 0) lote,
p.rid caixa,
p.rid || LPad(pm.payment_idx,3,0)AS nodocumentocm,
(SELECT d.coddocumento FROM cm.documento d WHERE p.rid || LPad(pm.payment_idx,3,0) = d.nodocumento AND d.idmodulo = 14 AND d.idusuarioinclusao = 15) coddocumentocm,

pm.document documentoinformadocaixa,
t.nome tipoderecebimento,
pm.value valor,
To_Char(pm.due,'dd/mm/yyyy') vencimento,
(SELECT d.nodocumento FROM cm.documento d WHERE p.rid || LPad(pm.payment_idx,3,0) = d.nodocumento AND d.idmodulo = 14 AND d.idusuarioinclusao = 15) documentocm,


(SELECT pl.plnplanil FROM cm.planilha pl WHERE pl.plncodigo = (SELECT l.plncodigo FROM cm.lancamento l WHERE l.lacnumdoc = To_Char(p.rid || LPad(pm.payment_idx,3,0)) AND l.idmodulo = 14 AND
l.idusuarioinclusao = 15 AND Upper(l.lachist1) LIKE 'DOC%' AND l.lacdebcre = 'C' AND ((l.lacvalor = pm.Value) OR (l.lacvalor *(-1) = pm.Value)))) PLANILHA,

(SELECT pl.plncodigo FROM cm.planilha pl WHERE pl.plncodigo = (SELECT l.plncodigo FROM cm.lancamento l WHERE l.lacnumdoc = To_Char(p.rid || LPad(pm.payment_idx,3,0)) AND l.idmodulo = 14 AND
l.idusuarioinclusao = 15 AND Upper(l.lachist1) LIKE 'DOC%' AND l.lacdebcre = 'C' AND ((l.lacvalor = pm.Value) OR (l.lacvalor *(-1) = pm.Value)))) plncodigo,


(SELECT pl.plndatdia FROM cm.planilha pl WHERE pl.plncodigo = (SELECT l.plncodigo FROM cm.lancamento l WHERE l.lacnumdoc = p.rid || LPad(pm.payment_idx,3,0) AND l.idmodulo = 14 AND
l.idusuarioinclusao = 15 AND Upper(l.lachist1) LIKE 'DOC%' AND l.lacdebcre = 'C' AND ((l.lacvalor = pm.Value) OR (l.lacvalor *(-1) = pm.Value)))) DATAPLANILHA,
(SELECT l.PLACONTA FROM cm.lancamento l WHERE l.lacnumdoc = p.rid || LPad(pm.payment_idx,3,0) AND l.idmodulo = 14 AND
l.idusuarioinclusao = 15 AND Upper(l.lachist1) LIKE 'DOC%' AND l.lacdebcre = 'C' AND ((l.lacvalor = pm.Value) OR (l.lacvalor *(-1) = pm.Value))) CONTACREDITO,

(SELECT l.PLACONTA FROM cm.lancamento l WHERE l.lacnumdoc = p.rid || LPad(pm.payment_idx,3,0) AND l.idmodulo = 14 AND
l.idusuarioinclusao = 15 AND Upper(l.lachist1) LIKE 'DOC%' AND l.lacdebcre = 'D'AND ((l.lacvalor = pm.Value) OR (l.lacvalor *(-1) = pm.Value))) CONTADEBITO

FROM
travel.payments@dblinktravel  p,
travel.paymentmethods@dblinktravel  pm,
travel.tags@dblinktravel  t,
travel.persons@dblinktravel pe
WHERE
p.rid IN (455380) AND
pm.person = pe.id(+) and
p.id = pm.payment_id AND
pm.tag = t.id AND
p.lastversion = 1 AND
p.trash = 0

--Habilitar doc no CFinan para exclusao
UPDATE cm.movimfinanc SET idmodulo = 9 WHERE plncodigo IN (11755382,11769305,11778806,11778792,11778816,11778797,11778815,11771706,11771829,11778817,11771708,11779123,11771719,11778776,11779149,11778776);          --permite exclusão dos depositos
--(Usa campo CODDOCUMENTOCM) (Contas a Receber)  permite exclusão dos documentos
UPDATE cm.documento set idmodulo = 4 WHERE coddocumento IN (8989070);
--Possibilitar a exclusão no CAP (Contas a Pagar)
UPDATE cm.documento SET idmodulo = 3 WHERE coddocumento IN (8301304);

SELECT * FROM modulo WHERE idmodulo IN (3,4,9);

--Saber os dados para colocar na hora de excluir o caixa
SELECT * FROM travel.agentpayments@dblinktravel WHERE payment = (SELECT p.id FROM travel.payments@dblinktravel p
WHERE p.rid = 455014  AND p.lastversion = 1)

SELECT * FROM travel.users@dblinktravel WHERE id = 48474;

SELECT * FROM usuariosistema WHERE idusuario = 48474;

SELECT * FROM pessoa WHERE idpessoa = 48474;

SELECT * FROM cm.documento WHERE nodocumento = '1023639';

--docs do netsuite

SELECT * FROM cm.movimfinanc WHERE   idmodulo = 4 AND DATALANCFINAN >= TO_DATE('08/10/2010','DD/MM/YYYY')  AND NUMCHQBORDERO in (1006016);

COMMIT;

SELECT * FROM planilha WHERE plntotdeb = 258 AND plndatdia  BETWEEN To_Date('30/07/2014 00:00:00','dd/mm/yyyy hh24:mi:ss') AND
                                                                      To_Date('30/07/2014 23:59:59','dd/mm/yyyy hh24:mi:ss');

--saber o plncódigo passando o numero da planilha após consultar no Contab
SELECT * FROM planilha WHERE plnplanil = 19047 AND plndatdia  BETWEEN To_Date('11/04/2014 00:00:00','dd/mm/yyyy hh24:mi:ss') AND
                                                                      To_Date('11/04/2014 23:59:59','dd/mm/yyyy hh24:mi:ss');