SELECT ra_nome,ra_nasc,ra_email,ra_mat,ra_cc,q3_descsum,
		CASE
			WHEN upper(q3_descsum) LIKE 'ANALIST%' THEN 'ANALISTA'
			WHEN upper(q3_descsum) LIKE 'SUP%' THEN 'SUPERVISOR'
			WHEN upper(q3_descsum) LIKE 'COORD%' THEN 'COORDENADOR'
			WHEN upper(q3_descsum) LIKE 'GER%' THEN 'GERENTE'
			WHEN upper(q3_descsum) LIKE 'DIR %' THEN 'DIRETOR'
			WHEN upper(q3_descsum) LIKE 'ASS EXP%' THEN 'GERENTE'
			WHEN upper(q3_descsum) LIKE 'COMPRADOR%' THEN 'ANALISTA'
			WHEN upper(q3_descsum) LIKE 'ADVOGADO%' THEN 'ANALISTA'
			ELSE 'OPERACAO'
		END AS FUNCAO
FROM 
	siga.sra010
	JOIN SQ3010 on RA_CARGO=Q3_CARGO AND trim(Substr(RA_FILIAL,3))=trim(Q3_filial)
WHERE
	RA_DEMISSA ='        '
ORDER BY 
	6;