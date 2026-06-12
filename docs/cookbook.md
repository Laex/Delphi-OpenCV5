# Cookbook

[← Documentation](README.md) · [Delphi units](delphi-units.md) · [Pipeline](pipeline.md)

## splitMat (BGR → channels)

```delphi
uses OpenCV5.Arith, OpenCV5.Types;

var Bgr, B, G, R: TCVMat;
begin
  Bgr := TCVMat.Create_2(H, W, CV_8UC3, TCVScalar.Create(0));
  B := TCVMat.Create_2(H, W, CV_8UC1, TCVScalar.Create(0));
  G := TCVMat.Create_2(H, W, CV_8UC1, TCVScalar.Create(0));
  R := TCVMat.Create_2(H, W, CV_8UC1, TCVScalar.Create(0));
  splitMat(Bgr.Handle, [B.Handle, G.Handle, R.Handle]);  // CV_8U only
end;
```

See [SEH → splitMat](project-structure.md#seh-and-limitations)

## PPOCR text detection

```delphi
uses OpenCV5.Dnn, OpenCV5.Utils;

var Model: TCVTextDetectionDB;
    Polygons, Conf: TCVMat;
    N: Integer;
begin
  Model := TCVTextDetectionDB.Create(PAnsiChar(PathToUTF8('models\text_detection_ppocr.onnx')), nil);
  Model.setInputSize(Img.cols, Img.rows);
  Polygons := TCVMat.Create_0(0, 8, CV_32F);
  Conf := TCVMat.Create_0(0, 1, CV_32F);
  N := Model.detectText(Img.Handle, Polygons.Handle, Conf.Handle, 0.3);
  // Polygons: N rows × 8 (4 corners x,y), Conf: N×1
end;
```

See [DemoDnnPpocr5](demos.md#demodnnppocr5)

## DNN high-level models

| API | Model | Notes |
|-----|-------|-------|
| `TCVClassificationModel` | `classification.onnx` | MobileNet |
| `TCVDetectionModel` | SSD/MobileNet | high-level OpenCV |
| `TCVDetectionModel` + custom | `detection_yolox.onnx` | `yolo_postprocess.cpp` |
| `TCVSegmentationModel` | `human_segmentation_pphumanseg_2023mar.onnx` | PP-HumanSeg |
| `TCVTextDetectionEAST` | `frozen_east_text_detection.pb` | TensorFlow `.pb` |
| `TCVTextDetectionDB` | `text_detection_ppocr.onnx` | quad N×8 |

```delphi
uses OpenCV5.Dnn, OpenCV5.Utils;

var Model: TCVClassificationModel;
    ClassId: Integer; Conf: Single;
begin
  Model := TCVClassificationModel.Create(PAnsiChar(PathToUTF8('models\classification.onnx')), nil);
  Model.setInputSize(Img.cols, Img.rows);
  Model.classify(Img.Handle, ClassId, Conf);
end;
```

## Contours without OutputArrayOfArrays

```delphi
uses OpenCV5.Helpers, OpenCV5.Imgproc;

var Contours: TCVMatVector;
    Hierarchy, Gray, Edges, Vis: TCVMat;
begin
  cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
  Canny(Gray.Handle, Edges.Handle, 80, 160, 3, False);
  findContoursEx(Edges.Handle, Contours, Hierarchy.Handle, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
  Src.copyTo(Vis.Handle);
  drawContoursEx(Vis.Handle, Contours, -1, TCVScalar.Create(0, 255, 0), 2);
end;
```

## PNG in memory

```delphi
uses OpenCV5.Imgcodecs;

var Bytes: TBytes;
    Decoded: TCVMat;
begin
  imencode(PAnsiChar(AnsiString('.png')), Mat.Handle, Bytes);
  Decoded := imdecode(@Bytes[0], Length(Bytes), IMREAD_COLOR);
end;
```

## VCL / FMX preview

```delphi
uses OpenCV5.Vcl;   // or OpenCV5.Fmx

BitmapFromMat(Mat, Image.Picture.Bitmap);   // VCL
FmxBitmapFromMat(Mat, FmxImage.Bitmap);     // FMX
```

See [Components](components.md)

## TcvPipeline

```delphi
uses OpenCV5.Components.Pipeline, OpenCV5.Components.Pipeline.Extended;

// Reset MOG2 after scene change
TcvBackgroundSubtractOperation(Pipeline1.Stages[0].Operation).Reset;

// Copy parameters without resetting the model
DestOp.ResetOnAssign := False;
DestOp.Assign(SourceOp);

// Stable label colors
with TcvConnectedComponentsOperation(Pipeline1.Stages[1].Operation) do
begin
  DrawOverlay := False;
  ColormapSeed := 17;
end;
```

Full reference: [TcvPipeline](pipeline.md)
