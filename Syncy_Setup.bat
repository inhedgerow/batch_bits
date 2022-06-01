@echo off
title Syncy Setup

:getprimary
cls
echo ##############################################################
echo.
setlocal enabledelayedexpansion
set count=0

for /f "skip=2 delims=" %%a in ('"wmic logicalDisk get deviceid, volumename, description /format:csv"') do (
  set /a count=count+1
  set choice[!count!]=%%a
)

echo.
echo Select Primary Drive:
echo.

for /l %%a in (1,1,!count!) do (
   echo %%a] !choice[%%a]!
)
echo x] Exit
echo.

set /p select=?
if '%select%'=='x' goto end
set primary_drive=!choice[%select%]!

for /f "tokens=3 delims=," %%p in ("%primary_drive%") do endlocal && set primary=%%p
echo Primary Drive %primary% Selected
echo.
choice /N /C:YN /M "Is this correct (Y/N)?"%1
if %ERRORLEVEL% == 1 goto getsecondary 
if %ERRORLEVEL% == 2 goto getprimary

:getsecondary
cls
echo ##############################################################
echo.
setlocal enabledelayedexpansion
set count=0

for /f "skip=2 delims=" %%a in ('"wmic logicalDisk get deviceid, volumename, description /format:csv"') do (
  for /f "tokens=3 delims=," %%q in ("%%a") do (
    if %%q neq %primary% (
    set /a count=count+1
    set choice[!count!]=%%a
    )
  )
)

echo.
echo Select Secondary Drive:
echo.

for /l %%a in (1,1,!count!) do (
   echo %%a] !choice[%%a]!
)
echo x] Exit
echo.

set /p select=?
if '%select%'=='x' goto end
set secondary_drive=!choice[%select%]!

for /f "tokens=3 delims=," %%p in ("%secondary_drive%") do endlocal && set secondary=%%p

for /f %%g in ('mountvol %secondary% /l') do set secguid=%%g

echo Primary Drive %primary% and
echo Secondary Drive %secondary% Selected
echo.
choice /N /C:YN /M "Is this correct (Y/N)?"%1
if %ERRORLEVEL% == 1 goto getloc 
if %ERRORLEVEL% == 2 goto getsecondary

:getloc
cls
echo ##############################################################
echo.

mountvol %secondary%\ /p
set secondary=S:
mountvol %secondary%\ %secguid%

echo Syncy will be put in %systemdrive%\Program Files\Syncy
echo.
choice /N /C:YN /M "Is this OK (Y/N)?"%1

if %ERRORLEVEL% == 1 set syncyloc=%systemdrive%\Program Files\Syncy&& goto syncywrite
if %ERRORLEVEL% == 2 goto newloc

:syncywrite

setlocal

md "%syncyloc%"
cd "%syncyloc%"
echo mountvol %secondary%\ %secguid% > syncy.bat
echo robocopy %primary%\ %secondary%\ /zb /copyall /mir /xd $RECYCLE.BIN "System Volume Information" /np /log+:"%syncyloc%\syncylog.txt" >> syncy.bat
echo mountvol %secondary%\ /p >> syncy.bat
endlocal

goto getdelay

