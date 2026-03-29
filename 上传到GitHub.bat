@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ========================================
echo   SketchUp 在线插件 - 一键上传
echo ========================================
echo.

:: 检查是否有改动
"C:\Program Files\Git\bin\git.exe" diff --quiet HEAD 2>nul
if %errorlevel%==0 (
    "C:\Program Files\Git\bin\git.exe" status --short | findstr /r "." >nul 2>nul
    if %errorlevel%==1 (
        echo  没有任何改动，无需上传。
        echo.
        pause
        exit /b
    )
)

:: 显示改动的文件
echo  本次改动的文件：
echo  ----------------------------------------
"C:\Program Files\Git\bin\git.exe" status --short
echo  ----------------------------------------
echo.

:: 输入提交说明
set /p MSG="  请输入更新说明（直接回车则使用默认说明）: "
if "%MSG%"=="" set MSG=更新插件

:: 提交
echo.
echo  正在提交...
"C:\Program Files\Git\bin\git.exe" add .
"C:\Program Files\Git\bin\git.exe" commit -m "%MSG%"

:: 推送
echo.
echo  正在推送到 GitHub...
"C:\Program Files\Git\bin\git.exe" push

if %errorlevel%==0 (
    echo.
    echo  ========================================
    echo   上传成功！
    echo   1~2 分钟后线上自动生效
    echo   用户在 SketchUp 刷新即可看到更新
    echo  ========================================
) else (
    echo.
    echo   上传失败，请检查网络或 GitHub 登录状态
)

echo.
pause
