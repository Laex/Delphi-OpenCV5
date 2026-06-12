# Troubleshooting

[← Documentation](README.md) · [Building](building.md) · [Models](models.md)

| Issue | What to check |
|-------|---------------|
| «Cannot load DLL» | `opencv_delphi_wrapper.dll` and OpenCV DLLs in `bin/` or `PATH` — [Building](building.md) |
| Camera won't open | `--camera=N`, `--backend=dshow` or `msmf` — [DemoWebcam5](demos.md#demowebcam5) |
| FaceDetectorYN won't create | OpenCV built with **dnn** |
| Empty detect on webcam | **2026may** model; `setInputSize` matches frame |
| YOLOX create/detect fail | path contains `yolox`; model in `models\`; custom postprocess |
| PPOCR 0 polygons | use `text_sample.png`, not `test.png` — [PPOCR](demos.md#demodnnppocr5) |
| PPOCR detect fail (Concat) | rebuild wrapper; `setInputSize` multiple of 32 |
| `EExternalException` in tests | OpenCV 5 + Delphi host — [SEH](project-structure.md#seh-and-limitations) |
| DemoUtils not found | `-N"path\samples\common"` when compiling |
| DemoTrackNano5 | `backbone.onnx` + `neckhead.onnx` in `bin/` — [Models](models.md) |
| BPL «compiled with a different version» | `build_package.ps1` with same Studio; don't mix BPL/DCP — [Packages](building.md#multiple-delphi-versions) |
| Components not on palette | `OpenCV5.bpl` + `OpenCV5Design.bpl`; Library path — [Components](components.md) |
| Pipeline INI without params | `SaveToIni` saves type and `Enabled`; params via OI — [Pipeline](pipeline.md) |
