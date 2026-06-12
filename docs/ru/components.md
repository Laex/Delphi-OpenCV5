# Компоненты

[← Документация](README.md) · [Сборка → пакеты](building.md#delphi-пакеты) · [TcvPipeline](pipeline.md)

## Пакеты

| Пакет | Содержимое |
|-------|------------|
| `OpenCV5.dpk` | ядро + runtime-компоненты |
| `OpenCV5Vcl.dpk` | `TcvViewVcl` |
| `OpenCV5Fmx.dpk` | `TcvViewFmx` |
| `OpenCV5Design.dpk` | редакторы Object Inspector (только IDE) |

Сборка: [Delphi-пакеты](building.md#delphi-пакеты). Без **OpenCV5Design.bpl** в списках `Source` / `SourceA` / `SourceB` не показывается сам компонент.

## Палитра IDE

| Палитра | Компоненты |
|---------|------------|
| OpenCV 5 | `TcvCamera`, `TcvVideoFile`, `TcvFaceDetector`, `TcvFaceRecognizer`, `TcvPipeline`, **`TcvMultiplexer`** |
| OpenCV 5 VCL | `TcvViewVcl` |
| OpenCV 5 FMX | `TcvViewFmx` |

## Цепочка данных

```
TcvCamera ──► TcvPipeline ──► TcvViewVcl
                  ▲
TcvVideoFile ─────┘
```

- `TcvCamera` — источник, свойство `Source` не используется.
- `TcvPipeline.Source` → камера или другой источник кадров.
- `TcvViewVcl.Source` / `TcvViewFmx.Source` → pipeline или камера.
- **`Enabled`** на камере включает захват.

Preview в коде: [Cookbook → VCL/FMX](cookbook.md#vcl--fmx-preview)

## TcvMultiplexer (MUX)

Два входа (`SourceA`, `SourceB`), один выход.

| Свойство | Описание |
|----------|----------|
| `Mode = mmFallback` | если выбранный вход пуст — подставляется другой (A↔B) |
| `Mode = mmStrict` | только выбранный вход |
| `OnSelectInput` | задайте `SelectedInput`: `0` = A, `1` = B |

Кадры с **SourceA** запускают `OnSelectInput` и передачу downstream; **SourceB** обновляет буфер и в `mmFallback` может инициировать выход, если A ещё не дал кадр.

**Пример:** `Test/Utit2` — `TcvCamera` → два `TcvPipeline` → `TcvMultiplexer` → `TcvViewVcl`; checkbox переключает вход в `OnSelectInput`.

Обработка кадров в pipeline: [TcvPipeline](pipeline.md)
