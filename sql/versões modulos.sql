SELECT * FROM versaopadrao WHERE idmodulo = 2;

SELECT * FROM modulo WHERE nomemodulo LIKE '%Global%';

INSERT INTO versaopadrao(idmodulo, versao) VALUES(2, '5.06.01a');

COMMIT;