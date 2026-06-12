# Models and data

[← Documentation](README.md) · [Demos](demos.md) · [Building](building.md)

## Download

```powershell
.\download_models.ps1
.\download_models.ps1 -Force   # re-download
```

Full list: `bin/models/README.txt`.

## Files in `bin/`

| File | Purpose |
|------|---------|
| `test.png` | general demos (squirrel_cls) |
| `text_sample.png` | PPOCR / `DemoDnnPpocr5` |
| `backbone.onnx`, `neckhead.onnx` | TrackerNano |

## Files in `bin/models/`

| File | API / demo |
|------|------------|
| `face_detection_yunet_2026may.onnx` | webcam OpenCV 5 (dynamic input) |
| `face_detection_yunet_2023mar.onnx` | photo |
| `face_recognition_sface_2021dec.onnx` | `DemoWebcamFaceId5` |
| `classification.onnx` | alias → MobileNet classify |
| `detection_yolox.onnx` | alias → YOLOX detect |
| `text_detection_ppocr.onnx` | alias → PPOCR DB |
| `human_segmentation_pphumanseg_2023mar.onnx` | segmentation |
| `frozen_east_text_detection.pb` | EAST |
| `nanotrack_*_sim.onnx` | TrackerNano |

## Sources

- [opencv_zoo](https://github.com/opencv/opencv_zoo)
- [SiamTrackers/NanoTrack](https://github.com/HonglinChu/SiamTrackers)
- EAST (Dropbox)

DNN in code: [Cookbook](cookbook.md#dnn-high-level-models)
