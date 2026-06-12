program DemoObjdetect5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Winapi.Windows,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Imgcodecs in '..\..\source\OpenCV5.Imgcodecs.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Highgui in '..\..\source\OpenCV5.Highgui.pas',
  OpenCV5.Objdetect in '..\..\source\OpenCV5.Objdetect.pas';

const
  CV_8UC1 = 0;
  CV_8UC3 = 16;
  CV_32SC1 = 4;
  CV_32FC2 = 13;
  WINDOW_AUTOSIZE = 1;

var
  GShowGui: Boolean = False;
  GOutDir: string = '';
  GFailed: Integer = 0;

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

procedure Section(const Title: string);
begin
  OutLn;
  OutLn('--- ' + Title + ' ---');
end;

procedure Check(const Name: string; Cond: Boolean);
begin
  if Cond then
    OutLn('[OK] ' + Name)
  else
  begin
    Inc(GFailed);
    OutLn('[FAIL] ' + Name);
  end;
end;

function SaveImage(const Mat: TCVMat; const FileName: string): Boolean;
var
  Path: AnsiString;
begin
  Path := AnsiString(TPath.Combine(GOutDir, FileName));
  Result := imwrite(PAnsiChar(Path), Mat.Handle);
  if Result then
    OutLn('  Saved: ' + FileName)
  else
    OutLn('  Failed to save: ' + FileName);
end;

function ToBgr(const Gray: TCVMat): TCVMat;
begin
  Result := TCVMat.Create_1(TCVSize.Create(Gray.cols, Gray.rows), CV_8UC3);
  cvtColor(Gray.Handle, Result.Handle, COLOR_GRAY2BGR, 0, 0);
end;

procedure ShowImage(const WinName: string; const Mat: TCVMat);
var
  Name: AnsiString;
begin
  if not GShowGui then
    Exit;
  if Mat.empty then
  begin
    OutLn('  Skip empty window: ' + WinName);
    Exit;
  end;
  Name := AnsiString(WinName);
  namedWindow(PAnsiChar(Name), WINDOW_AUTOSIZE);
  imshow(PAnsiChar(Name), Mat.Handle);
  waitKey(1);
  OutLn(Format('  Window "%s" - press any key', [WinName]));
  waitKey(0);
  destroyWindow(PAnsiChar(Name));
end;

procedure MakeChessboardImage(const InnerCols, InnerRows, Cell, Border: Integer;
  out Gray: TCVMat; out PatternSize: TCVSize);
var
  W, H, X, Y: Integer;
begin
  PatternSize := TCVSize.Create(InnerCols, InnerRows);
  W := (InnerCols + 1) * Cell + 2 * Border;
  H := (InnerRows + 1) * Cell + 2 * Border;
  Gray := TCVMat.Create_2(H, W, CV_8UC1, TCVScalar.Create(255));
  for Y := 0 to InnerRows do
    for X := 0 to InnerCols do
      if (X + Y) mod 2 = 0 then
        rectangle(Gray.Handle,
          TCVPoint.Create(Border + X * Cell, Border + Y * Cell),
          TCVPoint.Create(Border + (X + 1) * Cell - 1, Border + (Y + 1) * Cell - 1),
          TCVScalar.Create(0), FILLED, LINE_8, 0);
end;

procedure DemoChessboard;
var
  Gray, Corners, View: TCVMat;
  PatternSize: TCVSize;
  Found: Boolean;
  Flags: Integer;
begin
  Section('Chessboard: findChessboardCorners / drawChessboardCorners');

  MakeChessboardImage(9, 6, 40, 40, Gray, PatternSize);
  Corners := TCVMat.Create_0(0, 0, CV_32FC2);
  try
    Check('checkChessboard', checkChessboard(Gray.Handle, PatternSize));
    Flags := CALIB_CB_ADAPTIVE_THRESH + CALIB_CB_NORMALIZE_IMAGE + CALIB_CB_FAST_CHECK;
    Found := findChessboardCorners(Gray.Handle, PatternSize, Corners.Handle, Flags);
    Check('findChessboardCorners found pattern', Found);
    Check('corner count is 54', Corners.rows * Corners.cols = 54);
    OutLn(Format('  Corners: %d x %d', [Corners.rows, Corners.cols]));

    View := ToBgr(Gray);
    try
      drawChessboardCorners(View.Handle, PatternSize, Corners.Handle, Found);
      SaveImage(View, 'demo_obj_chessboard.png');
      ShowImage('Chessboard', View);
    finally
    end;
  finally
  end;
end;

procedure DemoCirclesGrid;
var
  Gray, Centers, View: TCVMat;
  Cols, Rows, Cell, Border, X, Y: Integer;
  PatternSize: TCVSize;
  Found: Boolean;
begin
  Section('Circles grid: findCirclesGrid');

  Cols := 4;
  Rows := 4;
  Cell := 60;
  Border := 50;
  PatternSize := TCVSize.Create(Cols, Rows);
  Gray := TCVMat.Create_2(Border * 2 + Cols * Cell, Border * 2 + Rows * Cell, CV_8UC1,
    TCVScalar.Create(255));
  Centers := TCVMat.Create_0(0, 0, CV_32FC2);
  try
    for Y := 0 to Rows - 1 do
      for X := 0 to Cols - 1 do
        circle(Gray.Handle,
          TCVPoint.Create(Border + X * Cell + Cell div 2, Border + Y * Cell + Cell div 2),
          Cell div 3, TCVScalar.Create(0), FILLED, LINE_8, 0);

    Found := findCirclesGrid(Gray.Handle, PatternSize, Centers.Handle, CALIB_CB_SYMMETRIC_GRID);
    Check('findCirclesGrid found pattern', Found);
    Check('center count is 16', Centers.rows * Centers.cols = 16);
    OutLn(Format('  Centers: %d x %d', [Centers.rows, Centers.cols]));

    View := ToBgr(Gray);
    try
      SaveImage(View, 'demo_obj_circles.png');
      ShowImage('Circles grid', View);
    finally
    end;
  finally
  end;
