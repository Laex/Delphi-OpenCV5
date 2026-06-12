param(
    [string]$Root = $PSScriptRoot
)

$ErrorActionPreference = "Stop"
$Bin = Join-Path $Root "bin"
$Log = Join-Path $Bin "test_results.txt"

Write-Host "=== OpenCV5 CI ==="
& (Join-Path $Root "build_all.ps1") -Root $Root

Push-Location $Bin
try {
    & (Join-Path $Bin "TestOpenCV5.exe") | Tee-Object -FilePath $Log
    if ($LASTEXITCODE -ne 0) {
        Write-Error "TestOpenCV5 failed with exit code $LASTEXITCODE"
    }
    Select-String -Path $Log -Pattern "failed" | ForEach-Object { Write-Host $_.Line }
    if (Select-String -Path $Log -Pattern "\d+ failed" -Quiet) {
        $m = Select-String -Path $Log -Pattern "Results: (\d+) passed, (\d+) failed"
        if ($m -and [int]$m.Matches[0].Groups[2].Value -gt 0) {
            Write-Error "Unit tests reported failures"
        }
    }
} finally {
    Pop-Location
}

Write-Host "CI OK. Log: $Log"
