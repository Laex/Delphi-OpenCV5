program DemoTrackNano5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Videoio in '..\..\source\OpenCV5.Videoio.pas',
  OpenCV5.Highgui in '..\..\source\OpenCV5.Highgui.pas',
  OpenCV5.Tracking in '..\..\source\OpenCV5.Tracking.pas',
  DemoUtils in '..\common\DemoUtils.pas';

const
  WIN_NAME = 'TrackerNano';
  WINDOW_AUTOSIZE = 1;

procedure RunDemo;
var
  CameraIndex, Backend: Integer;
  Cap: TCVVideoCapture;
  Frame: TCVMat;
  Tracker: TCVTrackerNano;
  Bbox: TCVRect;
  Key: Integer;
begin
  CameraIndex := StrToIntDef(DemoCmdValue('camera', '0'), 0);
  Backend := DemoParseBackend(DemoCmdValue('backend', ''));

  DemoOutLn('OpenCV 5.0 TrackerNano webcam demo');
  DemoOutLn('Options: --camera=0 [--backend=dshow|msmf]');
  DemoOutLn('Select ROI in the window, then press ESC to quit.');
  DemoOutLn('Requires backbone.onnx + neckhead.onnx in bin\');
  DemoOutLn('');

  Cap := DemoOpenCamera(CameraIndex, Backend);
  if not Cap.read(Frame) or Frame.empty then
    raise Exception.Create('Failed to read first frame');

  namedWindow(PAnsiChar(AnsiString(WIN_NAME)), WINDOW_AUTOSIZE);
  imshow(PAnsiChar(AnsiString(WIN_NAME)), Frame.Handle);
  DemoOutLn('Draw a rectangle around the object to track, then press SPACE or ENTER.');
  Bbox := selectROI(PAnsiChar(AnsiString(WIN_NAME)), Frame.Handle, True, False);
  if (Bbox.Width <= 0) or (Bbox.Height <= 0) then
    raise Exception.Create('Empty ROI selected');

  Tracker := TCVTrackerNano.Create;
  if Tracker.Handle = nil then
    raise Exception.Create('TrackerNano create failed (download backbone.onnx + neckhead.onnx)');
  Tracker.init(Frame.Handle, Bbox);

  while True do
  begin
    if not Cap.read(Frame) or Frame.empty then
      Break;
    if not Tracker.update(Frame.Handle, Bbox) then
      DemoOutLn('Track lost');
    rectangle(Frame.Handle, TCVPoint.Create(Bbox.X, Bbox.Y),
      TCVPoint.Create(Bbox.X + Bbox.Width, Bbox.Y + Bbox.Height),
      TCVScalar.Create(0, 255, 0), 2, LINE_8, 0);
    imshow(PAnsiChar(AnsiString(WIN_NAME)), Frame.Handle);
    Key := waitKey(1);
    if Key in [27, Ord('q'), Ord('Q')] then
      Break;
  end;
  destroyAllWindows;
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
