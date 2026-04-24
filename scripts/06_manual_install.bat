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
echo  [6/6] Manual Install Helper
echo ==========================================
echo.

echo Opening Download Pages for Login-Required Apps...

:: STM32 & Fusion
start https://www.st.com/en/development-tools/stm32cubeide.html
start https://www.st.com/en/development-tools/stm32cubeprog.html
start https://www.autodesk.com/products/fusion-360/personal

echo.
echo [6/6] Download pages opened in browser.
echo  - STM32CubeIDE
echo  - STM32CubeProgrammer
echo  - Autodesk Fusion 360 (Personal)
echo.
if /i not "%1"=="/auto" pause
