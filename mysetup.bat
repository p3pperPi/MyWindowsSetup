@echo off
setlocal enabledelayedexpansion

:: ==========================================
:: 1. Check Administrator Privileges
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
echo  Engineer PC Setup Script
echo  - CapsLock -> Ctrl (Registry)
echo  - Please set IME toggle (Ctrl+Space) in PowerToys later.
echo ==========================================
echo.

:: Check JSON file
if not exist "myapps.json" (
    echo [ERROR] "myapps.json" not found.
    pause
    exit /b
)

:: ==========================================
:: 2. System Settings (Registry)
:: ==========================================
echo [Setting] Disabling Fast Startup...
powercfg /h off

echo [KeyMap] Changing CapsLock to Ctrl (Registry)...
:: Scancode Map: CapsLock(0x3A) -> LeftCtrl(0x1D)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d 0000000000000000020000001d003a0000000000 /f >nul

echo [Setting] Disabling Windows Ads & Suggestions...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d 0 /f >nul


:: ==========================================
:: 3. Windows Settings Optimization
:: ==========================================
echo [Setting] Optimizing Explorer settings...
:: Show extensions
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f >nul
:: Show hidden files
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f >nul
:: Launch to "This PC"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f >nul
:: Restore old context menu
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul

echo [Setting] Enabling Dark Mode...
:: Apps
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 0 /f >nul
:: System
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d 0 /f >nul

echo [Setting] Adjusting Taskbar and Start Menu...
:: Taskbar Alignment (Left)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d 0 /f >nul
:: Disable Web Search
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1 /f >nul
:: Minimize Recommendations
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_Layout" /t REG_DWORD /d 1 /f >nul

echo [Setting] Creating Shortcuts...
powershell -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%USERPROFILE%\Desktop\DeviceManager.lnk'); $s.TargetPath = 'devmgmt.msc'; $s.Save(); $s2 = $ws.CreateShortcut('%USERPROFILE%\Desktop\ControlPanel.lnk'); $s2.TargetPath = 'control.exe'; $s2.Save();"

:: ==========================================
:: 4. Install Applications by Winget
:: ==========================================
echo.
echo [Install] Installing apps and fonts via Winget...
echo * Please do not close this window.
echo.

winget import --import-file "myapps.json" --accept-package-agreements --accept-source-agreements

echo.
echo Installing Sticky Notes ...
winget install --id 9NBLGGH4QGHW --source msstore --accept-package-agreements

:: HEIF & HEVC Extensions
echo.
echo Installing HEIF/HEVC Extensions (Store)...
echo Note: Installing "HEVC Video Extensions from Device Manufacturer" (Free version)
winget install --id 9PMMSR1CGPWG --source msstore --accept-package-agreements
winget install --id 9N4WGH0Z6VHQ --source msstore --accept-package-agreements

:: ==========================================
:: 5. Install Application by Chocolatey 
:: ==========================================
echo.
echo Installing Chocolatey...
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
set "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

echo.
echo Installing Dev Tools via Chocolatey...
choco install -y python3 arduino gimp inkscape firealpaca meshlab sysinternals

echo.
echo [Install KiCad] Installing versions 5.1.12 and 9.0.7...
choco install kicad --version 5.1.12 -y
choco install kicad --version 9.0.7 -y

:: Fonts
echo.
echo [Install Fonts] Installing Fonts...
choco install -y google-noto-sans-cjk-jp google-noto-serif-cjk-jp
choco install -y font-hackgen font-firge myrica jetbrainsmono source-han-code-jp
choco install -y fonts-ricty-diminished fonts-ricty
choco install -y jost

:: ==========================================
:: 6. File Association (Notepad++ for .txt)
:: ==========================================
echo.
echo [Config] Setting Notepad++ as default for .txt...
ftype txtfile="C:\Program Files\Notepad++\notepad++.exe" "%%1"
assoc .txt=txtfile

:: ==========================================
:: 7. Manual Install Helper
:: ==========================================
echo.
echo  Opening Download Pages for Login-Required Apps...

:: STM32 & Fusion
start https://www.st.com/en/development-tools/stm32cubeide.html
start https://www.st.com/en/development-tools/stm32cubeprog.html
start https://www.autodesk.com/products/fusion-360/personal

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