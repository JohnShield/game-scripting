;TODO add the following
; ability to add delays, alternative clicks, other click checks, modify color, to a exisiting trigger

global IDLE_PHY_CLICK_TIME := 3000
global IDLE_SCRIPT_TIME := 1000
global TRIGGER_CHECK_TIME := 1000
;global ESCAPE_CHECK_TIME := 100000

global arrayXPos := []
global arrayYPos := []
global arrayColor := []
global arrayLeeway := []

gosub createMenus

; needed to detected physical idle time
#InstallMouseHook

defaultCordMode()
   setDisplayStatusOn(10,930)


defaultCordMode() {
	CoordMode, Mouse, screen
	CoordMode, Pixel, screen
	CoordMode, ToolTip, screen
}

SetDefaultMouseSpeed, 0
;########################################################################
;# End Setup
;########################################################################

F1::
   ClickTimerOff()
   ToolTip
Return

F2::
   ClickTimerToggle(TRIGGER_CHECK_TIME)
Return

;########################################################################
;# Debugging Options
;########################################################################


F12::
	MouseGetPos, xcor, ycor 
	;CoordMode, Pixel
	PixelGetColor, color, Xcor, ycor
	ToolTip, color(%color%) at X%xcor% Y%ycor%.
return

;########################################################################
;# Menu Code
;########################################################################

F3::Menu, MyMenu, Show

createMenus:
	Menu, MyMenu, Add, Manual Click, MenuHandler
	Menu, MyMenu, Add  ;############################# Add a separator line.
	Menu, MyMenu, Add, Color Trigger: display status, MenuHandler
	Menu, MyMenu, Add, Color Trigger: readd with current color, MenuHandler
	Menu, MyMenu, Add, Color Trigger: show, MenuHandler
	Menu, MyMenu, Add, Color Trigger: typeout, MenuHandler
	Menu, MyMenu, Add  ;############################# Add a separator line.
	Menu, MyMenu, Add, Set IdleTime 1, MenuHandler
	Menu, MyMenu, Add, Set IdleTime 2, MenuHandler
	Menu, MyMenu, Add, Set IdleTime 5, MenuHandler
	Menu, MyMenu, Add  ;############################# Add a separator line.
	Menu, MyMenu, Add, WinMove Zero, MenuHandler

	; Create another menu destined to become a submenu of the above menu.
	;Menu, Submenu1, Add, Item1, MenuHandler
	;Menu, Submenu1, Add, Item2, MenuHandler
	;Menu, MyMenu, Add, My Submenu, :Submenu1

	;Menu, MyMenu, Add  ; Add a separator line below the submenu.
	;Menu, MyMenu, Add, Item3, MenuHandler  ; Add another menu item beneath the submenu.
return

MenuHandler:
	
	if (A_ThisMenuItem == "Manual Click") {
		mainClickRoutine()
	} else if (A_ThisMenuItem == "Color Trigger: readd with current color") {
		resampleDataLastLocation()
	} else if (A_ThisMenuItem == "Color Trigger: show") {
		checkValues()
	} else if (A_ThisMenuItem == "Color Trigger: display status") {
		toggleDisplayStatus()
	} else if (A_ThisMenuItem == "Color Trigger: typeout") {
		typeOutTriggers()
	} else if (A_ThisMenuItem == "WinMove Zero") {
		WinMoveZero()
	} else if (A_ThisMenuItem == "Set IdleTime 1") {
		IDLE_PHY_CLICK_TIME := 1000
		IDLE_SCRIPT_TIME := 500
	} else if (A_ThisMenuItem == "Set IdleTime 2") {
		IDLE_PHY_CLICK_TIME := 2000
		IDLE_SCRIPT_TIME := 1000
	} else if (A_ThisMenuItem == "Set IdleTime 5") {
		IDLE_PHY_CLICK_TIME := 5000
		IDLE_SCRIPT_TIME := 2000
	} else {
		MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
	}
return

;########################################################################
;# Event Handling
;########################################################################


customEvent1(x, y) {
	global state
	sleep 1000
	if (state == 0) {
		doClick(616,370)
		sleep 100
		state := 1
	} else if (state == 1) {
		state := 2
	} else {
		doClick(56,370)
		sleep 100
		doClick(56,370)
		sleep 100
		doClick(56,370)
		sleep 100
		doClick(56,370)
		sleep 100
		doClick(56,370)
		sleep 100
		state := 0
	}
	doClick(x,y)
	sleep 500
	doClick(x,y)
}

