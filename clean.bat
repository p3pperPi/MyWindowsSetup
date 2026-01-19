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
echo  Engineer PC Cleanup Script
echo  (Uninstalling Apps and Fonts)
echo ==========================================
echo.
echo  WARNING: This will uninstall installed applications.
echo  Press Ctrl+C to cancel, or any key to continue...
pause >nul

:: ==========================================
:: 2. Uninstall Chocolatey Packages
:: ==========================================
echo.
echo [Uninstall 1/3] Removing Chocolatey Packages...
echo (Python, KiCad, GIMP, Fonts, etc.)
echo.

:: Removing all versions to clean up KiCad side-by-side installs
choco uninstall -y --remove-dependencies --all-versions python3 arduino kicad gimp inkscape firealpaca meshlab sysinternals google-noto-sans-cjk-jp google-noto-serif-cjk-jp hackgen-nf udev-gothic ricty-diminished jost

:: ==========================================
:: 3. Uninstall Winget Apps
:: ==========================================
echo.
echo [Uninstall 2/3] Removing Winget Apps...
echo.

:: Define list of Winget IDs (Single line to avoid syntax errors)
set WINGET_APPS=Microsoft.VisualStudioCode Microsoft.VisualStudio.2022.Community Notepad++.Notepad++ Git.Git GitHub.GitHubDesktop Kitware.CMake AnalogDevices.LTspice TeraTermProject.TeraTerm BambuLab.BambuStudio Meltytech.Shotcut HandBrake.HandBrake XMediaRecode.XMediaRecode DigiDNA.iMazingHEICConverter IrfanSkiljan.IrfanView VideoLAN.VLC SlackTechnologies.Slack Asana.Asana Discord.Discord Zoom.Zoom Notion.Notion JohnMacFarlane.Pandoc JGraph.Draw Microsoft.PowerToys AutoHotkey.AutoHotkey AntibodySoftware.WizTree voidtools.Everything SumatraPDF.SumatraPDF 7zip.7zip WinMerge.WinMerge Google.Chrome Valve.Steam 9NBLGGH4QGHW

:: Loop uninstall
for %%I in (%WINGET_APPS%) do (
    echo Uninstalling %%I ...
    winget uninstall --id %%I --silent --accept-source-agreements
)

:: ==========================================
:: 4. Cleanup Shortcuts
:: ==========================================
echo.
echo [Uninstall 3/3] Cleaning up Shortcuts...
if exist "%USERPROFILE%\Desktop\DeviceManager.lnk" del "%USERPROFILE%\Desktop\DeviceManager.lnk"
if exist "%USERPROFILE%\Desktop\ControlPanel.lnk" del "%USERPROFILE%\Desktop\ControlPanel.lnk"

:: ==========================================
:: Completion
:: ==========================================
echo.
echo ==========================================
echo  Cleanup Completed.
echo  Please RESTART your PC to clear files.
echo  (Note: STM32CubeIDE and Fusion360 must be uninstalled manually)
echo ==========================================
pause