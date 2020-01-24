SELECT * FROM lancamentosfront WHERE idnotaspdv = 49212809;

SELECT documento FROM lancamentosfront WHERE idconta = 19854039;

UPDATE lancamentosfront SET documento = REPLACE (documento,'+','') WHERE idlancamento = 91475105;

SELECT * FROM reservasfront WHERE numreserva = 180241974;

SELECT * FROM contasfront WHERE idreservasfront = 2304895;

COMMIT;

ROLLBACK;

 Alter user consulta identified by consulta;