SELECT * FROM park2.lancamentoproduto WHERE numero = 35698853;

SELECT * FROM pdv.pdv WHERE id = 27;

UPDATE pdv.pdv SET customdata = '<PDV Id="24854" Desc="FRIGOBAR HOTEL TURISMO" PDVVinc="27" TpPDV="R" CodReduz="27" NumMesaIni="1" NumMesas="1" IdUsuario="5587576" LoginUsuario="ADEGMAR.FERREIRA" IdEmpresa="1" IdHotel="8484" Matricula="01210792" />' WHERE id = 27;

COMMIT;

SELECT * FROM pdv;

SELECT * FROM tipodebcredhotel WHERE descricao in ('FRIGOBAR HOTEL TURISMO');

SELECT * FROM pessoa WHERE idpessoa = 8484;

SELECT * FROM integracaopark WHERE datalancamento BETWEEN To_Date('01/05/2015 00:00:00','dd/mm/yyyy hh24:mi:ss') AND
                        To_Date('31/05/2015 23:59:59','dd/mm/yyyy hh24:mi:ss') AND
                        dataintegracao IS null

;