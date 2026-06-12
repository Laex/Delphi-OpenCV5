# Устранение неполадок

[← Документация](README.md) · [Сборка](building.md) · [Модели](models.md)

| Проблема | Что проверить |
|----------|----------------|
| «Cannot load DLL» | `opencv_delphi_wrapper.dll` и OpenCV DLL в `bin/` или `PATH` — [Сборка](building.md) |
| Камера не открывается | `--camera=N`, `--backend=dshow` или `msmf` — [DemoWebcam5](demos.md#demowebcam5) |
| FaceDetectorYN не создаётся | OpenCV собран с **dnn** |
| Пустой detect на webcam | модель **2026may**; `setInputSize` под кадр |
| YOLOX create/detect fail | путь с `yolox`; модель в `models\`; custom postprocess |
| PPOCR 0 полигонов | `text_sample.png`, не `test.png` — [PPOCR](demos.md#demodnnppocr5) |
| PPOCR detect fail (Concat) | пересоберите wrapper; `setInputSize` кратен 32 |
| `EExternalException` в тестах | OpenCV 5 + Delphi host — [SEH](project-structure.md#seh-и-ограничения) |
| DemoUtils not found | `-N"path\samples\common"` при компиляции |
| DemoTrackNano5 | `backbone.onnx` + `neckhead.onnx` в `bin/` — [Модели](models.md) |
| BPL «compiled with a different version» | `build_package.ps1` той же Studio; не смешивать BPL/DCP — [Пакеты](building.md#несколько-версий-delphi) |
| Компоненты не в палитре | `OpenCV5.bpl` + `OpenCV5Design.bpl`; Library path — [Компоненты](components.md) |
| Pipeline INI без параметров | `SaveToIni` — тип и `Enabled`; параметры через OI — [Pipeline](pipeline.md) |
