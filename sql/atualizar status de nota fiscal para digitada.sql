--Colocar o n�mero da nota no campo 'numdocumentoini' e ap�s executar o select, pegar o iddocumento correto,
--tendo em base o valor do documento e a data de emiss�o
SELECT
      dataemissao,
       flgstatusnfe,
       idempresa,
       vlrdocumento,
       iddocumento,
       protocolonfe,
       chavenfeletronica
    FROM
       LFDOCUMENTOFISCAL
    WHERE
       numdocumentoini='2303';

--Colocar o iddocumento desejado para alterar o status da nota para digitada
UPDATE
      LFDOCUMENTOFISCAL
    SET
      flgstatusnfe = '1' ,
      chavenfeletronica = '' ,
      protocolonfe= '',
      numeronfe= ''
    WHERE
      iddocumento ='4200896';


      COMMIT;

