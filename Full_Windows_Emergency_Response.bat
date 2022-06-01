@ECHO off

:customer
cls

echo ############### Customer Details ###############

echo 0. New Customer
echo 1. Existing Customer
echo x. Exit
echo.
echo.

echo.
set choice=
set /p choice= Select Option. 
if not '%choice%'=='' set choice=%choice:~0,1%

if '%choice%'=='0' goto new
if '%choice%'=='1' goto existing
if '%choice%'=='x' goto end

echo "%choice%" is not valid, try again
echo.
goto customer

:new
set /p name= Name - 
set /p email= Email -  
set when=%date%
set logfile=%~dp0AV\AV_Logs\%name%\log.txt
set logpath=%~dp0AV\AV_Logs\%name%

(md "%~dp0AV\AV_Logs\%name%\" 2>nul && (echo %name% && echo %email% && echo %when% && echo.) >>"%logfile%") || ((echo ######################### && echo %name% && echo %email% && echo %when% && echo.) >>"%logfile%")

goto av

:existing
setlocal enabledelayedexpansion
set count=0

for /d %%d in (%~dp0AV\AV_Logs\*) do (
  set /a count=count+1
  set choice[!count!]=%%d
)

echo.
echo Select one:
echo.

for /l %%d in (1,1,!count!) do (
   echo %%d] !choice[%%d]!
)
echo.

set /p select=?

set logpath=!choice[%select%]!
set logfile=!choice[%select%]!\log.txt

endlocal && set logpath=%logpath% && set logfile=%logfile%

goto av

:av
cls

echo ############### AV Tools ###############
echo.
echo 0.  None (Move to Next Steps)
echo 1.  Terminate Processes (RKill) USE FIRST
echo 2.  Kaspersky Virus Removal Tool
echo 3.  McAfee Stinger (Need to shut down all other apps)
echo 4.  Tdss Killer
echo 5.  Norton Power Eraser
echo 6.  Emsisoft Emergency Kit
echo 7.  Eset Online Scanner
echo 8.  Hitman Pro
echo 9.  F-Secure Online Scanner
echo 10. Malwarebytes Anti-Rootkit
echo 11. Malwarebytes Adwcleaner
echo 12. Malwarebytes
echo 13. CCleaner
echo 14. Chrome Cleanup Tool (Moved to browser)
echo 15. Sophos Scan and Clean
echo x.  Exit
echo.
echo.

set choice=
set /p choice= Select AV. 
if not '%choice%'=='' set choice=%choice:~0,2%

if '%choice%'=='0' goto other
if '%choice%'=='1' goto rk
if '%choice%'=='2' goto kvrt
if '%choice%'=='3' goto msp
if '%choice%'=='4' goto tdss
if '%choice%'=='5' goto npe
if '%choice%'=='6' goto eek
if '%choice%'=='7' goto eos
if '%choice%'=='8' goto hmp
if '%choice%'=='9' goto fos
if '%choice%'=='10' goto mbar
if '%choice%'=='11' goto mbaw
if '%choice%'=='12' goto mb
if '%choice%'=='13' goto cc
if '%choice%'=='14' goto gcc
if '%choice%'=='15' goto ssc
if '%choice%'=='x' goto end

echo "%choice%" is not valid, try again
echo.
goto av

:other
cls
echo ############### Tidy Up Stuff ###############
echo.
echo 0.  Back to AV
echo 1.  System File Checker
echo 2.  Deployment Image Servicing and Management
echo 3.  Check Startup
echo 4.  Check Installed Programs
echo 5.  Review Security Settings
echo 6.  Check user Account Settings
echo 7.  Configure DNS to use Quad9
echo 8.  Run Defender Offline Scan
echo 9.  Check for TPM
echo 10. Router Admin
echo 11. Move Logs to USB and clean up (Reboot before use)
echo 12. Check drive SMART status
echo 13. Retrieve Windows product key
echo 14. Reboot (Required for KVRT log removal)
echo 15. Create Restore Point
echo 16. System Information
echo x.  Exit

echo.
set choice=
set /p choice= Next Step. 
if not '%choice%'=='' set choice=%choice:~0,2%

