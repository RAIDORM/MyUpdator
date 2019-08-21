#include "libs\autoit-msgbox-master\_Msgbox.au3"
#include "libs\Functions.au3"
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so /rm /pe

#Au3Stripper_Ignore_Funcs = _iHoverOn,_iHoverOff,_iFullscreenToggleBtn,_cHvr_CSCP_X64,_cHvr_CSCP_X86,_iControlDelete
#AutoIt3Wrapper_Res_HiDpi=y

#NoTrayIcon
#include "libs\MetroGUI-UDF\MetroGUI_UDF.au3"
#include "libs\MetroGUI-UDF\_GUIDisable.au3"
#include <GUIConstants.au3>
#include <AutoItConstants.au3>

_Metro_EnableHighDPIScaling() 

_SetTheme("DarkOrange") 

gui1()

Func gui1()

$Form1 = _Metro_CreateGUI("MyUpdator", 500, 250)

$Control_Buttons = _Metro_AddControlButtons(True, False, True, False, True)

$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MAXIMIZE_BUTTON = $Control_Buttons[1]
$GUI_RESTORE_BUTTON = $Control_Buttons[2]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
$GUI_FULLSCREEN_BUTTON = $Control_Buttons[4]
$GUI_FSRestore_BUTTON = $Control_Buttons[5]
$GUI_MENU_BUTTON = $Control_Buttons[6]

Global $Button1 = _Metro_CreateButton("Download !", 320, 70, 130, 50)

Global $Radio1 = _Metro_CreateRadioEx("1", "Offical Mybot", 166, 80, 150, 25)
Global $Radio2 = _Metro_CreateRadioEx("1", "AIO Mod", 16, 80, 150, 25)
Global $Radio3 = _Metro_CreateRadioEx("1", "Light Mod", 16, 110, 150, 25)
Global $Radio4 = _Metro_CreateRadioEx("1", "Chill Mod",16 , 50 , 150, 25)

Global $Toggle1 = _Metro_CreateOnOffToggle("Install Visual C++ 2010", "Ignore Visual C++ 2010", 16, 150, 300, 30)
Global $Toggle2 = _Metro_CreateOnOffToggle("Keep Profiles", "Delete Profiles", 16, 180, 300, 30)
Global $Toggle3 = _Metro_CreateOnOffToggle("Keep CSV", "Delete CSV", 16, 210, 300, 30)
Global $Toggle4 = _Metro_CreateOnOffToggle("Custom Path", "Original Path", 316, 150, 300, 30)
_Metro_ToggleCheck($Toggle2)
_Metro_ToggleCheck($Toggle3)

_Metro_RadioCheck("1", $Radio1)
GUISetState(@SW_SHOW)

selfCreate()
selfCheck()
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $GUI_CLOSE_BUTTON
			_Metro_GUIDelete($Form1)
			Exit
		Case $GUI_MINIMIZE_BUTTON
			GUISetState(@SW_MINIMIZE, $Form1)
		Case $GUI_MENU_BUTTON
			Local $MenuButtonsArray[5] = ["Main", "Emulators", "CSV", "Profiles", "Exit"]
			Local $MenuSelect = _Metro_MenuStart($Form1, 150, $MenuButtonsArray)
			Switch $MenuSelect
				Case "1"
				gui2()
				Case "2"
					
				Case "3"
			
				Case "4"
					_Metro_GUIDelete($Form1)
					Exit
			EndSwitch
		Case $Radio1
			_Metro_RadioCheck(1, $Radio1)
		Case $Radio2
			_Metro_RadioCheck(1, $Radio2)
		Case $Radio3
			_Metro_RadioCheck(1, $Radio3)
		Case $Radio4
			_Metro_RadioCheck(1, $Radio4)
		Case $Button1
			download()
		Case $Toggle1
			If _Metro_ToggleIsChecked($Toggle1) Then
				_Metro_ToggleUnCheck($Toggle1)
			Else
				_Metro_ToggleCheck($Toggle1)
			EndIf
		Case $Toggle2
			If _Metro_ToggleIsChecked($Toggle2) Then
				_Metro_ToggleUnCheck($Toggle2)
			Else
				_Metro_ToggleCheck($Toggle2)
			EndIf
		Case $Toggle3
			If _Metro_ToggleIsChecked($Toggle3) Then
				_Metro_ToggleUnCheck($Toggle3)
			Else
				_Metro_ToggleCheck($Toggle3)
			EndIf
		Case $Toggle4
			If _Metro_ToggleIsChecked($Toggle4) Then
				_Metro_ToggleUnCheck($Toggle4)
			Else
				_Metro_ToggleCheck($Toggle4)

				Global $Input = _Metro_InputBox("Please enter the complete path", 11, @ScriptDir, False, True)
				If FileExists($Input) Then
					_MsgBox(64,'Sucess','Directory Valid !')
				Else
					_MsgBox(16,'Warning','Your Path seem not valid please be sure to use the complete path')
					_Metro_ToggleUnCheck($Toggle4)
				EndIf
			EndIf
	EndSwitch
