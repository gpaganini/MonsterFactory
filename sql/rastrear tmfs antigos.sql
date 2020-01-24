select
    c.local,
    c.cartao,
    c.sequencia,
    c.tmf,
    c.datahora,
    c.datahorainclusao,
    pdv.nome,
    case
      when c.quantidade >0 then 'N'
      when c.quantidade <0 then 'S'
    end as estorno,
    c.vendedor as matricula,
    v.loginusuario,
    Pr.Nome As Produto,
    C.quantidade,
    Park2.Produtopreco(C.produto,C.Datahorainclusao) As Valorunitario,
    Park2.Produtopreco(C.produto,C.Datahorainclusao)* c.quantidade as valortotal
  from
    pdv.consumo c
    join pdv.pdv on c.pdv=pdv.id
    left join pdv.produto pr on c.produto=pr.id
    left join
      (select distinct
          matricula,
          loginusuario
        from
          integrador.syncro_pdv) v on c.vendedor=v.matricula
  where
    datahora between to_date('24/09/2010','dd/mm/yyyy') and to_date('14/08/2017','dd/mm/yyyy')
    AND v.matricula = '01210293';



