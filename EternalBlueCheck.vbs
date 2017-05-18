' Checks if the computer is vulnerable to EternalBlue
'
'	Author: Cassius Puodzius
'	Rev: @Underdog1987

Dim KBList
Set KBList = CreateObject("System.Collections.ArrayList")

' Microsoft Security Bulletin MS17-010
' ref: https://technet.microsoft.com/library/security/MS17-010

' Your comupter is patched if you install one or more of netxt Fixes

KBList.Add "4012212"
KBList.Add "4012213"
KBList.Add "4012214"
KBList.Add "4012215"
KBList.Add "4012216"
KBList.Add "4012217"
KBList.Add "4012598"
KBList.Add "4012606"
KBList.Add "4013198"
KBList.Add "4013429"


' Windows 10 and Windows Server 2016 updates are cumulative.
' The monthly security release includes all security fixes for vulnerabilities that affect Windows 10, in addition to non-security updates.

' Cumulative KBs for Windows 10 and Windows Server 2016:
'
' From KB4012606
' ref: http://www.catalog.update.microsoft.com/ScopedViewInline.aspx?updateid=6a38fe85-98ba-4ce2-b4eb-aed947d5c203
' As of May 17, 2017:
'
'	2017-05 Cumulative Update for Windows 10 for x86-based Systems (KB4019474)
'	Cumulative Update for Windows 10 (KB4015221)
'	Cumulative Update for Windows 10 (KB4016637)
'

KBList.Add "4019474"
KBList.Add "4015221"
KBList.Add "4016637"

' From KB4013198
' ref: http://www.catalog.update.microsoft.com/ScopedViewInline.aspx?updateid=6d9f75f7-d998-4188-a935-7603f4e51a4d
' As of May 17, 2017:
'
'	Cumulative Update for Windows 10 Version 1511 (KB4015219)
'	Cumulative Update for Windows 10 Version 1511 (KB4016636)
'	Cumulative Update for Windows 10 Version 1511 (KB4019473)
'

KBList.Add "4015219"
KBList.Add "4016636"
KBList.Add "4019473"

' From KB4013429
' ref: http://www.catalog.update.microsoft.com/ScopedViewInline.aspx?updateid=724ee219-b949-4d44-9e02-e464c6062ae4
' As of May 17, 2017:
'
'	2017-05 Cumulative Update for Windows 10 Version 1607 for x86-based Systems (KB4019472)
'	Cumulative Update for Windows 10 Version 1607 (KB4015217)
'	Cumulative Update for Windows 10 Version 1607 (KB4015438)
'	Cumulative Update for Windows 10 Version 1607 (KB4016635)
'

KBList.Add "4015217"
KBList.Add "4015438"
KBList.Add "4016635"

' KBList.Add "99999999" 'more fixes goes here

Set WshShell = CreateObject("WScript.Shell")

WshShell.Popup "Fetching list of installed KBs" & vbcrlf & vbcrlf & "This may take some minutes... (Clic OK to start)", 5, "Vulnerable to EternalBlue?", vbOKOnly

'WshShell.Run "cmd /c wmic qfe list | clip", 0, True
WshShell.Run "cmd /c wmic qfe list > %USERPROFILE%\kbs.txt", 0, True

dim fso, f, content
Set fso = CreateObject("Scripting.FileSystemObject")

' Create a .txt file with installed updates
Set f = fso.OpenTextFile(WshShell.ExpandEnvironmentStrings("%USERPROFILE%") & "\kbs.txt", 1, False, -1)
content = f.ReadAll
f.close

Dim patched ' Already patched?
patched = False
For Each kb In KBList
	If InStr(content, "KB" & kb) > 0 Then
		MsgBox("Your computer is patched against EternalBlue (KB" & kb & ")"), vbInformation, "Success"
		patched = True
		Exit For
	End If
Next

if Not patched Then
	MsgBox("Your computer is NOT patched against EternalBlue"), vbCritical, "Warning!"
end if

If MsgBox ("Clic OK to view all installed updates", vbYesNo + vbQuestion, "Question") = vbYes then
	WshShell.Run "notepad " & WshShell.ExpandEnvironmentStrings("%USERPROFILE%") & "\kbs.txt"
end if
		