if '%choice%'=='1' goto sfc
if '%choice%'=='2' goto dism
if '%choice%'=='3' goto msc
if '%choice%'=='4' goto app
if '%choice%'=='5' goto sec
if '%choice%'=='6' goto acc
if '%choice%'=='7' goto dns
if '%choice%'=='8' goto ols
if '%choice%'=='9' goto tpm
if '%choice%'=='0' goto av
if '%choice%'=='10' goto router
if '%choice%'=='11' goto cleanup
if '%choice%'=='12' goto smart
if '%choice%'=='13' goto winkey
if '%choice%'=='14' goto rb
if '%choice%'=='15' goto rp
if '%choice%'=='16' goto si
if '%choice%'=='x' goto end

echo "%choice%" is not valid, try again
echo.
goto other

:: 1
:rk
"%~dp0AV\iExplore.exe"
(echo Rkill run at %time% && echo.) >> "%logfile%"
goto av

:: 2
:kvrt
"%~dp0AV\KVRT.exe"
(echo Kaspersky Virus Removal Tool run at %time% && echo.) >> "%logfile%"
goto av

:: 3
:msp
"%~dp0AV\McAfeeStingerPortable\McAfeeStingerPortable.exe"
(echo McAfee Stinger Portable run at %time% && echo.) >> "%logfile%"
goto av

:: 4
:tdss 
"%~dp0AV\tdsskiller.exe"
(echo TDSS Killer run at %time% && echo.) >> "%logfile%"
goto av

:: 5
:npe
"%~dp0AV\NPE.exe"
(echo Norton Power Eraser run at %time% && echo.) >> "%logfile%"
goto av

:: 6
:eek
"%~dp0AV\EEK\Start Emergency Kit Scanner.exe"
(echo Emsisoft Emergency Kit run at %time% && echo.) >> "%logfile%"

goto av

:: 7
:eos
"%~dp0AV\esetonlinescanner.exe"
(echo ESET Online Scanner run at %time% && echo.) >> "%logfile%"
goto av

:: 8
:hmp
"%~dp0AV\HitmanPro_x64.exe"
(echo Hitman Pro run at %time% && echo.) >> "%logfile%"

goto av

:: 9
:fos
"%~dp0AV\F-SecureOnlineScanner.exe"
(echo F-Secure Online Scanner run at %time% && echo.) >> "%logfile%"
goto av

:: 10
:mbar
"%~dp0AV\mbar-1.10.3.1001.exe"
(echo Malwarebytes Anti Rootkit run at %time% && echo.) >> "%logfile%"
goto av

:: 11
:mbaw
"%~dp0AV\adwcleaner.exe"
(echo Malwarebytes Adware Cleaner run at %time% && echo.) >> "%logfile%"
goto av

:: 12
:mb
"%~dp0AV\MBSetup.exe"
(echo Malwarebytes run at %time% && echo.) >> "%logfile%"
goto av

:: 13
:cc
"%~dp0AV\CCleaner\CCleaner.exe"
(echo CCleaner run at %time% && echo.) >> "%logfile%"

goto av

:: 14
:gcc
"%~dp0AV\chrome_cleanup_tool.exe"
(echo Google Chrome Cleanup Tool run at %time% && echo.) >> "%logfile%"
goto av

:: 15
:ssc
"%~dp0AV\SophosScanAndClean_x64.exe"
(echo Sophos Scan and Clean run at %time% && echo.) >> "%logfile%"

goto av

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: 1
:sfc
cd %systemdrive%\
sfc /scannow
(echo SFC scan run at %time% && echo.) >> "%logfile%"
pause
goto other

:: 2
:dism
cd %systemdrive%\
(echo DISM Check,Scan and Restore started at %time% && echo.) >> "%logfile%"
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
(echo DISM Check, Scan and Restore completed at %time% && echo.) >> "%logfile%"
pause
goto other

:: 3
:msc
msconfig
(echo Startup checked at %time% && echo.) >> "%logfile%"
goto other


:: 4
:app
control appwiz.cpl
(echo Installed Apps checked at %time% && echo.) >> "%logfile%"
goto other

:: 5
:sec
control wscui.cpl
(echo Security Settings checked at %time% && echo.) >> "%logfile%"
goto other

:: 6
:acc
control nusrmgr.cpl
(echo Account Settings checked at %time% && echo.) >> "%logfile%"
goto other

:: 7
:dns
for /F "tokens=3,*" %%a in ('netsh interface show interface^|find "Connected"') do (set itf=%%b)

