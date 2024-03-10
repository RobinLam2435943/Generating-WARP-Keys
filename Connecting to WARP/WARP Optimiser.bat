chcp 936
cls
@echo off & setlocal enabledelayedexpansion
cd "%~dp0"
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :start
) else (
    goto :UACPrompt
)

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B

:start
if not exist "warp.exe" echo Lacks 'warp.exe' Programme&pause&exit
if not exist "ips-v4.txt" echo Lacks IPV4 Data ips-v4.txt&pause&exit
if not exist "ips-v6.txt" echo Lacks IPV6 Data ips-v6.txt&pause&exit
echo.:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo.::                                                                 ::
echo.::                        WARP Optimiser                           ::
echo.::                                                                 ::
echo.:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo.
echo.
goto main

:main
title CF WARP Optimisation
set /a menu=1
echo 1. WARP-V4 IP Addresses and Ports Optimiser&echo 2. WARP-V6 IP Addresses and Ports Optimiser&echo 0. Exit&echo.
set /p menu=Please select an option (The default option is %menu%):
if %menu%==0 exit
if %menu%==1 title WARP-V4 Optimiser&set filename=ips-v4.txt&goto getv4
if %menu%==2 title WARP-V6 Optimiser&set filename=ips-v6.txt&goto getv6
cls
goto main

:getv4
for /f "delims=" %%i in (%filename%) do (
set !random!_%%i=randomsort
)
for /f "tokens=2,3,4 delims=_.=" %%i in ('set ^| findstr =randomsort ^| sort /m 10240') do (
call :randomcidrv4
if not defined %%i.%%j.%%k.!cidr! set %%i.%%j.%%k.!cidr!=anycastip&set /a n+=1
if !n! EQU 100 goto getip
)
goto getv4

:randomcidrv4
set /a cidr=%random%%%256
goto :eof

:getv6
for /f "delims=" %%i in (%filename%) do (
set !random!_%%i=randomsort
)
for /f "tokens=2,3,4 delims=_:=" %%i in ('set ^| findstr =randomsort ^| sort /m 10240') do (
call :randomcidrv6
if not defined [%%i:%%j:%%k::!cidr!] set [%%i:%%j:%%k::!cidr!]=anycastip&set /a n+=1
if !n! EQU 100 goto getip
)
goto getv6

:randomcidrv6
set str=0123456789abcdef
set /a r=%random%%%16
set cidr=!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!:!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!:!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!:!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
goto :eof

:getip
del ip.txt > nul 2>&1
for /f "tokens=1 delims==" %%i in ('set ^| findstr =randomsort') do (
set %%i=
)
for /f "tokens=1 delims==" %%i in ('set ^| findstr =anycastip') do (
echo %%i>>ip.txt
)
for /f "tokens=1 delims==" %%i in ('set ^| findstr =anycastip') do (
set %%i=
)
warp
for /f "skip=1 tokens=1,2,3 delims=," %%i in (result.csv) do (
set endpoint=%%i
set loss=%%j
set delay=%%k
goto warp-cli
)

:warp-cli
warp-cli disconnect
warp-cli tunnel endpoint reset
warp-cli tunnel endpoint set %endpoint%
warp-cli connect
del ip.txt result.csv> nul 2>&1
echo.:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo.::                                                                 ::
echo.           The server has been set to %endpoint%
echo.		    Loss %loss% Delay %delay%                
echo.::                                                                 ::
echo.:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo.
pause
exit