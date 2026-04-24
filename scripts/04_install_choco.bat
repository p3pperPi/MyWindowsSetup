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
echo  [4/6] Install Applications via Chocolatey
echo ==========================================
echo.

echo Installing Chocolatey...
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
set "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

echo.
echo Installing Dev Tools via Chocolatey (Interactive)...
choco install --notsilent python3 arduino gimp inkscape firealpaca meshlab sysinternals

echo.
echo [Install KiCad] Installing versions 5.1.12 and 9.0.7...
choco install kicad --version 5.1.12 -y
choco install kicad --version 9.0.7 -y

echo.
echo [Install Fonts] Installing Fonts...
choco install -y google-noto-sans-cjk-jp google-noto-serif-cjk-jp
choco install -y font-hackgen font-firge myrica jetbrainsmono source-han-code-jp
choco install -y fonts-ricty-diminished fonts-ricty
choco install -y jost

echo.
echo [4/6] Chocolatey Install Done.
echo.
if /i not "%1"=="/auto" pause