customEvent2(x, y) {
	doClick(56,370)
	sleep 100
	doClick(56,370)
	sleep 100
	doClick(56,370)
	sleep 100
	doClick(56,370)
	sleep 100
	doClick(56,370)
	sleep 100
}

customEvent3(x, y) {
	doClick(616,370)
	sleep 100
	doClick(x,y)
	sleep 500
	doClick(x,y)
}

doEvent(x, y, index) {
	if (index <= 3) {
		customEvent%index%(x, y)
	} else {
		doClick(x,y)
	}
}

;escape() {
;	SetKeyDelay, 10, 10
;	send {escape}
;}

doClick(x, y) {
   global colorSampleWinTitle
   saveMouseLoc()
   SetControlDelay -1
   ;ControlClick, x%x% y%y%, %colorSampleWinTitle%
   Click, %x%, %y%, %colorSampleWinTitle%
   ;ToolTip, % x ", " y ", " colorSampleWinTitle
   returnMouseLoc()
}

;########################################################################
;# WinMove Win
;########################################################################

WinMoveZero() {
	WinGetTitle, currentWinTitle, A
	WinMove, %currentWinTitle%, , 0, 0, 650, 750
}

;########################################################################
;# Timer Code
;########################################################################

ClickTimerToggle(repeatTimeSecs) {
   global clickEnableClickLocation

   if clickEnableClickLocation
   {
       ClickTimerOff()
   } else {
       ClickTimerOn(%repeatTimeSecs%)
   }
}

ClickTimerOn(repeatTimeSecs) {
   global clickEnableClickLocation
   gosub SaveLocation
   SetTimer, MainClickRoutine, %repeatTimeSecs%
   clickEnableClickLocation := 1
   mainClickRoutine()
}

ClickTimerOff() {
   global clickEnableClickLocation
   SetTimer, MainClickRoutine, off
   clickEnableClickLocation := 0
}

MainClickRoutine:
  	; cancel the click if we want to only do it while idle
   	if (A_TimeIdlePhysical > IDLE_PHY_CLICK_TIME) {
	     if (A_TimeIdle > IDLE_SCRIPT_TIME) {
		mainClickRoutine()
	     }
	}
return

mainClickRoutine() {
	SetTimer, MainClickRoutine, off
	eventSavedTriggerPoints()
	SetTimer, MainClickRoutine, on
}

saveMouseLoc() {
    global saveMouseLocX
    global saveMouseLocY
    CoordMode, Mouse, Screen
    MouseGetPos, saveMouseLocX, saveMouseLocY
    defaultCordMode()
}

returnMouseLoc() {
    global saveMouseLocX
    global saveMouseLocY
    CoordMode, Mouse, Screen
    MouseMove, saveMouseLocX, saveMouseLocY, 0
    defaultCordMode()
}

;########################################################################
;# Sampling Code for color based click triggers
;########################################################################

F4::
   sampleDataUnderMouse()
return


eventSavedTriggerPoints() {
   Loop % arrayXPos.Length()
   {
	_eventIfColorMatch(arrayXPos[A_Index], arrayYPos[A_Index], arrayColor[A_Index], arrayLeeway[A_Index], A_Index)
   }
}

resampleDataLastLocation() {
	index := arrayXPos.Length()
	PixelGetColor, savecolor, arrayXPos[index], arrayYPos[index]
	_addValues(arrayXPos[index], arrayYPos[index], savecolor, 0)
}

sampleDataUnderMouse() {
	global colorSampleWinTitle
	WinGetTitle, colorSampleWinTitle, A
	MouseGetPos, xcor, ycor
	;CoordMode, Pixel
	PixelGetColor, savecolor, xcor, ycor
	_addValues(xcor,ycor, savecolor, 0)
	colorSample_lasty := ycor
	colorSample_lastx := xcor
}

checkValues() {
   global colorSampleWinTitle
   listString = Title: %colorSampleWinTitle%  `n
   Loop % arrayXPos.Length()
   {
	listString = % listString arrayXPos[A_Index] " " arrayYPos[A_Index] " " arrayColor[A_Index] "`n" 
   }
   ToolTip, %listString%
}

