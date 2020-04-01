@echo off
setlocal enabledelayedexpansion

rem tunrdp.bat: SSH wrapper over old insecure RDP
rem
rem Usage: Simply run this bat file from cmd or just by clicking on it.
rem        No administrative privelleges required.
rem
rem Use cases: 1) When ssh server installed on RDS server;
rem            2) When ssh server is in the same network as RDS server;
rem            3) When you need to access PC in the same network as the SSH server.
rem
rem Author: Ilya Moiseev <ilya@moiseev.su>
rem
rem Version: 1.1 (April 02, 2020)
rem
rem Purpose: to wrap up and cover insecure rdp session using SSH tunneling
rem
rem License: "THE BEER-WARE LICENSE" (Revision 42):
rem <ilya@moiseev.su> wrote this file.  As long as you retain this notice you
rem can do whatever you want with this stuff. If we meet some day, and you think
rem this stuff is worth it, you can buy me a non-alcoholic beer in return. Ilya Moiseev
rem
rem TODO: CHKPLINK section is a potential one to fall into the infinite loop,
rem       it probably needs to be reworked (or not).

rem IP address of SSH server to create a ssh tunnel using it
set tunip=

rem PORT of the SSH server to connect, default one is: 22
set tunport=22

rem IP address of destination RDP server
set dstrdpip=

rem PORT of the RDP server, default one is: 3389
set dstrdpport=3389

rem PORT on localhost (127.0.0.1) interface to connect on using RDP utility ()mstsc.exe), you can leave 13777 as the default one
set localtunport=13777

rem USER with access to SSH server
rem This needs to be configured on SSH server side separately, general recommendation is:
rem create non-admin user with /usr/sbin/nologin as user's shell
set tunsshuser=

rem PASSWORD for the SSH server user, yes, in insecure manner
set tunsshuserpwd=

rem SSH server fingerprint
rem with this setting, plink.exe won't ask you to confirm and won't put this fingerprint into the registry.
rem You can find it by issuing: plink.exe -v -batch $HOSTNAME -P $PORT_NUMBER
rem The string after "Host key finger print is:" is our fingerprint to put here.
rem For example: 18:c2:4d:3f:79:c2:c3:4a:76:14:44:83:8f:47:ae:ad
set sshtunhostkey=

rem Starting with check if plink.exe already exis, if not -- download it into the home user's directory and call start tunneling script section
:CHKPLINK
if exist "C:\Users\%username%\plink.exe" (goto STARTTUNNEL) else (
echo plink.exe not found, downloading
bitsadmin /transfer putty_dwnld /download /priority high https://the.earth.li/~sgtatham/putty/latest/w32/plink.exe C:\Users\%username%\plink.exe
if errorlevel 1 (
   echo Download failed, will try again
   (goto CHKPLINK)
)
)

rem Starting tunnel to SSH server with port forwarding in the second shell
:STARTTUNNEL
echo Starting tunnel from your PC, using our ssh server, to remote desktop
start /MIN "TUNNEL" cmd /C C:\Users\%username%\plink.exe -batch -N -L %localtunport%:%dstrdpip%:%dstrdpport% %tunsshuser%@%tunip% -P %tunport% -pw %tunsshuserpwd% -hostkey %sshtunhostkey%
echo Preapearing to start an RDP session
goto STARTRDPSESSION 

rem When tunnel is up -- start RDP session utulity, when work is done, close the session by calling script section to close plink.exe
:STARTRDPSESSION
echo Starting the RDP session
mstsc.exe /v:127.0.0.1:%localtunport%
goto :CLOSEPLINK

rem Forcefully kill plink.exe process, this is the only way to handle it using batch
:CLOSEPLINK
echo Closing the plink.exe process and assigned CMD window
taskkill /F /IM plink.exe
if errorlevel 1 (
   echo An issue has occurred with killing plink.exe
   echo Consider kill it manually using Task Manager
   goto eof
)

:eof
