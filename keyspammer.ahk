;#SingleInstance off
;The following code is written by an amateur so please don't judge (but it works so i'm happy)
currentver = 1.4
currentver += 0.0

ConnectedToInternet(flag=0x40) { 
Return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag,"Int",0) 
}
If ConnectedToInternet()
{
	Gui, New,, Updater
	Gui, Font, s12 W700 cWhite
	Gui, Color, 505050
	Gui, Add, Text,, Searching for updates...
	Gui, Add, Progress, w185 h20 cFFD700 vUpdateProg
	Gui, Show
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "https://raw.githubusercontent.com/Elipse458/AHK-Keyspammer/master/version.txt", true)
	whr.Send()
	whr.WaitForResponse()
	remoteversion := whr.ResponseText
	remoteversion1 := remoteversion
	remoteversion += 0.0
	GuiControl,, UpdateProg, +25
	if ("" . remoteversion = currentver)
	{
		GuiControl,, UpdateProg, 100
		MsgBox, No updates found!
		Gui, Destroy
	}
	else
	{
		MsgBox, Updating to version %remoteversion1%
		UrlDownloadToFile, https://raw.githubusercontent.com/Elipse458/AHK-Keyspammer/master/keyspammer.ahk, %A_WorkingDir%\keyspammer1.ahk
		GuiControl,, UpdateProg, +25
		UrlDownloadToFile, https://raw.githubusercontent.com/Elipse458/AHK-Keyspammer/master/updatescript.txt, %A_WorkingDir%\updatescript.bat
		GuiControl,, UpdateProg, +25
		Run %A_WorkingDir%\updatescript.bat
		GuiControl,, UpdateProg, +25
		Sleep, 1000
		ExitApp
	}
}
else
{
	Gui, New,, Updater
	Gui	, Font, s12 W700 cWhite
	Gui, Color, 505050
	Gui, Add, Text,, Searching for updates...
	Gui, Add, Progress, w185 h20 cFFD700 vUpdateProg cRed
	Gui, Show
	GuiControl,, UpdateProg, 100
	MsgBox, No internet connection!
	Gui, Destroy
}
;----------------------------------------------------------------------------------------------------------------------------------------------------;
;^                                                                     UPDATER                                                                       ^
;----------------------------------------------------------------------------------------------------------------------------------------------------;
DetectHiddenWindows, On
SetWorkingDir %A_WorkingDir%
press = 0
input = 0
startstop = 0
startstop1 := off
oldtogglekey = 
Gui(){
global
Gui, New,, KeySpammer Settings
Gui, Color, 505050
Gui, Add, Text, cWhite, Delay
Gui, Add, Edit, vinput
Gui, Add, Text, cWhite, Key to spam
Gui, Add, DDL, vspamddl gspamddl Choose1, Other|LMB|RMB
Gui, Add, Hotkey, vspamkey X140 Y71
Gui, Add, Text, cWhite X10, Key to toggle spam
Gui, Add, DDL, vtoggleddl gtoggleddl Choose1, Other|Mb4|Mb5
Gui, Add, Hotkey, vtogglekey X140 Y117
Gui, Add, Button, X10 Y194 gButtonDone, Done
Gui, Add, Button, X53 Y194 gButtonReset, Reset
IfExist, KeySpammer.ini
{
	IniRead, presetlist, KeySpammer.ini
	StringReplace,presets,presetlist,`n,|,A
	Gui, Font, W500, s6
	Gui, Add, DDL, vpresetddl gpresetload X140 Y25 W116, %presets%
}
Gui, Add, Button, X98 Y194 gButtonSavePreset, Save Preset
Gui, Add, Text, X300 Y195, v1.4`nBy Elipse458
Gui, Font, W700 s12
Gui, Add, Text, c9999FF X275 Y5, F1+Esc - `nemergency`nexit`nF2 - menu`nF3 - info`nF4 - info off
Gui, Show, Center W375 H225
}
Gui()
$~F3::goto infoon
$~F4::goto infooff
$~F2::Gui()
F1 & Esc::ExitApp
Pause

toggleddl:
GuiControlGet, toggleddl,, toggleddl
togglekey = 
If toggleddl = Other
{
GuiControl, Enable, togglekey
}
else if toggleddl = Mb4
{
GuiControl, Disable, togglekey
togglekey = XButton1
}
else if toggleddl = Mb5
{
GuiControl, Disable, togglekey
togglekey = XButton2
}
Return

spamddl:
GuiControlGet, spamddl,, spamddl
spamkey =
If spamddl = Other
{
GuiControl, Enable, spamkey
}
else if spamddl = LMB
{
GuiControl, Disable, spamkey
spamkey = Click
}
else if spamddl = RMB
{
GuiControl, Disable, spamkey
spamkey := Click Right
}
Return

ButtonDone:
Gui, Submit, NoHide
togglekey1:= togglekey
spamkey1:= spamkey
If toggleddl = Mb4
{
	togglekey = XButton1
	togglekey1 = Mb4
}
else if toggleddl = Mb5
{
	togglekey = XButton2
	togglekey1 = Mb5
}
If spamddl = LMB
{
	spamkey = Click
	spamkey1 = LMB
}
else if spamddl = RMB
{
	spamkey :="Click Right"
	spamkey1 = RMB
}
If (input="") or (spamkey="") or (togglekey="")
{
MsgBox, None of the fields can be empty!
Return
}
else if input is number
{
if oldtogglekey
{
Hotkey, $~%oldtogglekey%, Off
}
sleeptime := input * 1000
Hotkey, $~%togglekey%, startstop
oldtogglekey := togglekey
MsgBox, Delay is %sleeptime%ms - Key to spam %spamkey1% - Key to toggle spam %togglekey1%
}
else
{
MsgBox, Delay must be a number!
}
Return

ButtonReset:
GuiControl, , input
GuiControl, , spamkey
GuiControl, , togglekey
input=""
spamkey=""
togglekey=""
Return

ButtonSavePreset:
gosub, ButtonDone
inispamkey := spamkey1
initogglekey := togglekey1
InputBox, presetname, Name of preset
If (input="") or (inispamkey="") or (initogglekey="") or (presetname="")
{
	MsgBox, None of the fields or preset name can be empty!
	Return
}
else
{
	if (not inispamkey)
		inispamkey = spamkey
	if (not initogglekey)
		initogglekey = togglekey
	IniWrite, %inispamkey%, KeySpammer.ini, %presetname%, spamkey
	IniWrite, %initogglekey%, KeySpammer.ini, %presetname%, togglekey
	IniWrite, %input%, KeySpammer.ini, %presetname%, delay
	MsgBox, Preset saved!`nClose the settings window and press F2 to see your new preset.
	Return
}
Return

presetload:
GuiControlGet, presetddl,, presetddl
IniRead, inidelay, KeySpammer.ini, %presetddl%, delay
IniRead, inispamkey, KeySpammer.ini, %presetddl%, spamkey
IniRead, initogglekey, KeySpammer.ini, %presetddl%, togglekey
If (inidelay="") or (inispamkey="") or (initogglekey="") or (inidelay is not number)
{
	MsgBox, Preset could not be loaded!`nSome key values are missing or are corrupted.
	Return
}
else
{
	input=inidelay
	if (inispamkey="LMB") or (inispamkey="RMB")
	{
		if inispamkey = LMB
		{
			GuiControl, Choose, spamddl, 2
			gosub, spamddl
		}
		if inispamkey = RMB
		{
			GuiControl, Choose, spamddl, 3
			gosub, spamddl
		}
	}
	else
	{
		spamkey=inispamkey
		GuiControl,, spamkey, %inispamkey%
		GuiControl, Choose, spamddl, 1
		gosub spamddl
	}
	if (initogglekey="Mb4") or (initogglekey="Mb5")
	{
		if initogglekey = Mb4
		{
			GuiControl, Choose, toggleddl, 2
			gosub, toggleddl
		}
		if initogglekey = Mb5
		{
			GuiControl, Choose, toggleddl, 3
			gosub, toggleddl
		}
	}
	else
	{
		togglekey=initogglekey
		GuiControl,, togglekey, %initogglekey%
		GuiControl, Choose, toggleddl, 1
		gosub toggleddl
	}
	GuiControl, , input, %inidelay%
	GuiControl, , spamkey, %inispamkey%
	GuiControl, , togglekey, %initogglekey%
	MsgBox, Preset loaded!`nPress done to apply.
}
Return

infoon:
SetTimer, info, 250
Return

infooff:
Settimer, info, off
ToolTip
Return

info:
ToolTip, %press% Presses`nCurrent delay: %input%s`nStatus - %startstop1%, 0, 0
Return

startstop:
SoundBeep, 10, 10
if startstop = 1
{
SetTimer, spam, off
startstop = 0
startstop1 = off
}
else if startstop = 0
{
SetTimer, spam, %sleeptime%
startstop = 1
startstop1 = on
}
Return

spam:
SendInput {%spamkey%}
press += 1
Return
