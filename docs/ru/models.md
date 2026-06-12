# Модели и данные

[← Документация](README.md) · [Демо](demos.md) · [Сборка](building.md)

## Загрузка

```powershell
.\download_models.ps1
.\download_models.ps1 -Force   # перекачать
```

Подробный список: `bin/models/README.txt`.

## Файлы в `bin/`

| Файл | Назначение |
|------|------------|
| `test.png` | общие демо (squirrel_cls) |
| `text_sample.png` | PPOCR / `DemoDnnPpocr5` |
| `backbone.onnx`, `neckhead.onnx` | TrackerNano |

## Файлы в `bin/models/`

| Файл | API / демо |
|------|------------|
| `face_detection_yunet_2026may.onnx` | webcam OpenCV 5 (динамический input) |
| `face_detection_yunet_2023mar.onnx` | фото |
| `face_recognition_sface_2021dec.onnx` | `DemoWebcamFaceId5` |
| `classification.onnx` | alias → MobileNet classify |
| `detection_yolox.onnx` | alias → YOLOX detect |
| `text_detection_ppocr.onnx` | alias → PPOCR DB |
| `human_segmentation_pphumanseg_2023mar.onnx` | сегментация |
| `frozen_east_text_detection.pb` | EAST |
| `nanotrack_*_sim.onnx` | TrackerNano |

## Источники

- [opencv_zoo](https://github.com/opencv/opencv_zoo)
- [SiamTrackers/NanoTrack](https://github.com/HonglinChu/SiamTrackers)
- EAST (Dropbox)

DNN в коде: [Cookbook](cookbook.md#dnn-high-level-модели)
