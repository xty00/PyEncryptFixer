# 定义参数
param (
    [string]$filePath
)

# 设置 PowerShell 控制台输出编码为 GBK
[System.Console]::OutputEncoding = [System.Text.Encoding]::Default
[System.Console]::InputEncoding = [System.Text.Encoding]::Default

# 打印接收到的所有参数
#Write-Output "All arguments received: $($args | Out-String)"
#[Console]::Out.Flush()

# 检查 filePath 是否为空
if (-not $filePath) {
    Write-Output "FilePath is empty, cannot proceed."
    exit
}

#Write-Output "Received file path: $filePath"  # 调试信息
#[Console]::Out.Flush()  # 强制刷新缓冲区

# 去掉双引号包裹的路径
$filePath = $filePath.Trim('"')

#Write-Output "Path after removing quotes: $filePath"  # 调试信息
#[Console]::Out.Flush()  # 强制刷新缓冲区

# 确保路径是绝对路径
if (-not [System.IO.Path]::IsPathRooted($filePath)) {
    $filePath = [System.IO.Path]::Combine($PWD, $filePath)
}

# 将路径转换为标准格式
try {
    $normalizedPath = Convert-Path -LiteralPath $filePath
} catch {
    Write-Output "Failed to convert path: $filePath"
    exit
}

Write-Output "Normalized path: $normalizedPath"  # 调试信息
[Console]::Out.Flush()  # 强制刷新缓冲区

# 检查文件是否存在
if (-not (Test-Path -LiteralPath $normalizedPath)) {
    Write-Output "Invalid file path or file does not exist: $normalizedPath"
    exit
}

# 定义熵值阈值
$ENTROPY_THRESHOLD = 7.8

# 计算文件熵值（用于检测随机性）
function Get-FileEntropy($filePath) {
    $bytes = [System.IO.File]::ReadAllBytes($filePath)
    $frequency = @{}
    foreach ($byte in $bytes) {
        if (-not $frequency.ContainsKey($byte)) {
            $frequency[$byte] = 0
        }
        $frequency[$byte]++
    }
    $entropy = 0.0
    $totalBytes = $bytes.Length
    foreach ($count in $frequency.Values) {
        $probability = $count / $totalBytes
        $entropy -= $probability * [Math]::Log($probability, 2)
    }
    return $entropy
}

# 计算文件熵值
$entropy = Get-FileEntropy -filePath $normalizedPath
$isEncrypted = ($entropy -gt $ENTROPY_THRESHOLD)

# 输出熵值和判定结果
$fileName = Split-Path -Leaf $normalizedPath
Write-Output "FileName: $fileName"
Write-Output ("Entropy: {0:F2}" -f $entropy)
Write-Output ("Threshold: {0}" -f $ENTROPY_THRESHOLD)
Write-Output ("IsEncrypted: {0}" -f $isEncrypted)
[Console]::Out.Flush()  # 强制刷新缓冲区

# 设置 PowerShell 控制台输出编码为 UTF-8
[System.Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
#Write-Output $isEncrypted

# 最终输出加密状态
#Write-Output ($isEncrypted -eq $true ? "true" : "false")
# 输出最终结果
if ($isEncrypted) {
    Write-Output "true"
} else {
    Write-Output "false"
}