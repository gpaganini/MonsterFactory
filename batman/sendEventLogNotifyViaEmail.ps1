# -------------------------------------
# Ryadel.com - Powershell script to send an e-mail through the Event Viewer
# -------------------------------------
#
# To test this script you can use Powershell to write your own test error log entry in the following way:
# -------------------------------------
# New-EventLog –LogName Application –Source "Test"
# Write-EventLog –LogName Application –Source "Test" –EntryType Error –EventID 1 –Message "This is a test message."
 
$event = get-eventlog -LogName Security -Source "Microsoft-Windows-Security-Auditing" -newest 4624
#get-help get-eventlog will show there are a handful of other options available for selecting the log entry you want.
#example: -source "your-source"
 
# "Error" - send only error
if ($event.EntryType -eq "Error")
{
    $PCName = $env:COMPUTERNAME
    $EmailBody = $event | format-list -property * | out-string
    $EmailFrom = "$PCName <giovani.paganini@rioquenteresorts.com.br>"
    $EmailTo = "giovani.paganini@rioquenteresorts.com.br" 
    $EmailSubject = "New Event Log [Application]"
    $SMTPServer = "localhost"
    Write-host "Sending Email"
    Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -body $EmailBody -SmtpServer $SMTPServer
}
else
{
    write-host "No error found"
    write-host "Here is the log entry that was inspected:"
    $event
}