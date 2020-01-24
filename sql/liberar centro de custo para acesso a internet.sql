
SELECT * FROM intracessosw.respcentrocusto WHERE idpessoa = 5504182; --saber quais centro de custos um gestor tem acesso, passando o idpessoa da mesma

SELECT * FROM usuariosistema WHERE nomeusuario = 'EDSON.GONCALVES'; --saber o idpessoa/idusuario do gestor

--Depois o insert com o idpessoa e o código do centro de custo

INSERT INTO intracessosw.respcentrocusto (IDPESSOA,CODCENTROCUSTO) VALUES (5504182,'070602');


COMMIT;


