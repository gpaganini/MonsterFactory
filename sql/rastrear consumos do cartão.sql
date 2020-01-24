SELECT
    i.datahora,
    i.codcartao AS cartao,
    i.pdv,
    i.codproduto,
    i.qtd AS quantidade,
    p.nome AS produto
  FROM
      integrador.syncro_consumo i
        join pdv.produto p ON i.codproduto = p.id
  WHERE
      i.codcartao = 7516665;
