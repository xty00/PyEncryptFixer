# �������
param (
    [string]$filePath
)

# ���� PowerShell ����̨�������Ϊ GBK
[System.Console]::OutputEncoding = [System.Text.Encoding]::Default
[System.Console]::InputEncoding = [System.Text.Encoding]::Default

# ��ӡ���յ������в���
#Write-Output "All arguments received: $($args | Out-String)"
#[Console]::Out.Flush()

# ��� filePath �Ƿ�Ϊ��
if (-not $filePath) {
    Write-Output "FilePath is empty, cannot proceed."
    exit
}

#Write-Output "Received file path: $filePath"  # ������Ϣ
#[Console]::Out.Flush()  # ǿ��ˢ�»�����

# ȥ��˫���Ű�����·��
$filePath = $filePath.Trim('"')

#Write-Output "Path after removing quotes: $filePath"  # ������Ϣ
#[Console]::Out.Flush()  # ǿ��ˢ�»�����

# ȷ��·���Ǿ���·��
if (-not [System.IO.Path]::IsPathRooted($filePath)) {
    $filePath = [System.IO.Path]::Combine($PWD, $filePath)
}

# ��·��ת��Ϊ��׼��ʽ
try {
    $normalizedPath = Convert-Path -LiteralPath $filePath
} catch {
    Write-Output "Failed to convert path: $filePath"
    exit
}

Write-Output "Normalized path: $normalizedPath"  # ������Ϣ
[Console]::Out.Flush()  # ǿ��ˢ�»�����

# ����ļ��Ƿ����
if (-not (Test-Path -LiteralPath $normalizedPath)) {
    Write-Output "Invalid file path or file does not exist: $normalizedPath"
    exit
}

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

# �����ļ���ֵ
$entropy = Get-FileEntropy -filePath $normalizedPath
$isEncrypted = ($entropy -gt $ENTROPY_THRESHOLD)

# �����ֵ���ж����
$fileName = Split-Path -Leaf $normalizedPath
Write-Output "FileName: $fileName"
Write-Output ("Entropy: {0:F2}" -f $entropy)
Write-Output ("Threshold: {0}" -f $ENTROPY_THRESHOLD)
Write-Output ("IsEncrypted: {0}" -f $isEncrypted)
[Console]::Out.Flush()  # ǿ��ˢ�»�����

# ���� PowerShell ����̨�������Ϊ UTF-8
[System.Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
#Write-Output $isEncrypted

# �����������״̬
#Write-Output ($isEncrypted -eq $true ? "true" : "false")
# ������ս��
if ($isEncrypted) {
    Write-Output "true"
} else {
    Write-Output "false"
}