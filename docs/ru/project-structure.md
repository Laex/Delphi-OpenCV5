# Структура проекта

[← Документация](README.md)

```
OpenCV 5.0/
├── source/           Delphi-юниты (OpenCV5.*.pas)
├── wrapper/          C++ DLL opencv_delphi_wrapper.dll
│   └── yolo_postprocess.cpp   custom YOLO X/v5/v8 postprocess
├── package/          OpenCV5.dpk, OpenCV5Vcl, OpenCV5Fmx, OpenCV5Design
├── dcu/              промежуточные .dcu (Win64/Release, из IDE)
├── docs/             документация (этот каталог)
├── samples/          тесты и демо; common/DemoUtils.pas
├── Test/             проекты компонентов (Utit2, …)
├── build_all.ps1     сборка DLL + все exe
├── build_package.ps1 сборка .bpl / .dcp
├── download_models.ps1
├── ci.ps1
├── bin/
│   ├── bpl/          runtime/design .bpl (build_package.ps1)
│   ├── dcp/          .dcp для линковки пакетов
│   └── …             exe, DLL, models/, test.png
└── README.md         краткое описание + ссылка сюда
```

Каталог `generator/` (скрипт автогенерации привязок) **не входит в git** — см. [Генератор](generator.md).

## Два слоя

| Слой | Каталог | Роль |
|------|---------|------|
| Pascal | `source/` | типы, CMR, flat API, компоненты |
| C++ | `wrapper/` | `opencv_delphi_wrapper.dll`, SEH, custom postprocess |

Приложение загружает `opencv_delphi_wrapper.dll`, которая линкуется с OpenCV. Pascal-юниты — thin wrappers над экспортами DLL.

## Custom Managed Records (CMR)

Типы `TCVMat`, `TCVFaceDetectorYN`, `TCVVideoCapture`, `TCVMOG2` и др. — **CMR**: память освобождается автоматически, вызов `.Free` не нужен.

Подробнее об API: [Delphi-модули](delphi-units.md).

## SEH и ограничения

DLL собирается с `/EHa`, при загрузке вызывается `Core_installSehTranslator` (также из `OpenCV5.Core` initialization). Критичные вызовы в C++ обёрнуты в `try/catch` + `Core_setLastError`.

| API | Примечание |
|-----|------------|
| `splitMat` | для `CV_8U` — pure-Pascal `splitMat8u`; plane Mat создайте заранее (`Create_2`, не `Create_0`) |
| `imencode` | работает в тестах и демо |
| `fastNlMeansDenoisingColored`, `seamlessClone` | в `TestOpenCV5.exe` не вызываются; `DemoSeamlessClone5` — preview, `--try-clone` опционально |

**Webcam:** `TCVVideoCapture.read(var image: TCVMat)` создаёт пустой `CV_8UC3` Mat, если `Handle = nil`.

См. также: [Устранение неполадок](troubleshooting.md) · [Сборка wrapper](building.md#1-c-wrapper)
