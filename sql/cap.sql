SELECT * FROM lotexdocum WHERE numlote='248175';


SELECT coddocumento, numlancto, plncodigo, operacao, flgcontabilizado FROM lanctodocum WHERE coddocumento IN ( SELECT coddocumento FROM lotexdocum WHERE numlote='248175') AND operacao='2';
SELECT * FROM planilha WHERE plncodigo='10709066';

SELECT nodocumento, compldocumento , plano, placonta FROM documento WHERE coddocumento IN (      SELECT coddocumento FROM lotexdocum WHERE numlote='248175');

