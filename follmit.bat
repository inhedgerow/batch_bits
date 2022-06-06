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
if '%ab%'=='1' goto backupkey
if '%ab%'=='2' goto restore
echo.
echo Please enter valid option
pause
goto beginit


:backupkey
cls
echo ############################################
echo.
echo.
md %homedrive%%homepath%\FollinaMitigation
echo Backing up Registry Keys
reg export HKEY_CLASSES_ROOT\ms-msdt %homedrive%%homepath%\FollinaMitigation\msdt
echo.
echo Deleting Registry Keys
reg delete HKEY_CLASSES_ROOT\ms-msdt /f
echo.
echo Keys backed up to %homedrive%%homepath%\FollinaMitigation and deleted from Registry
echo.
echo This Temp folder will be removed when a patch is released and you do a restore.
echo Please leave it in place until then.
echo.
pause
goto end

:restore
cls
echo ############################################
echo.
echo.
echo Importing Registry Keys
reg import %homedrive%%homepath%\FollinaMitigation\msdt
echo.
echo Removing Temp Folder
rmdir /s /q %homedrive%%homepath%\FollinaMitigation
echo.
echo Done
echo.
pause
goto end

:end
exit
