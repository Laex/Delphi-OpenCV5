program DemoFarneback5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Video in '..\..\source\OpenCV5.Video.pas',
  OpenCV5.Highgui in '..\..\source\OpenCV5.Highgui.pas',
  DemoUtils in '..\common\DemoUtils.pas';

const
  WIN = 'Farneback optical flow';

procedure RunDemo;
var
  Prev, Next, Flow, Magnitude: TCVMat;
  I, J, W, H: Integer;
  Fx, Fy, Mag: Single;
  Key: Integer;
begin
  W := 160;
  H := 120;
  DemoOutLn('OpenCV 5.0 Farneback optical flow demo (synthetic shift)');
  DemoOutLn('Press ESC or Q in the window to exit.');
  DemoOutLn('');

  Prev := TCVMat.Create_2(H, W, CV_8UC1, TCVScalar.Create(0));
  Next := TCVMat.Create_2(H, W, CV_8UC1, TCVScalar.Create(0));
  for I := 20 to 80 do
    for J := 20 to 100 do
    begin
      PByte(Prev.ptr(I, J))^ := 200;
      if (J + 3 <= W - 1) then
        PByte(Next.ptr(I, J + 3))^ := 200;
    end;

  Flow := TCVMat.Create_0(H, W, CV_32FC2);
  calcOpticalFlowFarneback(Prev.Handle, Next.Handle, Flow.Handle,
    0.5, 3, 15, 3, 5, 1.2, 0);

  Magnitude := TCVMat.Create_0(H, W, CV_8UC1);
  for I := 0 to H - 1 do
    for J := 0 to W - 1 do
    begin
      Fx := PSingle(Flow.ptr(I, J))^;
      Fy := PSingle(PByte(Flow.ptr(I, J)) + SizeOf(Single))^;
      Mag := Sqrt(Fx * Fx + Fy * Fy);
      PByte(Magnitude.ptr(I, J))^ := Byte(Min(255, Trunc(Mag * 20)));
    end;

  namedWindow(PAnsiChar(AnsiString(WIN)), WINDOW_AUTOSIZE);
  imshow(PAnsiChar(AnsiString(WIN)), Magnitude.Handle);
  Key := waitKey(0);
  destroyAllWindows;
  DemoOutLn(Format('waitKey returned %d', [Key]));
end;

begin
  try
    RunDemo;
  except
    on E: Exception do
    begin
      DemoOutLn('ERROR: ' + E.Message);
      destroyAllWindows;
      ExitCode := 1;
    end;
  end;
end.
