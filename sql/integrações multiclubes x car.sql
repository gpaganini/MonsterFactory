select
    case
        when coddocumentocm is null then 'N'
        else 'S'
      end as integrado,
      count(*)
  from
    multiclubes.MCintegracaoCAR IC
  where
    Transacao like 'Pagamento%' and
    coddocumentocm is null AND
    ic.datahora BETWEEN to_date('01/04/2016','dd/mm/yyyy') AND to_date('30/04/2016 23:59:59','dd/mm/yyyy hh24:mi:ss')
  group by
    case
        when coddocumentocm is null then 'N'
        else 'S'
      END

     -- certo

     select
    case
        when coddocumentocm is null then 'N'
        when coddocumentocm is not null then 'S'
      end as integrado,
      sum(ic.parcelas)
  from
    multiclubes.MCintegracaoCAR IC
  where
    Transacao like 'Pagamento%' and
    coddocumentocm is null AND
    ic.datahora BETWEEN to_date('01/04/2016','dd/mm/yyyy') AND to_date('30/04/2016 23:59:59','dd/mm/yyyy hh24:mi:ss')
  group by
    case
        when coddocumentocm is null then 'N'
        when coddocumentocm is not null then 'S'
      end