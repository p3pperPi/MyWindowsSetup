@echo off
setlocal enabledelayedexpansion

:: ==========================================
:: 1. 管理者権限チェック
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
echo  (Uninstalling Apps & Fonts)
echo ==========================================
echo.
echo  WARNING: This will uninstall installed applications.
echo  Press Ctrl+C to cancel, or any key to continue...
pause >nul

:: ==========================================
:: 2. Chocolatey Packages Uninstall
:: ==========================================
echo.
echo [Uninstall 1/3] Removing Chocolatey Packages...
echo (Including Python, KiCad, GIMP, Fonts, etc.)
echo.

:: 依存関係も含めて削除、確認なし(-y)、全バージョン削除(KiCad対策)
:: Note: Chocolatey自体は最後に削除します
choco uninstall -y --remove-dependencies --all-versions ^
 python3 arduino kicad gimp inkscape firealpaca meshlab sysinternals ^
 google-noto-sans-cjk-jp google-noto-serif-cjk-jp ^
 hackgen-nf udev-gothic ricty-diminished jost

:: ==========================================
:: 3. Winget Apps Uninstall
:: ==========================================
echo.
echo [Uninstall 2/3] Removing Winget Apps...
echo.

:: 削除対象のIDリスト
set APPS=^
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
 7zip.7zip ^
 WinMerge.WinMerge ^
 Google.Chrome ^
 Valve.Steam ^
 9NBLGGH4QGHW

:: ループ処理で削除実行
for %%I in (%APPS%) do (
    echo Uninstalling %%I ...
    winget uninstall --id %%I --silent --accept-source-agreements
)

:: ==========================================
:: 4. Cleanup Shortcuts & Extras
:: ==========================================
echo.
echo [Uninstall 3/3] Cleaning up Shortcuts...
del "%USERPROFILE%\Desktop\DeviceManager.lnk" >nul 2>&1
del "%USERPROFILE%\Desktop\ControlPanel.lnk" >nul 2>&1

:: Chocolatey本体の削除は手動で行うのが安全ですが、
:: フォルダを削除することで無効化できます（ここではフォルダ削除コマンドのみ表示）
echo.
echo [Info] To completely remove Chocolatey itself:
echo   rmdir /s /q "%ALLUSERSPROFILE%\chocolatey"
echo.
echo [Info] Please uninstall the following MANUALLY:
echo   - STM32CubeIDE / Programmer
echo   - Autodesk Fusion
echo.

echo ==========================================
echo  Cleanup Completed.
echo  Please RESTART your PC to clear files/fonts.
echo ==========================================
pause