currentver = 1.0
currentver += 0.0
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
MsgBox, Updating to version %remoteversion%
UrlDownloadToFile, https://raw.githubusercontent.com/Elipse458/AHK-Keyspammer/master/keyspammer.ahk, %A_WorkingDir%\keyspammer1.ahk
GuiControl,, UpdateProg, +25
UrlDownloadToFile, https://raw.githubusercontent.com/Elipse458/AHK-Keyspammer/master/updatescript.txt, %A_WorkingDir%\updatescript.bat
GuiControl,, UpdateProg, +25
Run %A_WorkingDir%\updatescript.bat
GuiControl,, UpdateProg, +25
Sleep, 1000
ExitApp
}
press = 0
input = 0
startstop = 0
Gui(){
Gui, New,, KeySpammer Settings
Gui, Color, 505050
Gui, Add, Text, cWhite, Delay
Gui, Add, Edit, vinput
Gui, Add, Text, cWhite, Key to spam
Gui, Add, Hotkey, vspamkey
Gui, Add, Text, cWhite, Key to toggle spam
Gui, Add, Hotkey, vtogglekey
Gui, Add, Button,, Done
Gui, Add, Button,, Reset
Gui, Add, Text, X235 Y175, v1.0`nBy Elipse458
Gui, Font, W700 s12
Gui, Add, Text, c9999FF X200 Y5, F1+Esc - `nemergency`nexit`nF2 - menu`nF3 - info`nF4 - info off
Gui, Show, Center W300
}
Gui()
F3::goto infoon
F4::goto infooff
F2::Gui()
F1 & Esc::ExitApp
Pause

ButtonDone:
Gui, Submit, NoHide
If (input="") or (spamkey="") or (togglekey="")
{
MsgBox, None of the fields can be empty!
Return
}
else if input is number
{
sleeptime := input * 1000
Hotkey, %togglekey%, startstop
MsgBox, Delay is %sleeptime%ms - Key to spam %spamkey% - Key to toggle spam %togglekey%
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

infoon:
SetTimer, info, 250
Return

infooff:
Settimer, info, off
ToolTip
Return

info:
ToolTip, %press% Presses - Current delay: %input%s, 0, 0
Return

startstop:
if startstop = 1
{
SetTimer, spam, off
startstop = 0
}
else if startstop = 0
{
SetTimer, spam, %sleeptime%
startstop = 1
}
Return

spam:
SendInput {%spamkey%}
press += 1
Return
