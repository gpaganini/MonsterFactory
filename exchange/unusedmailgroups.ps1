#Distribution List comparison
Get-DistributionGroup -Resultsize unlimited | Select-Object PrimarySMTPAddress | Sort-Object PrimarySMTPAddress | Export-CSV DL-ALL.csv -notype
Get-MessageTrackingLog -Server srvad-a -EventId Expand -ResultSize Unlimited | Sort-Object RelatedRecipientAddress | Group-Object RelatedRecipientAddress | Sort-Object Name | Select-Object @{label=”PrimarySmtpAddress”;expression={$_.Name}}, Count | Export-CSV DL-Active-1.csv -notype
Get-MessageTrackingLog -Server srvad-a -EventId Expand -ResultSize Unlimited | Sort-Object RelatedRecipientAddress | Group-Object RelatedRecipientAddress | Sort-Object Name | Select-Object @{label=”PrimarySmtpAddress”;expression={$_.Name}}, Count | Export-CSV DL-Active-2.csv -notype
$DLall = import-csv -path .DL-All.csv
$L1 = import-csv -Path .DL-Active-1.csv
$L2 = import-csv -Path .DL-Active-2.csv
$Half = Compare-Object $DLall $L1 -Property PrimarySmtpAddress | where{$_.SideIndicator -eq “<=”} | Sort-Object PrimarySmtpAddress | Select-Object -Property PrimarySmtpAddress
Compare-Object $Half $L2 -Property PrimarySmtpAddress | where{$_.SideIndicator -eq “<=”} | Sort-Object PrimarySmtpAddress | Select-Object -Property PrimarySmtpAddress | Export-CSV DL-Inactive.csv -notype