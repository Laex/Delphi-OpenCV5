program DemoDnnTextEast5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Dnn in '..\..\source\OpenCV5.Dnn.pas',
  OpenCV5.Utils in '..\..\source\OpenCV5.Utils.pas',
  DemoUtils in '..\common\DemoUtils.pas';

procedure RunDemo;
var
  ModelPath, ImagePath: string;
  Model: TCVTextDetectionEAST;
  Img, Boxes, Confidences: TCVMat;
  I, N: Integer;
begin
  ModelPath := DemoCmdValue('model', 'models\frozen_east_text_detection.pb');
  ImagePath := DemoCmdValue('image', 'test.png');

  DemoOutLn('OpenCV 5.0 TextDetectionModel_EAST demo');
  DemoOutLn('Options: --model=models\frozen_east_text_detection.pb --image=test.png');
  DemoOutLn('');

  if not FileExists(ModelPath) then
    raise Exception.Create('Model not found: ' + ModelPath + ' (run download_models.ps1)');
  if not FileExists(ImagePath) then
    raise Exception.Create('Image not found: ' + ImagePath);

  Model := TCVTextDetectionEAST.Create(PAnsiChar(PathToUTF8(ModelPath)), nil);
  if Model.Handle = nil then
    raise Exception.Create('Failed to create TextDetectionEAST');

  Img := imreadPath(ImagePath, IMREAD_COLOR);
  if Img.empty then
    raise Exception.Create('Failed to read image');

  Model.setInputSize(320, 320);
  Boxes := TCVMat.Create_0(0, 5, CV_32F);
  Confidences := TCVMat.Create_0(0, 1, CV_32F);

  N := Model.detectText(Img.Handle, Boxes.Handle, Confidences.Handle, 0.5, 0.4);
  if N < 0 then
    raise Exception.Create('detectText failed');

  DemoOutLn(Format('Text regions: %d', [N]));
  for I := 0 to N - 1 do
    DemoOutLn(Format('  [%d] cx=%.1f cy=%.1f w=%.1f h=%.1f angle=%.1f conf=%.3f', [I,
      PSingle(Boxes.ptr(I, 0))^, PSingle(Boxes.ptr(I, 1))^,
      PSingle(Boxes.ptr(I, 2))^, PSingle(Boxes.ptr(I, 3))^,
      PSingle(Boxes.ptr(I, 4))^, PSingle(Confidences.ptr(I, 0))^]));
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
