SELECT
  idusuario,
  nomeusuario,
  nome
    FROM
      usuariosistema u
    join
      pessoa p
    ON
      u.idusuario = p.idpessoa
    WHERE
      nomeusuario
    IN
    ('EZIO',
     'VILMAURO',
     'RONIERY',
     'ALTIER.ALENCAR',
     'ANTONIO.BORGES',
     'PAULO.PASSOS',
     'KLAUS.MORAES',
     'EDUARDO.CACERE',
     'WILTON',
     'ADMARAES',
     'JOSEA',
     'MALVEZZI',
     'JULIANA.PEREIRA',
     'JOSEVALDO.SILVA',
     'PAULO.AMANCIO',
     'ANTONIO.SANTOS',
     'DAYANNE.SANTOS',
     'HIGOR.LIMA')