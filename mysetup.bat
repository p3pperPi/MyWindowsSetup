@echo off
setlocal enabledelayedexpansion

:: ==========================================
:: Check Administrator Privileges
:: ==========================================
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
echo  Engineer PC Setup Script (Interactive Mode)
echo  - Installers will require user input
echo ==========================================
echo.

:: Change to scripts directory
cd /d "%~dp0scripts"

:: ==========================================
:: Run each section
:: ==========================================
call 01_system_settings.bat /auto
call 02_windows_optimize.bat /auto
call 03_install_winget.bat /auto
call 04_install_choco.bat /auto
call 05_file_association.bat /auto
call 06_manual_install.bat /auto

:: ==========================================
:: Completion
:: ==========================================
echo.
echo [Post-Install] Launching Sticky Notes...
start shell:AppsFolder\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe!App

echo.
echo ==========================================
echo  All Setup Completed!
echo.
echo  [IMPORTANT]
echo  1. Please RESTART your PC to apply Registry/FastStartup settings.
echo  2. Open "PowerToys" -> "Keyboard Manager" for Ctrl+Space toggle.
echo ==========================================
pause
