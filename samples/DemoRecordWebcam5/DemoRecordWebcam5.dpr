program DemoRecordWebcam5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Videoio in '..\..\source\OpenCV5.Videoio.pas',
  OpenCV5.Highgui in '..\..\source\OpenCV5.Highgui.pas',
  DemoUtils in '..\common\DemoUtils.pas';

const
  WIN_NAME = 'Record Webcam';

procedure RunDemo;
var
  Cap: TCVVideoCapture;
  Writer: TCVVideoWriter;
  Frame: TCVMat;
  CameraIndex, Width, Height, Key, Frames: Integer;
  BackendId: Integer;
  OutFile: string;
  Fps: Double;
  FrameSize: TCVSize;
  Fourcc: Integer;
begin
  CameraIndex := StrToIntDef(DemoCmdValue('camera', '0'), 0);
  Width := StrToIntDef(DemoCmdValue('width', '640'), 640);
  Height := StrToIntDef(DemoCmdValue('height', '480'), 480);
  BackendId := DemoParseBackend(LowerCase(DemoCmdValue('backend', '')));
  OutFile := DemoCmdValue('out', 'output\webcam_record.avi');
  Fps := StrToFloatDef(DemoCmdValue('fps', '25'), 25);

  DemoOutLn('OpenCV 5.0 Webcam Recorder');
  DemoOutLn('Options: --camera=0 --width=640 --height=480 --fps=25');
  DemoOutLn('         --out=output\webcam_record.avi --backend=dshow|msmf|any');
  DemoOutLn('Press ESC or Q in the preview window to stop recording.');
  DemoOutLn('');

  Cap := DemoOpenCamera(CameraIndex, BackendId);
  Cap.setProp(CAP_PROP_FRAME_WIDTH, Width);
  Cap.setProp(CAP_PROP_FRAME_HEIGHT, Height);

  FrameSize := TCVSize.Create(
    Trunc(Cap.getProp(CAP_PROP_FRAME_WIDTH)),
    Trunc(Cap.getProp(CAP_PROP_FRAME_HEIGHT)));

  Fourcc := DemoFourcc('M', 'J', 'P', 'G');
  Writer := TCVVideoWriter.Create_1(PAnsiChar(AnsiString(OutFile)), Fourcc, Fps, FrameSize, True);
  if not Writer.isOpened then
    raise Exception.Create('Cannot create video writer: ' + OutFile);

  Frame := TCVMat.Create_0(0, 0, CV_8UC3);
  namedWindow(PAnsiChar(AnsiString(WIN_NAME)), WINDOW_AUTOSIZE);

  DemoOutLn(Format('Recording to: %s', [OutFile]));
  DemoOutLn(Format('Resolution: %d x %d @ %.1f fps', [FrameSize.Width, FrameSize.Height, Fps]));

  Frames := 0;
  while True do
  begin
    if not Cap.read(Frame) then
    begin
      DemoOutLn('Failed to read frame from camera.');
      Break;
    end;

    Writer.write(Frame.Handle);
    imshow(PAnsiChar(AnsiString(WIN_NAME)), Frame.Handle);
    Inc(Frames);

    Key := waitKey(1);
    if Key in [27, Ord('q'), Ord('Q')] then
      Break;
  end;

  DemoOutLn(Format('Frames recorded: %d', [Frames]));
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
