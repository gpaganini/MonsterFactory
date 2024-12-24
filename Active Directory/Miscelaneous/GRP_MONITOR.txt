PsExec \\SRVRQEAD02
PsExec \\SRVAD-C
PsExec \\SRVAD-D
PsExec \\SRVRQE950005


"C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" -command "C:\GRP_Monitor\Monitor-ADGroupMembership.ps1 -group \"Domain Admins\" -Emailfrom \"group.monitor@rioquenteresorts.com.br\" -Emailto \"gustavo.loge@rioquenteresorts.com.br\" -Emailserver \"mail.grq.com.br\"" -verbose

ad-a
"C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" -command "C:\Windows\SYSVOL_DFSR\sysvol\rqr.com.br\scripts\GRP_Monitor\Monitor-ADGroupMembership.ps1 -group \"Domain Admins\" -Emailfrom \"group.monitor@rioquenteresorts.com.br\" -Emailto \"gustavo.loge@rioquenteresorts.com.br\" -Emailserver \"mail.grq.com.br\"" -verbose

ad02
PsExec \\SRVRQEAD02 "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" -command "C:\Windows\SYSVOL\sysvol\rqr.com.br\scripts\GRP_Monitor\Monitor-ADGroupMembership.ps1 -group \"Domain Admins\" -Emailfrom \"group.monitor@rioquenteresorts.com.br\" -Emailto \"gustavo.loge@rioquenteresorts.com.br\" -Emailserver \"mail.grq.com.br\"" -verbose

ad-c
PsExec \\SRVAD-C "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" -command "H:\AD\SYSVOL\sysvol\rqr.com.br\scripts\GRP_Monitor\Monitor-ADGroupMembership.ps1 -group \"Domain Admins\" -Emailfrom \"group.monitor@rioquenteresorts.com.br\" -Emailto \"gustavo.loge@rioquenteresorts.com.br\" -Emailserver \"mail.grq.com.br\"" -verbose

ad-d
PsExec \\SRVAD-D "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" -command "C:\Windows\SYSVOL\sysvol\rqr.com.br\scripts\GRP_Monitor\Monitor-ADGroupMembership.ps1 -group \"Domain Admins\" -Emailfrom \"group.monitor@rioquenteresorts.com.br\" -Emailto \"gustavo.loge@rioquenteresorts.com.br\" -Emailserver \"mail.grq.com.br\"" -verbose

950005
PsExec \\SRVRQE950005 "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" -command "C:\Windows\SYSVOL\sysvol\rqr.com.br\scripts\GRP_Monitor\Monitor-ADGroupMembership.ps1 -group \"Domain Admins\" -Emailfrom \"group.monitor@rioquenteresorts.com.br\" -Emailto \"gustavo.loge@rioquenteresorts.com.br\" -Emailserver \"mail.grq.com.br\"" -verbose