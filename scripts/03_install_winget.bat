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
echo  [3/6] Install Applications via Winget
echo  * Please do not close this window.
echo ==========================================
echo.

set WINGET_APPS=^
 Microsoft.VisualStudioCode ^
 Microsoft.VisualStudio.2022.Community ^
 Notepad++.Notepad++ ^
 Git.Git ^
 GitHub.GitHubDesktop ^
 Kitware.CMake ^
 AnalogDevices.LTspice ^
 TeraTermProject.TeraTerm ^
 BambuLab.BambuStudio ^
 Meltytech.Shotcut ^
 HandBrake.HandBrake ^
 XMediaRecode.XMediaRecode ^
 DigiDNA.iMazingHEICConverter ^
 IrfanSkiljan.IrfanView ^
 VideoLAN.VLC ^
 SlackTechnologies.Slack ^
 Asana.Asana ^
 Discord.Discord ^
 Zoom.Zoom ^
 Notion.Notion ^
 JohnMacFarlane.Pandoc ^
 JGraph.Draw ^
 Microsoft.PowerToys ^
 AutoHotkey.AutoHotkey ^
 AntibodySoftware.WizTree ^
 voidtools.Everything ^
 SumatraPDF.SumatraPDF ^
 Adobe.Acrobat.Reader.64-bit ^
 7zip.7zip ^
 WinMerge.WinMerge ^
 Google.Chrome ^
 Valve.Steam

for %%I in (%WINGET_APPS%) do (
    echo Installing: %%I
    winget install --id %%I --interactive --accept-package-agreements --accept-source-agreements
)

echo.
echo Installing Store Apps...
winget install --id 9NBLGGH4QGHW --source msstore --accept-package-agreements

echo.
echo Installing HEIF/HEVC Extensions (Store)...
echo Note: Installing "HEVC Video Extensions from Device Manufacturer" (Free version)
winget install --id 9PMMSR1CGPWG --source msstore --accept-package-agreements
winget install --id 9N4WGH0Z6VHQ --source msstore --accept-package-agreements

echo.
echo [3/6] Winget Install Done.
echo.
if /i not "%1"=="/auto" pause
