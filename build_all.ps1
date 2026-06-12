param(
    [string]$Root = $PSScriptRoot,
    [string]$Dcc = "C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\dcc64.exe",
    [string]$Cmake = "C:\Program Files\Microsoft Visual Studio\18\Enterprise\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
)

$ErrorActionPreference = "Stop"
$Source = Join-Path $Root "source"
$Bin = Join-Path $Root "bin"
$Common = Join-Path $Root "samples\common"
$U = "-U""$Source"""
$N = "-N""$Common"""

Write-Host "Building C++ wrapper..."
& $Cmake --build (Join-Path $Root "wrapper\build") --config Release
Copy-Item (Join-Path $Root "wrapper\build\Release\opencv_delphi_wrapper.dll") (Join-Path $Bin "opencv_delphi_wrapper.dll") -Force

$Projects = @(
    "samples\TestOpenCV5\TestOpenCV5.dpr",
    "samples\DemoOpenCV5\DemoOpenCV5.dpr",
    "samples\DemoObjdetect5\DemoObjdetect5.dpr",
    "samples\DemoWebcam5\DemoWebcam5.dpr",
    "samples\DemoFaceDetect5\DemoFaceDetect5.dpr",
    "samples\DemoWebcamFace5\DemoWebcamFace5.dpr",
    "samples\DemoRecordWebcam5\DemoRecordWebcam5.dpr",
    "samples\DemoOpticalFlow5\DemoOpticalFlow5.dpr",
    "samples\DemoWebcamFaceId5\DemoWebcamFaceId5.dpr",
    "samples\DemoCalibrate5\DemoCalibrate5.dpr",
    "samples\DemoMatch5\DemoMatch5.dpr",
    "samples\DemoDnn5\DemoDnn5.dpr",
    "samples\DemoMl5\DemoMl5.dpr",
    "samples\DemoTrack5\DemoTrack5.dpr",
    "samples\DemoHomography5\DemoHomography5.dpr",
    "samples\DemoTemplateMatch5\DemoTemplateMatch5.dpr",
    "samples\DemoStereoDepth5\DemoStereoDepth5.dpr",
    "samples\DemoContours5\DemoContours5.dpr",
    "samples\DemoCannyHough5\DemoCannyHough5.dpr",
    "samples\DemoImencode5\DemoImencode5.dpr",
    "samples\DemoVclPreview5\DemoVclPreview5.dpr",
    "samples\DemoFarneback5\DemoFarneback5.dpr",
    "samples\DemoDnnClassify5\DemoDnnClassify5.dpr",
    "samples\DemoDnnDetect5\DemoDnnDetect5.dpr",
    "samples\DemoDnnSegment5\DemoDnnSegment5.dpr",
    "samples\DemoDnnTextEast5\DemoDnnTextEast5.dpr",
    "samples\DemoDnnPpocr5\DemoDnnPpocr5.dpr",
    "samples\DemoPointCloud5\DemoPointCloud5.dpr",
    "samples\DemoSeamlessClone5\DemoSeamlessClone5.dpr",
    "samples\DemoTrackNano5\DemoTrackNano5.dpr",
    "samples\DemoHighguiCallbacks5\DemoHighguiCallbacks5.dpr",
    "samples\DemoFmxPreview5\DemoFmxPreview5.dpr"
)

foreach ($Proj in $Projects) {
    $Path = Join-Path $Root $Proj
    $ProjDir = Split-Path $Path -Parent
    Write-Host "Compiling $Proj..."
    Push-Location $ProjDir
    try {
        if ($Proj -match "Demo(Record|Optical|WebcamFaceId|Calibrate|Match|Dnn|Webcam|Ml|Track|Homography|Template|Stereo|Contours|Canny|Imencode|Farneback|Classify|Detect|Segment|TextEast|Ppocr|PointCloud|Seamless|TrackNano|Highgui)") {
            & $Dcc -Q -E"$Bin" $U $N (Split-Path $Path -Leaf)
        } elseif ($Proj -match "Demo(Vcl|Fmx)Preview5") {
            & $Dcc -Q -E"$Bin" $U (Split-Path $Path -Leaf)
        } else {
            & $Dcc -Q -E"$Bin" $U (Split-Path $Path -Leaf)
        }
    } finally {
        Pop-Location
    }
}

Write-Host "Done. Bin: $Bin"
