program DemoFaceDetect5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils,
  Winapi.Windows,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Imgcodecs in '..\..\source\OpenCV5.Imgcodecs.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Highgui in '..\..\source\OpenCV5.Highgui.pas',
  OpenCV5.Objdetect in '..\..\source\OpenCV5.Objdetect.pas';

const
  CV_8UC3 = 16;
  CV_32FC1 = 5;
  IMREAD_COLOR = 1;
  WINDOW_AUTOSIZE = 1;

var
  GShowGui: Boolean = False;
  GOutDir: string = '';

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

function HasCmdSwitch(const Name: string): Boolean;
var
  I: Integer;
  Arg, Switch: string;
begin
  Switch := LowerCase(Name);
  if FindCmdLineSwitch(Switch, True) then
    Exit(True);
  for I := 1 to ParamCount do
  begin
    Arg := LowerCase(ParamStr(I));
    if (Arg = Switch) or (Arg = '-' + Switch) or (Arg = '--' + Switch) or
       (Arg = '/' + Switch) then
      Exit(True);
  end;
  Result := False;
end;

function CmdValue(const Name: string; const Default: string): string;
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
    if SameText(Copy(Arg, 2, Length(Prefix)), Prefix) and (Arg[1] in ['-', '/']) then
      Exit(Copy(Arg, Length(Prefix) + 2, MaxInt));
  end;
end;

procedure ShowImage(const WinName: string; const Mat: TCVMat);
begin
  if not GShowGui then
    Exit;
  imshow(PAnsiChar(AnsiString(WinName)), Mat.Handle);
  waitKey(0);
  destroyWindow(PAnsiChar(AnsiString(WinName)));
end;

procedure RunDemo;
var
  ModelPath, ImagePath, OutPath: string;
  Det: TCVFaceDetectorYN;
  Img, Faces: TCVMat;
  Count, I: Integer;
  Score: Single;
begin
  ModelPath := ResolveFaceDetectorModelPath(CmdValue('model', ''));
  ImagePath := CmdValue('image', 'test.png');

  if not FileExists(ModelPath) then
  begin
    OutLn('Model not found: ' + ModelPath);
    OutLn(FaceDetectorModelMissingHint);
    OutLn('Use --model=path');
    ExitCode := 1;
    Exit;
  end;

  if not FileExists(ImagePath) then
  begin
    OutLn('Image not found: ' + ImagePath);
    OutLn('Use --image=path or place test.png in the working directory.');
    ExitCode := 1;
    Exit;
  end;

  OutLn('Model : ' + ModelPath);
  OutLn('Image : ' + ImagePath);

  Det := TCVFaceDetectorYN.Create(PAnsiChar(AnsiString(ModelPath)), nil,
    TCVSize.Create(320, 320), 0.9, 0.3, 5000);
  if Det.Handle = nil then
  begin
    OutLn('Failed to create FaceDetectorYN (is OpenCV built with DNN?)');
    ExitCode := 1;
    Exit;
  end;

  Img := imread(PAnsiChar(AnsiString(ImagePath)), IMREAD_COLOR);
  if Img.empty then
  begin
    OutLn('Failed to load image.');
    ExitCode := 1;
    Exit;
  end;

  Faces := TCVMat.Create_0(0, 0, CV_32FC1);
  Det.setInputSize(TCVSize.Create(Img.cols, Img.rows));
  Count := Det.detect(Img.Handle, Faces.Handle);

  OutLn(Format('Detected faces: %d', [Count]));
  for I := 0 to Count - 1 do
  begin
    Score := PSingle(Faces.ptr(I, FACE_IDX_SCORE))^;
    OutLn(Format('  #%d score=%.3f bbox=(%.0f, %.0f, %.0f, %.0f)', [
      I + 1, Score,
      PSingle(Faces.ptr(I, FACE_IDX_X))^,
      PSingle(Faces.ptr(I, FACE_IDX_Y))^,
      PSingle(Faces.ptr(I, FACE_IDX_W))^,
      PSingle(Faces.ptr(I, FACE_IDX_H))^]));
  end;

  if Count > 0 then
    drawDetectedFaces(Img.Handle, Faces);

  if GOutDir <> '' then
  begin
    ForceDirectories(GOutDir);
    OutPath := TPath.Combine(GOutDir, 'faces_detected.png');
    if imwrite(PAnsiChar(AnsiString(OutPath)), Img.Handle) then
      OutLn('Saved: ' + OutPath);
  end;

  ShowImage('FaceDetect', Img);
  OutLn('Done.');
end;

begin
  GShowGui := HasCmdSwitch('gui');
  GOutDir := CmdValue('out', 'output');
  try
    RunDemo;
  except
    on E: Exception do
    begin
      OutLn('ERROR: ' + E.ClassName + ': ' + E.Message);
      ExitCode := 1;
    end;
  end;
end.
