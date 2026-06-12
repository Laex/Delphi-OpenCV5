# TcvPipeline

[← Documentation](README.md) · [Components](components.md) · [Cookbook → pipeline](cookbook.md#tcvpipeline)

`TcvPipeline` is a chain of **Mat → Mat** stages. Each stage is a `Stages` item with `StageType` and parameters in `Operation`. Errors are handled by `ErrorPolicy` (default: passthrough of the original frame).

## Infrastructure

| Property / API | Description |
|----------------|-------------|
| `ProcessEveryN` | process every N-th frame |
| `ErrorPolicy` | `epPassthrough`, `epSkipStage`, `epStop` |
| `Preset` | quick chain load (table below) |
| `SaveToIni` / `LoadFromIni` | stage type + `Enabled` (operation params — OI/code) |
| `OnBeforeStage` / `OnAfterStage` | `Cancel` in `OnBeforeStage` skips the stage |
| `OnStageTiming` | stage time in ms |

## Presets

| Preset | Stages |
|--------|--------|
| `ppEdges` | Color → Blur(5) → Canny(80/160) |
| `ppNightVision` | CLAHE → BrightnessContrast(1.2, +10) |
| `ppDenoiseSharp` | Denoise → Sharpen |
| `ppContours` | Color → Contours |
| `ppMotionDetect` | BackgroundSubtract |
| `ppLines` | HoughLinesP |
| `ppOpticalFlow` | OpticalFlow |
| `ppGrabCut` | GrabCut |

## Stages (63 types)

Color, Blur, Threshold, Canny, Morphology, Resize, Custom, AdaptiveThreshold, BilateralFilter, EqualizeHist, Sobel, Invert, Clahe, InRange, MorphologyEx, ColorMap, BrightnessContrast, PyrDown, PyrUp, Laplacian, Scharr, Denoise, DistanceTransform, Crop, Normalize, Sharpen, Bitwise, Rotate, WarpPolar, Filter2D, CornerHarris, TemporalBlend, MatchTemplate, Contours, ChannelExtract, Flip, OrthoRotate, Gamma, AddWeighted, PyrMeanShift, SepFilter2D, SqrBoxFilter, SpatialGradient, CornerMinEigenVal, Integral, AbsDiff, AutoContrast, MergeChannels, Inpaint, Undistort, Remap, CustomLUT, HoughLinesP, HoughCircles, ConnectedComponents, BackgroundSubtract, DebugText, PhaseCorrelate, BlendLinear, ReferenceDiff, OpticalFlow, RunningAvg, GrabCut, Watershed.

### Stage enhancements

Color (`ColorPreset`: Gray/HSV/Lab/RGB) · Canny (`L2gradient`) · Morphology/MorphologyEx (`BorderMode`, `BorderValue`) · InRange (Red/Green/Blue HSV presets) · Resize (`ResizeMode=Scale`, `ScaleX`/`ScaleY`, `KeepAspect`).

## Overlay and analysis events

| Stage | Event | Data |
|-------|-------|------|
| MatchTemplate | `OnMatchResult` | max val, point |
| Contours | `OnContoursResult` | contour count |
| HoughLinesP | `OnHoughLinesResult` | line segments |
| HoughCircles | `OnHoughCirclesResult` | x, y, r |
| ConnectedComponents | `OnConnectedComponentsResult` | `LabelId`, area, rect |
| BackgroundSubtract | `OnForegroundMaskResult` | foreground fraction |
| PhaseCorrelate | `OnPhaseCorrelateResult` | shift, response |
| OpticalFlow | `OnOpticalFlowResult` | mean magnitude |

`DrawOverlay` (default `True`) draws markup on the frame; events provide metrics without drawing.

## ConnectedComponents — ColormapSeed

When `DrawOverlay=False`, output is a JET colormap of labels.

| `ColormapSeed` | Behavior |
|----------------|----------|
| `0` (default) | normalize by `MaxVal`; colors may shift when blob count changes |
| `≠ 0` | stable index `(LabelId * Seed) mod 254 + 1` |

## BackgroundSubtract (MOG2 / KNN)

| API | Description |
|-----|-------------|
| `Reset` | explicit background model reset |
| `ResetOnAssign` | default `True`: `Assign` resets the model; `False` — parameters only |
| setters `Algorithm`, `History`, … | recreate the subtractor |

## Tier 3 — stateful / second input

| Stage | Notes |
|-------|-------|
| TemporalBlend | EMA (`accumulateWeighted`) |
| AbsDiff | diff with previous frame |
| AddWeighted, Bitwise, Inpaint, MergeChannels | `OperandPath` / `MaskPath` / channel files |
| BlendLinear | `OperandPath` + `Weight1`/`Weight2` |
| ReferenceDiff | `ReferencePath` + absdiff |
| OpticalFlow | Farneback; `Output`: HSV / magnitude / overlay |
| RunningAvg | `accumulate`, average since session start |
| GrabCut | ROI rect; mask / foreground / overlay |
| Watershed | markers: border=BG, rect=FG |
| DebugText | `putText` + optional `rectangle` |

## Example

```delphi
Pipeline1.Stages.Add.StageType := stClahe;
Pipeline1.Stages.Add.StageType := stCanny;
Pipeline1.Preset := ppMotionDetect;

with TcvBackgroundSubtractOperation(Pipeline1.Stages[0].Operation) do
begin
  Algorithm := bsMOG2;
  OnForegroundMaskResult := OnFg;
end;
```

Demo: `Test/Utit2`. Code examples: [Cookbook](cookbook.md#tcvpipeline)