checkValuesWithResults() {
   global colorSampleWinTitle
   listString = Click Locations:`n
   ;listString = Click Locations: %colorSampleWinTitle%  `n
   Loop % arrayXPos.Length()
   {
	SetFormat, IntegerFast, hex
	PixelGetColor, savecolor, arrayXPos[A_Index], arrayYPos[A_Index]

	if (checkMatch(savecolor, arrayColor[A_Index], arrayLeeway[A_Index])) {
	     match = true
	} else {
	     c1 := checkDiff(savecolor, arrayColor[A_Index],0)
	     c2 := checkDiff(savecolor, arrayColor[A_Index],1)
	     c3 := checkDiff(savecolor, arrayColor[A_Index],2)
	     match = %c3% %c2% %c1%
        }

	SetFormat, IntegerFast, d
	listString = % listString arrayXPos[A_Index] " " arrayYPos[A_Index] " " 
	SetFormat, IntegerFast, hex
	listString = % listString arrayColor[A_Index] " = " savecolor "("arrayLeeway[A_Index]") : " match "`n"  
	SetFormat, IntegerFast, d
   }
   return listString
}

checkDiff(c1,c2,index) {
   if (index==0) {
	c1 := c1 & 0xFF
	c2 := c2 & 0xFF	
	return abs(c1-c2)
   } else if (index==1) {
	c1 := (c1>>8)& 0xFF
	c2 := (c2>>8)& 0xFF	
	return abs(c1-c2)
   } else {
	c1 := (c1>>16)& 0xFF
	c2 := (c2>>16)& 0xFF	
	return abs(c1-c2)
   }
   return 0   
}

checkMatch(v1,v2,leeway) {
   c1 := v1 & 0xFF
   c2 := v2 & 0xFF
   if (abs(c1-c2) > (leeway & 0xFF))
	return 0
   c1 := (v1>>8)& 0xFF
   c2 := (v2>>8)& 0xFF	
   if (abs(c1-c2) > ((leeway>>8) & 0xFF))
	return 0
   c1 := (v1>>16)& 0xFF
   c2 := (v2>>16)& 0xFF	
   if (abs(c1-c2) > ((leeway>>16) & 0xFF))
	return 0

   return 1   
}

typeOutTriggers() {
   Loop % arrayXPos.Length()
   {
	listString = % listString "   _addValues(" arrayXPos[A_Index] "," arrayYPos[A_Index] "," 
	SetFormat, IntegerFast, hex
	listString = % listString arrayColor[A_Index] "," arrayLeeway[A_Index]  ")`n" 
	SetFormat, IntegerFast, d
   }
   ToolTip, %listString%
   SendRaw %listString%
}

_eventIfColorMatch(xcor, ycor, color, leeway, index) {
	PixelGetColor, _color, xcor, ycor
	if (checkMatch(color,_color,leeway)){
		;ToolTip, % xcor ", " ycor ", " color "=" _color, xcor, ycor
		doEvent(xcor,ycor,index)
        }
}

_addValues(x,y,color,leeway) {
	arrayXPos.Push(x)
	arrayYPos.Push(y)
	arrayColor.Push(color)
	arrayLeeway.Push(leeway)
}


toggleDisplayStatus() {
	Global displayStatusEnable
	if (displayStatusEnable == 1) {
		setDisplayStatusOff()
	} else {
		MouseGetPos, x, y
		setDisplayStatusOn(x,y)
	}
}

setDisplayStatusOff() {
	Global displayStatusEnable
	displayStatusEnable := 0
	SetTimer, displayStatus, off
	SetTimer, removeToolTip, 500

}

setDisplayStatusOn(x,y) {
	Global displayStatusEnable
	Global statusXCor := x
	Global statusYCor := y
	displayStatusEnable := 1
	GoSub displayStatus
	SetTimer, displayStatus, 2000
}

displayStatus:
	MouseGetPos, xcor, ycor
	result := checkValuesWithResults()
	result := "Run:" clickEnableClickLocation " Idle:" IDLE_PHY_CLICK_TIME "  (" xcor "," ycor ") " result
	ToolTip, %result%, statusXCor, statusYCor
return

removeToolTip:
	ToolTip
	SetTimer, removeToolTip, off
return


;########################################################################


;########################################################################
;# Save and click on a location for later
;########################################################################

SaveLocation:
   MouseGetPos, savedXCor, SavedYCor
   WinGetTitle, SavedWinTitle, A
return

ClickLocation:
   SetControlDelay -1
   ControlClick, x%savedXCor% y%SavedYCor%, %SavedWinTitle%
return
;########################################################################



;########################################################################
;########################################################################
;########################################################################
