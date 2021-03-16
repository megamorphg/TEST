#SingleInstance  ; Allow only one instance of this script to be running.
#NoEnv
;#Warn ;Ignores Initial Warnings
SetWorkingDir %A_ScriptDir% ;SET WORKING DIRECTORY TO SCRIPT DIRECTORY
SetTitleMatchMode, 2 ;CHANGE SETTITLEMATCHMODE TO CONTAINING, FAST
SetWinDelay, -1 ;SET WINDOW DELAY TO NONE
CoordMode, Mouse, Window ;MOUSE COORDINATE MODE
CoordMode, Pixel, Window ;MOUSE COORDINATE MODE
; CoordMode, Pixel, Screen
; CoordMode, Mouse, Screen
; PREV_A_CoordModeMouse := A_CoordModeMouse
; PREV_A_CoordModePixel := A_CoordModePixel
DetectHiddenWindows, off ;DETECT HIDDEN WINDOWS
SetScrollLockState, AlwaysOff
;~ OnExit("ExitFunc")
;~ OnExit(ObjBindMethod(ExitObject, "ExitObjectFunc"))
^CapsLock::Reload
#^CapsLock::
if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}
else
{
	ToolTip, ALREADY ADMIN,,,19
	sleep, 2000
	ToolTip,,,,19
	return
}
return
#!CapsLock::ExitApp

;---------------------------------------  TEST KEY
#+r::
test := 123
MsgBox,,%test%
sleep, 2001
MsgBox,,%test%
return

;--------------------------------------- HOTSTRINGS
;~ :*b0:<em>::</em>{left 5}

;--------------------------------------- SPEAK
;~ ComObjCreate("SAPI.SpVoice").Speak("Peter Piper picked a peck of pickled peppers")

;–––––––––––––––––––––––––––––––––––––– CMD
;~ run, %comspec% /k tree B: /a > B:\myfileB.txt

/*
;--------------------------------------- IMAGE FINDER
Prev_TitleMatchMode := A_TitleMatchMode
SetTitleMatchMode, regex
If WinExist("Media Monarchy - Google Chrome")
{ ;IMAGE SEARCHING SCRIPT FOR MEDIA MONARCHY PLAY BUTTON
	PREV_A_CoordModeMouse := A_CoordModeMouse
	PREV_A_CoordModePixel := A_CoordModePixel
	CoordMode, Mouse, Screen
	CoordMode, Pixel, Screen
	MouseGetPos, prev_mousex, prev_mousey
    WinGetPos, windowx, windowy, windoww, windowh, Media Monarchy
    windowx2 := windowx+windoww
    windowy2 := windowy+windowh
    ;~ MsgBox, %windowx% %windowy% %windowx2% %windowy2% %A_CoordModeMouse% %A_CoordModePixel% ;DEBUG ASSIST
    ImageSearch, FoundX, FoundY, %windowx%, %windowy%, %windowx2%, %windowy2%, *10 %A_ScriptDir%\pics\mediamonarchy_play.bmp
	If ErrorLevel ;IF ERROR SEARCH FOR PAUSE
	{
    ;~ MsgBox, Error %ErrorLevel% ;DEBUG ASSIST
    ImageSearch, FoundX, FoundY, %windowx%, %windowy%, %windowx2%, %windowy2%, *10 %A_ScriptDir%\pics\mediamonarchy_pause.bmp
		{
            If ErrorLevel ;IF ERROR SEARCH FOR PAUSE
				return
			else
				MouseClick,L,FoundX, FoundY
                MouseMove, %prev_mousex%, %prev_mousey%
		}
		sleep, 1000 
	}
	Else
	{
		MouseClick,L,FoundX, FoundY
        MouseMove, %prev_mousex%, %prev_mousey%
		;~ ToolTip, X: %FoundX% Y: %FoundY%,,,19
		;~ sleep, 1000
		;~ ToolTip,,,,19
	}
	CoordMode, Mouse, %PREV_A_CoordModeMouse%
	CoordMode, Pixel, %PREV_A_CoordModePixel%
}
SetTitleMatchMode %Prev_TitleMatchMode%

;--------------------------------------- MOVE FILES
MoveFilesAndFolders(SourcePattern, DestinationFolder, DoOverwrite = false)
; Moves all files and folders matching SourcePattern into the folder named DestinationFolder and
; returns the number of files/folders that could not be moved. This function requires v1.0.38+
; because it uses FileMoveDir's mode 2.
{
    if DoOverwrite = 1
        DoOverwrite = 2  ; See FileMoveDir for description of mode 2 vs. 1.
    ; First move all the files (but not the folders):
    FileMove, %SourcePattern%, %DestinationFolder%, %DoOverwrite%
    ErrorCount := ErrorLevel
    ; Now move all the folders:
    Loop, %SourcePattern%, 2  ; 2 means "retrieve folders only".
    {
        FileMoveDir, %A_LoopFileFullPath%, %DestinationFolder%\%A_LoopFileName%, %DoOverwrite%
        ErrorCount += ErrorLevel
        if ErrorLevel  ; Report each problem folder by name.
            MsgBox Could not move %A_LoopFileFullPath% into %DestinationFolder%.
    }
    return ErrorCount
}

;/*––––––––––––OTHER–––––––––––*/ 

