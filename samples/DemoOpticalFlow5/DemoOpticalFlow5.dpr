program DemoOpticalFlow5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Video in '..\..\source\OpenCV5.Video.pas',
  OpenCV5.Features2d in '..\..\source\OpenCV5.Features2d.pas',
  OpenCV5.Videoio in '..\..\source\OpenCV5.Videoio.pas',
  OpenCV5.Highgui in '..\..\source\OpenCV5.Highgui.pas',
  DemoUtils in '..\common\DemoUtils.pas';

const
  WIN_NAME = 'Optical Flow (Lucas-Kanade)';

procedure DrawTracks(const Frame: TCVMat; const PrevPts, NextPts, Status: TCVMat);
var
  I, Count: Integer;
  P0, P1: TCVPoint;
  Good: Byte;
begin
  Count := PrevPts.rows;
  for I := 0 to Count - 1 do
  begin
    Good := PByte(Status.ptr(I, 0))^;
    if Good = 0 then
      Continue;
    P0.X := Trunc(PSingle(PrevPts.ptr(I, 0))^);
    P0.Y := Trunc(PSingle(PrevPts.ptr(I, 1))^);
    P1.X := Trunc(PSingle(NextPts.ptr(I, 0))^);
    P1.Y := Trunc(PSingle(NextPts.ptr(I, 1))^);
    line(Frame.Handle, P0, P1, TCVScalar.Create(0, 255, 0), 2, LINE_8, 0);
    circle(Frame.Handle, P1, 3, TCVScalar.Create(0, 0, 255), FILLED, LINE_8, 0);
  end;
end;

procedure RunDemo;
var
  Cap: TCVVideoCapture;
  Frame, Gray, PrevGray, PrevPts, NextPts, Status, Err: TCVMat;
  CameraIndex, Width, Height, Key, Frames, MaxCorners, LastW, LastH: Integer;
  BackendId: Integer;
  Criteria: TCVTermCriteria;
  WinSize: TCVSize;
begin
  CameraIndex := StrToIntDef(DemoCmdValue('camera', '0'), 0);
  Width := StrToIntDef(DemoCmdValue('width', '640'), 640);
  Height := StrToIntDef(DemoCmdValue('height', '480'), 480);
  MaxCorners := StrToIntDef(DemoCmdValue('corners', '200'), 200);
  BackendId := DemoParseBackend(LowerCase(DemoCmdValue('backend', '')));

  DemoOutLn('OpenCV 5.0 Optical Flow Demo (Lucas-Kanade)');
  DemoOutLn('Options: --camera=0 --width=640 --height=480 --corners=200');
  DemoOutLn('Press ESC or Q in the video window to exit.');
  DemoOutLn('');

  Cap := DemoOpenCamera(CameraIndex, BackendId);
  Cap.setProp(CAP_PROP_FRAME_WIDTH, Width);
  Cap.setProp(CAP_PROP_FRAME_HEIGHT, Height);

  Frame := TCVMat.Create_0(0, 0, CV_8UC3);
  Gray := TCVMat.Create_0(0, 0, CV_8UC1);
  PrevGray := TCVMat.Create_0(0, 0, CV_8UC1);
  PrevPts := TCVMat.Create_0(0, 0, CV_32FC2);
  NextPts := TCVMat.Create_0(0, 0, CV_32FC2);
  Status := TCVMat.Create_0(0, 0, CV_8UC1);
  Err := TCVMat.Create_0(0, 0, CV_32FC1);

  namedWindow(PAnsiChar(AnsiString(WIN_NAME)), WINDOW_AUTOSIZE);
  Criteria := TCVTermCriteria.Create(TERM_CRITERIA_COUNT or TERM_CRITERIA_EPS, 10, 0.03);
  WinSize := TCVSize.Create(21, 21);
  LastW := -1;
  LastH := -1;
  Frames := 0;

  while True do
  begin
    if not Cap.read(Frame) then
    begin
      DemoOutLn('Failed to read frame from camera.');
      Break;
    end;

    cvtColor(Frame.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);

    if (Gray.cols <> LastW) or (Gray.rows <> LastH) then
    begin
      LastW := Gray.cols;
      LastH := Gray.rows;
      Gray.copyTo(PrevGray.Handle);
      goodFeaturesToTrack(PrevGray.Handle, PrevPts.Handle, MaxCorners, 0.01, 10);
    end
    else
    begin
      PrevPts.copyTo(NextPts.Handle);
      calcOpticalFlowPyrLK(PrevGray.Handle, Gray.Handle, PrevPts.Handle, NextPts.Handle,
        Status.Handle, Err.Handle, WinSize, 3, Criteria, 0, 0.001);
      DrawTracks(Frame, PrevPts, NextPts, Status);
      Gray.copyTo(PrevGray.Handle);
      NextPts.copyTo(PrevPts.Handle);
    end;

    imshow(PAnsiChar(AnsiString(WIN_NAME)), Frame.Handle);
    Inc(Frames);

    Key := waitKey(1);
    if Key in [27, Ord('q'), Ord('Q')] then
      Break;
  end;

  DemoOutLn(Format('Frames processed: %d', [Frames]));
  destroyAllWindows;
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
