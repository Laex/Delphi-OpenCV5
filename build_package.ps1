param(
    [string]$Root = $PSScriptRoot,
    [string]$Dcc = "C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\dcc64.exe"
)

$ErrorActionPreference = "Stop"
$Source = Join-Path $Root "source"
$PackageDir = Join-Path $Root "package"
$BplDir = Join-Path $Root "bin\bpl"
$DcpDir = Join-Path $Root "bin\dcp"

New-Item -ItemType Directory -Force -Path $BplDir | Out-Null
New-Item -ItemType Directory -Force -Path $DcpDir | Out-Null

function Build-Dpk {
    param([string]$DpkName)
    Write-Host "Building $DpkName..."
    Push-Location $PackageDir
    try {
        & $Dcc -Q -LE"$BplDir" -LN"$DcpDir" -U"$Source" $DpkName
        if ($LASTEXITCODE -ne 0) { throw "dcc failed for $DpkName (exit $LASTEXITCODE)" }
    } finally {
        Pop-Location
    }
}

# Core first — OpenCV5Vcl / OpenCV5Fmx depend on OpenCV5.dcp
Build-Dpk "OpenCV5.dpk"
Build-Dpk "OpenCV5Vcl.dpk"
Build-Dpk "OpenCV5Fmx.dpk"

$StudioLib = "C:\Program Files (x86)\Embarcadero\Studio\37.0\lib\win64\release"
Write-Host "Building OpenCV5Design.dpk..."
Push-Location $PackageDir
try {
    & $Dcc -Q -LE"$BplDir" -LN"$DcpDir" -U"$Source" -U"$StudioLib" "OpenCV5Design.dpk"
    if ($LASTEXITCODE -ne 0) { Write-Warning "OpenCV5Design.dpk skipped (install design package from IDE if needed)" }
} finally {
    Pop-Location
}

Write-Host ""
Write-Host "Done."
Write-Host "  BPL: $BplDir\OpenCV5.bpl, OpenCV5Vcl.bpl, OpenCV5Fmx.bpl, OpenCV5Design.bpl"
Write-Host "  DCP: $DcpDir"
Write-Host ""
Write-Host "IDE install (Win64):"
Write-Host "  1. Tools > Options > Delphi > Library > Library path — add:"
Write-Host "       $Source"
Write-Host "       $BplDir"
Write-Host "       $DcpDir"
Write-Host "  2. Component > Install Packages — add OpenCV5.bpl (required), OpenCV5Design.bpl (OI editors), then Vcl and/or Fmx."
