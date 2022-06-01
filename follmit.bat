@echo off
title Follina Mitigation
:beginit
cls
echo ############################################
echo.
echo.
echo 1. Backup and Delete Registry Key
echo 2. Restore Registry Key
echo x. Exit
echo.

set /p ab=?
if '%ab%'=='x' goto end
if '%ab%'=='1' goto backuploc
if '%ab%'=='2' goto restore
echo.
echo Please enter valid option
pause
goto beginit

:backuploc
cls
echo ############################################
echo.
echo.

echo Select folder for Registry Key backup . . .
call:FolderSelection "%backuploc%", backuploc, "Select Folder"
echo Registry Key will be backed up to "%backuploc%"
echo.
choice /N /C:YN /M "Is this OK (Y/N)?"%1

if %ERRORLEVEL% == 1 goto backupkey
if %ERRORLEVEL% == 2 goto backuploc

:FolderSelection <SelectedPath> <folder> <Description>
SetLocal & set "folder=%~1"
set "dialog=powershell -sta "Add-Type -AssemblyName System.windows.forms^
|Out-Null;$f=New-Object System.Windows.Forms.FolderBrowserDialog;$f.SelectedPath='%~1';$f.Description='%~3';^
$f.ShowNewFolderButton=$true;$f.ShowDialog();$f.SelectedPath""
for /F "delims=" %%I in ('%dialog%') do set "res=%%I"
EndLocal & (if "%res%" EQU "" (set "%2=%folder%") else (set "%2=%res%"))
exit/B 0

:backupkey
cls
echo ############################################
echo.
echo.
md %homedrive%%homepath%\follinamitigation
echo %backuploc%\msdt > %homedrive%%homepath%\follinamitigation\backuplocation

reg export HKEY_CLASSES_ROOT\ms-msdt %backuploc%\msdt
reg delete HKEY_CLASSES_ROOT\ms-msdt /f

echo Key backed up to %backuploc% and deleted from Registry
echo.
echo There is also a folder %homedrive%%homepath%\follinamitigation
echo This Temp folder will be removed when a patch is released and you do a restore.
echo Please leave it in place until then.
pause
goto end

:restore
set /p backloc=<%homedrive%%homepath%\follinamitigation\backuplocation
reg import %backloc%
rmdir /s /q %homedrive%%homepath%\follinamitigation
rmdir /s /q %backloc%

:end
exit