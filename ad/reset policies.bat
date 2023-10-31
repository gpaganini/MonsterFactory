::Reset all policies

RD /S /Q "%WinDir%\System32\GroupPolicyUsers"
RD /S /Q "%WinDir%\System32\GroupPolicy"
secedit /configure /cfg %windir%\inf\defltbase.inf /db defltbase.sdb /verbo





veeam tcp - 2500-3300,49152-65535,2500-5000,137-139,445,6160-6162,6210,135,111,2049,6170,9401
veeam udp - 137-139,445,111,2049

10.96.0.1
10.96.0.2
10.96.0.5 - OK
10.96.0.7
10.96.0.8
10.96.0.10
10.96.0.11
10.96.0.12
10.96.0.13 - OK
10.96.0.14
10.96.0.15 - +- OK
10.96.0.16 - +- OK

10.76.0.11 - 
10.76.0.12 - OK

