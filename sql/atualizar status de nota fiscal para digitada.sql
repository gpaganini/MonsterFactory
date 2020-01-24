--Colocar o número da nota no campo 'numdocumentoini' e após executar o select, pegar o iddocumento correto,
--tendo em base o valor do documento e a data de emissão
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

