@echo off
setlocal enabledelayedexpansion

openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Run as Administrator required.
    echo Please right-click and select "Run as administrator".
    echo.
    pause
    exit /b
)

echo ==========================================
echo  [5/6] File Association
echo ==========================================
echo.

echo [Config] Setting Notepad++ as default for .txt...
ftype txtfile="C:\Program Files\Notepad++\notepad++.exe" "%1"
assoc .txt=txtfile

echo.
echo [5/6] File Association Done.
echo.
if /i not "%1"=="/auto" pause
