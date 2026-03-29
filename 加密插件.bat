@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ========================================
echo   SketchUp 插件加密工具
echo ========================================
echo.

:: 提示输入密钥（首次使用设定，以后每次必须一样）
set /p KEY="  请输入加密密钥: "
if "%KEY%"=="" (
    echo   密钥不能为空！
    pause
    exit /b
)
echo.

:: 用 PowerShell 执行加密
powershell -ExecutionPolicy Bypass -File "%~dp0tools\encrypt.ps1" -Key "%KEY%" -PluginDir "%~dp0plugins" -ManifestPath "%~dp0manifest.json"

echo.
pause
