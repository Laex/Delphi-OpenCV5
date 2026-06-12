# Сборка

[← Документация](README.md) · [Структура](project-structure.md) · [Компоненты](components.md)

## Требования

- **Windows 10/11**, x64
- **Embarcadero Delphi** (Win64), проверено на Studio 37
- **OpenCV 5.0** с модулями `dnn`, `videoio`, `highgui`, `objdetect`, `features`, `stereo`, `photo`, `stitching`
- **Visual Studio / MSVC**, **CMake ≥ 3.16**
- DLL OpenCV (`opencv_world*.dll` или модули) — в `bin/` или `PATH`

## 1. C++ wrapper

```powershell
cd wrapper
cmake -B build -D OpenCV_DIR=C:/opencv/opencv-5.0/build
cmake --build build --config Release
```

Или Visual Studio: `wrapper/build/opencv_delphi_wrapper.slnx` → **Release | x64**.

Результат: `wrapper/build/Release/opencv_delphi_wrapper.dll` → скопировать в `bin/` вместе с DLL OpenCV.

## 2. Delphi-приложения

```powershell
.\build_all.ps1
```

Скрипт собирает wrapper, копирует DLL и компилирует каждый `.dpr` из его папки (нужно для `DemoUtils`).

**CI:**

```powershell
.\ci.ps1
```

Ручная сборка (пример):

```powershell
$dcc = "C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\dcc64.exe"
$root = "D:\Work\Delphi\OpenCV\OpenCV 5.0"
$U = "-U""$root\source"""
$N = "-N""$root\samples\common"""

& $dcc -Q -E"$root\bin" $U "$root\samples\TestOpenCV5\TestOpenCV5.dpr"
& $dcc -Q -E"$root\bin" $U $N "$root\samples\DemoDnnPpocr5\DemoDnnPpocr5.dpr"
```

Все exe и `opencv_delphi_wrapper.dll` — в `bin/`. **Запускайте из `bin/`**, чтобы работали относительные пути к `models\` и изображениям.

См. [Демо и тесты](demos.md) · [Модели](models.md)

## Delphi-пакеты

```powershell
.\build_package.ps1
# другой путь к компилятору:
.\build_package.ps1 -Dcc "C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\dcc64.exe"
```

Порядок сборки: **OpenCV5** → **OpenCV5Vcl** / **OpenCV5Fmx** → **OpenCV5Design** (design-time; может быть пропущен при ошибке линковки с RTL IDE).

| Артефакт | Каталог |
|----------|---------|
| `.bpl` | `bin\bpl\` |
| `.dcp` | `bin\dcp\` |
| `.dcu` (IDE) | `dcu\Win64\Release\` |

### Установка в IDE (Win64)

1. **Tools → Options → Delphi → Library → Library path** — добавить:
   - `…\OpenCV 5.0\source`
   - `…\OpenCV 5.0\bin\bpl`
   - `…\OpenCV 5.0\bin\dcp`
2. **Component → Install Packages** — `OpenCV5.bpl` (обязательно), `OpenCV5Design.bpl` (OI), затем `OpenCV5Vcl.bpl` и/или `OpenCV5Fmx.bpl`.

Приложения могут использовать `-Usource` (как `build_all.ps1`) **или** установленные BPL. Для design-time форм нужна регистрация компонентов — см. [Компоненты](components.md).

### Несколько версий Delphi

- Каталог **`package/` один** — общие `.dpk` и `.pas`.
- **Разделяйте артефакты:** `.bpl`, `.dcp`, `.dcu` **несовместимы** между версиями компилятора (Studio 11, 12, 37, …).
- Одна версия (Studio 37): достаточно `bin\bpl` и `bin\dcp`.
- Несколько версий: отдельные каталоги, напр. `bin\D37\win64\bpl\`, свой Library path в каждой IDE.
- `opencv_delphi_wrapper.dll` от версии Delphi **не зависит**.

Компоненты только **Win64** (`{$MESSAGE ERROR}` при Win32).

См. [Устранение неполадок → BPL](troubleshooting.md)
