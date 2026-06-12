# Demos and tests

[← Documentation](README.md) · [Building](building.md) · [Models](models.md)

## Tests

```powershell
cd bin
.\TestOpenCV5.exe
.\TestOpenCV5.exe --gui          # imshow (requires test.png)
.\TestOpenCV5.exe --model=models\face_detection_yunet_2026may.onnx
```

Report: `bin/test_results.txt`. **120+ passed** after [download_models.ps1](models.md).

YOLOX / YOLOv5 / YOLOv8: custom postprocess in `wrapper/yolo_postprocess.cpp` (path contains `yolox`, `yolov5`, or `yolov8`).

## Demo list

GUI: `/gui`, `--gui`, or `-gui` — OpenCV windows (`imshow`).

| Program | Purpose |
|---------|---------|
| `DemoOpenCV5.exe` | histograms, CLAHE, moments, floodFill |
| `DemoObjdetect5.exe` | chessboard, ArUco, QR, barcode |
| `DemoWebcam5.exe` | webcam |
| `DemoRecordWebcam5.exe` | AVI recording (MJPEG) |
| `DemoOpticalFlow5.exe` | Lucas–Kanade from camera |
| `DemoFaceDetect5.exe` | YuNet on photo |
| `DemoWebcamFace5.exe` | YuNet from camera |
| `DemoWebcamFaceId5.exe` | YuNet + SFace (enroll / identify) |
| `DemoCalibrate5.exe` | synthetic calibration |
| `DemoMatch5.exe` | ORB matching |
| `DemoDnn5.exe` | `readNet` + `forward` |
| `DemoDnnClassify5.exe` | `TCVClassificationModel` |
| `DemoDnnDetect5.exe` | `TCVDetectionModel` (YOLOX) |
| `DemoDnnSegment5.exe` | `TCVSegmentationModel` |
| `DemoDnnTextEast5.exe` | `TCVTextDetectionEAST` |
| `DemoDnnPpocr5.exe` | `TCVTextDetectionDB` (PPOCR) |
| `DemoPointCloud5.exe` | PLY load/save |
| `DemoSeamlessClone5.exe` | preview; `--try-clone` — `seamlessClone` |
| `DemoTrackNano5.exe` | camera + `TCVTrackerNano` |
| `DemoHighguiCallbacks5.exe` | mouse / trackbar |
| `DemoVclPreview5.exe` / `DemoFmxPreview5.exe` | VCL/FMX preview |
| `DemoTemplateMatch5.exe` | `matchTemplate` |
| `DemoStereoDepth5.exe` | `StereoSGBM` |
| `DemoContours5.exe` | contours |
| `DemoCannyHough5.exe` | Canny + Hough |
| `DemoImencode5.exe` | `imencode` / `imdecode` |
| `DemoFarneback5.exe` | Farneback flow |
| `DemoMl5.exe` / `DemoTrack5.exe` / `DemoHomography5.exe` | ml, tracking, homography |

## DemoDnnPpocr5

After `download_models.ps1`, `bin\` contains `text_sample.png` (736×736).

```powershell
.\DemoDnnPpocr5.exe --image=text_sample.png
.\DemoDnnPpocr5.exe --model=models\text_detection_ppocr.onnx --image=text_sample.png
```

On `test.png` (squirrel) polygon count is usually **0** — expected. See [Cookbook → PPOCR](cookbook.md#ppocr-text-detection).

## DemoDnnDetect5 — YOLOX

```powershell
.\DemoDnnDetect5.exe --model=models\detection_yolox.onnx --image=test.png
```

## DemoWebcamFaceId5

```powershell
.\DemoWebcamFaceId5.exe --enroll=photo.jpg --name=Alice
.\DemoWebcamFaceId5.exe --camera=0 --score=0.7
```

| Option | Description |
|--------|-------------|
| `--model=` | YuNet ONNX |
| `--rec-model=` | SFace ONNX |
| `--enroll=` / `--name=` | register a face |
| `E` in window | enroll current face |

## DemoWebcam5

```powershell
.\DemoWebcam5.exe --camera=0 --width=1280 --height=720 --backend=dshow
```

Exit: **ESC** or **Q**.

## DemoMatch5

```powershell
.\DemoMatch5.exe --query=test.png --train=test.png
```

## Components (IDE)

`Test/Utit2` — camera, pipeline, MUX, VCL view. See [Components](components.md) · [Pipeline](pipeline.md).
