program DemoImencode5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Imgcodecs in '..\..\source\OpenCV5.Imgcodecs.pas',
  OpenCV5.Utils in '..\..\source\OpenCV5.Utils.pas',
  DemoUtils in '..\common\DemoUtils.pas';

procedure RunDemo;
var
  ImagePath: string;
  Src, Decoded: TCVMat;
  Bytes: TBytes;
begin
  ImagePath := DemoCmdValue('image', 'test.png');
  DemoOutLn('OpenCV 5.0 imencode / imdecode demo');
  DemoOutLn('Options: --image=test.png');
  DemoOutLn('');

  if not FileExists(ImagePath) then
    raise Exception.Create('Image not found: ' + ImagePath);

  Src := imreadPath(ImagePath, IMREAD_COLOR);
  if Src.empty then
    raise Exception.Create('Failed to read: ' + ImagePath);

  if not imencode(PAnsiChar(AnsiString('.png')), Src.Handle, Bytes) then
    raise Exception.Create('imencode failed');

  DemoOutLn(Format('Encoded PNG size: %d bytes', [Length(Bytes)]));

  Decoded := imdecode(@Bytes[0], Length(Bytes), IMREAD_COLOR);
  if Decoded.empty then
    raise Exception.Create('imdecode failed');

  DemoOutLn(Format('Decoded image: %dx%d channels=%d',
    [Decoded.cols, Decoded.rows, Decoded.channels]));
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
