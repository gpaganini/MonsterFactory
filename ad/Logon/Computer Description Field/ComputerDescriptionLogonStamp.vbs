Option Explicit
On Error Resume Next
Dim oNetwork : Set oNetwork = Wscript.CreateObject("WScript.Network")
Dim oShell : Set oShell = Wscript.CreateObject("Wscript.Shell")
Dim oADS : Set oADS = CreateObject("ADSystemInfo")
Dim sUserName : sUserName = oNetwork.UserName
Dim sUserDomain : sUserDomain = oNetwork.UserDomain
Dim sSiteName : sSiteName = oADS.SiteName
If Err Then
	sSiteName = "Unknown"
	Err.Clear
End If
Dim sDescription : sDescription = "" & sUserName & "|" & Date & "|" & Left(Time,5) & "|"
Dim sProductType : sProductType = oShell.RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ProductOptions\ProductType")
If sProductType <> "WinNT" Then
 sDescription = sDescription & "SNMP: " & IsServiceInstalled("SNMP") & " | "
Else
	sDescription = sDescription & "" & sSiteName & "|" & sUserDomain & "|"
End If
Dim oComputer : Set oComputer = GetObject("LDAP://" & oADS.ComputerName)
oComputer.Put "description", sDescription
oComputer.SetInfo

Function IsServiceInstalled(sService)
On Error Resume Next
Dim oWMI : Set oWMI = GetObject("winmgmts:\\.\root\cimv2")
If Err Then
	IsServiceInstalled = "WMI connection failed"
	Err.Clear : Exit Function
End If
Dim oService : Set oService = oWMI.Get("Win32_Service.Name='" & sService & "'")
If Err Then
	IsServiceInstalled = Trim(Replace(Err.Description, vbcrlf, " - "))
	Err.Clear : Exit Function
Else
	IsServiceInstalled = oService.State
End If
End Function