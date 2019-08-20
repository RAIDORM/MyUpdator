;Self Check if all files and folders are present
Func selfCheck()
	if FileExists(@ScriptDir & '\libs') AND FileExists(@ScriptDir & '\temp') == 0 Then
		_MsgBox(16,'Warning !',"MyUpdador can't find all needed directories !")
		Exit
	EndIf
EndFunc


;My personal fonction to launch easier cmd command
Func cmd($command,$working = '')
    RunWait(@ComSpec & ' /c ' & $command,$working)
EndFunc

;Checking what version is selected
Func versionCheck()
	If _Metro_RadioIsChecked(1,$Radio1) == True Then
		Global $folder = 'MyBot-develop'
		return 'https://github.com/MyBotRun/MyBot/archive/develop.zip'
	ElseIf _Metro_RadioIsChecked(1,$Radio2) == True Then
		Global $folder = 'MyBot.Run-AIO-MOD-develop'
		return 'https://github.com/NguyenAnhHD/MyBot.Run-AIO-MOD/archive/develop.zip'
	ElseIf _Metro_RadioIsChecked(1,$Radio3) == True Then
		Global $folder = 'MyBot_v7-master'
		'https://github.com/ChackBR/MyBot_v7/archive/master.zip'
	Else
		Global $folder = 'MBR-Chill-MOD-develop'
		return 'https://github.com/nickpavini/MBR-Chill-MOD/archive/develop.zip' 
	EndIf
EndFunc

Func download()
	;SelfCheck
	selfCheck()

	;Check if emulators are selected
	emulator()

	;verify if toggle is toggled for package
	If (_Metro_ToggleIsChecked($toggle1) == True) Then
		package()
	EndIf

	$profile = profileSave()

	;If Profiles folder exist in mybot move it to temp folder
	If ($profile == 2 AND _Metro_ToggleIsChecked($toggle2) == True) Then
		cmd('move ' & @ScriptDir & '\Mybot\Profiles' & ' ' & @ScriptDir & '\temp')
	EndIf

	;If CSV Check keep it
	If FileExists(@ScriptDir & '\Mybot\CSV') AND _Metro_ToggleIsChecked($toggle3) Then
		cmd('move ' & @ScriptDir & '\Mybot\CSV' & ' ' & @ScriptDir & '\temp')
	EndIf

	;If previous Mybot release exist delete it
	If (FileExists(@ScriptDir & '\Mybot') == 1) Then
		DirRemove(@ScriptDir & '\Mybot',1)
	EndIf

	$link = versionCheck()
	
	;Download realease
	InetGet($link,@ScriptDir & '\temp\update.zip')
	
	;unzip release
	RunWait(@ComSpec & ' /c ' & 'unzip.exe ' & @ScriptDir & '\temp\update.zip',@ScriptDir & '\libs\zip\')
	
	;Move unziped file to script directory
	cmd('move ' & @ScriptDir & '\libs\zip\' & $folder & ' ' & @ScriptDir)
	
	;rename mybot version folder to Mybot
	DirMove(@ScriptDir & '\' &$folder,@ScriptDir & '\Mybot')
	
	;Delete update.zip file
	FileDelete(@ScriptDir & '\temp\update.zip')
	
	;Move Profiles folder if exist in temp folder
	If ($profile == 2 OR $profile == 1) Then
		DirMove(@ScriptDir & '\temp\Profiles',@ScriptDir & '\Mybot',1)
	EndIf

	;Move CSV folder if exist in temp folder
	If FileExists(@ScriptDir & '\temp\CSV') Then
		DirRemove(@ScriptDir & '\Mybot\CSV',1)
		DirMove(@ScriptDir & '\temp\CSV',@ScriptDir & '\Mybot',1)
	EndIf
	_MsgBox(64,'Success','Your Mybot Version is updated !')
EndFunc

;Function checking if any profiles is there
Func profileSave()
	If (FileExists(@ScriptDir & '\temp\Profiles') == 1) Then
		Return 1
	ElseIf (FileExists(@ScriptDir & '\Mybot\Profiles') == 1) Then
		Return 2
	Else 
		return 3
	EndIf
EndFunc

;If package is selected install it 
Func package()
	InetGet('https://download.microsoft.com/download/5/B/C/5BC5DBB3-652D-4DCE-B14A-475AB85EEF6E/vcredist_x86.exe',@ScriptDir & '\temp\package.exe')
	cmd('package.exe /q /norestart',@ScriptDir & '\temp')
	FileDelete(@ScriptDir & '\temp\package.exe')
EndFunc

;If any emulator is selected install it
Func emulator()
	If _Metro_CheckboxIsChecked($Checkbox1) Then
		Dim $emulator_link = ['http://download1079.mediafire.com/f2jyq915v36g/4kzi6v2ajv9o9f1/BlueStacks+2.5.43.8001+-+Rooted.exe','BlueStacks']
	ElseIf _Metro_CheckboxIsChecked($Checkbox2) Then
		Dim $emulator_link = ['http://dl.memuplay.com/download/MEmu-Setup-6.2.9-ha41a2eb97.exe','Memu']
	ElseIf  _Metro_CheckboxIsChecked($Checkbox3) Then
		Dim $emulator_link = ['https://res06.bignox.com/full/20190816/ce5fe8d976084b2b86b20141bd459fdc.exe?filename=nox_setup_v6.3.0.6_full_intl.exe','Nox']
	Else
		return 2
	EndIf
	If FileExists(@ScriptDir & '\temp\emulator.exe') Then
		FileDelete(@ScriptDir & '\temp\emulator.exe')
	EndIf
	InetGet($emulator_link[0],@ScriptDir & '\temp\emulator.exe','','1')
	_MsgBox(32,'Emulator','Your emulator ' & $emulator_link[1] & " Will download on background don't close MyUpdator !")
EndFunc