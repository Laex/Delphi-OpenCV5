program DemoCannyHough5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Imgcodecs in '..\..\source\OpenCV5.Imgcodecs.pas',
  DemoUtils in '..\common\DemoUtils.pas';

procedure RunDemo;
var
  ImagePath, OutPath: string;
  Image, Gray, Edges, OutImg, Lines: TCVMat;
  I, N: Integer;
  X1, Y1, X2, Y2: Integer;
  Row: array[0..3] of Single;
  P: ^Single;
begin
  ImagePath := DemoCmdValue('image', 'test.png');
  OutPath := DemoCmdValue('out', 'output\canny_hough.png');

  DemoOutLn('OpenCV 5.0 Canny + HoughLinesP Demo');
  DemoOutLn('Options: --image=test.png --out=output\canny_hough.png');
  DemoOutLn('');

  if not FileExists(ImagePath) then
    raise Exception.Create('Image not found: ' + ImagePath);

  Image := imread(PAnsiChar(AnsiString(ImagePath)), IMREAD_COLOR);
  if Image.empty then
    raise Exception.Create('Failed to read image');

  Gray := TCVMat.Create_0(0, 0, CV_8UC1);
  Edges := TCVMat.Create_0(0, 0, CV_8UC1);
  Lines := TCVMat.Create_0(0, 0, CV_32F);
  cvtColor(Image.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
  Canny(Gray.Handle, Edges.Handle, 50, 150, 3, False);
  HoughLinesP(Edges.Handle, Lines.Handle, 1, Pi / 180, 50, 50, 10);

  OutImg := Image.clone;
  N := Lines.rows;
  DemoOutLn(Format('Detected %d line segments', [N]));
  for I := 0 to N - 1 do
  begin
    P := Lines.ptr(I, 0);
    Move(P^, Row[0], SizeOf(Row));
    X1 := Round(Row[0]); Y1 := Round(Row[1]); X2 := Round(Row[2]); Y2 := Round(Row[3]);
    line(OutImg.Handle, TCVPoint.Create(X1, Y1), TCVPoint.Create(X2, Y2),
      TCVScalar.Create(0, 0, 255), 2, LINE_8, 0);
  end;

  if not DirectoryExists(ExtractFilePath(OutPath)) then
    ForceDirectories(ExtractFilePath(OutPath));
  if not imwrite(PAnsiChar(AnsiString(OutPath)), OutImg.Handle) then
    raise Exception.Create('Failed to write: ' + OutPath);
  DemoOutLn('Saved: ' + OutPath);
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
