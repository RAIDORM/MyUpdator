#include "libs\autoit-msgbox-master\_Msgbox.au3"
#include "libs\Functions.au3"
#include <GDIPlus.au3>
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

$Form1 = _Metro_CreateGUI("MyUpdator", 500, 250)

$Control_Buttons = _Metro_AddControlButtons(True, False, True, False, False)

$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MAXIMIZE_BUTTON = $Control_Buttons[1]
$GUI_RESTORE_BUTTON = $Control_Buttons[2]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
$GUI_FULLSCREEN_BUTTON = $Control_Buttons[4]
$GUI_FSRestore_BUTTON = $Control_Buttons[5]
$GUI_MENU_BUTTON = $Control_Buttons[6]

$Button1 = _Metro_CreateButton("Download !", 320, 70, 130, 50)

$Radio1 = _Metro_CreateRadioEx("1", "Offical Mybot", 166, 80, 150, 25)
$Radio2 = _Metro_CreateRadioEx("1", "AIO Mod", 16, 80, 150, 25)
$Radio3 = _Metro_CreateRadioEx("1", "Light Mod", 16, 110, 150, 25)
$Radio4 = _Metro_CreateRadioEx("1", "Chill Mod",16 , 50 , 150, 25)

$Checkbox1 = _Metro_CreateCheckboxEx2("Install Bluestacks", 16, 150, 150, 30)
$Checkbox2 = _Metro_CreateCheckboxEx2("Install Memu", 16, 180, 150, 30)
$Checkbox3 = _Metro_CreateCheckboxEx2("Install Nox", 16, 210, 150, 30)

$Toggle1 = _Metro_CreateOnOffToggle("Install Visual C++ 2010", "Ignore Visual C++ 2010", 250, 150, 300, 30)
$Toggle2 = _Metro_CreateOnOffToggle("Keep Profiles", "Delete Profiles", 250, 180, 300, 30)
$Toggle3 = _Metro_CreateOnOffToggle("Keep CSV", "Delete CSV", 250, 210, 300, 30)
_Metro_ToggleCheck($Toggle2)
_Metro_ToggleCheck($Toggle3)

_Metro_RadioCheck("1", $Radio1)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $GUI_CLOSE_BUTTON
			_Metro_GUIDelete($Form1)
			Exit
		Case $GUI_MINIMIZE_BUTTON
			GUISetState(@SW_MINIMIZE, $Form1)
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
		Case $Checkbox1
			If _Metro_CheckboxIsChecked($Checkbox1) Then
				_Metro_CheckboxUnCheck($Checkbox1)
			Else
				_Metro_CheckboxCheck($Checkbox1)
				_Metro_CheckboxUnCheck($Checkbox2)
				_Metro_CheckboxUnCheck($Checkbox3)
			EndIf
		Case $Checkbox2
			If _Metro_CheckboxIsChecked($Checkbox2) Then
				_Metro_CheckboxUnCheck($Checkbox2)
			Else
				_Metro_CheckboxCheck($Checkbox2)
				_Metro_CheckboxUnCheck($Checkbox1)
				_Metro_CheckboxUnCheck($Checkbox3)
			EndIf
		Case $Checkbox3
			If _Metro_CheckboxIsChecked($Checkbox3) Then
				_Metro_CheckboxUnCheck($Checkbox3)
			Else
				_Metro_CheckboxCheck($Checkbox3)
				_Metro_CheckboxUnCheck($Checkbox1)
				_Metro_CheckboxUnCheck($Checkbox2)
			EndIf
	EndSwitch
WEnd