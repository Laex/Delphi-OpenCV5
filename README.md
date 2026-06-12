# OpenCV 5.0 Delphi Wrapper

Delphi bindings for [OpenCV 5.0](https://opencv.org/) on **Windows Win64**: Pascal units (`source/`) + C++ DLL bridge (`wrapper/`).

**Documentation:** [docs/README.md](docs/README.md)

## Quick start

```powershell
cd "OpenCV 5.0"
.\download_models.ps1
.\build_all.ps1
cd bin
.\TestOpenCV5.exe
```

Expected result: **120+ passed** (after `download_models.ps1`). IDE components: `.\build_package.ps1` — see [Delphi packages](docs/building.md#delphi-packages).

## Requirements

Windows 10/11 x64 · Delphi Win64 (tested with Studio 37) · OpenCV 5.0 · MSVC + CMake · DLLs in `bin/` or `PATH`.

## Layout (brief)

| Directory | Purpose |
|-----------|---------|
| `source/` | `OpenCV5.*.pas` units |
| `wrapper/` | `opencv_delphi_wrapper.dll` |
| `package/` | `.dpk` for the IDE |
| `samples/` | demos and tests |
| `bin/` | exe, DLL, models, bpl/dcp |

Details: [Project structure](docs/project-structure.md).

## License

Wrapper — per your project terms. OpenCV — [Apache 2.0](https://opencv.org/license/). See [Licenses](docs/license.md).
