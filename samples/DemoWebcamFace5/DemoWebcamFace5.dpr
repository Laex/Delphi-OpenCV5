program DemoWebcamFace5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Winapi.Windows,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Videoio in '..\..\source\OpenCV5.Videoio.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Highgui in '..\..\source\OpenCV5.Highgui.pas',
  OpenCV5.Objdetect in '..\..\source\OpenCV5.Objdetect.pas';

const
  CV_8UC3 = 16;
  CV_32FC1 = 5;
  WINDOW_AUTOSIZE = 1;

  CAP_ANY = 0;
  CAP_DSHOW = 700;
  CAP_MSMF = 1400;

  CAP_PROP_FRAME_WIDTH = 3;
  CAP_PROP_FRAME_HEIGHT = 4;

  WIN_NAME = 'Face Detection Webcam';

procedure OutLn(const S: string = '');
var
  Line: string;
  Written: DWORD;
  Handle: THandle;
  Utf8: TBytes;
begin
  if S = '' then
    Line := sLineBreak
  else
    Line := S + sLineBreak;
  Handle := GetStdHandle(STD_OUTPUT_HANDLE);
  if (Handle <> INVALID_HANDLE_VALUE) and ((GetFileType(Handle) and $FF) = FILE_TYPE_CHAR) then
  begin
    if Length(Line) > 0 then
      WriteConsoleW(Handle, PWideChar(Line), Length(Line), Written, nil);
  end
  else
  begin
    Utf8 := TEncoding.UTF8.GetBytes(Line);
    if Length(Utf8) > 0 then
      WriteFile(Handle, Utf8[0], Length(Utf8), Written, nil);
  end;
end;

function CmdValue(const Name, Default: string): string;
var
  I: Integer;
  Arg, Prefix: string;
begin
  Result := Default;
  Prefix := LowerCase(Name) + '=';
  for I := 1 to ParamCount do
  begin
    Arg := ParamStr(I);
    if SameText(Copy(Arg, 1, Length(Prefix)), Prefix) then
      Exit(Copy(Arg, Length(Prefix) + 1, MaxInt));
    if SameText(Copy(Arg, 2, Length(Prefix)), Prefix) and CharInSet(Arg[1], ['-', '/']) then
      Exit(Copy(Arg, Length(Prefix) + 2, MaxInt));
  end;
end;

function ParseBackend(const Name: string): Integer;
begin
  if SameText(Name, 'dshow') then
    Result := CAP_DSHOW
  else if SameText(Name, 'msmf') then
    Result := CAP_MSMF
  else if SameText(Name, 'any') then
    Result := CAP_ANY
  else
    Result := -1;
end;

function OpenCamera(const Index: Integer; const PreferredBackend: Integer): TCVVideoCapture;
const
  FALLBACK: array[0..2] of Integer = (CAP_DSHOW, CAP_MSMF, CAP_ANY);
var
  I, Backend, Start: Integer;
  BackendName: string;
begin
  if PreferredBackend >= 0 then
  begin
    Result := TCVVideoCapture.Create_2(Index, PreferredBackend);
    if Result.isOpened then
    begin
      BackendName := string(Result.getBackendName);
      OutLn(Format('Camera %d opened (backend id=%d, name=%s)', [Index, PreferredBackend, BackendName]));
      Exit;
    end;
    Result.Release;
  end;

  Start := 0;
  if PreferredBackend = CAP_DSHOW then
    Start := 0
  else if PreferredBackend = CAP_MSMF then
    Start := 1
  else if PreferredBackend = CAP_ANY then
    Start := 2;

  for I := Start to High(FALLBACK) do
  begin
    Backend := FALLBACK[I];
    Result := TCVVideoCapture.Create_2(Index, Backend);
    if Result.isOpened then
    begin
      BackendName := string(Result.getBackendName);
      OutLn(Format('Camera %d opened (backend id=%d, name=%s)', [Index, Backend, BackendName]));
      Exit;
    end;
    Result.Release;
  end;

  raise Exception.CreateFmt('Cannot open camera index %d. Try --camera=N or --backend=dshow|msmf', [Index]);
end;

function LoadFaceDetector(const ModelPath: string; const ScoreThreshold: Single): TCVFaceDetectorYN;
var
  Path: string;
