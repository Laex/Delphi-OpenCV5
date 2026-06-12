program DemoDnnPpocr5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Dnn in '..\..\source\OpenCV5.Dnn.pas',
  OpenCV5.System in '..\..\source\OpenCV5.System.pas',
  OpenCV5.Utils in '..\..\source\OpenCV5.Utils.pas',
  DemoUtils in '..\common\DemoUtils.pas';

function DefaultImagePath: string;
begin
  if FileExists('text_sample.png') then
    Result := 'text_sample.png'
  else if FileExists('test.png') then
    Result := 'test.png'
  else
    Result := 'text_sample.png';
end;

procedure RunDemo;
var
  ModelPath, ImagePath: string;
  Model: TCVTextDetectionDB;
  Img, Polygons, Confidences: TCVMat;
  I, N: Integer;
begin
  ModelPath := DemoCmdValue('model', 'models\text_detection_ppocr.onnx');
  if DemoCmdValue('image', '') <> '' then
    ImagePath := DemoCmdValue('image', '')
  else
    ImagePath := DefaultImagePath;

  DemoOutLn('OpenCV 5.0 TextDetectionModel_DB demo (PPOCR)');
  DemoOutLn('Options: --model=models\text_detection_ppocr.onnx --image=text_sample.png');
  DemoOutLn('Run download_models.ps1 to create text_sample.png with visible text.');
  DemoOutLn('Output: polygon rows x 8 (4 corner x,y), confidence per row');
  DemoOutLn('');

  if not FileExists(ModelPath) then
    raise Exception.Create('Model not found: ' + ModelPath);
  if not FileExists(ImagePath) then
    raise Exception.Create('Image not found: ' + ImagePath + ' (run download_models.ps1)');

  Model := TCVTextDetectionDB.Create(PAnsiChar(PathToUTF8(ModelPath)), nil);
  if Model.Handle = nil then
    raise Exception.Create('Failed to create TextDetectionDB: ' + getLastOpenCVError);

  Img := imreadPath(ImagePath, IMREAD_COLOR);
  if Img.empty then
    raise Exception.Create('Failed to read image');

  Model.setInputSize(Img.cols, Img.rows);
  Polygons := TCVMat.Create_0(0, 8, CV_32F);
  Confidences := TCVMat.Create_0(0, 1, CV_32F);

  N := Model.detectText(Img.Handle, Polygons.Handle, Confidences.Handle, 0.3);
  if N < 0 then
    raise Exception.Create('detectText failed: ' + getLastOpenCVError);

  DemoOutLn(Format('Image: %s (%dx%d)', [ImagePath, Img.cols, Img.rows]));
  DemoOutLn(Format('Text polygons: %d', [N]));
  if N = 0 then
    DemoOutLn('[NOTE] no text detected; try lower threshold or another image')
  else if SameText(ExtractFileName(ImagePath), 'test.png') then
    DemoOutLn('[NOTE] test.png has no text; use --image=text_sample.png');

  for I := 0 to N - 1 do
  begin
    DemoOutLn(Format('  [%d] conf=%.3f poly=(%.0f,%.0f)-(%.0f,%.0f)-(%.0f,%.0f)-(%.0f,%.0f)', [I,
      PSingle(Confidences.ptr(I, 0))^,
      PSingle(Polygons.ptr(I, 0))^, PSingle(Polygons.ptr(I, 1))^,
      PSingle(Polygons.ptr(I, 2))^, PSingle(Polygons.ptr(I, 3))^,
      PSingle(Polygons.ptr(I, 4))^, PSingle(Polygons.ptr(I, 5))^,
      PSingle(Polygons.ptr(I, 6))^, PSingle(Polygons.ptr(I, 7))^]));
  end;
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
