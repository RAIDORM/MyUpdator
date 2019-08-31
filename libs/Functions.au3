;Create temp dir if not exist
Func selfCreate()
	If (FileExists(@ScriptDir & '\temp') == 0) Then
		DirCreate(@ScriptDir & '\temp')
	EndIf
EndFunc


;Self Check if all files and folders are present
Func selfCheck()
	if FileExists(@ScriptDir & '\libs') AND FileExists(@ScriptDir & '\temp') == 0 Then
		_Metro_MsgBox(16,'Warning !',"MyUpdador can't find all needed directories !")
		Exit
	EndIf
EndFunc

Func selfUpdate($iDelay = 0)
	InetGet("https://codeload.github.com/RAIDORM/MyUpdator/zip/master",@ScriptDir & '\temp\MyUpdator_New.zip')
	_Metro_MsgBox(16,'Warning !','The new update zip is on temp folder extract it before use !')
	Exit
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
		return 'https://github.com/ChackBR/MyBot_v7/archive/master.zip'
	Else
		Global $folder = 'MBR-Chill-MOD-master'
		return 'https://codeload.github.com/nickpavini/MBR-Chill-MOD/zip/master' 
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
		DirMove(@ScriptDir & '\' & $folder,@ScriptDir & '\Mybot')
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
	_Metro_MsgBox(64,'Success','Your Mybot Version ' & FileGetVersion (@ScriptDir & '\Mybot\MyBot.run.exe')& ' is updated !')
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
	If (_Metro_RadioIsChecked(2,$Radio5)) Then
		Local $emulatorLink = 'http://download975.mediafire.com/ifllgdrk5cdg/edda0y8jadktomy/BlueStacks+Rooted+0.10.7.5601.exe'
	EndIf
	If (_Metro_RadioIsChecked(2,$Radio6)) Then
		Local $emulatorLink = 'http://download1582.mediafire.com/xjb7dexfstyg/twx22cj3t6xsd73/BlueStacks.2.2.27.6431.exe'
	EndIf
	If (_Metro_RadioIsChecked(2,$Radio7)) Then
		Local $emulatorLink = 'http://download1072.mediafire.com/rf0le4tw3fng/mfidgyhxnxnvtzl/Rooted+BlueStacks+2.4.43.6254.exe'
	EndIf
	If (_Metro_RadioIsChecked(2,$Radio8)) Then
		Local $emulatorLink = 'http://download1079.mediafire.com/qym3smxwzdqg/4kzi6v2ajv9o9f1/BlueStacks+2.5.43.8001+-+Rooted.exe'
	EndIf
	If (_Metro_RadioIsChecked(2,$Radio9)) Then
		Local $emulatorLink = 'http://download944.mediafire.com/na0ss32bxg0g/fhik1fdw2patp4z/BS2-2.6.105.7802.exe'
	EndIf
	If (_Metro_RadioIsChecked(2,$Radio10)) Then
		Local $emulatorLink = 'http://download1586.mediafire.com/2nkg60y3d1dg/o60n2bxetueqck2/BlueStacks.3.50.52.Rooted.exe'
	EndIf
	If (_Metro_RadioIsChecked(2,$Radio11)) Then
		Local $emulatorLink = 'http://download1521.mediafire.com/rc4t0e5rlklg/ixo9w76gxqgfytc/BlueStacks.3.54.65.1755.exe'
	EndIf
	If (_Metro_RadioIsChecked(2,$Radio12)) Then
		Local $emulatorLink = 'http://download2056.mediafire.com/k43jw6akyt7g/7qqss4hljarpp79/BlueStacks.3.55.70.1783.exe'
	EndIf
	If (_Metro_RadioIsChecked(2,$Radio13)) Then
		Local $emulatorLink = 'http://download1525.mediafire.com/snrdjcernfgg/165pbyu52hbc5pt/BlueStacks.3.56.73.1817.exe'
	EndIf
	If (_Metro_RadioIsChecked(2,$Radio14)) Then
		Local $emulatorLink = 'http://dl.memuplay.com/download/MEmu-Setup-6.3.2-ha45606838.exe'
	EndIf
	If (_Metro_RadioIsChecked(2,$Radio15)) Then
		Local $emulatorLink = 'https://res06.bignox.com/full/20190816/ce5fe8d976084b2b86b20141bd459fdc.exe?filename=nox_setup_v6.3.0.6_full_intl.exe'
	EndIf

	If IsDeclared('emulatorLink') Then
		_Metro_MsgBox(32,'Downloading',"The programm will not respond please don't close it")
		InetGet($emulatorLink,@ScriptDir & '\temp\emulator.exe')
	Else
		_Metro_MsgBox(16,'Warning','Please select a version before clicking here !')
	EndIf
EndFunc

Func profiles()
	If Not (FileExists(@ScriptDir & '\temp\ProfileEditor.exe')) Then
	InetGet('https://github.com/PoH98/MyBot.Injector/releases/latest/download/MyBot.Injector.exe',@ScriptDir & '\temp\ProfileEditor.exe')
	EndIf
	RunWait(@ScriptDir & '\temp\ProfileEditor.exe')
EndFunc

Func csv()
	If FileExists(@ScriptDir & '\temp\CSV') Then
		DirRemove(@ScriptDir & '\temp\CSV',1)
	EndIf
	InetGet('https://codeload.github.com/RAIDORM/Csv-Collection/zip/master',@ScriptDir & '\libs\zip\Csv.zip')
	RunWait(@ComSpec & ' /c ' & 'unzip.exe ' & @ScriptDir & '\libs\zip\Csv.zip',@ScriptDir & '\libs\zip\')
	cmd('move ' & @ScriptDir & '\libs\zip\Csv-Collection-master '& @ScriptDir & '\temp')
	FileDelete(@ScriptDir & '\libs\zip\Csv.zip')
	DirMove(@ScriptDir & '\temp\Csv-Collection-master',@ScriptDir & '\temp\CSV',1)
EndFunc