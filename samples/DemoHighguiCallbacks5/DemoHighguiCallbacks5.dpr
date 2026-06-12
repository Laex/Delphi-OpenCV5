program DemoHighguiCallbacks5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Highgui in '..\..\source\OpenCV5.Highgui.pas',
  OpenCV5.Utils in '..\..\source\OpenCV5.Utils.pas',
  DemoUtils in '..\common\DemoUtils.pas';

const
  WIN_NAME = 'Highgui callbacks';
  WINDOW_AUTOSIZE = 1;
  EVENT_LBUTTONDOWN = 1;
  EVENT_MOUSEMOVE = 0;

var
  GPos: Integer = 50;
  GMouseX, GMouseY: Integer;

procedure OnTrackbar(Pos: Integer; UserData: Pointer); cdecl;
begin
  GPos := Pos;
end;

procedure OnMouse(Event, X, Y, Flags: Integer; UserData: Pointer); cdecl;
begin
  if Event = EVENT_MOUSEMOVE then
  begin
    GMouseX := X;
    GMouseY := Y;
  end
  else if Event = EVENT_LBUTTONDOWN then
    DemoOutLn(Format('Mouse click at (%d,%d)', [X, Y]));
end;

procedure RunDemo;
var
  ImagePath: string;
  Img, Display: TCVMat;
  Key: Integer;
begin
  ImagePath := DemoCmdValue('image', 'test.png');

  DemoOutLn('OpenCV 5.0 highgui callbacks demo');
  DemoOutLn('Trackbar adjusts circle radius; click in window for coordinates.');
  DemoOutLn('Press ESC to exit.');
  DemoOutLn('');

  if FileExists(ImagePath) then
    Img := imreadPath(ImagePath, IMREAD_COLOR)
  else
  begin
    Img := TCVMat.Create_2(480, 640, CV_8UC3, TCVScalar.Create(40, 40, 40));
    putText(Img.Handle, PAnsiChar(AnsiString('No test.png - synthetic background')),
      TCVPoint.Create(20, 240), FONT_HERSHEY_SIMPLEX, 0.7, TCVScalar.Create(200, 200, 200), 2, LINE_8, False);
  end;

  namedWindow(PAnsiChar(AnsiString(WIN_NAME)), WINDOW_AUTOSIZE);
  setMouseCallback(PAnsiChar(AnsiString(WIN_NAME)), OnMouse, nil);
  createTrackbar(PAnsiChar(AnsiString('Radius')), PAnsiChar(AnsiString(WIN_NAME)), GPos, 200, OnTrackbar, nil);

  while True do
  begin
    Display := Img.clone;
    circle(Display.Handle, TCVPoint.Create(GMouseX, GMouseY), GPos,
      TCVScalar.Create(0, 255, 0), 2, LINE_8, 0);
    imshow(PAnsiChar(AnsiString(WIN_NAME)), Display.Handle);
    Key := waitKey(30);
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
