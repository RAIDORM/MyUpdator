#include "libs\autoit-msgbox-master\_Msgbox.au3"
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so /rm /pe

#Au3Stripper_Ignore_Funcs=_iHoverOn,_iHoverOff,_iFullscreenToggleBtn,_cHvr_CSCP_X64,_cHvr_CSCP_X86,_iControlDelete
#AutoIt3Wrapper_Res_HiDpi=y

#NoTrayIcon
#include "libs\MetroGUI-UDF\MetroGUI_UDF.au3"
#include "libs\MetroGUI-UDF\_GUIDisable.au3"
#include <GUIConstants.au3>
#include <AutoItConstants.au3>

_Metro_EnableHighDPIScaling() 

_SetTheme("DarkOrange") 

$Form1 = _Metro_CreateGUI("MyUpdator", 300, 200)

$Control_Buttons = _Metro_AddControlButtons(True, False, True, False, False)

$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MAXIMIZE_BUTTON = $Control_Buttons[1]
$GUI_RESTORE_BUTTON = $Control_Buttons[2]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
$GUI_FULLSCREEN_BUTTON = $Control_Buttons[4]
$GUI_FSRestore_BUTTON = $Control_Buttons[5]
$GUI_MENU_BUTTON = $Control_Buttons[6]

$Button1 = _Metro_CreateButtonEx2("Download !", 180, 80, 100, 40)

$Radio1 = _Metro_CreateRadioEx("1", "Offical Mybot", 16, 50, 150, 25)
$Radio2 = _Metro_CreateRadioEx("1", "AIO Mod", 16, 80, 150, 25)
$Radio3 = _Metro_CreateRadioEx("1", "Chill Mod", 16, 110, 150, 25)
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
		Case $Button1
			download()
	EndSwitch
WEnd

;My personal fonction to launch easier cmd command
Func cmd($command)
    RunWait(@ComSpec & " /c " & $command)
EndFunc

;Checking what version is selected
Func versionCheck()
	If _Metro_RadioIsChecked(1,$Radio1) == True Then
		Global $folder = "MyBot-develop"
		return 'https://github.com/MyBotRun/MyBot/archive/develop.zip'
	ElseIf _Metro_RadioIsChecked(1,$Radio2) == True Then
		Global $folder = "MyBot.Run-AIO-MOD-develop"
		return 'https://github.com/NguyenAnhHD/MyBot.Run-AIO-MOD/archive/develop.zip'
	Else
		Global $folder = "MyBot_v7-master"
		return 'https://github.com/ChackBR/MyBot_v7/archive/master.zip'
	EndIf
EndFunc

Func download()
	$profile = profileSave()

	;If Profiles folder exist in mybot move it to temp folder
	If ($profile == 2) Then
		cmd("move " & @ScriptDir & '\Mybot\Profiles' & " " & @ScriptDir & '\temp')
	EndIf

	;If previous Mybot release exist delete it
	If (FileExists(@ScriptDir & '\Mybot') == 1) Then
		DirRemove(@ScriptDir & '\Mybot',1)
	EndIf

	$link = versionCheck()
	;Download realease
	RunWait(@ScriptDir & "/libs/wget/wget.exe " & $link & " -O update.zip",@ScriptDir & '/temp')
	;unzip release
	RunWait(@ComSpec & " /c " & 'unzip.exe ' & @ScriptDir & '/temp/update.zip',@ScriptDir & "/libs/zip/")
	;Move unziped file to script directory
	cmd("move " & @ScriptDir & "/libs/zip/" & $folder & " " & @ScriptDir)
	;rename mybot version folder to Mybot
	RunWait(@ComSpec & " /c " & "rename " & $folder & " Mybot",@ScriptDir)
	;Delete update.zip file
	cmd('del ' & @ScriptDir & '\temp\update.zip')
	;Move Profiles folder if exist in Mybot folder
	If ($profile == 2 OR $profile == 1) Then
		DirMove(@ScriptDir & '/temp/Profiles',@ScriptDir & '/Mybot',1)
	EndIf
	_MsgBox(32,'Success','Your Mybot Version is updated !')
EndFunc

;Function checking if any profiles is here
Func profileSave()
	If (FileExists(@ScriptDir & '/temp/Profiles') == 1) Then
		Return 1
	ElseIf (FileExists(@ScriptDir & '/Mybot/Profiles') == 1) Then
		Return 2
	Else 
		return 3
	EndIf
EndFunc