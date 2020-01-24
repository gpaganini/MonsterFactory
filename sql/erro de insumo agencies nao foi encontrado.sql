--ver se o caminho já foi setado no insumo criado no valet passando o ID
SELECT *FROM centraldistribuicao.insumo WHERE id = 10021

--se o caminho for null executar esse update passando o caminho que deu erro no travel e o ID do insumo no valenet
UPDATE centraldistribuicao.insumo SET caminho = 'agencies/13346/services[1046]' WHERE id = 10021;

COMMIT;


