@echo off
cd /d "%~dp0evaltrack-api"
echo Starting Laravel API on http://127.0.0.1:5001
C:\xampp\php\php.exe artisan serve --host=127.0.0.1 --port=5001
pause
