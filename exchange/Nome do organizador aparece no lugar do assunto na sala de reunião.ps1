    A Resource mailbox is configured to AutoAccept in an Microsoft Exchange Server or Office 365 environment.
    You send a meeting request to the Resource mailbox.
    The meeting request is accepted automatically, and the meeting subject is displayed correctly in the organizer’s mailbox.

In this scenario, when you log on to the Resource mailbox, you see that the meeting subject is replaced with the organizer’s name.

This is default behavior for Exchange Web Services and Office 365. 
It occurs because two configuration parameters, AddOrganizerToSubject and DeleteSubject are set to $True.

Solução:

1 - Connect to office365 powershell
2 - check settings:

	Get-CalendarProcessing -Identity <resourceMailbox>@aviva.com.br | FL

3 - Set -DeleteSubject and -AddOrganizerToSubject to $False

	Set-CalendarProcessing -Identity <resourceMailbox>@aviva.com.br -DeleteSubject $False -AddOrganizerToSubject $False

Fix'd