((ipconfig | findstr /C:IPv4 | findstr /V Link) >Nul && (netsh interface ipv4 set dnsservers %itf% static 9.9.9.9 primary && netsh interface ipv4 add dnsservers %itf% 149.112.112.112 index=2 && echo IPv4 DNS modified))

((ipconfig | findstr /C:IPv6 | findstr /V Link) >Nul && (netsh interface ipv6 set dnsservers %itf% static 2620:fe::fe primary && netsh interface ipv6 add dnsservers %itf% 2620:fe::9 index=2 && echo IPv6 DNS modified))

ipconfig /flushdns
(echo DNS set to Quad9 and cache flushed at %time% && echo.) >> "%logfile%"
goto other

:: 8
:ols
echo THIS WILL NOT WORK WITH ANOTHER AV RUNNING!
echo.
echo Disable other AV and close all open programs as there will be a reboot
choice /N /C:YN /M "Continue (Y/N)?"%1
if %ERRORLEVEL% == 2 goto other
if %ERRORLEVEL% == 1 goto psols
goto other

:psols
"%ProgramFiles%\Windows Defender\mpcmdrun.exe" -SignatureUpdate
PowerShell Start-MpWDOScan
(echo Windows Defender Signatures Updated and Offline Scan Initiated at %time% && echo.) >> "%logfile%"
goto end

:: 9
:tpm
tpm.msc
(echo TPM status checked at %time% && echo.) >> "%logfile%"
goto other

:: 10
:router
for /F "tokens=12,*" %%a in ('ipconfig^|findstr /C:"Default Gateway"') do (start http://%%b)
(echo Router Settings checked at %time% && echo.) >> "%logfile%"
goto other

:: 11
:cleanup
::::::::: Registry ::::::::::::::

setlocal enabledelayedexpansion
set keys="HKEY_LOCAL_MACHINE\SOFTWARE\Norton" "HKEY_LOCAL_MACHINE\SOFTWARE\Emsisoft" "HKEY_LOCAL_MACHINE\SOFTWARE\HitmanPro" "HKEY_LOCAL_MACHINE\SOFTWARE\Piriform" "HKEY_LOCAL_MACHINE\SOFTWARE\SophosScanAndClean"

for %%k in (%keys%) do (reg query %%k >nul 2>&1 if !errorlevel! == 0 (reg delete %%k /f && echo "Removed %%k at %time%" && echo.) >> %%logfile%% )
endlocal

::::::::: Move Log Files ::::::::::::
::@echo on

:: rkill
if exist "%userprofile%\Desktop\Rkill.txt" move "%userprofile%\Desktop\Rkill.txt" "%logpath%"
if exist "%userprofile%\OneDrive\Desktop\Rkill.txt" move "%userprofile%\OneDrive\Desktop\Rkill.txt" "%logpath%"

pause

:: kvrt
if exist "%systemdrive%\KVRT*" for /f "delims=" %%a in ('dir /b /ad "%systemdrive%\KVRT*"') do xcopy /i /s /t /r /h "%systemdrive%\%%a" "%logpath%\KVRT"
if exist "%systemdrive%\KVRT*" for /f "delims=" %%a in ('dir /b /ad "%systemdrive%\KVRT*"') do rmdir /Q /S "%systemdrive%\%%a"

pause

:: msp
:: tdss
if exist "%systemdrive%\TDSSKiller*.*" move "%systemdrive%\TDSSKiller*.*" "%logpath%"

pause

:: npe
:: eek
:: eos
:: hmp
:: fos
:: mbar
:: mbaw
if exist "%systemdrive%\AdwCleaner\" move "%systemdrive%\AdwCleaner" "%logpath%"

pause

:: mb
:: cc
:: gcc
:: ssc
::@echo off

goto other

:: 12
:smart
wmic diskdrive get model,status

pause

echo Smart Status >> "%logfile%"
wmic diskdrive get model,status >> "%logfile%"

goto other

:: 13
:winkey
echo Windows Product Key >> "%logfile%"
wmic path softwarelicensingservice get OA3xOriginalProductKey >> "%logfile%"

pause

goto other

:: 14
:rb
shutdown /r /t 4 /c "To unload arkmon.sys" /d p:4:1

goto end

:: 15
:rp
SystemPropertiesProtection

goto other

:: 16
:si
systeminfo >> "%logfile"
pause

goto other

:end

exit
