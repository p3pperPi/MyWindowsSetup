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
echo  App Update Script
echo ==========================================
echo.

:: ==========================================
:: Winget
:: ==========================================
echo [Update] Updating all apps via Winget...
winget upgrade --all --accept-package-agreements --accept-source-agreements
echo.

:: ==========================================
:: Chocolatey
:: ==========================================
echo [Update] Updating all apps via Chocolatey...
choco upgrade all -y
echo.

echo ==========================================
echo  All Updates Completed!
echo ==========================================
pause
