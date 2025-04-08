# ������ֵ��ֵ
$ENTROPY_THRESHOLD = 7.8

# �����ļ���ֵ�����ڼ������ԣ�
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

# ������߼�
Get-ChildItem -File | ForEach-Object {
    $file = $_
    $isEncrypted = $false
    
    # ��ֵ��⣨��ֵ7.8������Ϊ���ܼ��ܣ�
    $entropy = Get-FileEntropy -filePath $file.FullName
    if ($entropy -gt $ENTROPY_THRESHOLD) {
        $isEncrypted = $true
    }

    # ������
    [PSCustomObject]@{
        FileName = $file.Name
        Entropy = [math]::Round($entropy, 2)
        IsEncrypted = $isEncrypted
    }
} | Format-Table -AutoSize