WEnd
EndFunc

Func gui2()
	$Form2 = _Metro_CreateGUI("Emulators", 500, 300)
	$Radio5 = _Metro_CreateRadioEx(2,"Install Bluestacks 3.56.73", 16, 20, 250, 30)
	$Radio6 = _Metro_CreateRadioEx(2,"Install Bluestacks 3.55.70", 16, 50, 250, 30)
	$Radio7 = _Metro_CreateRadioEx(2,"Install Bluestacks 3.54.65", 16, 80, 250, 30)
	$Radio8 = _Metro_CreateRadioEx(2,"Install Bluestacks 3.50.52", 16, 110, 250, 30)
	$Radio9 = _Metro_CreateRadioEx(2,"Install Bluestacks 2.6.105", 16, 140, 250, 30)
	$Radio10 = _Metro_CreateRadioEx(2,"Install Bluestacks 2.5.43", 16, 170, 250, 30)
	$Radio11 = _Metro_CreateRadioEx(2,"Install Bluestacks 2.4.43", 16, 200, 250, 30)
	$Radio12 = _Metro_CreateRadioEx(2,"Install Bluestacks 2.2.21", 16, 230, 250, 30)
	$Radio13 = _Metro_CreateRadioEx(2,"Install Bluestacks 0.10.7", 16, 260, 250, 30)
	$Radio14 = _Metro_CreateRadioEx(2,"Install Memu", 280, 50, 150, 30)
	$Radio15 = _Metro_CreateRadioEx(2,"Install Nox", 280, 80, 150, 30)
	$Button2 = _Metro_CreateButton("Download !", 280, 200, 130, 50)
	$Control_Buttons = _Metro_AddControlButtons(True, False, False, False, False)
	$GUI_CLOSE_BUTTON = $Control_Buttons[0]
	$GUI_MAXIMIZE_BUTTON = $Control_Buttons[1]
	$GUI_RESTORE_BUTTON = $Control_Buttons[2]
	$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
	$GUI_FULLSCREEN_BUTTON = $Control_Buttons[4]
	$GUI_FSRestore_BUTTON = $Control_Buttons[5]
	$GUI_MENU_BUTTON = $Control_Buttons[6]
	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $GUI_CLOSE_BUTTON
				_Metro_GUIDelete($Form2)
				return
			Case $Radio5
				_Metro_RadioCheck(2, $Radio5)
			Case $Radio6
				_Metro_RadioCheck(2, $Radio6)
			Case $Radio7
				_Metro_RadioCheck(2, $Radio7)
			Case $Radio8
				_Metro_RadioCheck(2, $Radio8)
			Case $Radio9
				_Metro_RadioCheck(2, $Radio9)
			Case $Radio10
				_Metro_RadioCheck(2, $Radio10)
			Case $Radio11
				_Metro_RadioCheck(2, $Radio11)
			Case $Radio12
				_Metro_RadioCheck(2, $Radio12)
			Case $Radio13
				_Metro_RadioCheck(2, $Radio13)
			Case $Radio14
				_Metro_RadioCheck(2, $Radio14)
			Case $Radio15
				_Metro_RadioCheck(2, $Radio15)
			Case $Button2
				emulator()
		EndSwitch
	Wend
EndFunc
