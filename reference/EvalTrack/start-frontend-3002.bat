@echo off
cd /d "%~dp0evaltrack-web"
echo Starting Vue (Vite) on http://127.0.0.1:3002
call npm run dev
pause
