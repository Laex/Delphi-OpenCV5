# Components

[← Documentation](README.md) · [Building → packages](building.md#delphi-packages) · [TcvPipeline](pipeline.md)

## Packages

| Package | Contents |
|---------|----------|
| `OpenCV5.dpk` | core + runtime components |
| `OpenCV5Vcl.dpk` | `TcvViewVcl` |
| `OpenCV5Fmx.dpk` | `TcvViewFmx` |
| `OpenCV5Design.dpk` | Object Inspector editors (IDE only) |

Build: [Delphi packages](building.md#delphi-packages). Without **OpenCV5Design.bpl**, the component itself does not appear in `Source` / `SourceA` / `SourceB` dropdowns.

## IDE palette

| Palette | Components |
|---------|------------|
| OpenCV 5 | `TcvCamera`, `TcvVideoFile`, `TcvFaceDetector`, `TcvFaceRecognizer`, `TcvPipeline`, **`TcvMultiplexer`** |
| OpenCV 5 VCL | `TcvViewVcl` |
| OpenCV 5 FMX | `TcvViewFmx` |

## Data flow

```
TcvCamera ──► TcvPipeline ──► TcvViewVcl
                  ▲
TcvVideoFile ─────┘
```

- `TcvCamera` — source; `Source` property is not used.
- `TcvPipeline.Source` → camera or another frame source.
- `TcvViewVcl.Source` / `TcvViewFmx.Source` → pipeline or camera.
- **`Enabled`** on the camera starts capture.

Preview in code: [Cookbook → VCL/FMX](cookbook.md#vcl--fmx-preview)

## TcvMultiplexer (MUX)

Two inputs (`SourceA`, `SourceB`), one output.

| Property | Description |
|----------|-------------|
| `Mode = mmFallback` | if the selected input is empty, use the other (A↔B) |
| `Mode = mmStrict` | selected input only |
| `OnSelectInput` | set `SelectedInput`: `0` = A, `1` = B |

Frames from **SourceA** trigger `OnSelectInput` and downstream delivery; **SourceB** updates its buffer and in `mmFallback` may trigger output if A has not delivered a frame yet.

**Example:** `Test/Utit2` — `TcvCamera` → two `TcvPipeline` → `TcvMultiplexer` → `TcvViewVcl`; a checkbox switches input in `OnSelectInput`.

Frame processing in pipeline: [TcvPipeline](pipeline.md)
