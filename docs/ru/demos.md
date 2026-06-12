# Демо и тесты

[← Документация](README.md) · [Сборка](building.md) · [Модели](models.md)

## Тесты

```powershell
cd bin
.\TestOpenCV5.exe
.\TestOpenCV5.exe --gui          # imshow (нужен test.png)
.\TestOpenCV5.exe --model=models\face_detection_yunet_2026may.onnx
```

Отчёт: `bin/test_results.txt`. **120+ passed** после [download_models.ps1](models.md).

YOLOX / YOLOv5 / YOLOv8: custom postprocess в `wrapper/yolo_postprocess.cpp` (путь с `yolox`, `yolov5` или `yolov8`).

## Список демо

GUI: `/gui`, `--gui` или `-gui` — окна OpenCV (`imshow`).

| Программа | Назначение |
|-----------|------------|
| `DemoOpenCV5.exe` | гистограммы, CLAHE, moments, floodFill |
| `DemoObjdetect5.exe` | шахматка, ArUco, QR, barcode |
| `DemoWebcam5.exe` | веб-камера |
| `DemoRecordWebcam5.exe` | запись AVI (MJPEG) |
| `DemoOpticalFlow5.exe` | Lucas–Kanade с камеры |
| `DemoFaceDetect5.exe` | YuNet на фото |
| `DemoWebcamFace5.exe` | YuNet с камеры |
| `DemoWebcamFaceId5.exe` | YuNet + SFace (enroll / identify) |
| `DemoCalibrate5.exe` | синтетическая калибровка |
| `DemoMatch5.exe` | ORB matching |
| `DemoDnn5.exe` | `readNet` + `forward` |
| `DemoDnnClassify5.exe` | `TCVClassificationModel` |
| `DemoDnnDetect5.exe` | `TCVDetectionModel` (YOLOX) |
| `DemoDnnSegment5.exe` | `TCVSegmentationModel` |
| `DemoDnnTextEast5.exe` | `TCVTextDetectionEAST` |
| `DemoDnnPpocr5.exe` | `TCVTextDetectionDB` (PPOCR) |
| `DemoPointCloud5.exe` | PLY load/save |
| `DemoSeamlessClone5.exe` | preview; `--try-clone` — `seamlessClone` |
| `DemoTrackNano5.exe` | камера + `TCVTrackerNano` |
| `DemoHighguiCallbacks5.exe` | mouse / trackbar |
| `DemoVclPreview5.exe` / `DemoFmxPreview5.exe` | preview VCL/FMX |
| `DemoTemplateMatch5.exe` | `matchTemplate` |
| `DemoStereoDepth5.exe` | `StereoSGBM` |
| `DemoContours5.exe` | контуры |
| `DemoCannyHough5.exe` | Canny + Hough |
| `DemoImencode5.exe` | `imencode` / `imdecode` |
| `DemoFarneback5.exe` | Farneback flow |
| `DemoMl5.exe` / `DemoTrack5.exe` / `DemoHomography5.exe` | ml, tracking, homography |

## DemoDnnPpocr5

После `download_models.ps1` в `bin\` — `text_sample.png` (736×736).

```powershell
.\DemoDnnPpocr5.exe --image=text_sample.png
.\DemoDnnPpocr5.exe --model=models\text_detection_ppocr.onnx --image=text_sample.png
```

На `test.png` (белка) полигонов обычно **0** — нормально. См. [Cookbook → PPOCR](cookbook.md#ppocr-text-detection).

## DemoDnnDetect5 — YOLOX

```powershell
.\DemoDnnDetect5.exe --model=models\detection_yolox.onnx --image=test.png
```

## DemoWebcamFaceId5

```powershell
.\DemoWebcamFaceId5.exe --enroll=photo.jpg --name=Alice
.\DemoWebcamFaceId5.exe --camera=0 --score=0.7
```

| Параметр | Описание |
|----------|----------|
| `--model=` | YuNet ONNX |
| `--rec-model=` | SFace ONNX |
| `--enroll=` / `--name=` | регистрация лица |
| `E` в окне | enroll текущего лица |

## DemoWebcam5

```powershell
.\DemoWebcam5.exe --camera=0 --width=1280 --height=720 --backend=dshow
```

Выход: **ESC** или **Q**.

## DemoMatch5

```powershell
.\DemoMatch5.exe --query=test.png --train=test.png
```

## Компоненты (IDE)

`Test/Utit2` — камера, pipeline, MUX, VCL view. См. [Компоненты](components.md) · [Pipeline](pipeline.md).
