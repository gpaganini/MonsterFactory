--Usado para descobrir o numero da planilha quando se tem o plncodigo:
SELECT * FROM cm.planilha WHERE plnplanil = 8881410

--Usado para descobrir o (Coddocumento) quando se tem o documento CM(nodocumento)
SELECT * FROM cm.documento WHERE nodocumento = '229370000'

UPDATE cm.movimfinanc SET idmodulo = 9 WHERE plncodigo IN (8904186),8904207),8829963,8829962,8829961,8829960,8829959,8829958)          --permite exclusão dos depositos
UPDATE cm.documento set idmodulo = 4 WHERE coddocumento IN (7133421),6541625,6521059,6520984,6516341)         --(Usa campo CODDOCUMENTOCM)  permite exclusão dos documentos

COMMIT

UPDATE cm.documento set idmodulo = 9 WHERE coddocumento IN (7133421),6541625,6521059,6520984,6516341)