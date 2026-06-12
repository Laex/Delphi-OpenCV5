program DemoSeamlessClone5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Photo in '..\..\source\OpenCV5.Photo.pas',
  OpenCV5.System in '..\..\source\OpenCV5.System.pas',
  OpenCV5.Utils in '..\..\source\OpenCV5.Utils.pas',
  DemoUtils in '..\common\DemoUtils.pas';

procedure RunDemo;
var
  OutPath, SrcPath: string;
  Bg, Patch, Mask, Result: TCVMat;
  Center: TCVPoint;
begin
  OutPath := DemoCmdValue('out', 'seamless_out.png');
  SrcPath := DemoCmdValue('image', 'test.png');
  DemoOutLn('OpenCV 5.0 seamlessClone demo');
  DemoOutLn('Options: --out=seamless_out.png [--image=test.png] [--try-clone]');
  DemoOutLn('Photo.seamlessClone is exported; OpenCV 5 may raise SEH in the host exe.');
  DemoOutLn('Default: writes background preview. Pass --try-clone to attempt seamlessClone.');
  DemoOutLn('');

  if FileExists(SrcPath) then
    Bg := imreadPath(SrcPath, IMREAD_COLOR)
  else
    Bg := TCVMat.Create_2(128, 128, CV_8UC3, TCVScalar.Create(40, 80, 120));

  if Bg.empty then
    raise Exception.Create('Background image missing or unreadable');

  if FindCmdLineSwitch('try-clone', True) then
  begin
    Patch := TCVMat.Create_2(32, 32, CV_8UC3, TCVScalar.Create(220, 40, 40));
    Mask := TCVMat.Create_2(32, 32, CV_8UC1, TCVScalar.Create(255));
    Result := TCVMat.Create_0(0, 0, CV_8UC3);
    Center := TCVPoint.Create(Bg.cols div 2, Bg.rows div 2);
    seamlessClone(Patch.Handle, Bg.Handle, Mask.Handle, Center, Result.Handle, NORMAL_CLONE);
    if Result.empty then
      DemoOutLn('[WARN] seamlessClone returned empty: ' + getLastOpenCVError)
    else if imwritePath(OutPath, Result.Handle) then
    begin
      DemoOutLn('Written ' + OutPath + Format(' (%dx%d)', [Result.cols, Result.rows]));
      Exit;
    end;
  end;

  if not imwritePath(OutPath, Bg.Handle) then
    raise Exception.Create('imwrite failed: ' + OutPath);
  DemoOutLn('Written ' + OutPath + Format(' (%dx%d)', [Bg.cols, Bg.rows]));
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
