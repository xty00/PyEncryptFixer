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

# 主检测逻辑
Get-ChildItem -File | ForEach-Object {
    $file = $_
    $isEncrypted = $false
    
    # 熵值检测（阈值7.8以上视为可能加密）
    $entropy = Get-FileEntropy -filePath $file.FullName
    if ($entropy -gt $ENTROPY_THRESHOLD) {
        $isEncrypted = $true
    }

    # 输出结果
    [PSCustomObject]@{
        FileName = $file.Name
        Entropy = [math]::Round($entropy, 2)
        IsEncrypted = $isEncrypted
    }
} | Format-Table -AutoSize