:newloc
cls
echo ##############################################################
echo.
echo( Select folder . . .
call:FolderSelection "%syncyloc%", syncyloc, "Select Folder"
echo( Syncy will be written to "%syncyloc%"
echo.
choice /N /C:YN /M "Is this OK (Y/N)?"%1

if %ERRORLEVEL% == 1 goto syncywrite
if %ERRORLEVEL% == 2 goto newloc

:FolderSelection <SelectedPath> <folder> <Description>
SetLocal & set "folder=%~1"
set "dialog=powershell -sta "Add-Type -AssemblyName System.windows.forms^
|Out-Null;$f=New-Object System.Windows.Forms.FolderBrowserDialog;$f.SelectedPath='%~1';$f.Description='%~3';^
$f.ShowNewFolderButton=$true;$f.ShowDialog();$f.SelectedPath""
for /F "delims=" %%I in ('%dialog%') do set "res=%%I"
EndLocal & (if "%res%" EQU "" (set "%2=%folder%") else (set "%2=%res%"))
exit/B 0

pause

:getdelay
cls
echo ##############################################################
echo.
echo 1]    MINUTE - Specifies the number of minutes before the sync should run.
echo 2]    HOURLY - Specifies the number of hours before the sync should run.
echo 3]    DAILY - Specifies the number of days before the sync should run.
echo 4]    WEEKLY Specifies the number of weeks before the sync should run.
echo 5]    MONTHLY - Specifies the number of months before the sync should run.
echo 6]    ONCE - Specifies that that sync runs once at a specified date and time.
echo 7]    ONSTART - Specifies that the sync runs every time the system starts. You can specify a start date, or run the task the next time the system starts.
echo 8]    ONLOGON - Specifies that the sync runs whenever a user (any user) logs on. You can specify a date, or run the task the next time the user logs on.
echo 9]    ONIDLE - Specifies that the sync runs whenever the system is idle for a specified period of time. You can specify a date, or run the task the next time the system is idle.
echo x]    Exit
echo.
echo.
set /p choice=Type of Sync (yeah, only select 3)? 

if not '%choice%'=='' set choice=%choice:~0,1%

if '%choice%'=='1' goto minute
if '%choice%'=='2' goto hourly
if '%choice%'=='3' goto daily
if '%choice%'=='4' goto weekly
if '%choice%'=='5' goto monthly
if '%choice%'=='6' goto once
if '%choice%'=='7' goto onstart
if '%choice%'=='8' goto onlogon
if '%choice%'=='9' goto onidle
if '%choice%'=='x' goto end

echo "%choice%" is not valid, try again
echo.
goto getdelay

:minute
cls
echo ##############################################################
echo.
echo Sorry, not implemented yet!
echo Cartoon running away with clouds of dust..............
pause
goto end

:hourly
cls
echo ##############################################################
echo.
echo Sorry, not implemented yet!
echo Cartoon running away with clouds of dust..............
pause
goto end

:daily
cls
echo ##############################################################
echo.

set /p numdays=Number of days between Syncs? 
set /p starthour=Hour to start - 24 Hour (HH)? 
set starthour=0%starthour%
set starthour=%starthour:~-2%
set /p startmin=Minute (MM)? 
set startmin=0%startmin%
set startmin=%startmin:~-2%
set starttime=%starthour%:%startmin%
echo.
echo StartTime %starttime%
choice /N /C:YN /M "Is this correct (Y/N)?"%1

if %ERRORLEVEL% == 1 schtasks /create /f /sc daily /tn "MyTasks\Syncy" /tr "%syncyloc%\syncy.bat" /ru %username% /rl HIGHEST /mo %numdays% /st %starttime%
if %ERRORLEVEL% == 2 goto daily

pause

goto end

:weekly
cls
echo ##############################################################
echo.
echo Sorry, not implemented yet!
echo Cartoon running away with clouds of dust..............
pause
goto end

:monthly
cls
echo ##############################################################
echo.
echo Sorry, not implemented yet!
echo Cartoon running away with clouds of dust..............
pause
goto end

:once
cls
echo ##############################################################
echo.
schtasks /create /sc once /tn "MyTasks\Syncy" /tr "%systemdrive%\Program Files\Syncy\syncy.bat" /mo %numdays% /st %starttime%
pause 
goto end

:onstart
cls
echo ##############################################################
echo.
echo Sorry, not implemented yet!
echo Cartoon running away with clouds of dust..............
pause
goto end

:onlogon
cls
echo ##############################################################
echo.
echo Sorry, not implemented yet!
echo Cartoon running away with clouds of dust..............
pause
goto end

:onidle
cls
echo ##############################################################
echo.
echo Sorry, not implemented yet!
echo Cartoon running away with clouds of dust..............
pause
goto end

:end

exit



