@echo off
rem This bat lives in the project folder; %~dp0 is that folder (encoding-safe).
rem --bind 127.0.0.1: local-only, immune to network changes (tethering, wifi switch).
rem Loop: if the server ever dies, restart it after 3 seconds.
cd /d "%~dp0"
:loop
python -m http.server 8000 --bind 127.0.0.1
timeout /t 3 /nobreak >nul
goto loop
