SELECT distinct co.seqconsumo,
  (select pdvvinc from integrador.syncro_pdv p2 where p2.pdvvinc=co.pdv and rownum=1) as codpdv,
  (select descr from integrador.syncro_pdv p2 where p2.pdvvinc=co.pdv and rownum=1) as pdv,
    case
      when co.estornado is null then 'N'
      else co.estornado
    end estornado,
    co.matricula,
    (select loginusuario from integrador.syncro_pdv p2 where p2.matricula=co.matricula and rownum=1) as usuario,
    a.codartigo,
    a.descprod,
    co.qtd,
       (SELECT
        hp.valor
      FROM
        pdv.preco hp
      WHERE
        hp.produto=co.codproduto AND
        hp.data=(SELECT
                      Max(data)
                    FROM
                      pdv.preco hp2
                    WHERE
                      co.codproduto=hp2.produto AND
                      co.datahora>hp2.data)) AS precounitario,
   (SELECT
        hp.valor
      FROM
        pdv.preco hp
      WHERE
        hp.produto=co.codproduto AND
        hp.data=(SELECT
                      Max(data)
                    FROM
                      pdv.preco hp2
                    WHERE
                      co.codproduto=hp2.produto AND
                      co.datahora>hp2.data)) *co.qtd as valortotal,
   to_char(co.datahora,'dd/mm/yyyy hh24:mi:ss') as datahora,
   co.terminal
  from
   integrador.syncro_consumo co

   left join integrador.syncro_artigo a on
     co.codproduto=a.codartigo

  where
    estorno='N' and
    co.datahora BETWEEN To_Date('22/12/1999 00:00:00','dd/mm/yyyy hh24:mi:ss') AND
                        To_Date('07/12/2016 23:59:59','dd/mm/yyyy hh24:mi:ss') AND co.matricula = '01206353'
                    --  AND To_Date(co.datahora, 'hh24:mi:ss') BETWEEN To_Char('15:38:00', 'hh24:mi:ss') AND To_Char('23:59:59', 'hh24:mi:ss')
ORDER by 1