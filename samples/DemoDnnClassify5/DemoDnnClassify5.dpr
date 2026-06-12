program DemoDnnClassify5;

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
  ModelPath, ConfigPath, ImagePath: string;
  Model: TCVClassificationModel;
  Img: TCVMat;
  ClassId: Integer;
  Conf: Single;
begin
  ModelPath := DemoCmdValue('model', '');
  ConfigPath := DemoCmdValue('config', '');
  ImagePath := DemoCmdValue('image', 'test.png');

  DemoOutLn('OpenCV 5.0 ClassificationModel demo');
  DemoOutLn('Options: --model=net.onnx [--config=] --image=test.png');
  DemoOutLn('');

  if ModelPath = '' then
    raise Exception.Create('Specify --model=classification.onnx');
  if not FileExists(ModelPath) then
    raise Exception.Create('Model not found: ' + ModelPath);
  if not FileExists(ImagePath) then
    raise Exception.Create('Image not found: ' + ImagePath);

  if ConfigPath <> '' then
    Model := TCVClassificationModel.Create(PAnsiChar(PathToUTF8(ModelPath)),
      PAnsiChar(PathToUTF8(ConfigPath)))
  else
    Model := TCVClassificationModel.Create(PAnsiChar(PathToUTF8(ModelPath)), nil);

  if Model.Handle = nil then
    raise Exception.Create('Failed to create ClassificationModel');

  Img := imreadPath(ImagePath, IMREAD_COLOR);
  if Img.empty then
    raise Exception.Create('Failed to read image');

  Model.setInputSize(Img.cols, Img.rows);
  if not Model.classify(Img.Handle, ClassId, Conf) then
    raise Exception.Create('classify failed');

  DemoOutLn(Format('classId=%d confidence=%.4f', [ClassId, Conf]));
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
