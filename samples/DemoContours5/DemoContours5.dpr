program DemoContours5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Imgcodecs in '..\..\source\OpenCV5.Imgcodecs.pas',
  OpenCV5.Helpers in '..\..\source\OpenCV5.Helpers.pas',
  DemoUtils in '..\common\DemoUtils.pas';

procedure RunDemo;
var
  ImagePath, OutPath: string;
  Image, Gray, Binary, OutImg: TCVMat;
  Contours: TCVMatVector;
  I, N, MaxI, MaxLen, Len: Integer;
  Pts: TArray<TCVPoint>;
begin
  ImagePath := DemoCmdValue('image', 'test.png');
  OutPath := DemoCmdValue('out', 'output\contours.png');

  DemoOutLn('OpenCV 5.0 Contours Demo (threshold + findContoursEx)');
  DemoOutLn('Options: --image=test.png --out=output\contours.png');
  DemoOutLn('');

  if not FileExists(ImagePath) then
    raise Exception.Create('Image not found: ' + ImagePath);

  Image := imread(PAnsiChar(AnsiString(ImagePath)), IMREAD_COLOR);
  if Image.empty then
    raise Exception.Create('Failed to read image');

  Gray := TCVMat.Create_0(0, 0, CV_8UC1);
  Binary := TCVMat.Create_0(0, 0, CV_8UC1);
  cvtColor(Image.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
  GaussianBlur(Gray.Handle, Gray.Handle, TCVSize.Create(5, 5), 0, 0, 0, 0);
  threshold(Gray.Handle, Binary.Handle, 0, 255, THRESH_BINARY or THRESH_OTSU);

  Contours := TCVMatVector.Create;
  findContoursEx(Binary.Handle, Contours, nil, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE,
    TCVPoint.Create(0, 0));

  OutImg := Image.clone;
  N := Contours.Count;
  MaxI := -1;
  MaxLen := 0;
  for I := 0 to N - 1 do
  begin
    Pts := ContourToPoints(Contours.At(I));
    Len := Length(Pts);
    if Len > MaxLen then
    begin
      MaxLen := Len;
      MaxI := I;
    end;
  end;

  DemoOutLn(Format('Found %d contours; drawing largest (%d points)', [N, MaxLen]));
  if MaxI >= 0 then
    drawContoursEx(OutImg.Handle, Contours, MaxI, TCVScalar.Create(0, 255, 0), 2);

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
