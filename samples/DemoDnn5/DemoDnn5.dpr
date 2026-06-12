program DemoDnn5;

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
  Net: TCVNet;
  Img, Blob, Output: TCVMat;
  InputSize: TCVSize;
  LayerNames: string;
begin
  ModelPath := DemoCmdValue('model', '');
  ImagePath := DemoCmdValue('image', 'test.png');

  DemoOutLn('OpenCV 5.0 DNN Demo');
  DemoOutLn('Options: --model=model.onnx --image=test.png');
  DemoOutLn('');

  if ModelPath = '' then
    raise Exception.Create('Specify --model=path.onnx');
  if not FileExists(ModelPath) then
    raise Exception.Create('Model not found: ' + ModelPath);
  if not FileExists(ImagePath) then
    raise Exception.Create('Image not found: ' + ImagePath);

  Net := TCVNet.readNet(PAnsiChar(PathToUTF8(ModelPath)), nil);
  if Net.empty then
    raise Exception.Create('Failed to load network: ' + ModelPath);

  LayerNames := Net.getUnconnectedOutLayersNames;
  DemoOutLn('Output layers:');
  DemoOutLn(LayerNames);

  Img := imreadPath(ImagePath, IMREAD_COLOR);
  if Img.empty then
    raise Exception.Create('Failed to read image: ' + ImagePath);

  InputSize := TCVSize.Create(224, 224);
  Blob := blobFromImage(Img.Handle, 1.0 / 255.0, InputSize,
    TCVScalar.Create(0, 0, 0, 0), True, False);
  Net.setInput(Blob.Handle);
  Output := Net.forwardOutput(nil);

  DemoOutLn(Format('Input blob : rows=%d cols=%d', [Blob.rows, Blob.cols]));
  DemoOutLn(Format('Output     : rows=%d cols=%d channels=%d',
    [Output.rows, Output.cols, Output.channels]));
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
