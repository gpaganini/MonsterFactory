Select
   /*Lp.Numero,
   lf.idlancamento,
   lf.trgdtinclusao*/
   'update park2.lancamentoproduto set idvenda='||lf.idlancamento||',datahoraintegracao=to_date('''|| lf.trgdtinclusao||''',''Dd/Mm/Yyyy Hh24:Mi:Ss''),integrado=1 where numero='||lp.numero||';'
  From
    Park2.Lancamentoproduto@Dblinktravel Lp
    Join Park2.Conta@Dblinktravel Ct On Lp.Conta=Ct.Numero
    Join Lancamentospdv Lpdv On Ct.Contavhf||Lp.Numero||'       '||Lp.Numero=Lpdv.Seqtransacao
    join lancamentosfront lf on lpdv.idnotaspdv=lf.idnotaspdv
  Where
    --Lp.Datahoraintegracao Is Null And
    --lp.idvenda=0 and
    Lp.Integrado=0 And
    Lp.Datahora BETWEEN To_Date('01/05/2015 00:00:00','dd/mm/yyyy hh24:mi:ss') AND
                        To_Date('30/05/2015 23:59:59','dd/mm/yyyy hh24:mi:ss') And
    Lp.Naoiraintegrar Is Null;