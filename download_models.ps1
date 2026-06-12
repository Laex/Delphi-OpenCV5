param(
    [string]$Root = $PSScriptRoot,
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$ModelsDir = Join-Path $Root "bin\models"
$BinDir = Join-Path $Root "bin"
New-Item -ItemType Directory -Force -Path $ModelsDir | Out-Null

function Get-ZooUrl([string]$RelativePath) {
    "https://media.githubusercontent.com/media/opencv/opencv_zoo/main/$RelativePath"
}

function Download-File([string]$Url, [string]$Dest, [string]$Label) {
    if ((Test-Path $Dest) -and -not $Force) {
        $len = (Get-Item $Dest).Length
        if ($len -gt 1024) {
            Write-Host ("[skip] {0} ({1} bytes)" -f $Label, $len)
            return
        }
    }
    Write-Host "[get]  $Label"
    Write-Host "       $Url"
    Invoke-WebRequest -Uri $Url -OutFile $Dest -UseBasicParsing
    $len = (Get-Item $Dest).Length
    if ($len -lt 1024) {
        $head = Get-Content $Dest -TotalCount 3 -ErrorAction SilentlyContinue
        if ($head -match "git-lfs") {
            Remove-Item $Dest -Force
            throw "LFS pointer instead of model: $Dest"
        }
    }
    Write-Host ("       -> {0} ({1} bytes)" -f $Dest, $len)
}

function New-TextSampleImage([string]$Dest) {
    if ((Test-Path $Dest) -and -not $Force) {
        $len = (Get-Item $Dest).Length
        if ($len -gt 1024) {
            Write-Host ("[skip] text_sample.png ({0} bytes)" -f $len)
            return
        }
    }
    Write-Host "[gen]  text_sample.png (synthetic OCR sample)"
    Add-Type -AssemblyName System.Drawing
    $W = 736
    $H = 736
    $bmp = New-Object System.Drawing.Bitmap $W, $H
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::White)
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $font = New-Object System.Drawing.Font('Segoe UI', 32, [System.Drawing.FontStyle]::Bold)
    $brush = [System.Drawing.Brushes]::Black
    $g.DrawString('OpenCV 5.0 Delphi Wrapper', $font, $brush, 48, 260)
    $g.DrawString('PPOCR Text Detection Sample', $font, $brush, 48, 340)
    $bmp.Save($Dest, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $font.Dispose()
    $bmp.Dispose()
    Write-Host ("       -> {0} ({1} bytes)" -f $Dest, (Get-Item $Dest).Length)
}

Write-Host "=== OpenCV 5.0 Delphi - download models ==="
Write-Host "Target: $ModelsDir"
Write-Host ""

# Sample image for demos/tests (OpenCV squirrel_cls)
$TestPng = Join-Path $BinDir "test.png"
Download-File "https://media.githubusercontent.com/media/opencv/opencv/4.x/samples/data/squirrel_cls.jpg" $TestPng "test.png (squirrel_cls.jpg)"

$TextSample = Join-Path $BinDir "text_sample.png"
New-TextSampleImage $TextSample

# --- opencv_zoo (Git LFS via media.githubusercontent.com) ---
$Zoo = @(
    @{ Rel = "models/face_detection_yunet/face_detection_yunet_2026may.onnx"; Name = "face_detection_yunet_2026may.onnx" },
    @{ Rel = "models/face_detection_yunet/face_detection_yunet_2023mar.onnx"; Name = "face_detection_yunet_2023mar.onnx" },
    @{ Rel = "models/face_recognition_sface/face_recognition_sface_2021dec.onnx"; Name = "face_recognition_sface_2021dec.onnx" },
    @{ Rel = "models/image_classification_mobilenet/image_classification_mobilenetv2_2022apr.onnx"; Name = "image_classification_mobilenetv2_2022apr.onnx" },
    @{ Rel = "models/object_detection_yolox/object_detection_yolox_2022nov.onnx"; Name = "object_detection_yolox_2022nov.onnx" },
    @{ Rel = "models/human_segmentation_pphumanseg/human_segmentation_pphumanseg_2023mar.onnx"; Name = "human_segmentation_pphumanseg_2023mar.onnx" },
    @{ Rel = "models/text_detection_ppocr/text_detection_en_ppocrv3_2023may.onnx"; Name = "text_detection_en_ppocrv3_2023may.onnx" }
)

foreach ($item in $Zoo) {
    $dest = Join-Path $ModelsDir $item.Name
    Download-File (Get-ZooUrl $item.Rel) $dest $item.Name
}

# Convenience aliases for demos
Copy-Item (Join-Path $ModelsDir "image_classification_mobilenetv2_2022apr.onnx") `
    (Join-Path $ModelsDir "classification.onnx") -Force
Copy-Item (Join-Path $ModelsDir "object_detection_yolox_2022nov.onnx") `
    (Join-Path $ModelsDir "detection_yolox.onnx") -Force
Copy-Item (Join-Path $ModelsDir "text_detection_en_ppocrv3_2023may.onnx") `
    (Join-Path $ModelsDir "text_detection_ppocr.onnx") -Force
Write-Host "[link] classification.onnx, detection_yolox.onnx, text_detection_ppocr.onnx"

# --- TrackerNano (OpenCV default names in bin/) ---
$NanoBackbone = "https://github.com/HonglinChu/SiamTrackers/raw/master/NanoTrack/models/nanotrackv2/nanotrack_backbone_sim.onnx"
$NanoHead = "https://github.com/HonglinChu/SiamTrackers/raw/master/NanoTrack/models/nanotrackv2/nanotrack_head_sim.onnx"
Download-File $NanoBackbone (Join-Path $BinDir "backbone.onnx") "TrackerNano backbone.onnx"
Download-File $NanoHead (Join-Path $BinDir "neckhead.onnx") "TrackerNano neckhead.onnx"
Copy-Item (Join-Path $BinDir "backbone.onnx") (Join-Path $ModelsDir "nanotrack_backbone_sim.onnx") -Force
Copy-Item (Join-Path $BinDir "neckhead.onnx") (Join-Path $ModelsDir "nanotrack_head_sim.onnx") -Force

# --- EAST text detector (.pb for TextDetectionModel_EAST) ---
$EastTar = Join-Path $ModelsDir "frozen_east_text_detection.tar.gz"
$EastPb = Join-Path $ModelsDir "frozen_east_text_detection.pb"
if (-not ((Test-Path $EastPb) -and ((Get-Item $EastPb).Length -gt 1MB)) -or $Force) {
    Write-Host "[get]  frozen_east_text_detection (Dropbox tar.gz)"
    $EastUrl = "https://www.dropbox.com/s/r2ingd0l3zt8hxs/frozen_east_text_detection.tar.gz?dl=1"
    Invoke-WebRequest -Uri $EastUrl -OutFile $EastTar -UseBasicParsing
    $tmp = Join-Path $env:TEMP "ocv5_east_extract"
    if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
    New-Item -ItemType Directory -Path $tmp | Out-Null
    tar -xzf $EastTar -C $tmp
    $found = Get-ChildItem -Path $tmp -Recurse -Filter "frozen_east_text_detection.pb" | Select-Object -First 1
    if (-not $found) { throw "frozen_east_text_detection.pb not found in archive" }
    Copy-Item $found.FullName $EastPb -Force
    Remove-Item $tmp -Recurse -Force
    Remove-Item $EastTar -Force -ErrorAction SilentlyContinue
    Write-Host ("       -> {0} ({1} bytes)" -f $EastPb, (Get-Item $EastPb).Length)
} else {
    Write-Host "[skip] frozen_east_text_detection.pb"
}

Write-Host ""
Write-Host "Done. Run demos from bin\ with models in bin\models\"
Write-Host "  DemoWebcamFace5.exe"
Write-Host "  DemoDnnClassify5.exe --model=models\classification.onnx --image=test.png"
Write-Host "  DemoDnnDetect5.exe --model=models\detection_yolox.onnx --image=test.png"
Write-Host "  DemoDnnSegment5.exe --image=test.png"
Write-Host "  DemoDnnTextEast5.exe --image=test.png"
Write-Host "  DemoDnnPpocr5.exe --image=text_sample.png"
Write-Host "  DemoDnnPpocr5.exe --model=models\text_detection_ppocr.onnx --image=text_sample.png"
Write-Host "  TestOpenCV5.exe --model=models\face_detection_yunet_2026may.onnx"
