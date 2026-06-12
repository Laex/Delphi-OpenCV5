# Project structure

[← Documentation](README.md)

```
OpenCV 5.0/
├── source/           Delphi units (OpenCV5.*.pas)
├── wrapper/          C++ DLL opencv_delphi_wrapper.dll
│   └── yolo_postprocess.cpp   custom YOLO X/v5/v8 postprocess
├── package/          OpenCV5.dpk, OpenCV5Vcl, OpenCV5Fmx, OpenCV5Design
├── dcu/              intermediate .dcu (Win64/Release, from IDE)
├── docs/             documentation (English; Russian in docs/ru/)
├── samples/          tests and demos; common/DemoUtils.pas
├── Test/             component projects (Utit2, …)
├── build_all.ps1     build DLL + all executables
├── build_package.ps1 build .bpl / .dcp
├── download_models.ps1
├── ci.ps1
├── bin/
│   ├── bpl/          runtime/design .bpl (build_package.ps1)
│   ├── dcp/          .dcp for package linking
│   └── …             exe, DLL, models/, test.png
└── README.md         short overview + link here
```

The `generator/` folder (binding autogeneration script) is **not in git** — see [Generator](generator.md).

## Two layers

| Layer | Directory | Role |
|-------|-----------|------|
| Pascal | `source/` | types, CMR, flat API, components |
| C++ | `wrapper/` | `opencv_delphi_wrapper.dll`, SEH, custom postprocess |

The application loads `opencv_delphi_wrapper.dll`, which links against OpenCV. Pascal units are thin wrappers over DLL exports.

## Custom Managed Records (CMR)

Types such as `TCVMat`, `TCVFaceDetectorYN`, `TCVVideoCapture`, `TCVMOG2`, etc. are **CMR**: memory is released automatically; calling `.Free` is not required.

API details: [Delphi units](delphi-units.md).

## SEH and limitations

The DLL is built with `/EHa`. On load, `Core_installSehTranslator` is called (also from `OpenCV5.Core` initialization). Critical C++ calls are wrapped in `try/catch` + `Core_setLastError`.

| API | Note |
|-----|------|
| `splitMat` | for `CV_8U` — pure-Pascal `splitMat8u`; create plane Mats upfront (`Create_2`, not `Create_0`) |
| `imencode` | works in tests and demos |
| `fastNlMeansDenoisingColored`, `seamlessClone` | not called in `TestOpenCV5.exe`; `DemoSeamlessClone5` — preview, `--try-clone` optional |

**Webcam:** `TCVVideoCapture.read(var image: TCVMat)` creates an empty `CV_8UC3` Mat when `Handle = nil`.

See also: [Troubleshooting](troubleshooting.md) · [Building the wrapper](building.md#1-c-wrapper)
