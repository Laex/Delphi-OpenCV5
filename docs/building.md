# Building

[← Documentation](README.md) · [Structure](project-structure.md) · [Components](components.md)

## Requirements

- **Windows 10/11**, x64
- **Embarcadero Delphi** (Win64), tested with Studio 37
- **OpenCV 5.0** with modules `dnn`, `videoio`, `highgui`, `objdetect`, `features`, `stereo`, `photo`, `stitching`
- **Visual Studio / MSVC**, **CMake ≥ 3.16**
- OpenCV DLLs (`opencv_world*.dll` or modules) — in `bin/` or `PATH`

## 1. C++ wrapper

```powershell
cd wrapper
cmake -B build -D OpenCV_DIR=C:/opencv/opencv-5.0/build
cmake --build build --config Release
```

Or Visual Studio: `wrapper/build/opencv_delphi_wrapper.slnx` → **Release | x64**.

Output: `wrapper/build/Release/opencv_delphi_wrapper.dll` → copy to `bin/` together with OpenCV DLLs.

## 2. Delphi applications

```powershell
.\build_all.ps1
```

The script builds the wrapper, copies DLLs, and compiles each `.dpr` from its folder (required for `DemoUtils`).

**CI:**

```powershell
.\ci.ps1
```

Manual build (example):

```powershell
$dcc = "C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\dcc64.exe"
$root = "D:\Work\Delphi\OpenCV\OpenCV 5.0"
$U = "-U""$root\source"""
$N = "-N""$root\samples\common"""

& $dcc -Q -E"$root\bin" $U "$root\samples\TestOpenCV5\TestOpenCV5.dpr"
& $dcc -Q -E"$root\bin" $U $N "$root\samples\DemoDnnPpocr5\DemoDnnPpocr5.dpr"
```

All executables and `opencv_delphi_wrapper.dll` go to `bin/`. **Run from `bin/`** so relative paths to `models\` and images work.

See [Demos and tests](demos.md) · [Models](models.md)

## Delphi packages

```powershell
.\build_package.ps1
# custom compiler path:
.\build_package.ps1 -Dcc "C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\dcc64.exe"
```

Build order: **OpenCV5** → **OpenCV5Vcl** / **OpenCV5Fmx** → **OpenCV5Design** (design-time; may be skipped on IDE RTL link errors).

| Artifact | Directory |
|----------|-----------|
| `.bpl` | `bin\bpl\` |
| `.dcp` | `bin\dcp\` |
| `.dcu` (IDE) | `dcu\Win64\Release\` |

### IDE installation (Win64)

1. **Tools → Options → Delphi → Library → Library path** — add:
   - `…\OpenCV 5.0\source`
   - `…\OpenCV 5.0\bin\bpl`
   - `…\OpenCV 5.0\bin\dcp`
2. **Component → Install Packages** — `OpenCV5.bpl` (required), `OpenCV5Design.bpl` (Object Inspector), then `OpenCV5Vcl.bpl` and/or `OpenCV5Fmx.bpl`.

Applications can use `-Usource` (as in `build_all.ps1`) **or** installed BPLs. Design-time forms require registered components — see [Components](components.md).

### Multiple Delphi versions

- Single **`package/`** directory — shared `.dpk` and `.pas` files.
- **Separate build artifacts:** `.bpl`, `.dcp`, `.dcu` are **incompatible** across compiler versions (Studio 11, 12, 37, …).
- One version (Studio 37): `bin\bpl` and `bin\dcp` are enough.
- Multiple versions: use separate output dirs, e.g. `bin\D37\win64\bpl\`, with a dedicated Library path per IDE.
- `opencv_delphi_wrapper.dll` does **not** depend on Delphi version.

Components are **Win64 only** (`{$MESSAGE ERROR}` on Win32).

See [Troubleshooting → BPL](troubleshooting.md)
