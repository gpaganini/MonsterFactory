SELECT
idtipodebcred,
descricao,
obrigadocum,
codreduzido,
debitocredito,
principalsecundar,
idprincipal,
cobrartaxa
FROM tipodebcredhotel WHERE descricao = 'CIELO MASTER PARCELADO' AND idhotel = 8484;

SELECT * FROM park2.tiporecebimento WHERE id = 408;

UPDATE park2.tiporecebimento
SET
customdata = '<TipoDC Id="1815" Desc="CIELO MASTER A VISTA" ObrDocum="S" PDVVinc="" TpPDV="" CodReduz="CMV" DebCred="C" PrincSec="S" IdPrinc="623" CobrTx="N" PercTxServPDV="0" IdEmpresa="1" />'
WHERE id = 412;