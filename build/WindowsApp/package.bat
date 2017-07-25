@echo off

REM --- change these ---
SET folderpath=C:\Users\Doge\Desktop\MultiCraft-1.1.8-dev-win32
SET outputpath=C:\Users\Doge\Desktop
SET version=1.1.8.0
SET publisher=example text
REM --------------------

rem Find path to DesktopAppConverter
pushd "%ProgramFiles%\WindowsApps"
set cmd="dir /b Microsoft.DesktopAppConverter_*"
for /f "tokens=*" %%i in (' %cmd% ') do set appname=%%i
popd

rem Find installed Windows 10 SDK version
pushd "%ProgramFiles(x86)%\Windows Kits\10\bin"
set cmd="dir /b 10.*"
for /f "tokens=*" %%i in (' %cmd% ') do set sdkver=%%i
popd

echo Please wait...
powershell -NoProfile -NoLogo -ExecutionPolicy Bypass^
 -File "%ProgramFiles%\WindowsApps\%appname%\DesktopAppConverter.ps1"^
 -Installer "%folderpath%" -AppExecutable MultiCraft.exe^
 -Destination "%outputpath%" -PackageName MultiCraft^
 -Publisher "CN=%publisher%" -Version %version%
"%ProgramFiles(x86)%\Windows Kits\10\bin\%sdkver%\x64\MakeAppx.exe"^
 pack /l^
 /d "%outputpath%\MultiCraft\PackageFiles" /p "%outputpath%\MultiCraft.appx"

pause
