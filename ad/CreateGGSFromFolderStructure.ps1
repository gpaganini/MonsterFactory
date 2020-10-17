$folders = get-childitem -Path "\\srvrqe941010\d$\Unidade - Rio Quente Resorts\Intersecao\IS_PlanejamentoFinanceiro_Orc\PACOTE\" | Select Name

foreach ($folder in $folders) {
      $ggsRw = "GGS_FS_RQR_IS_PlanejamentoFinanceiro_Orc_"+$folder.Name+"_RW"
      New-ADGroup -name $ggsRw -DisplayName $ggsRw -SamAccountName $ggsRw -GroupCategory Security -GroupScope Global -Path "OU=FS Rio Quente,OU=Grupos,OU=Unidade Rio Quente,DC=aviva,DC=com,DC=br"
      $ggsRo = "GGS_FS_RQR_IS_PlanejamentoFinanceiro_Orc_"+$folder.Name+"_RO"
      New-ADGroup -name $ggsRo -DisplayName $ggsRo -SamAccountName $ggsRo -GroupCategory Security -GroupScope Global -Path "OU=FS Rio Quente,OU=Grupos,OU=Unidade Rio Quente,DC=aviva,DC=com,DC=br"    
}