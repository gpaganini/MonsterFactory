SELECT
    to_char(lf.datalancamento,'dd/mm/yyyy')||' '||To_Char(horalancamento,'hh24:mi:ss') AS datahoraconsumo,
    lf.trgdtinclusao AS datahoraintegracao,
    rf.numreserva,
    c.idcartao,
    dc.descricao AS pdv,
    p.descprod AS produto,
    lf.vlrlancamento,
    l.trgdtinclusao AS DataListaNegra
  FROM
    cartao c
        join contasfront cf ON c.idhospede=cf.idhospede
        join lancamentosfront lf ON cf.idconta=lf.idconta
        join lancamentospdv lp ON lf.idnotaspdv=lp.idnotaspdv
        join tipodebcredhotel dc ON lf.idtipodebcred=dc.idtipodebcred
        join artigo a ON lp.codartigo=a.codartigo
        join produto p ON a.codproduto= p.codproduto
        left join listanegracartao l ON  c.idcartao=l.idcartao
        left join reservasfront rf ON cf.idreservasfront=rf.idreservasfront
   WHERE
        c.idcartao = 6882899
   ORDER BY
        3,2,1
