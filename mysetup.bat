@echo off

chcp 932

setlocal enabledelayedexpansion



:: ==========================================

:: 1. 管理者権限チェック

:: ==========================================

openfiles >nul 2>&1

if %errorlevel% neq 0 (

    echo.

    echo [ERROR] 管理者権限が必要です。

    echo バッチファイルを右クリックして「管理者として実行」してください。

    echo.

    pause

    exit /b

)



echo ==========================================

echo  エンジニア向け Windows環境構築スクリプト

echo  - Dynamic Drawは手動でインストールしてください

echo  - SolidWorks等は手動でインストールしてください

echo ==========================================

echo.



:: JSONファイルの存在確認

if not exist "myapps.json" (

    echo [ERROR] "myapps.json" が見つかりません。

    pause

    exit /b

)



:: ==========================================

:: 2. キーボード設定 (CapsLockのみレジストリ推奨)

:: ==========================================

echo [KeyMap] CapsLockをCtrlに変更します(レジストリ変更)...

:: Scancode Map: CapsLock(0x3A) -> LeftCtrl(0x1D)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d 0000000000000000020000001d003a0000000000 /f >nul



:: ==========================================

:: 3. Windows設定の最適化

:: ==========================================

echo [Setting] エクスプローラー設定を変更中...

:: 拡張子を表示

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f >nul

:: 隠しファイルを表示

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f >nul

:: 起動時に「PC」を開く

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f >nul



echo [Setting] 右クリックメニューを旧仕様(フル表示)に変更中...

reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul



echo [Setting] ダークモードを有効化中...

:: アプリのダークモード

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 0 /f >nul

:: システム(タスクバー等)のダークモード

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d 0 /f >nul



echo [Setting] タスクバーとスタートメニューを調整中...

:: タスクバー左揃え

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d 0 /f >nul

:: Web検索無効化

reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1 /f >nul

:: スタートメニューの「おすすめ」を最小化（完全に消すにはExplorerPatcher等が必要）

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_Layout" /t REG_DWORD /d 1 /f >nul



echo [Setting] デスクトップにショートカットを作成中...

powershell -NoProfile -Command ^

  "$ws = New-Object -ComObject WScript.Shell; ^

   $s = $ws.CreateShortcut('%USERPROFILE%\Desktop\DeviceManager.lnk'); ^

   $s.TargetPath = 'devmgmt.msc'; $s.Save(); ^

   $s2 = $ws.CreateShortcut('%USERPROFILE%\Desktop\ControlPanel.lnk'); ^

   $s2.TargetPath = 'control.exe'; $s2.Save();"



echo [Setting] 設定変更完了。



:: ==========================================

:: 4. アプリケーションの一括インストール

:: ==========================================

echo.

echo [Install] アプリとフォントをインストールします...

echo ※時間がかかります。画面を閉じないでください。

echo.



winget import --import-file "myapps.json" --accept-package-agreements --accept-source-agreements



:: 付箋を起動してみる（インストール確認）

echo.

echo [Post-Install] 付箋アプリを起動します...

start shell:AppsFolder\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe!App



echo.

echo ==========================================

echo  すべての処理が完了しました。

echo  右クリックメニューなどを反映させるため、

echo  必ず【PCを再起動】してください。

echo ==========================================

pause