select idreservasfront from reservasfront where numreserva=134048296 --> achar idreservasfront


select * from cartao where idreservasfront=1774099 --> ver dados da reserva

select * from pessoa where idpessoa=6262824 --> ver quem deu checkin/checkout usando o idpessoa
-------------------------------------------------------------------------------------------------------

SELECT
    p.nome checkin,
    p2.nome checkout,
    c.*
  FROM
    cartao c
    join pessoa p ON SubStr(c.trguserinclusao,3)=p.idpessoa
    join pessoa p2 ON c.idusuariocheckout =p2.idpessoa
  WHERE
    c.idcartao=6878198;
