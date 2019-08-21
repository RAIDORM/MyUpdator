;Create temp dir if not exist
Func selfCreate()
	If (FileExists(@ScriptDir & '\temp') == 0) Then
		DirCreate(@ScriptDir & '\temp')
	EndIf
EndFunc


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
	selfCheck()
	;verify if toggle is toggled for package
	If (_Metro_ToggleIsChecked($toggle1) == True) Then
		package()
	EndIf

	$profile = profileSave()

	;If Profiles folder exist in mybot move it to temp folder
	If ($profile == 2 AND _Metro_ToggleIsChecked($toggle2) == True) Then
		cmd('move ' & @ScriptDir & '\Mybot\Profiles' & ' ' & @ScriptDir & '\temp')
	EndIf
	;If Custom path is selected and keep profiles move it to temp folder 
	If($profile == 4 AND _Metro_ToggleIsChecked($toggle2) == True) Then
		cmd('move ' & $Input & '\Mybot\Profiles' & ' ' & @ScriptDir & '\temp')
	EndIf

	;If CSV Check Save it to temp folder
	If (IsDeclared('Input') AND _Metro_ToggleIsChecked($toggle4) == True) Then
		If FileExists($Input & '\Mybot\CSV') AND _Metro_ToggleIsChecked($toggle3) Then
			cmd('move ' & $Input & '\Mybot\CSV' & ' ' & @ScriptDir & '\temp')
		EndIf
	EndIf
	If FileExists(@ScriptDir & '\Mybot\CSV') AND _Metro_ToggleIsChecked($toggle3) Then
		cmd('move ' & @ScriptDir & '\Mybot\CSV' & ' ' & @ScriptDir & '\temp')
	EndIf

	;If previous Mybot release exist delete it
	If (IsDeclared('Input') AND _Metro_ToggleIsChecked($toggle4) == True) Then
		DirRemove($Input & '\Mybot',1)
	EndIf
	If (FileExists(@ScriptDir & '\Mybot') == 1) Then
		DirRemove(@ScriptDir & '\Mybot',1)
	EndIf

	$link = versionCheck()
	
	;Download realease
	InetGet($link,@ScriptDir & '\temp\update.zip')
	
	;unzip release
	RunWait(@ComSpec & ' /c ' & 'unzip.exe ' & @ScriptDir & '\temp\update.zip',@ScriptDir & '\libs\zip\')
	;Move unziped file to script directory
	If (IsDeclared('Input') AND _Metro_ToggleIsChecked($toggle4) == True) Then
		cmd('move ' & @ScriptDir & '\libs\zip\' & $folder & ' ' & $Input)
	Else
		cmd('move ' & @ScriptDir & '\libs\zip\' & $folder & ' ' & @ScriptDir)
	EndIf
	;rename mybot version folder to Mybot
	If (IsDeclared('Input') AND _Metro_ToggleIsChecked($toggle4) == True) Then
		DirMove($Input & '\' & $folder,$Input & '\Mybot')
	Else
		DirMove(@ScriptDir & '\' &$folder,@ScriptDir & '\Mybot')
	EndIf
	;Delete update.zip file
	FileDelete(@ScriptDir & '\temp\update.zip')
	
	;Move Profiles folder if exist in temp folder
	If ($profile == 2 OR $profile == 1 OR $profile == 4) Then
		If (IsDeclared('Input') AND _Metro_ToggleIsChecked($toggle4) == True) Then
			DirMove(@ScriptDir & '\temp\Profiles',$Input & '\Mybot',1)
		Else
			DirMove(@ScriptDir & '\temp\Profiles',@ScriptDir & '\Mybot',1)
		EndIf
	EndIf

	;Move CSV folder if exist in temp folder
	If FileExists(@ScriptDir & '\temp\CSV') Then
		If (IsDeclared('Input') AND _Metro_ToggleIsChecked($toggle4) == True) Then
			DirRemove($Input & '\Mybot\CSV',1)
			DirMove(@ScriptDir & '\temp\CSV',$Input & '\Mybot',1)
		Else
			DirRemove(@ScriptDir & '\Mybot\CSV',1)
			DirMove(@ScriptDir & '\temp\CSV',@ScriptDir & '\Mybot',1)
		Endif
	EndIf
	_MsgBox(64,'Success','Your Mybot Version is updated !')
EndFunc

;Function checking if any profiles is there
Func profileSave()
	If (FileExists(@ScriptDir & '\temp\Profiles') == 1) Then
		Return 1
	ElseIf (FileExists(@ScriptDir & '\Mybot\Profiles') == 1) Then
		Return 2
	ElseIf (IsDeclared('Input') AND _Metro_ToggleIsChecked($toggle4) == True) Then
		Return 4
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
	_MsgBox(64,'Curious ( ͡° ͜ʖ ͡°)','Avaible in next update !')
EndFunc