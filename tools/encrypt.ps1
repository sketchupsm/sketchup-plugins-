param(
    [string]$Key,
    [string]$PluginDir,
    [string]$ManifestPath
)

$ErrorActionPreference = "Stop"

function Encrypt-File {
    param([string]$FilePath, [string]$Password)

    $content = [System.IO.File]::ReadAllBytes($FilePath)

    # Generate random IV (16 bytes) and Salt (16 bytes)
    $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
    $iv = New-Object byte[] 16
    $salt = New-Object byte[] 16
    $rng.GetBytes($iv)
    $rng.GetBytes($salt)

    # Derive key using PBKDF2 (SHA1, 10000 iterations, 32 bytes = AES-256)
    $derive = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($Password, $salt, 10000)
    $aesKey = $derive.GetBytes(32)

    # AES-256-CBC encrypt
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
    $aes.Key = $aesKey
    $aes.IV = $iv

    $encryptor = $aes.CreateEncryptor()
    $encrypted = $encryptor.TransformFinalBlock($content, 0, $content.Length)

    # Output format: base64( IV[16] + Salt[16] + Ciphertext )
    $combined = New-Object byte[] ($iv.Length + $salt.Length + $encrypted.Length)
    [Array]::Copy($iv, 0, $combined, 0, 16)
    [Array]::Copy($salt, 0, $combined, 16, 16)
    [Array]::Copy($encrypted, 0, $combined, 32, $encrypted.Length)

    $outputPath = [System.IO.Path]::ChangeExtension($FilePath, ".rbe")
    $base64 = [Convert]::ToBase64String($combined)
    [System.IO.File]::WriteAllText($outputPath, $base64)

    $aes.Dispose()
    $derive.Dispose()
    $rng.Dispose()

    return $outputPath
}

# Find all main.rb files in plugin subdirectories
$mainFiles = Get-ChildItem -Path $PluginDir -Recurse -Filter "main.rb" | Where-Object {
    $_.DirectoryName -ne $PluginDir
}

if ($mainFiles.Count -eq 0) {
    Write-Host "  没有找到需要加密的 main.rb 文件" -ForegroundColor Yellow
    exit
}

Write-Host "  找到 $($mainFiles.Count) 个文件需要加密：" -ForegroundColor Cyan
Write-Host ""

$encrypted_count = 0
foreach ($file in $mainFiles) {
    $relative = $file.FullName.Substring($PluginDir.Length + 1)
    try {
        $outPath = Encrypt-File -FilePath $file.FullName -Password $Key
        Write-Host "  [OK] $relative -> $([System.IO.Path]::GetFileName($outPath))" -ForegroundColor Green

        # Delete original .rb file
        Remove-Item $file.FullName -Force
        $encrypted_count++
    }
    catch {
        Write-Host "  [FAIL] $relative : $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Update manifest.json: replace main.rb with main.rbe in files arrays
if (Test-Path $ManifestPath) {
    $json = Get-Content $ManifestPath -Raw -Encoding UTF8
    $json = $json -replace '/main\.rb"', '/main.rbe"'
    [System.IO.File]::WriteAllText($ManifestPath, $json, [System.Text.Encoding]::UTF8)
    Write-Host ""
    Write-Host "  manifest.json 已自动更新 (main.rb -> main.rbe)" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "  ========================================" -ForegroundColor Green
Write-Host "  加密完成！共加密 $encrypted_count 个文件" -ForegroundColor Green
Write-Host "  原始 .rb 文件已删除" -ForegroundColor Green
Write-Host "  ========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  重要：请记住你的密钥！" -ForegroundColor Yellow
Write-Host "  同一个密钥需要配置到客户端 crypto.rb 中" -ForegroundColor Yellow
