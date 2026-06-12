program DemoStereoDepth5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Imgcodecs in '..\..\source\OpenCV5.Imgcodecs.pas',
  OpenCV5.Stereo in '..\..\source\OpenCV5.Stereo.pas',
  DemoUtils in '..\common\DemoUtils.pas';

procedure FillSyntheticStereo(out Left, Right: TCVMat);
var
  Y, X: Integer;
  P: PByte;
begin
  Left := TCVMat.Create_2(240, 320, CV_8UC1, TCVScalar.Create(40));
  Right := TCVMat.Create_2(240, 320, CV_8UC1, TCVScalar.Create(40));
  for Y := 0 to Left.rows - 1 do
  begin
    P := PByte(Left.ptr(Y, 0));
    for X := 0 to Left.cols - 1 do
    begin
      if (X > 80) and (X < 240) and (Y > 60) and (Y < 180) then
        P^ := 200
      else
        P^ := 40;
      Inc(P);
    end;
  end;
  for Y := 0 to Right.rows - 1 do
  begin
    P := PByte(Right.ptr(Y, 0));
    for X := 0 to Right.cols - 1 do
    begin
      if (X > 72) and (X < 232) and (Y > 60) and (Y < 180) then
        P^ := 200
      else
        P^ := 40;
      Inc(P);
    end;
  end;
end;

procedure RunDemo;
var
  OutPath: string;
  Left, Right, Disparity, DispVis: TCVMat;
  Matcher: TCVStereoMatcher;
  Scale: Double;
  Y, X: Integer;
  V: Integer;
  P: PByte;
begin
  OutPath := DemoCmdValue('out', 'output\stereo_disparity.png');

  DemoOutLn('OpenCV 5.0 Stereo Depth Demo (StereoSGBM on synthetic pair)');
  DemoOutLn('Options: --out=output\stereo_disparity.png');
  DemoOutLn('');

  FillSyntheticStereo(Left, Right);
  Disparity := TCVMat.Create_0(0, 0, CV_16S);
  Matcher := TCVStereoMatcher.CreateSGBM(0, 32, 5);
  Matcher.compute(Left.Handle, Right.Handle, Disparity.Handle);

  DispVis := TCVMat.Create_0(Left.rows, Left.cols, CV_8UC1);
  Scale := 255.0 / (32.0 * 16.0);
  for Y := 0 to Disparity.rows - 1 do
  begin
    P := PByte(DispVis.ptr(Y, 0));
    for X := 0 to Disparity.cols - 1 do
    begin
      V := PSmallInt(Disparity.ptr(Y, X))^;
      if V < 0 then
        P^ := 0
      else
        P^ := Byte(Min(255, Round(V * Scale)));
      Inc(P);
    end;
  end;

  if not DirectoryExists(ExtractFilePath(OutPath)) then
    ForceDirectories(ExtractFilePath(OutPath));
  if not imwrite(PAnsiChar(AnsiString(OutPath)), DispVis.Handle) then
    raise Exception.Create('Failed to write: ' + OutPath);
  DemoOutLn('Saved disparity visualization: ' + OutPath);
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