UrlDownloadToFile, https://autohotkey.com/download/1.1/version.txt, C:\test.txt

; ~^c:: ;Clipboard append to file
; KeyWait, LWin
; KeyWait, LCtrl
; KeyWait, LShift
; KeyWait, q
; send, ^c
; test := Clipboard
; MsgBox, %test%
; FileAppend, %test%, "C:\Users\Ahmed\Desktop\test.txt"
; return

KeyWait, RWin
IfExist, D:\
    MsgBox,, It exists.
else
    MsgBox, It does not exist.
return


~$LButton::
    While GetKeyState("LButton", "P"){
        Click
        Sleep 50  ;  milliseconds
    }
return

~LButton::
    MouseGetPos, begin_x, begin_y
    while GetKeyState("LButton")
    {
        MouseGetPos, x, y
        ToolTip, % begin_x ", " begin_y "`n" Abs(begin_x-x) " x " Abs(begin_y-y)
        Sleep, 10
    }
    ToolTip
return


*/
;/*––––––––––––ACTIVE FUNCTIONS–––––––––––*/

CPULoadAverage1() {
collected_load = 0
loop, 10
{
	collected_load += % CPULoad()
	sleep, 100
}
average_load := collected_load/10
; ToolTip, %average_load%,,,19
return average_load
}

CPULoad() { ; By SKAN, CD:22-Apr-2014 / MD:05-May-2014. Thanks to ejor, Codeproject: http://goo.gl/epYnkO
Static PIT, PKT, PUT                           ; http://ahkscript.org/boards/viewtopic.php?p=17166#p17166
  IfEqual, PIT,, Return 0, DllCall( "GetSystemTimes", "Int64P",PIT, "Int64P",PKT, "Int64P",PUT )
 
  DllCall( "GetSystemTimes", "Int64P",CIT, "Int64P",CKT, "Int64P",CUT )
, IdleTime := PIT - CIT,    KernelTime := PKT - CKT,    UserTime := PUT - CUT
, SystemTime := KernelTime + UserTime 
 
Return ( ( SystemTime - IdleTime ) * 100 ) // SystemTime,    PIT := CIT,    PKT := CKT,    PUT := CUT 
} 

;DOES NOT CONTINUE UNTIL A PIXEL IS FOUND AT X AND Y
waitForPixelColor(mousex, mousey, color)
{
	Loop
	{
		PixelGetColor, Loaded, %mousex%, %mousey%, RGB
		if Loaded = %color%
		{
			ToolTip,,,,19
			break
		}
		else
			ToolTip,Found %Loaded% at %mousex% %mousey%,,,19
	}
	return
}

;EXIT CALL FUNCTION
ExitFunc(ExitReason, ExitCode)
{
}
class ExitObject
{
    ExitObjectFunc()
    {
    }
}