begin
  Path := ResolveFaceDetectorModelPath(ModelPath);
  if not FileExists(Path) then
    raise Exception.Create('Model not found: ' + Path + sLineBreak + FaceDetectorModelMissingHint);

  Result := TCVFaceDetectorYN.Create(PAnsiChar(AnsiString(Path)), nil,
    TCVSize.Create(320, 320), ScoreThreshold, 0.3, 5000);
  if Result.Handle = nil then
    raise Exception.Create('Failed to create FaceDetectorYN (OpenCV must be built with DNN)');
end;

procedure UpdateDetectorInputSize(var Det: TCVFaceDetectorYN; const Frame: TCVMat;
  var LastW, LastH: Integer);
begin
  if (Frame.cols = LastW) and (Frame.rows = LastH) then
    Exit;
  LastW := Frame.cols;
  LastH := Frame.rows;
  Det.setInputSize(TCVSize.Create(LastW, LastH));
end;

procedure DrawOverlay(const Frame: TCVMat; const FaceCount: Integer);
var
  Txt: AnsiString;
begin
  Txt := AnsiString(Format('faces: %d  [ESC/Q exit]', [FaceCount]));
  putText(Frame.Handle, PAnsiChar(Txt), TCVPoint.Create(8, 28),
    FONT_HERSHEY_SIMPLEX, 0.7, TCVScalar.Create(0, 255, 0), 2, LINE_8, False);
end;

procedure RunDemo;
var
  Cap: TCVVideoCapture;
  Det: TCVFaceDetectorYN;
  Frame, Faces: TCVMat;
  ModelPath: string;
  CameraIndex, Width, Height, Key, LastW, LastH, FaceCount, Frames: Integer;
  BackendName: string;
  BackendId: Integer;
  ScoreThreshold: Single;
begin
  ModelPath := ResolveFaceDetectorModelPath(CmdValue('model', ''));
  CameraIndex := StrToIntDef(CmdValue('camera', '0'), 0);
  Width := StrToIntDef(CmdValue('width', '0'), 0);
  Height := StrToIntDef(CmdValue('height', '0'), 0);
  BackendName := LowerCase(CmdValue('backend', ''));
  BackendId := ParseBackend(BackendName);
  ScoreThreshold := StrToFloatDef(CmdValue('score', '0.7'), 0.7);

  OutLn('OpenCV 5.0 Webcam Face Detection');
  OutLn('Options: --model=path  --camera=0  --width=640  --height=480');
  OutLn('         --score=0.7  --backend=dshow|msmf|any');
  OutLn('Press ESC or Q in the video window to exit.');
  OutLn('');

  Det := LoadFaceDetector(ModelPath, ScoreThreshold);
  Cap := OpenCamera(CameraIndex, BackendId);

  if Width > 0 then
    Cap.setProp(CAP_PROP_FRAME_WIDTH, Width);
  if Height > 0 then
    Cap.setProp(CAP_PROP_FRAME_HEIGHT, Height);

  Frame := TCVMat.Create_0(0, 0, CV_8UC3);
  Faces := TCVMat.Create_0(0, 0, CV_32FC1);
  namedWindow(PAnsiChar(AnsiString(WIN_NAME)), WINDOW_AUTOSIZE);

  OutLn(Format('Model : %s', [ModelPath]));
  OutLn(Format('Score threshold: %.2f', [Det.getScoreThreshold]));
  OutLn(Format('Resolution: %.0f x %.0f', [
    Cap.getProp(CAP_PROP_FRAME_WIDTH),
    Cap.getProp(CAP_PROP_FRAME_HEIGHT)]));

  LastW := -1;
  LastH := -1;
  Frames := 0;

  while True do
  begin
    if not Cap.read(Frame) then
    begin
      OutLn('Failed to read frame from camera.');
      Break;
    end;

    UpdateDetectorInputSize(Det, Frame, LastW, LastH);
    FaceCount := Det.detect(Frame.Handle, Faces.Handle);
    if FaceCount > 0 then
      drawDetectedFaces(Frame.Handle, Faces);
    DrawOverlay(Frame, FaceCount);

    imshow(PAnsiChar(AnsiString(WIN_NAME)), Frame.Handle);
    Inc(Frames);

    Key := waitKey(1);
    if Key in [27, Ord('q'), Ord('Q')] then
      Break;
  end;

  OutLn(Format('Frames processed: %d', [Frames]));
  destroyAllWindows;
end;

begin
  try
    RunDemo;
  except
    on E: Exception do
    begin
      OutLn('ERROR: ' + E.Message);
      destroyAllWindows;
      ExitCode := 1;
    end;
  end;
end.
