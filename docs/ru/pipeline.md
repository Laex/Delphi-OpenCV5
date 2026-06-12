# TcvPipeline

[← Документация](README.md) · [Компоненты](components.md) · [Cookbook → pipeline](cookbook.md#tcvpipeline)

`TcvPipeline` — цепочка стадий **Mat → Mat**. Каждая стадия — элемент `Stages` с `StageType` и параметрами в `Operation`. Ошибка обрабатывается `ErrorPolicy` (по умолчанию passthrough исходного кадра).

## Инфраструктура

| Свойство / API | Описание |
|----------------|----------|
| `ProcessEveryN` | обрабатывать каждый N-й кадр |
| `ErrorPolicy` | `epPassthrough`, `epSkipStage`, `epStop` |
| `Preset` | быстрая загрузка цепочки (таблица ниже) |
| `SaveToIni` / `LoadFromIni` | тип стадии + `Enabled` (параметры операций — OI/код) |
| `OnBeforeStage` / `OnAfterStage` | `Cancel` в `OnBeforeStage` пропускает стадию |
| `OnStageTiming` | время стадии, мс |

## Пресеты

| Пресет | Стадии |
|--------|--------|
| `ppEdges` | Color → Blur(5) → Canny(80/160) |
| `ppNightVision` | CLAHE → BrightnessContrast(1.2, +10) |
| `ppDenoiseSharp` | Denoise → Sharpen |
| `ppContours` | Color → Contours |
| `ppMotionDetect` | BackgroundSubtract |
| `ppLines` | HoughLinesP |
| `ppOpticalFlow` | OpticalFlow |
| `ppGrabCut` | GrabCut |

## Стадии (63 типа)

Color, Blur, Threshold, Canny, Morphology, Resize, Custom, AdaptiveThreshold, BilateralFilter, EqualizeHist, Sobel, Invert, Clahe, InRange, MorphologyEx, ColorMap, BrightnessContrast, PyrDown, PyrUp, Laplacian, Scharr, Denoise, DistanceTransform, Crop, Normalize, Sharpen, Bitwise, Rotate, WarpPolar, Filter2D, CornerHarris, TemporalBlend, MatchTemplate, Contours, ChannelExtract, Flip, OrthoRotate, Gamma, AddWeighted, PyrMeanShift, SepFilter2D, SqrBoxFilter, SpatialGradient, CornerMinEigenVal, Integral, AbsDiff, AutoContrast, MergeChannels, Inpaint, Undistort, Remap, CustomLUT, HoughLinesP, HoughCircles, ConnectedComponents, BackgroundSubtract, DebugText, PhaseCorrelate, BlendLinear, ReferenceDiff, OpticalFlow, RunningAvg, GrabCut, Watershed.

### Улучшения отдельных стадий

Color (`ColorPreset`: Gray/HSV/Lab/RGB) · Canny (`L2gradient`) · Morphology/MorphologyEx (`BorderMode`, `BorderValue`) · InRange (пресеты Red/Green/Blue HSV) · Resize (`ResizeMode=Scale`, `ScaleX`/`ScaleY`, `KeepAspect`).

## Overlay и события анализа

| Стадия | Событие | Данные |
|--------|---------|--------|
| MatchTemplate | `OnMatchResult` | max val, точка |
| Contours | `OnContoursResult` | число контуров |
| HoughLinesP | `OnHoughLinesResult` | отрезки |
| HoughCircles | `OnHoughCirclesResult` | x, y, r |
| ConnectedComponents | `OnConnectedComponentsResult` | `LabelId`, area, rect |
| BackgroundSubtract | `OnForegroundMaskResult` | доля foreground |
| PhaseCorrelate | `OnPhaseCorrelateResult` | сдвиг, response |
| OpticalFlow | `OnOpticalFlowResult` | средняя magnitude |

`DrawOverlay` (default `True`) рисует разметку на кадре; события — метрики без отрисовки.

## ConnectedComponents — ColormapSeed

При `DrawOverlay=False` выход — JET-colormap меток.

| `ColormapSeed` | Поведение |
|----------------|-----------|
| `0` (default) | нормализация по `MaxVal`; цвета могут меняться при изменении числа blob'ов |
| `≠ 0` | стабильный индекс `(LabelId * Seed) mod 254 + 1` |

## BackgroundSubtract (MOG2 / KNN)

| API | Описание |
|-----|----------|
| `Reset` | явный сброс модели фона |
| `ResetOnAssign` | default `True`: `Assign` сбрасывает модель; `False` — только параметры |
| сеттеры `Algorithm`, `History`, … | пересоздают subtractor |

## Tier 3 — stateful / второй вход

| Стадия | Особенность |
|--------|-------------|
| TemporalBlend | EMA (`accumulateWeighted`) |
| AbsDiff | diff с предыдущим кадром |
| AddWeighted, Bitwise, Inpaint, MergeChannels | `OperandPath` / `MaskPath` / файлы каналов |
| BlendLinear | `OperandPath` + `Weight1`/`Weight2` |
| ReferenceDiff | `ReferencePath` + absdiff |
| OpticalFlow | Farneback; `Output`: HSV / magnitude / overlay |
| RunningAvg | `accumulate`, усреднение с начала сессии |
| GrabCut | ROI rect; mask / foreground / overlay |
| Watershed | маркеры: border=BG, rect=FG |
| DebugText | `putText` + опциональный `rectangle` |

## Пример

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

Демо: `Test/Utit2`. Примеры кода: [Cookbook](cookbook.md#tcvpipeline)
