program DemoWebcam5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Videoio in '..\..\source\OpenCV5.Videoio.pas',
  OpenCV5.Highgui in '..\..\source\OpenCV5.Highgui.pas',
  DemoUtils in '..\common\DemoUtils.pas';

const
  WIN_NAME = 'OpenCV Webcam';

procedure RunDemo;
var
  Cap: TCVVideoCapture;
  Frame: TCVMat;
  CameraIndex, Width, Height, Key, Frames: Integer;
  BackendId: Integer;
begin
  CameraIndex := StrToIntDef(DemoCmdValue('camera', '0'), 0);
  Width := StrToIntDef(DemoCmdValue('width', '0'), 0);
  Height := StrToIntDef(DemoCmdValue('height', '0'), 0);
  BackendId := DemoParseBackend(LowerCase(DemoCmdValue('backend', '')));

  DemoOutLn('OpenCV 5.0 Webcam Demo');
  DemoOutLn('Options: --camera=0  --width=640  --height=480  --backend=dshow|msmf|any');
  DemoOutLn('Press ESC or Q in the video window to exit.');
  DemoOutLn('');

  Cap := DemoOpenCamera(CameraIndex, BackendId);

  if Width > 0 then
    Cap.setProp(CAP_PROP_FRAME_WIDTH, Width);
  if Height > 0 then
    Cap.setProp(CAP_PROP_FRAME_HEIGHT, Height);

  Frame := TCVMat.Create_0(0, 0, CV_8UC3);
  namedWindow(PAnsiChar(AnsiString(WIN_NAME)), WINDOW_AUTOSIZE);

  DemoOutLn(Format('Resolution: %.0f x %.0f', [
    Cap.getProp(CAP_PROP_FRAME_WIDTH),
    Cap.getProp(CAP_PROP_FRAME_HEIGHT)]));

  Frames := 0;
  while True do
  begin
    if not Cap.read(Frame) then
    begin
      DemoOutLn('Failed to read frame from camera.');
      Break;
    end;

    imshow(PAnsiChar(AnsiString(WIN_NAME)), Frame.Handle);
    Inc(Frames);

    Key := waitKey(1);
    if Key in [27, Ord('q'), Ord('Q')] then
      Break;
  end;

  DemoOutLn(Format('Frames displayed: %d', [Frames]));
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