end;

procedure DemoAruco;
type
  PPoint2f = ^TPoint2f;
  TPoint2f = record
    X, Y: Single;
  end;
var
  Marker, View, Corners, Ids: TCVMat;
  Detector: TCVArucoDetector;
  Count, I, J: Integer;
  IdVal: Integer;
  Pt: PPoint2f;
begin
  Section('ArUco: generateArucoMarker / detectMarkers');

  Marker := TCVMat.Create_0(0, 0, CV_8UC1);
  Corners := TCVMat.Create_0(0, 0, CV_32FC2);
  Ids := TCVMat.Create_0(0, 0, CV_32SC1);
  Detector := TCVArucoDetector.Create(DICT_4X4_50);
  try
    generateArucoMarker(DICT_4X4_50, 0, 200, Marker.Handle);
    Check('generateArucoMarker', not Marker.empty);

    Count := Detector.detectMarkers(Marker.Handle, Corners.Handle, Ids.Handle);
    Check('detectMarkers count = 1', Count = 1);
    if (Count > 0) and (Ids.rows > 0) then
    begin
      IdVal := PInteger(Ids.ptr(0, 0))^;
      OutLn(Format('  Marker id: %d', [IdVal]));
      Check('marker id is 0', IdVal = 0);
    end;

    View := ToBgr(Marker);
    try
      if Count > 0 then
        for I := 0 to Corners.rows - 1 do
          for J := 0 to 3 do
          begin
            Pt := PPoint2f(Corners.ptr(I, J));
            circle(View.Handle, TCVPoint.Create(Round(Pt.X), Round(Pt.Y)),
              5, TCVScalar.Create(0, 0, 255), FILLED, LINE_8, 0);
          end;
      SaveImage(View, 'demo_obj_aruco.png');
      ShowImage('ArUco marker', View);
    finally
    end;
  finally
  end;
end;

procedure DemoQRCode;
var
  QR, View, Points: TCVMat;
  Detector: TCVQRCodeDetector;
  Text, Decoded: string;
  Ok: Boolean;
begin
  Section('QR code: encodeQRCode / detectAndDecode');

  QR := TCVMat.Create_0(0, 0, CV_8UC1);
  Points := TCVMat.Create_0(0, 0, CV_32FC2);
  Detector := TCVQRCodeDetector.Create;
  try
    Text := 'OpenCV 5 Delphi objdetect';
    encodeQRCode(PAnsiChar(AnsiString(Text)), QR.Handle);
    Check('encodeQRCode', not QR.empty);

    Ok := Detector.detectAndDecode(QR.Handle, Points.Handle, Decoded);
    Check('detectAndDecode success', Ok);
    OutLn('  Encoded: ' + Text);
    OutLn('  Decoded: ' + Decoded);
    Check('decoded text matches', SameText(Decoded, Text));

    View := ToBgr(QR);
    try
      SaveImage(View, 'demo_obj_qrcode.png');
      ShowImage('QR code', View);
    finally
    end;
  finally
  end;
end;

procedure DemoBarcode;
var
  Img, View: TCVMat;
  Detector: TCVBarcodeDetector;
  Texts, Types: TStrings;
  Ok: Boolean;
begin
  Section('Barcode: detectAndDecodeWithType');

  Img := TCVMat.Create_2(200, 200, CV_8UC1, TCVScalar.Create(255));
  Detector := TCVBarcodeDetector.Create;
  Texts := TStringList.Create;
  Types := TStringList.Create;
  try
    Ok := Detector.detectAndDecodeWithType(Img.Handle, nil, Texts, Types);
    OutLn(Format('  detectAndDecodeWithType on blank image: %s', [BoolToStr(Ok, True)]));
    OutLn(Format('  Barcodes found: %d', [Texts.Count]));
    Check('blank image returns no barcode', not Ok);

    View := ToBgr(Img);
    try
      SaveImage(View, 'demo_obj_barcode_blank.png');
      ShowImage('Barcode (blank image)', View);
    finally
    end;
  finally
    Types.Free;
    Texts.Free;
  end;
end;

procedure RunDemo;
begin
  OutLn('OpenCV 5.0 objdetect demo');
  OutLn('Output: ' + GOutDir);
  if GShowGui then
    OutLn('GUI mode: images shown with imshow (press a key in each window)')
  else
    OutLn('Use /gui or --gui to show images on screen');

  DemoChessboard;
  DemoCirclesGrid;
  DemoAruco;
  DemoQRCode;
  DemoBarcode;

  if GShowGui then
    destroyAllWindows;

  OutLn;
  if GFailed = 0 then
    OutLn('Demo finished successfully.')
  else
    OutLn(Format('Demo finished with %d failed check(s).', [GFailed]));
end;

begin
  try
    GShowGui := HasCmdSwitch('gui');
    GOutDir := ExtractFilePath(ParamStr(0));
    ForceDirectories(GOutDir);
    RunDemo;
  except
    on E: Exception do
    begin
      OutLn('Error: ' + E.ClassName + ': ' + E.Message);
      ExitCode := 1;
    end;
  end;
  if GFailed > 0 then
    ExitCode := 1;
end.
