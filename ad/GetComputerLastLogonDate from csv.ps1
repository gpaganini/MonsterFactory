import-module ActiveDirectory
$PcList = Import-Csv -Path ".\rqvccomputers.csv"

foreach ($Computer in $PcList) {
    Get-ADComputer -Identity $Computer.CN -Properties *  | Sort LastLogonDate | FT Name, LastLogonDate -Autosize
}