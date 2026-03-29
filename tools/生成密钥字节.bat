@echo off
chcp 65001 >nul
echo ========================================
echo   密钥字节生成器
echo ========================================
echo.
echo   输入你的加密密钥，会输出对应的 Ruby 字节数组。
echo   把结果复制到 crypto.rb 的 SECRET_BYTES 中。
echo.

set /p KEY="  请输入密钥: "

powershell -Command "$bytes = [System.Text.Encoding]::UTF8.GetBytes('%KEY%'); $arr = ($bytes | ForEach-Object { $_.ToString() }) -join ', '; Write-Host ''; Write-Host '  复制以下内容替换 crypto.rb 中的 SECRET_BYTES：' -ForegroundColor Cyan; Write-Host ''; Write-Host \"  SECRET_BYTES = [$arr].freeze\" -ForegroundColor Green; Write-Host ''"

echo.
pause
