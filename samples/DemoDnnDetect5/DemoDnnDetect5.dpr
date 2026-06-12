program DemoDnnDetect5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Dnn in '..\..\source\OpenCV5.Dnn.pas',
  OpenCV5.System in '..\..\source\OpenCV5.System.pas',
  OpenCV5.Utils in '..\..\source\OpenCV5.Utils.pas',
  DemoUtils in '..\common\DemoUtils.pas';

procedure RunDemo;
var
  ModelPath, ImagePath: string;
  Model: TCVDetectionModel;
  Img, ClassIds, Confidences, Boxes: TCVMat;
  I, N: Integer;
begin
  ModelPath := DemoCmdValue('model', 'models\detection_yolox.onnx');
  ImagePath := DemoCmdValue('image', 'test.png');

  DemoOutLn('OpenCV 5.0 DetectionModel demo (YOLOX)');
  DemoOutLn('Options: --model=models\detection_yolox.onnx --image=test.png');
  DemoOutLn('');

  if not FileExists(ModelPath) then
    raise Exception.Create('Model not found: ' + ModelPath);
  if not FileExists(ImagePath) then
    raise Exception.Create('Image not found: ' + ImagePath);

  Model := TCVDetectionModel.Create(PAnsiChar(PathToUTF8(ModelPath)), nil);
  if Model.Handle = nil then
    raise Exception.Create('Failed to create DetectionModel: ' + getLastOpenCVError);

  Img := imreadPath(ImagePath, IMREAD_COLOR);
  if Img.empty then
    raise Exception.Create('Failed to read image');

  Model.setInputSize(640, 640);
  ClassIds := TCVMat.Create_0(0, 1, CV_32S);
  Confidences := TCVMat.Create_0(0, 1, CV_32F);
  Boxes := TCVMat.Create_0(0, 4, CV_32S);

  N := Model.detect(Img.Handle, ClassIds.Handle, Confidences.Handle, Boxes.Handle, 0.25, 0.45);
  if N < 0 then
    raise Exception.Create('detect failed');

  DemoOutLn(Format('Detections: %d', [N]));
  for I := 0 to N - 1 do
    DemoOutLn(Format('  [%d] class=%d conf=%.3f box=(%d,%d,%d,%d)', [I,
      PInteger(ClassIds.ptr(I, 0))^,
      PSingle(Confidences.ptr(I, 0))^,
      PInteger(Boxes.ptr(I, 0))^, PInteger(Boxes.ptr(I, 1))^,
      PInteger(Boxes.ptr(I, 2))^, PInteger(Boxes.ptr(I, 3))^]));
end;

begin
  try
    RunDemo;
  except
    on E: Exception do
    begin
      DemoOutLn('ERROR: ' + E.Message);
      ExitCode := 1;
    end;
  end;
end.
