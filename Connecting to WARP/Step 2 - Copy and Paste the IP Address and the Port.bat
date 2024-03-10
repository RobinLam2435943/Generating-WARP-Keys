@echo off
chcp 936 > nul
set endpoint=162.159.192.1:2408
set /p endpoint=Please enter the IP address and the port number (The default option is %endpoint%):
warp-cli.exe clear-custom-endpoint
warp-cli.exe set-custom-endpoint %endpoint%
echo The current IP address and the port is set to be %endpoint%
pause