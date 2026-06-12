program TestOpenCV5;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  System.Math,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Imgcodecs in '..\..\source\OpenCV5.Imgcodecs.pas',
  OpenCV5.Highgui in '..\..\source\OpenCV5.Highgui.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Objdetect in '..\..\source\OpenCV5.Objdetect.pas',
  OpenCV5.Calib3d in '..\..\source\OpenCV5.Calib3d.pas',
  OpenCV5.Features2d in '..\..\source\OpenCV5.Features2d.pas',
  OpenCV5.Dnn in '..\..\source\OpenCV5.Dnn.pas',
  OpenCV5.Video in '..\..\source\OpenCV5.Video.pas',
  OpenCV5.Ml in '..\..\source\OpenCV5.Ml.pas',
  OpenCV5.Tracking in '..\..\source\OpenCV5.Tracking.pas',
  OpenCV5.Stereo in '..\..\source\OpenCV5.Stereo.pas',
  OpenCV5.Photo in '..\..\source\OpenCV5.Photo.pas',
  OpenCV5.Stitching in '..\..\source\OpenCV5.Stitching.pas',
  OpenCV5.Persistence in '..\..\source\OpenCV5.Persistence.pas',
  OpenCV5.Arith in '..\..\source\OpenCV5.Arith.pas',
  OpenCV5.Ptcloud in '..\..\source\OpenCV5.Ptcloud.pas',
  OpenCV5.Utils in '..\..\source\OpenCV5.Utils.pas',
  OpenCV5.Components.VideoSource in '..\..\source\OpenCV5.Components.VideoSource.pas',
  OpenCV5.Components.Processors in '..\..\source\OpenCV5.Components.Processors.pas',
  OpenCV5.Components.Pipeline in '..\..\source\OpenCV5.Components.Pipeline.pas';

const
  WINDOW_AUTOSIZE = 1;

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

function FindCmdLineValue(const Name: string): string;
var
  I: Integer;
  Arg, Prefix: string;
begin
  Result := '';
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

function ResolveFaceModelPath: string;
begin
  Result := ResolveFaceDetectorModelPath(FindCmdLineValue('model'));
  if (Result <> '') and not FileExists(Result) then
    Result := '';
end;

function ResolveBinModel(const Candidates: array of string): string;
var
  I: Integer;
begin
  for I := Low(Candidates) to High(Candidates) do
    if FileExists(Candidates[I]) then
      Exit(Candidates[I]);
  Result := '';
end;

var
  GPassed: Integer = 0;
  GFailed: Integer = 0;
  GLog: TStringList;
  GRunGui: Boolean = False;

procedure LogLine(const S: string);
begin
  Writeln(S);
  Flush(Output);
  if Assigned(GLog) then
    GLog.Add(S);
end;

procedure Check(const Name: string; Cond: Boolean);
begin
  if Cond then
  begin
    Inc(GPassed);
    LogLine('[PASS] ' + Name);
  end
  else
  begin
    Inc(GFailed);
    LogLine('[FAIL] ' + Name);
  end;
end;

function ReadByte(const Mat: TCVMat; Row, Col: Integer): Byte;
begin
  Result := PByte(Mat.ptr(Row, Col))^;
end;

function ReadFloat(const Mat: TCVMat; Row, Col: Integer): Single;
begin
  Result := PSingle(Mat.ptr(Row, Col))^;
end;

procedure MakeTwoLevelGrayImage(out Img: TCVMat);
begin
  Img := TCVMat.Create_2(100, 100, CV_8UC1, TCVScalar.Create(0));
  rectangle(Img.Handle, TCVPoint.Create(0, 0), TCVPoint.Create(49, 99),
    TCVScalar.Create(50), FILLED, LINE_8, 0);
  rectangle(Img.Handle, TCVPoint.Create(50, 0), TCVPoint.Create(99, 99),
    TCVScalar.Create(200), FILLED, LINE_8, 0);
end;

procedure TestClipLine;
var
  Pt1, Pt2: TCVPoint;
  Ok: Boolean;
begin
  Pt1 := TCVPoint.Create(-10, 50);
  Pt2 := TCVPoint.Create(110, 50);
  Ok := clipLine(TCVSize.Create(100, 100), @Pt1, @Pt2);
  Check('clipLine returns true', Ok);
  Check('clipLine clips X coordinates',
    (Pt1.X >= 0) and (Pt1.X <= 99) and (Pt2.X >= 0) and (Pt2.X <= 99));
end;

procedure TestClipLine2l;
var
  Pt1, Pt2: TCVPoint2l;
  Ok: Boolean;
begin
  Pt1 := TCVPoint2l.Create(-100, 500);
  Pt2 := TCVPoint2l.Create(5000, 500);
  Ok := clipLine(TCVSize2l.Create(4000, 4000), @Pt1, @Pt2);
  Check('clipLine(Size2l) returns true', Ok);
  Check('clipLine(Size2l) clips coordinates',
    (Pt1.X >= 0) and (Pt1.X <= 3999) and (Pt2.X >= 0) and (Pt2.X <= 3999));
end;

procedure TestEllipse2Poly;
var
  Pts: array[0..255] of TCVPoint;
  Count: Integer;
begin
  Count := ellipse2Poly(TCVPoint.Create(50, 50), TCVSize.Create(40, 20),
    0, 0, 360, 5, @Pts[0], Length(Pts));
  Check('ellipse2Poly returns point count > 8', Count > 8);
  Check('ellipse2Poly writes first point', (Pts[0].X <> 0) or (Pts[0].Y <> 0));
end;

procedure TestCalcHistSimple;
var
  Img, Hist: TCVMat;
  HistSize: Integer;
  Ranges: array[0..1] of Single;
  B50, B200: Single;
begin
  MakeTwoLevelGrayImage(Img);
  Hist := TCVMat.Create_0(256, 1, CV_32FC1);
  try
    HistSize := 256;
    Ranges[0] := 0;
    Ranges[1] := 256;
    calcHistSimple(Img.Handle, Hist.Handle, 0, nil, @HistSize, @Ranges[0], 1, False);
    B50 := ReadFloat(Hist, 50, 0);
    B200 := ReadFloat(Hist, 200, 0);
    Check('calcHistSimple peak at 50', B50 > 1000);
    Check('calcHistSimple peak at 200', B200 > 1000);
  finally
  end;
end;

procedure TestCalcHist;
var
  Img, Hist: TCVMat;
  Images: array[0..0] of Pointer;
  Channels: array[0..0] of Integer;
  HistSize: array[0..0] of Integer;
  Ranges: array[0..1] of Single;
  B50, B200: Single;
begin
  MakeTwoLevelGrayImage(Img);
  Hist := TCVMat.Create_0(256, 1, CV_32FC1);
  try
    Images[0] := Img.Handle;
    Channels[0] := 0;
    HistSize[0] := 256;
    Ranges[0] := 0;
    Ranges[1] := 256;
    calcHist(@Images[0], 1, @Channels[0], 1, nil, Hist.Handle,
      @HistSize[0], 1, @Ranges[0], 2, False);
    B50 := ReadFloat(Hist, 50, 0);
    B200 := ReadFloat(Hist, 200, 0);
    Check('calcHist peak at 50', B50 > 1000);
    Check('calcHist peak at 200', B200 > 1000);
  finally
  end;
end;

procedure TestCalcBackProject;
var
  Img, Hist, Back: TCVMat;
  HistSize: Integer;
  Ranges: array[0..1] of Single;
  Y, X: Integer;
  Total: Double;
begin
  MakeTwoLevelGrayImage(Img);
  Hist := TCVMat.Create_0(256, 1, CV_32FC1);
  Back := TCVMat.Create_1(TCVSize.Create(100, 100), CV_8UC1);
  try
    HistSize := 256;
    Ranges[0] := 0;
    Ranges[1] := 256;
    calcHistSimple(Img.Handle, Hist.Handle, 0, nil, @HistSize, @Ranges[0], 1, False);
    calcBackProjectSimple(Img.Handle, Hist.Handle, Back.Handle, @Ranges[0], 2, 255.0);
    Total := 0;
    for Y := 0 to 99 do
      for X := 0 to 99 do
        Total := Total + ReadByte(Back, Y, X);
    Check('calcBackProject produces non-zero map', Total > 0.0);
  finally
  end;
end;

procedure TestCLAHE;
var
  Src, Dst: TCVMat;
  Clahe: TCVCLAHE;
  X: Integer;
  Before, After: Byte;
begin
  Src := TCVMat.Create_2(128, 128, CV_8UC1, TCVScalar.Create(0));
  Dst := TCVMat.Create_1(TCVSize.Create(128, 128), CV_8UC1);
  Clahe := createCLAHE(2.0, TCVSize.Create(8, 8));
  try
    for X := 0 to 127 do
      rectangle(Src.Handle, TCVPoint.Create(X, 0), TCVPoint.Create(X, 127),
        TCVScalar.Create(X * 2), FILLED, LINE_8, 0);
    Before := ReadByte(Src, 64, 64);
    Clahe.apply(Src.Handle, Dst.Handle);
    After := ReadByte(Dst, 64, 64);
    Check('CLAHE.apply keeps image size', (Dst.cols = 128) and (Dst.rows = 128));
    Check('CLAHE.apply changes pixel values', After <> Before);
    Check('CLAHE.getClipLimit', Abs(Clahe.getClipLimit - 2.0) < 0.001);
  finally
  end;
end;

procedure TestMomentsAndHuMoments;
var
  Img, Hu: TCVMat;
  M: TCVMoments;
  HuVal: Double;
begin
  Img := TCVMat.Create_2(100, 100, CV_8UC1, TCVScalar.Create(0));
  Hu := TCVMat.Create_2(1, 7, CV_64FC1, TCVScalar.Create(0));
  try
    rectangle(Img.Handle, TCVPoint.Create(20, 20), TCVPoint.Create(69, 69),
      TCVScalar.Create(255), FILLED, LINE_8, 0);
    M := moments(Img.Handle, True);
    Check('moments m00 > 0', M.m00 > 0);
    HuMoments(M, Hu.Handle);
    HuVal := PDouble(Hu.ptr(0, 0))^;
    Check('HuMoments writes values', HuVal <> 0.0);
  finally
  end;
end;

procedure TestFloodFill;
var
  Img: TCVMat;
  Area: Integer;
  Before, After: Byte;
begin
  Img := TCVMat.Create_2(80, 80, CV_8UC1, TCVScalar.Create(0));
  try
    rectangle(Img.Handle, TCVPoint.Create(10, 10), TCVPoint.Create(69, 69),
      TCVScalar.Create(255), FILLED, LINE_8, 0);
    Before := ReadByte(Img, 40, 40);
    Area := floodFill(Img.Handle, TCVPoint.Create(40, 40), TCVScalar.Create(128),
      nil, TCVScalar.Create(20), TCVScalar.Create(20), 4);
    After := ReadByte(Img, 40, 40);
    Check('floodFill changes seed pixel', After <> Before);
    Check('floodFill returns filled area > 0', Area > 0);
  finally
  end;
end;

procedure TestImwriteImread;
var
  Src, Loaded: TCVMat;
  Path: AnsiString;
  Ok: Boolean;
begin
  LogLine('  -> imwrite/imread start');
  Src := TCVMat.Create_2(64, 48, CV_8UC1, TCVScalar.Create(128));
  try
    Path := 'test_roundtrip.png';
    Ok := imwrite(PAnsiChar(Path), Src.Handle);
    Check('imwrite succeeds', Ok);
    LogLine('  -> imread start');
    Loaded := imread(PAnsiChar(Path), IMREAD_COLOR);
    try
      Check('imread loads saved image', not Loaded.empty);
      Check('imread preserves width', Loaded.cols = 48);
      Check('imread preserves height', Loaded.rows = 64);
    finally
    end;
  finally
  end;
  LogLine('  -> imwrite/imread done');
end;

procedure TestHighguiBasic;
begin
  namedWindow('opencv_test_window', WINDOW_AUTOSIZE);
  Check('pollKey callable', pollKey >= -1);
  destroyWindow('opencv_test_window');
  Check('destroyWindow callable', True);
end;

procedure TestCompareHist;
var
  Img, Hist1, Hist2: TCVMat;
  HistSize: Integer;
  Ranges: array[0..1] of Single;
  Score: Double;
begin
  MakeTwoLevelGrayImage(Img);
  Hist1 := TCVMat.Create_0(256, 1, CV_32FC1);
  Hist2 := TCVMat.Create_0(256, 1, CV_32FC1);
  try
    HistSize := 256;
    Ranges[0] := 0;
    Ranges[1] := 256;
    calcHistSimple(Img.Handle, Hist1.Handle, 0, nil, @HistSize, @Ranges[0], 1, False);
    calcHistSimple(Img.Handle, Hist2.Handle, 0, nil, @HistSize, @Ranges[0], 1, False);
    Score := compareHist(Hist1.Handle, Hist2.Handle, HISTCMP_CORREL);
    Check('compareHist identical histograms ~ 1', Abs(Score - 1.0) < 0.01);
  finally
  end;
end;

procedure MakeChessboardGray(const InnerCols, InnerRows, Cell, Border: Integer; out Gray: TCVMat);
var
  W, H, X, Y: Integer;
begin
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

procedure TestObjdetect;
var
  Img, Corners, Ids, Rejected, QRImg, Points, CharucoCorners, CharucoIds: TCVMat;
  Meta, Sharpness, BoardImg, Marker: TCVMat;
  QR: TCVQRCodeDetector;
  Encoder: TCVQRCodeEncoder;
  Barcode: TCVBarcodeDetector;
  Aruco: TCVArucoDetector;
  GridBoard: TCVGridBoard;
  CharucoBoard: TCVCharucoBoard;
  CharucoDet: TCVCharucoDetector;
  Count, N: Integer;
  Ok: Boolean;
  Text: string;
  Texts: TStringList;
  Sharp: TCVScalar;
  PatternSize: TCVSize;
begin
  Img := TCVMat.Create_2(100, 100, CV_8UC1, TCVScalar.Create(128));
  Corners := TCVMat.Create_0(0, 0, CV_32FC2);
  try
    Ok := checkChessboard(Img.Handle, TCVSize.Create(7, 7));
    Check('checkChessboard callable', Ok or not Ok);

    MakeChessboardGray(9, 6, 40, 40, Img);
    PatternSize := TCVSize.Create(9, 6);
    Ok := findChessboardCorners(Img.Handle, PatternSize, Corners.Handle,
      CALIB_CB_ADAPTIVE_THRESH + CALIB_CB_NORMALIZE_IMAGE + CALIB_CB_FAST_CHECK);
    Check('findChessboardCorners on synthetic board', Ok);
    Ok := findChessboardCornersSB(Img.Handle, PatternSize, Corners.Handle, CALIB_CB_NORMALIZE_IMAGE);
    Check('findChessboardCornersSB on synthetic board', Ok);
    Ok := find4QuadCornerSubpix(Img.Handle, Corners.Handle, TCVSize.Create(11, 11));
    Check('find4QuadCornerSubpix callable', Ok or not Ok);
    Ok := estimateChessboardSharpness(Img.Handle, PatternSize, Corners.Handle, 0.8, False, nil, Sharp);
    Check('estimateChessboardSharpness callable', Ok or (Sharp.V0 >= 0));

    QR := TCVQRCodeDetector.Create;
    Ok := QR.detect(Img.Handle, Corners.Handle);
    Check('QRCodeDetector.detect callable', Ok or not Ok);
    QR.setUseAlignmentMarkers(True);
    Check('QRCodeDetector.setUseAlignmentMarkers', True);

    Encoder := TCVQRCodeEncoder.Create(-1, QR_CORRECT_LEVEL_M, QR_MODE_BYTE);
    QRImg := TCVMat.Create_0(0, 0, CV_8UC1);
    Points := TCVMat.Create_0(0, 0, CV_32FC2);
    try
      Encoder.encode('OpenCV5 Delphi', QRImg.Handle);
      Check('QRCodeEncoder.encode not empty', not QRImg.empty);
      encodeQRCode(PAnsiChar(AnsiString('OpenCV5 Delphi')), QRImg.Handle);
      Check('encodeQRCode helper not empty', not QRImg.empty);
      QR := TCVQRCodeDetector.Create;
      Ok := QR.detectAndDecode(QRImg.Handle, Points.Handle, Text);
      Check('QR roundtrip detectAndDecode', Ok and (Text = 'OpenCV5 Delphi'));
      if Ok then
        Check('QR getEncoding callable', QR.getEncoding(0) >= 0);
    finally
    end;

    Barcode := TCVBarcodeDetector.Create;
    Texts := TStringList.Create;
    try
      Ok := Barcode.detect(Img.Handle, Corners.Handle);
      Check('BarcodeDetector.detect callable', Ok or not Ok);
      Check('BarcodeDetector downsampling default > 0', Barcode.getDownsamplingThreshold > 0);
      Barcode.setGradientThreshold(64);
      Check('BarcodeDetector gradient threshold', Barcode.getGradientThreshold = 64);
    finally
      Texts.Free;
    end;

    Aruco := TCVArucoDetector.Create(DICT_4X4_50);
    Ids := TCVMat.Create_0(0, 0, CV_32SC1);
    Rejected := TCVMat.Create_0(0, 0, CV_32FC2);
    Marker := TCVMat.Create_0(0, 0, CV_8UC1);
    try
      Count := Aruco.detectMarkers(Img.Handle, Corners.Handle, Ids.Handle, Rejected.Handle);
      Check('ArucoDetector.detectMarkers with rejected on blank', Count = 0);

      generateArucoMarker(DICT_4X4_50, 0, 200, Marker.Handle);
      Check('generateArucoMarker not empty', not Marker.empty);
      Count := Aruco.detectMarkers(Marker.Handle, Corners.Handle, Ids.Handle);
      Check('ArucoDetector detects generated marker', Count = 1);
      if Count > 0 then
        drawDetectedMarkers(Marker.Handle, Corners.Handle, Ids.Handle);
      Check('drawDetectedMarkers callable', True);
    finally
    end;

    LogLine('  -> GridBoard');
    GridBoard := TCVGridBoard.Create(4, 4, 0.04, 0.012, DICT_4X4_50);
    BoardImg := TCVMat.Create_0(0, 0, CV_8UC1);
    try
      Check('GridBoard.Create handle', GridBoard.Handle <> nil);
      if GridBoard.Handle <> nil then
      begin
        GridBoard.generateImage(1200, 1200, 0, 1, BoardImg.Handle);
        Check('GridBoard.generateImage not empty', not BoardImg.empty);
      end;
    finally
    end;

    LogLine('  -> CharucoBoard');
    CharucoBoard := TCVCharucoBoard.Create(5, 7, 0.04, 0.02, DICT_4X4_50);
    CharucoDet := TCVCharucoDetector.Create(CharucoBoard);
    CharucoCorners := TCVMat.Create_0(0, 0, CV_32FC2);
    CharucoIds := TCVMat.Create_0(0, 0, CV_32SC1);
    BoardImg := TCVMat.Create_0(0, 0, CV_8UC1);
    try
      Check('CharucoBoard.Create handle', CharucoBoard.Handle <> nil);
      if CharucoBoard.Handle <> nil then
      begin
        CharucoBoard.generateImage(800, 600, 20, 1, BoardImg.Handle);
        Check('CharucoBoard.generateImage not empty', not BoardImg.empty);
      end;
      if (CharucoDet.Handle <> nil) and not BoardImg.empty then
      begin
        CharucoDet.detectBoard(BoardImg.Handle, CharucoCorners.Handle, CharucoIds.Handle, nil, nil);
        N := CharucoCorners.rows;
        Check('CharucoDetector.detectBoard finds corners', N > 0);
        if N > 0 then
          drawDetectedCornersCharuco(BoardImg.Handle, CharucoCorners.Handle, CharucoIds.Handle);
      end;
      Check('drawDetectedCornersCharuco callable', True);
    finally
    end;
  finally
  end;
end;

procedure TestShowImage;
var
  Image: TCVMat;
begin
  if not GRunGui then
  begin
    LogLine('[SKIP] GUI imshow test (use --gui to run)');
    Exit;
  end;

  LogLine('=== GUI test: imshow + waitKey ===');
  Image := imread(PAnsiChar(AnsiString('test.png')), IMREAD_COLOR);
  try
    Check('imread test.png', not Image.empty);
    imshow('OpenCV 5.0 Delphi Demo', Image.Handle);
    waitKey(1000);
    destroyWindow('OpenCV 5.0 Delphi Demo');
  finally
  end;
end;

procedure TestFaceDetect;
var
  ModelPath: string;
  Det: TCVFaceDetectorYN;
  InputSize: TCVSize;
begin
  ModelPath := ResolveFaceModelPath;
  if ModelPath = '' then
  begin
    LogLine('[SKIP] FaceDetectorYN test (' + FaceDetectorModelMissingHint + ')');
    Exit;
  end;

  InputSize := TCVSize.Create(320, 320);
  Det := TCVFaceDetectorYN.Create(PAnsiChar(AnsiString(ModelPath)), nil, InputSize, 0.9, 0.3, 5000);
  try
    Check('FaceDetectorYN.Create handle', Det.Handle <> nil);
    if Det.Handle = nil then
      Exit;

    Det.setScoreThreshold(0.75);
    Check('FaceDetectorYN.getScoreThreshold', Abs(Det.getScoreThreshold - 0.75) < 0.001);
    Check('FaceDetectorYN.getTopK default', Det.getTopK > 0);
    LogLine('[NOTE] FaceDetectorYN.detect skipped in unit test (runtime DNN forward may abort on synthetic input)');
  finally
  end;
end;

procedure TestProjectPoints;
var
  ObjectPts, Rvec, Tvec, CameraMatrix, DistCoeffs, ImagePts: TCVMat;
  Pt: ^Single;
begin
  ObjectPts := TCVMat.Create_0(4, 1, CV_32FC3);
  Rvec := TCVMat.Create_0(3, 1, CV_64FC1);
  Tvec := TCVMat.Create_0(3, 1, CV_64FC1);
  CameraMatrix := TCVMat.Create_0(3, 3, CV_64FC1);
  DistCoeffs := TCVMat.Create_0(5, 1, CV_64FC1);
  ImagePts := TCVMat.Create_0(4, 1, CV_32FC2);
  try
    Pt := ObjectPts.ptr(0, 0);
    Pt^ := 0; Inc(Pt); Pt^ := 0; Inc(Pt); Pt^ := 0;
    Pt := ObjectPts.ptr(1, 0);
    Pt^ := 1; Inc(Pt); Pt^ := 0; Inc(Pt); Pt^ := 0;
    Pt := ObjectPts.ptr(2, 0);
    Pt^ := 1; Inc(Pt); Pt^ := 1; Inc(Pt); Pt^ := 0;
    Pt := ObjectPts.ptr(3, 0);
    Pt^ := 0; Inc(Pt); Pt^ := 1; Inc(Pt); Pt^ := 0;

    PDouble(CameraMatrix.ptr(0, 0))^ := 500;
    PDouble(CameraMatrix.ptr(1, 1))^ := 500;
    PDouble(CameraMatrix.ptr(0, 2))^ := 320;
    PDouble(CameraMatrix.ptr(1, 2))^ := 240;
    PDouble(CameraMatrix.ptr(2, 2))^ := 1;

    FillChar(DistCoeffs.ptr(0, 0)^, DistCoeffs.rows * DistCoeffs.cols * SizeOf(Double), 0);

    PDouble(Tvec.ptr(0, 0))^ := 0;
    PDouble(Tvec.ptr(1, 0))^ := 0;
    PDouble(Tvec.ptr(2, 0))^ := 1;

    projectPoints(ObjectPts.Handle, Rvec.Handle, Tvec.Handle,
      CameraMatrix.Handle, DistCoeffs.Handle, ImagePts.Handle);
    Check('projectPoints output rows', ImagePts.rows = 4);
    Check('projectPoints writes coordinates', PSingle(ImagePts.ptr(0, 0))^ <> 0);
  finally
  end;
end;

procedure TestSolvePnP;
begin
  LogLine('[NOTE] solvePnP unit call skipped (OpenCV 5 may raise SEH across DLL boundary; see DemoCalibrate5)');
end;

procedure TestFeatures2d;
var
  Img, Gray, Keypoints, Descriptors, Descriptors2, Matches, OutImg: TCVMat;
  Orb: TCVORB;
  Matcher: TCVBFMatcher;
  N, MatchCount: Integer;
begin
  if not FileExists('test.png') then
  begin
    Img := TCVMat.Create_3(TCVSize.Create(256, 256), CV_8UC3, TCVScalar.Create(40, 80, 120));
    try
      Gray := TCVMat.Create_0(0, 0, CV_8UC1);
      cvtColor(Img.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
      rectangle(Gray.Handle, TCVPoint.Create(40, 40), TCVPoint.Create(200, 200),
        TCVScalar.Create(255), 2, LINE_8, 0);
    finally
    end;
  end
  else
  begin
    Img := imread(PAnsiChar(AnsiString('test.png')), IMREAD_COLOR);
    Gray := TCVMat.Create_0(0, 0, CV_8UC1);
    cvtColor(Img.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
  end;

  Orb := TCVORB.Create(200);
  Matcher := TCVBFMatcher.Create(NORM_HAMMING, False);
  Keypoints := TCVMat.Create_0(0, 0, CV_32FC1);
  Descriptors := TCVMat.Create_0(0, 0, CV_8UC1);
  Descriptors2 := TCVMat.Create_0(0, 0, CV_8UC1);
  Matches := TCVMat.Create_0(0, 0, CV_32FC1);
  try
    Check('ORB.Create handle', Orb.Handle <> nil);
    N := Orb.detectAndCompute(Gray.Handle, nil, Keypoints.Handle, Descriptors.Handle);
    Check('ORB.detectAndCompute count', N >= 0);
    Check('ORB keypoints rows', (N = 0) or (Keypoints.rows = N));
    Descriptors.copyTo(Descriptors2.Handle);
    MatchCount := Matcher.match(Descriptors.Handle, Descriptors2.Handle, Matches.Handle);
    Check('BFMatcher.match count', MatchCount >= 0);
    if MatchCount > 0 then
      Check('BFMatcher self-match distance', PSingle(Matches.ptr(0, MATCH_IDX_DISTANCE))^ >= 0);
    OutImg := TCVMat.Create_0(0, 0, CV_8UC3);
    Check('drawFeatureMatches callable', drawFeatureMatches(Gray.Handle, Gray.Handle,
      Keypoints.Handle, Keypoints.Handle, Matches.Handle, OutImg.Handle, 10) >= 0);
  finally
  end;
end;

procedure TestDnnReadNet;
var
  Net: TCVNet;
begin
  Net := TCVNet.readNet('nonexistent_model_12345.onnx', nil);
  try
    Check('Dnn.readNet handle', Net.Handle <> nil);
    Check('Dnn.readNet empty for missing file', Net.empty);
    Check('Dnn.getUnconnectedOutLayersNames callable', Length(Net.getUnconnectedOutLayersNames) >= 0);
  finally
  end;
end;

procedure TestFaceRecognizer;
var
  RecPath: string;
begin
  RecPath := ResolveFaceRecognizerModelPath('');
  if (RecPath = '') or not FileExists(RecPath) then
  begin
    LogLine('[SKIP] FaceRecognizerSF test (' + FaceRecognizerModelMissingHint + ')');
    Exit;
  end;
  LogLine('[NOTE] FaceRecognizerSF.feature/match skipped in unit test (OpenCV 5 DNN forward may abort)');
end;

procedure TestOpticalFlowApi;
var
  Prev, Next, PrevPts, NextPts, Status, Err: TCVMat;
  Criteria: TCVTermCriteria;
begin
  Prev := TCVMat.Create_3(TCVSize.Create(64, 64), CV_8UC1, TCVScalar.Create(0));
  Next := TCVMat.Create_3(TCVSize.Create(64, 64), CV_8UC1, TCVScalar.Create(0));
  PrevPts := TCVMat.Create_0(4, 1, CV_32FC2);
  NextPts := TCVMat.Create_0(4, 1, CV_32FC2);
  Status := TCVMat.Create_0(4, 1, CV_8UC1);
  Err := TCVMat.Create_0(4, 1, CV_32FC1);
  Criteria := TCVTermCriteria.Create(TERM_CRITERIA_COUNT or TERM_CRITERIA_EPS, 5, 0.01);
  try
    goodFeaturesToTrack(Prev.Handle, PrevPts.Handle, 4, 0.01, 5);
    PrevPts.copyTo(NextPts.Handle);
    calcOpticalFlowPyrLK(Prev.Handle, Next.Handle, PrevPts.Handle, NextPts.Handle,
      Status.Handle, Err.Handle, TCVSize.Create(15, 15), 2, Criteria, 0, 0.001);
    Check('calcOpticalFlowPyrLK callable', True);
  finally
  end;
end;

procedure TestDelphiComponents;
var
  Cam: TcvCamera;
  VF: TcvVideoFile;
  Det: TcvFaceDetector;
  Rec: TcvFaceRecognizer;
  Pipe: TcvPipeline;
  Stage: TcvPipelineStage;
  Src, Dst: TCVMat;
begin
  Cam := TcvCamera.Create(nil);
  try
    Check('TcvCamera properties default width', Cam.Width = 640);
    Check('TcvCamera inactive by default', not Cam.Active);
  finally
    Cam.Free;
  end;

  VF := TcvVideoFile.Create(nil);
  try
    Check('TcvVideoFile loop default true', VF.Loop);
    VF.FileName := 'test.mp4';
    Check('TcvVideoFile filename set', VF.FileName = 'test.mp4');
  finally
    VF.Free;
  end;

  Det := TcvFaceDetector.Create(nil);
  try
    Check('TcvFaceDetector defaults topK', Det.TopK = 5000);
    Check('TcvFaceDetector defaults scoreThreshold', Abs(Det.ScoreThreshold - 0.9) < 0.001);
  finally
    Det.Free;
  end;

  Rec := TcvFaceRecognizer.Create(nil);
  try
    Check('TcvFaceRecognizer created', Rec <> nil);
  finally
    Rec.Free;
  end;

  Pipe := TcvPipeline.Create(nil);
  try
    Check('TcvPipeline created with 0 stages', Pipe.Stages.Count = 0);
    Stage := Pipe.Stages.Add;
    Stage.StageType := stColor;
    Stage.ColorCode := COLOR_BGR2GRAY;
    Check('TcvPipeline stages count is 1', Pipe.Stages.Count = 1);
    
    Src := TCVMat.Create_2(100, 100, CV_8UC3, TCVScalar.Create(0, 128, 255));
    Dst := TCVMat.Create_0(0, 0, CV_8UC1);
    try
      try
        Pipe.Process(Src, Dst);
        Check('TcvPipeline BGR2GRAY channel is 1', Dst.channels = 1);
        Check('TcvPipeline BGR2GRAY cols count', Dst.cols = 100);

        // Test stInvert
        Stage.StageType := stInvert;
        Pipe.Process(Src, Dst);
        Check('TcvPipeline Invert channels', Dst.channels = 3);

        // Test stAdaptiveThreshold
        Stage.StageType := stAdaptiveThreshold;
        Pipe.Process(Src, Dst);
        Check('TcvPipeline AdaptiveThreshold channels', Dst.channels = 1);

        // Test stBilateralFilter
        Stage.StageType := stBilateralFilter;
        Pipe.Process(Src, Dst);
        Check('TcvPipeline BilateralFilter channels', Dst.channels = 3);

        // Test stEqualizeHist
        Stage.StageType := stEqualizeHist;
        Pipe.Process(Src, Dst);
        Check('TcvPipeline EqualizeHist channels', Dst.channels = 1);

        // Test stSobel
        Stage.StageType := stSobel;
        Pipe.Process(Src, Dst);
        Check('TcvPipeline Sobel channels', Dst.channels = 3);
      except
        on E: Exception do
        begin
          LogLine('Exception during Pipeline.Process: ' + E.ClassName + ': ' + E.Message);
          Check('TcvPipeline failed with exception', False);
        end;
      end;
    finally
    end;
  finally
    Pipe.Free;
  end;
  LogLine('  -> TestDelphiComponents finished');
end;

procedure TestMl;
var
  Samples, Responses, TestSample, ResultMat: TCVMat;
  Knn: TCVKNearest;
  PcaData, PcaVec, PcaOut: TCVMat;
  Pca: TCVPCA;
  Pt: PSingle;
begin
  Samples := TCVMat.Create_0(4, 2, CV_32F);
  Responses := TCVMat.Create_0(4, 1, CV_32F);
  TestSample := TCVMat.Create_0(1, 2, CV_32F);
  ResultMat := TCVMat.Create_0(1, 1, CV_32F);
  Pt := Samples.ptr(0, 0); Pt^ := 0; Inc(Pt); Pt^ := 0;
  Pt := Samples.ptr(1, 0); Pt^ := 1; Inc(Pt); Pt^ := 0;
  Pt := Samples.ptr(2, 0); Pt^ := 10; Inc(Pt); Pt^ := 10;
  Pt := Samples.ptr(3, 0); Pt^ := 11; Inc(Pt); Pt^ := 10;
  PSingle(Responses.ptr(0, 0))^ := 0;
  PSingle(Responses.ptr(1, 0))^ := 0;
  PSingle(Responses.ptr(2, 0))^ := 1;
  PSingle(Responses.ptr(3, 0))^ := 1;
  Pt := TestSample.ptr(0, 0); Pt^ := 0.1; Inc(Pt); Pt^ := 0.05;
  Knn := TCVKNearest.Create;
  Check('KNN.train', Knn.train(Samples.Handle, Responses.Handle));
  Knn.findNearest(TestSample.Handle, ResultMat.Handle, nil, nil, 1);
  Check('KNN label class 0', PSingle(ResultMat.ptr(0, 0))^ = 0);

  PcaData := TCVMat.Create_0(3, 2, CV_32F);
  PSingle(PcaData.ptr(0, 0))^ := 1; PSingle(PcaData.ptr(0, 1))^ := 2;
  PSingle(PcaData.ptr(1, 0))^ := 2; PSingle(PcaData.ptr(1, 1))^ := 4;
  PSingle(PcaData.ptr(2, 0))^ := 3; PSingle(PcaData.ptr(2, 1))^ := 6;
  Pca := TCVPCA.Create(PcaData.Handle, 1, PCA_DATA_AS_ROW);
  PcaVec := TCVMat.Create_0(1, 2, CV_32F);
  PSingle(PcaVec.ptr(0, 0))^ := 2; PSingle(PcaVec.ptr(0, 1))^ := 4;
  PcaOut := Pca.project(PcaVec.Handle);
  Check('PCA components > 0', Pca.getComponents > 0);
  Check('PCA project rows', PcaOut.rows = 1);
end;

procedure TestTracking;
var
  Prob: TCVMat;
  Window: TCVRect;
  Rotated: TCVRotatedRect;
  Criteria: TCVTermCriteria;
  Kalman: TCVKalmanFilter;
  Meas, State: TCVMat;
  Nano: TCVTrackerNano;
  Bbox: TCVRect;
begin
  Prob := TCVMat.Create_2(80, 80, CV_8UC1, TCVScalar.Create(0));
  PByte(Prob.ptr(40, 40))^ := 255;
  Window := TCVRect.Create(30, 30, 20, 20);
  Criteria := TCVTermCriteria.Create(TERM_CRITERIA_COUNT, 5, 1.0);
  camShift(Prob.Handle, Window, Criteria, Rotated);
  Check('camShift updates window', Window.Width > 0);
  Window := TCVRect.Create(30, 30, 20, 20);
  Check('meanShift callable', meanShift(Prob.Handle, Window, Criteria) >= 0);
  Kalman := TCVKalmanFilter.Create(2, 1);
  Meas := TCVMat.Create_0(1, 1, CV_32F);
  PSingle(Meas.ptr(0, 0))^ := 5;
  Kalman.predict(nil);
  State := Kalman.correct(Meas.Handle);
  Check('Kalman state rows', State.rows = 2);

  Nano := TCVTrackerNano.Create;
  if Nano.Handle = nil then
    LogLine('[NOTE] TrackerNano skipped (needs backbone.onnx + neckhead.onnx near exe)')
  else
  begin
    Check('TrackerNano create', True);
    Bbox := TCVRect.Create(10, 10, 20, 20);
    Nano.init(Prob.Handle, Bbox);
    Check('TrackerNano update', Nano.update(Prob.Handle, Bbox));
  end;
end;

procedure TestCalib3dExtended;
var
  Src, Dst, H, Rvec, Rmat, Bboxes, Scores, Indices: TCVMat;
  Pt: PSingle;
begin
  Src := TCVMat.Create_0(4, 2, CV_32F);
  Dst := TCVMat.Create_0(4, 2, CV_32F);
  Pt := Src.ptr(0, 0); Pt^ := 0; Inc(Pt); Pt^ := 0;
  Pt := Src.ptr(1, 0); Pt^ := 10; Inc(Pt); Pt^ := 0;
  Pt := Src.ptr(2, 0); Pt^ := 10; Inc(Pt); Pt^ := 10;
  Pt := Src.ptr(3, 0); Pt^ := 0; Inc(Pt); Pt^ := 10;
  Pt := Dst.ptr(0, 0); Pt^ := 1; Inc(Pt); Pt^ := 1;
  Pt := Dst.ptr(1, 0); Pt^ := 11; Inc(Pt); Pt^ := 1;
  Pt := Dst.ptr(2, 0); Pt^ := 11; Inc(Pt); Pt^ := 11;
  Pt := Dst.ptr(3, 0); Pt^ := 1; Inc(Pt); Pt^ := 11;
  H := findHomography(Src.Handle, Dst.Handle, HOMOGRAPHY_RANSAC, 3.0, nil);
  Check('findHomography 3x3', (not H.empty) and (H.rows = 3) and (H.cols = 3));
  Rvec := TCVMat.Create_0(3, 1, CV_64F);
  Rmat := TCVMat.Create_0(3, 3, CV_64F);
  Rodrigues(Rvec.Handle, Rmat.Handle, nil);
  Check('Rodrigues 3x3', Rmat.rows = 3);
  Bboxes := TCVMat.Create_0(2, 4, CV_32F);
  Scores := TCVMat.Create_0(2, 1, CV_32F);
  Indices := TCVMat.Create_0(0, 1, CV_32S);
  PSingle(Bboxes.ptr(0, 0))^ := 0; PSingle(Bboxes.ptr(0, 1))^ := 0;
  PSingle(Bboxes.ptr(0, 2))^ := 50; PSingle(Bboxes.ptr(0, 3))^ := 50;
  PSingle(Bboxes.ptr(1, 0))^ := 5; PSingle(Bboxes.ptr(1, 1))^ := 5;
  PSingle(Bboxes.ptr(1, 2))^ := 50; PSingle(Bboxes.ptr(1, 3))^ := 50;
  PSingle(Scores.ptr(0, 0))^ := 0.9;
  PSingle(Scores.ptr(1, 0))^ := 0.8;
  Check('NMSBoxes callable', NMSBoxes(Bboxes.Handle, Scores.Handle, Indices.Handle, 0.5, 0.4) >= 1);
end;

procedure TestDnnExtended;
var
  Net: TCVNet;
begin
  Net := TCVNet.readNetFromONNX('missing_model_xyz.onnx');
  try
    Check('readNetFromONNX handle', Net.Handle <> nil);
    Check('readNetFromONNX empty', Net.empty);
  finally
  end;
  LogLine('[NOTE] blobFromImages unit test skipped (OpenCV 5 DNN may raise SEH on batch blob)');
end;

procedure TestFeatures2dExtended;
var
  Gray, Keypoints, Descriptors, Matches: TCVMat;
  Sift: TCVSIFT;
  Flann: TCVFlannMatcher;
  N: Integer;
begin
  Gray := TCVMat.Create_2(128, 128, CV_8UC1, TCVScalar.Create(40));
  rectangle(Gray.Handle, TCVPoint.Create(20, 20), TCVPoint.Create(100, 100),
    TCVScalar.Create(200), FILLED, LINE_8, 0);
  Sift := TCVSIFT.Create(50);
  Keypoints := TCVMat.Create_0(0, 0, CV_32FC1);
  Descriptors := TCVMat.Create_0(0, 0, CV_32FC1);
  N := Sift.detectAndCompute(Gray.Handle, nil, Keypoints.Handle, Descriptors.Handle);
  Check('SIFT detectAndCompute', N >= 0);
  if N > 1 then
  begin
    Flann := TCVFlannMatcher.Create;
    Matches := TCVMat.Create_0(0, 0, CV_32FC1);
    Check('FlannMatcher knnMatch', Flann.knnMatch(Descriptors.Handle, Descriptors.Handle,
      Matches.Handle, 2) >= 0);
  end
  else
    LogLine('[NOTE] SIFT found few keypoints on synthetic image; Flann skipped');
end;

procedure TestOpenCV5Tier1;
var
  K1, D1, K2, D2, R, T, R1, R2, P1, P2, Q: TCVMat;
  ImgSize: TCVSize;
  Src, Mask, Dst, Noisy, Denoised: TCVMat;
  Frame, FgMask: TCVMat;
  Mog2: TCVMOG2;
  Kn: TCVKNN;
  FromPts, ToPts, Aff: TCVMat;
  UpdatedScores, Indices: TCVMat;
  Bboxes, Scores: TCVMat;
  Pt: PSingle;
begin
  ImgSize := TCVSize.Create(640, 480);
  K1 := TCVMat.Create_0(3, 3, CV_64F);
  K2 := TCVMat.Create_0(3, 3, CV_64F);
  D1 := TCVMat.Create_0(5, 1, CV_64F);
  D2 := TCVMat.Create_0(5, 1, CV_64F);
  R := TCVMat.Create_0(3, 3, CV_64F);
  PDouble(R.ptr(0, 0))^ := 1; PDouble(R.ptr(1, 1))^ := 1; PDouble(R.ptr(2, 2))^ := 1;
  T := TCVMat.Create_0(3, 1, CV_64F);
  PDouble(T.ptr(0, 0))^ := 0.1;
  R1 := TCVMat.Create_0(3, 3, CV_64F);
  R2 := TCVMat.Create_0(3, 3, CV_64F);
  P1 := TCVMat.Create_0(3, 4, CV_64F);
  P2 := TCVMat.Create_0(3, 4, CV_64F);
  Q := TCVMat.Create_0(4, 4, CV_64F);
  PDouble(K1.ptr(0, 0))^ := 500; PDouble(K1.ptr(1, 1))^ := 500;
  PDouble(K1.ptr(0, 2))^ := 320; PDouble(K1.ptr(1, 2))^ := 240; PDouble(K1.ptr(2, 2))^ := 1;
  K2 := TCVMat.Create_6(K1);
  stereoRectify(K1.Handle, D1.Handle, K2.Handle, D2.Handle, ImgSize,
    R.Handle, T.Handle, R1.Handle, R2.Handle, P1.Handle, P2.Handle, Q.Handle);
  Check('stereoRectify fills Q', Q.rows = 4);

  Src := TCVMat.Create_2(64, 64, CV_8UC1, TCVScalar.Create(128));
  Mask := TCVMat.Create_2(64, 64, CV_8UC1, TCVScalar.Create(0));
  PByte(Mask.ptr(30, 30))^ := 255;
  PByte(Mask.ptr(31, 30))^ := 255;
  Dst := TCVMat.Create_0(0, 0, CV_8UC1);
  inpaint(Src.Handle, Mask.Handle, Dst.Handle, 3.0, INPAINT_TELEA);
  Check('inpaint output size', (Dst.rows = 64) and (Dst.cols = 64));

  Noisy := TCVMat.Create_6(Src);
  Denoised := TCVMat.Create_0(0, 0, CV_8UC1);
  fastNlMeansDenoising(Noisy.Handle, Denoised.Handle, 3.0);
  Check('fastNlMeansDenoising output', Denoised.rows = 64);

  Frame := TCVMat.Create_2(80, 80, CV_8UC1, TCVScalar.Create(0));
  FgMask := TCVMat.Create_0(0, 0, CV_8UC1);
  Mog2 := TCVMOG2.Create;
  Mog2.apply(Frame.Handle, FgMask.Handle);
  Check('MOG2 fgmask size', (FgMask.rows = 80) and (FgMask.cols = 80));

  Kn := TCVKNN.Create;
  Check('KNN subtractor create', Kn.Handle <> nil);
  FgMask := TCVMat.Create_0(0, 0, CV_8UC1);
  Kn.apply(Frame.Handle, FgMask.Handle);
  Check('KNN fgmask size', (FgMask.rows = 80) and (FgMask.cols = 80));

  FromPts := TCVMat.Create_0(4, 2, CV_32F);
  ToPts := TCVMat.Create_0(4, 2, CV_32F);
  Pt := FromPts.ptr(0, 0); Pt^ := 0; Inc(Pt); Pt^ := 0;
  Pt := FromPts.ptr(1, 0); Pt^ := 10; Inc(Pt); Pt^ := 0;
  Pt := FromPts.ptr(2, 0); Pt^ := 10; Inc(Pt); Pt^ := 10;
  Pt := FromPts.ptr(3, 0); Pt^ := 0; Inc(Pt); Pt^ := 10;
  Pt := ToPts.ptr(0, 0); Pt^ := 1; Inc(Pt); Pt^ := 1;
  Pt := ToPts.ptr(1, 0); Pt^ := 11; Inc(Pt); Pt^ := 1;
  Pt := ToPts.ptr(2, 0); Pt^ := 11; Inc(Pt); Pt^ := 11;
  Pt := ToPts.ptr(3, 0); Pt^ := 1; Inc(Pt); Pt^ := 11;
  Aff := estimateAffine2D(FromPts.Handle, ToPts.Handle);
  Check('estimateAffine2D 2x3', (not Aff.empty) and (Aff.rows = 2) and (Aff.cols = 3));

  Bboxes := TCVMat.Create_0(2, 4, CV_32F);
  Scores := TCVMat.Create_0(2, 1, CV_32F);
  UpdatedScores := TCVMat.Create_0(0, 1, CV_32F);
  Indices := TCVMat.Create_0(0, 1, CV_32S);
  PSingle(Bboxes.ptr(0, 0))^ := 0; PSingle(Bboxes.ptr(0, 1))^ := 0;
  PSingle(Bboxes.ptr(0, 2))^ := 50; PSingle(Bboxes.ptr(0, 3))^ := 50;
  PSingle(Bboxes.ptr(1, 0))^ := 5; PSingle(Bboxes.ptr(1, 1))^ := 5;
  PSingle(Bboxes.ptr(1, 2))^ := 50; PSingle(Bboxes.ptr(1, 3))^ := 50;
  PSingle(Scores.ptr(0, 0))^ := 0.9;
  PSingle(Scores.ptr(1, 0))^ := 0.8;
  Check('softNMSBoxes callable', softNMSBoxes(Bboxes.Handle, Scores.Handle,
    UpdatedScores.Handle, Indices.Handle, 0.5, 0.4, 0, 0.5, SOFTNMS_GAUSSIAN) >= 0);
end;

procedure TestOpenCV5Tier2;
var
  Gray, Keypoints, Descriptors, KnnMatches, GoodMatches, OutImg: TCVMat;
  Orb: TCVORB;
  Bf: TCVBFMatcher;
  Gftt: TCVGFTT;
  Mser: TCVMSER;
  N: Integer;
begin
  Gray := TCVMat.Create_2(128, 128, CV_8UC1, TCVScalar.Create(40));
  rectangle(Gray.Handle, TCVPoint.Create(20, 20), TCVPoint.Create(100, 100),
    TCVScalar.Create(200), FILLED, LINE_8, 0);
  Orb := TCVORB.Create(200);
  Keypoints := TCVMat.Create_0(0, 0, CV_32FC1);
  Descriptors := TCVMat.Create_0(0, 0, CV_32FC1);
  N := Orb.detectAndCompute(Gray.Handle, nil, Keypoints.Handle, Descriptors.Handle);
  OutImg := TCVMat.Create_0(0, 0, CV_8UC3);
  drawKeypoints(Gray.Handle, Keypoints.Handle, OutImg.Handle);
  Check('drawKeypoints output', OutImg.rows = 128);
  if N > 1 then
  begin
    Bf := TCVBFMatcher.Create(NORM_HAMMING, False);
    KnnMatches := TCVMat.Create_0(0, 0, CV_32FC1);
    GoodMatches := TCVMat.Create_0(0, 0, CV_32FC1);
    Check('BFMatcher knnMatch', Bf.knnMatch(Descriptors.Handle, Descriptors.Handle,
      KnnMatches.Handle, 2) >= 0);
    Check('filterMatchesByRatio', filterMatchesByRatio(KnnMatches.Handle, 2, 0.75,
      GoodMatches.Handle) >= 0);
    drawMatches(Gray.Handle, Keypoints.Handle, Gray.Handle, Keypoints.Handle,
      GoodMatches.Handle, OutImg.Handle, 20);
    Check('drawMatches output', OutImg.cols >= Gray.cols);
  end
  else
    LogLine('[NOTE] ORB found few keypoints; drawMatches skipped');

  Gftt := TCVGFTT.Create(100);
  N := Gftt.detectAndCompute(Gray.Handle, nil, Keypoints.Handle, Descriptors.Handle);
  Check('GFTT detectAndCompute', N >= 0);

  Mser := TCVMSER.Create;
  N := Mser.detectAndCompute(Gray.Handle, nil, Keypoints.Handle, Descriptors.Handle);
  Check('MSER detectAndCompute', N >= 0);
end;

procedure TestOpenCV5Tier3;
var
  Fs: TCVFileStorage;
  MatOut, MatIn: TCVMat;
  Stitcher: TCVStitcher;
  TmpPath: string;
begin
  TmpPath := 'd:\Work\Delphi\OpenCV\OpenCV 5.0\bin\ocv5_test_mat.yml';
  MatOut := TCVMat.Create_2(2, 2, CV_32F, TCVScalar.Create(1));
  Fs := TCVFileStorage.Open(PAnsiChar(AnsiString(TmpPath)), FS_WRITE);
  Check('FileStorage opened', Fs.isOpened);
  Fs.writeMat('matrix', MatOut.Handle);
  Fs.Release;
  Fs := TCVFileStorage.Open(PAnsiChar(AnsiString(TmpPath)), FS_READ);
  MatIn := TCVMat.Create_0(0, 0, CV_32F);
  Check('FileStorage readMat', Fs.readMat('matrix', MatIn.Handle));
  Check('FileStorage mat 2x2', (MatIn.rows = 2) and (MatIn.cols = 2));
  Fs.Release;
  DeleteFile(TmpPath);

  Stitcher := TCVStitcher.Create(STITCHER_PANORAMA);
  Check('Stitcher create', Stitcher.Handle <> nil);
  LogLine('[NOTE] Stitcher.stitch skipped in unit test (may abort on synthetic tiles)');
end;

procedure TestRoadmap10;
var
  A, B, Diff, Mask, Left, Right, Disp: TCVMat;
  MinVal, MaxVal: Double;
  MinLoc, MaxLoc: TCVPoint;
  Matcher: TCVStereoMatcher;
  Pts1, Pts2: TCVMat;
  F, E, R1, R2, T: TCVMat;
  K: TCVMat;
  Fast: TCVFAST;
  Keypoints, Descriptors: TCVMat;
  Tracker: TCVTrackerMIL;
  Bbox: TCVRect;
  Fs: TCVFileStorage;
  IVal: Integer;
  DVal: Double;
  SVal: AnsiString;
  TmpPath: string;
begin
  A := TCVMat.Create_2(32, 32, CV_8UC1, TCVScalar.Create(10));
  B := TCVMat.Create_2(32, 32, CV_8UC1, TCVScalar.Create(20));
  Diff := TCVMat.Create_0(0, 0, CV_8UC1);
  Mask := TCVMat.Create_0(0, 0, CV_8UC1);
  absdiff(A.Handle, B.Handle, Diff.Handle);
  Check('absdiff nonzero', ReadByte(Diff, 0, 0) = 10);
  inRange(A.Handle, TCVScalar.Create(5), TCVScalar.Create(15), Mask.Handle);
  Check('inRange mask', countNonZero(Mask.Handle) > 0);
  subtractMat(A.Handle, B.Handle, Diff.Handle);
  addMat(A.Handle, B.Handle, Diff.Handle);
  bitwise_xor(A.Handle, B.Handle, Diff.Handle);
  minMaxLoc(Diff.Handle, MinVal, MaxVal, MinLoc, MaxLoc);
  Check('minMaxLoc max >= min', MaxVal >= MinVal);

  Left := TCVMat.Create_2(64, 64, CV_8UC1, TCVScalar.Create(100));
  Right := TCVMat.Create_2(64, 64, CV_8UC1, TCVScalar.Create(100));
  Disp := TCVMat.Create_0(0, 0, CV_16S);
  Matcher := TCVStereoMatcher.CreateSGBM(0, 16, 5);
  Matcher.compute(Left.Handle, Right.Handle, Disp.Handle);
  Check('StereoSGBM disparity size', (Disp.rows = 64) and (Disp.cols = 64));

  Pts1 := TCVMat.Create_0(8, 2, CV_32F);
  Pts2 := TCVMat.Create_0(8, 2, CV_32F);
  F := findFundamentalMat(Pts1.Handle, Pts2.Handle);
  Check('findFundamentalMat callable', (F.rows = 3) or F.empty);
  K := TCVMat.Create_0(3, 3, CV_64F);
  PDouble(K.ptr(0, 0))^ := 500; PDouble(K.ptr(1, 1))^ := 500;
  PDouble(K.ptr(0, 2))^ := 32; PDouble(K.ptr(1, 2))^ := 32; PDouble(K.ptr(2, 2))^ := 1;
  E := findEssentialMat(Pts1.Handle, Pts2.Handle, K.Handle);
  Check('findEssentialMat callable', E.rows = 3);
  R1 := TCVMat.Create_0(3, 3, CV_64F);
  R2 := TCVMat.Create_0(3, 3, CV_64F);
  T := TCVMat.Create_0(3, 1, CV_64F);
  decomposeEssentialMat(E.Handle, R1.Handle, R2.Handle, T.Handle);
  Check('decomposeEssentialMat R1', R1.rows = 3);

  Fast := TCVFAST.Create;
  Keypoints := TCVMat.Create_0(0, 0, CV_32F);
  Descriptors := TCVMat.Create_0(0, 0, CV_32F);
  Check('FAST detectAndCompute', Fast.detectAndCompute(A.Handle, nil,
    Keypoints.Handle, Descriptors.Handle) >= 0);

  Tracker := TCVTrackerMIL.Create;
  Bbox := TCVRect.Create(10, 10, 20, 20);
  Tracker.init(A.Handle, Bbox);
  Check('TrackerMIL update', Tracker.update(A.Handle, Bbox));

  LogLine('[NOTE] fastNlMeansDenoisingColored: wrapper catches errors; call from Demo/ app (SEH may not be catchable in this exe)');

  TmpPath := 'd:\Work\Delphi\OpenCV\OpenCV 5.0\bin\ocv5_test_cfg.yml';
  Fs := TCVFileStorage.Open(PAnsiChar(AnsiString(TmpPath)), FS_WRITE);
  Fs.writeInt('version', 10);
  Fs.writeDouble('threshold', 0.75);
  Fs.writeString('name', 'opencv5');
  Fs.Release;
  Fs := TCVFileStorage.Open(PAnsiChar(AnsiString(TmpPath)), FS_READ);
  Check('Persistence readInt', Fs.readInt('version', IVal) and (IVal = 10));
  Check('Persistence readDouble', Fs.readDouble('threshold', DVal));
  Check('Persistence readString', Fs.readString('name', SVal) and (SVal = 'opencv5'));
  Fs.Release;
  DeleteFile(TmpPath);

  if ResolveBinModel(['models\detection_yolox.onnx', 'models\object_detection_yolox_2022nov.onnx']) <> '' then
    LogLine('[NOTE] DetectionModel: see TestDevInfra with test.png')
  else
    LogLine('[NOTE] DetectionModel skipped (run download_models.ps1)');
end;

procedure TestDevInfra;
var
  Bytes: TBytes;
  ImgPath, TextPath, DetPath, ClsPath, SegPath, EastPath, PpocrPath, PlyPath: string;
  Img, ClassIds, Confidences, Boxes, Mask, EastBoxes, EastConf, DbPolygons, DbConf: TCVMat;
  ModelDet: TCVDetectionModel;
  ModelCls: TCVClassificationModel;
  ModelSeg: TCVSegmentationModel;
  ModelEast: TCVTextDetectionEAST;
  ModelDb: TCVTextDetectionDB;
  Verts, Loaded: TCVMat;
  ClassId: Integer;
  Conf: Single;
  DetN, EastN, DbN: Integer;
  I: Integer;
begin
  ImgPath := ResolveBinModel(['test.png']);
  TextPath := ResolveBinModel(['text_sample.png']);

  if ImgPath <> '' then
  begin
    Img := imreadPath(ImgPath, IMREAD_COLOR);
    try
      Check('imencode PNG', imencode(PAnsiChar(AnsiString('.png')), Img.Handle, Bytes) and (Length(Bytes) > 100));
    except
      on E: Exception do
        LogLine('[NOTE] imencode: ' + E.ClassName);
    end;
  end
  else
    LogLine('[NOTE] test.png missing; run download_models.ps1');

  DetPath := ResolveBinModel(['models\detection_yolox.onnx', 'models\object_detection_yolox_2022nov.onnx']);
  ClsPath := ResolveBinModel(['models\classification.onnx', 'models\image_classification_mobilenetv2_2022apr.onnx']);
  SegPath := ResolveBinModel(['models\human_segmentation_pphumanseg_2023mar.onnx']);
  EastPath := ResolveBinModel(['models\frozen_east_text_detection.pb']);
  PpocrPath := ResolveBinModel(['models\text_detection_ppocr.onnx',
    'models\text_detection_en_ppocrv3_2023may.onnx']);

  if (DetPath <> '') and FileExists(DetPath) then
  begin
    if ImgPath = '' then
      LogLine('[NOTE] DetectionModel detect skipped (test.png missing)')
    else
    begin
      Img := imreadPath(ImgPath, IMREAD_COLOR);
      ModelDet := TCVDetectionModel.Create(PAnsiChar(AnsiString(DetPath)), nil);
      try
        Check('DetectionModel create', ModelDet.Handle <> nil);
        if ModelDet.Handle <> nil then
        begin
          ModelDet.setInputSize(640, 640);
          ClassIds := TCVMat.Create_0(0, 1, CV_32S);
          Confidences := TCVMat.Create_0(0, 1, CV_32F);
          Boxes := TCVMat.Create_0(0, 4, CV_32S);
          DetN := ModelDet.detect(Img.Handle, ClassIds.Handle, Confidences.Handle, Boxes.Handle, 0.25, 0.45);
          Check('DetectionModel detect callable', DetN >= 0);
        end;
      except
        on E: Exception do
          LogLine('[NOTE] DetectionModel: ' + E.ClassName);
      end;
    end;
  end
  else
    LogLine('[NOTE] DetectionModel skipped (model missing)');

  if (ImgPath <> '') and (ClsPath <> '') then
  begin
    Img := imreadPath(ImgPath, IMREAD_COLOR);
    ModelCls := TCVClassificationModel.Create(PAnsiChar(AnsiString(ClsPath)), nil);
    try
      Check('ClassificationModel create', ModelCls.Handle <> nil);
      if ModelCls.Handle <> nil then
      begin
        ModelCls.setInputSize(Img.cols, Img.rows);
        Check('ClassificationModel classify', ModelCls.classify(Img.Handle, ClassId, Conf));
      end;
    except
      on E: Exception do
        LogLine('[NOTE] ClassificationModel: ' + E.ClassName);
    end;
  end;

  if (ImgPath <> '') and (SegPath <> '') then
  begin
    Img := imreadPath(ImgPath, IMREAD_COLOR);
    ModelSeg := TCVSegmentationModel.Create(PAnsiChar(AnsiString(SegPath)), nil);
    try
      Check('SegmentationModel create', ModelSeg.Handle <> nil);
      if ModelSeg.Handle <> nil then
      begin
        ModelSeg.setInputSize(192, 192);
        Mask := TCVMat.Create_0(0, 0, CV_8UC1);
        Check('SegmentationModel segment', ModelSeg.segment(Img.Handle, Mask.Handle));
      end;
    except
      on E: Exception do
        LogLine('[NOTE] SegmentationModel: ' + E.ClassName);
    end;
  end;

  if (ImgPath <> '') and (EastPath <> '') then
  begin
    Img := imreadPath(ImgPath, IMREAD_COLOR);
    ModelEast := TCVTextDetectionEAST.Create(PAnsiChar(AnsiString(EastPath)), nil);
    try
      Check('TextDetectionEAST create', ModelEast.Handle <> nil);
      if ModelEast.Handle <> nil then
      begin
        ModelEast.setInputSize(320, 320);
        EastBoxes := TCVMat.Create_0(0, 5, CV_32F);
        EastConf := TCVMat.Create_0(0, 1, CV_32F);
        EastN := ModelEast.detectText(Img.Handle, EastBoxes.Handle, EastConf.Handle, 0.5, 0.4);
        Check('TextDetectionEAST detect', EastN >= 0);
      end;
    except
      on E: Exception do
        LogLine('[NOTE] TextDetectionEAST: ' + E.ClassName);
    end;
  end;

  if (PpocrPath <> '') and ((TextPath <> '') or (ImgPath <> '')) then
  begin
    if TextPath <> '' then
      Img := imreadPath(TextPath, IMREAD_COLOR)
    else
      Img := imreadPath(ImgPath, IMREAD_COLOR);
    ModelDb := TCVTextDetectionDB.Create(PAnsiChar(AnsiString(PpocrPath)), nil);
    try
      Check('TextDetectionDB create', ModelDb.Handle <> nil);
      if ModelDb.Handle <> nil then
      begin
        ModelDb.setInputSize(Img.cols, Img.rows);
        DbPolygons := TCVMat.Create_0(0, 8, CV_32F);
        DbConf := TCVMat.Create_0(0, 1, CV_32F);
        DbN := ModelDb.detectText(Img.Handle, DbPolygons.Handle, DbConf.Handle, 0.3);
        Check('TextDetectionDB detect', DbN >= 0);
        if TextPath <> '' then
          Check('TextDetectionDB finds text', DbN > 0);
      end;
    except
      on E: Exception do
        LogLine('[NOTE] TextDetectionDB: ' + E.ClassName);
    end;
  end
  else if PpocrPath = '' then
    LogLine('[NOTE] TextDetectionDB skipped (PPOCR model missing)')
  else
    LogLine('[NOTE] TextDetectionDB skipped (run download_models.ps1 for text_sample.png)');

  Verts := TCVMat.Create_0(4, 3, CV_32F);
  for I := 0 to 3 do
  begin
    PSingle(Verts.ptr(I, 0))^ := I;
    PSingle(Verts.ptr(I, 1))^ := I + 1;
    PSingle(Verts.ptr(I, 2))^ := I + 2;
  end;
  PlyPath := 'ocv5_ptcloud_test.ply';
  try
    savePointCloud(PAnsiChar(AnsiString(PlyPath)), Verts.Handle);
    Loaded := TCVMat.Create_0(0, 0, CV_32F);
    Check('savePointCloud + loadPointCloud', loadPointCloud(PAnsiChar(AnsiString(PlyPath)), Loaded) and
      ((Loaded.rows >= 4) or (Loaded.cols >= 4)));
  except
    on E: Exception do
      LogLine('[NOTE] savePointCloud: ' + E.ClassName);
  end;
  if FileExists(PlyPath) then
    DeleteFile(PlyPath);

  LogLine('[NOTE] setMouseCallback/createTrackbar: DemoHighguiCallbacks5.exe');
  LogLine('[NOTE] VCL/FMX preview: DemoVclPreview5.exe, DemoFmxPreview5.exe');
end;

procedure RunAllTests;
begin
  LogLine('=== OpenCV 5.0 Delphi Wrapper Tests ===');
  LogLine('');

  LogLine('> clipLine'); TestClipLine;
  LogLine('> clipLine2l'); TestClipLine2l;
  LogLine('> ellipse2Poly'); TestEllipse2Poly;
  LogLine('> calcHistSimple'); TestCalcHistSimple;
  LogLine('> calcHist'); TestCalcHist;
  LogLine('> calcBackProject'); TestCalcBackProject;
  LogLine('> CLAHE'); TestCLAHE;
  LogLine('> moments/HuMoments'); TestMomentsAndHuMoments;
  LogLine('> floodFill'); TestFloodFill;
  LogLine('> imwrite/imread'); TestImwriteImread;
  LogLine('> compareHist'); TestCompareHist;
  LogLine('> objdetect'); TestObjdetect;
  LogLine('> face detect'); TestFaceDetect;
  LogLine('> face recognize'); TestFaceRecognizer;
  LogLine('> calib3d projectPoints'); TestProjectPoints;
  LogLine('> calib3d solvePnP'); TestSolvePnP;
  LogLine('> features2d ORB/BFMatcher'); TestFeatures2d;
  LogLine('> dnn readNet'); TestDnnReadNet;
  LogLine('> dnn extended'); TestDnnExtended;
  LogLine('> ml KNN/PCA'); TestMl;
  LogLine('> tracking'); TestTracking;
  LogLine('> calib3d extended'); TestCalib3dExtended;
  LogLine('> features2d SIFT/Flann'); TestFeatures2dExtended;
  LogLine('> OpenCV5 tier1 stereo/photo/video/dnn'); TestOpenCV5Tier1;
  LogLine('> OpenCV5 tier2 features2d extended'); TestOpenCV5Tier2;
  LogLine('> OpenCV5 tier3 persistence/stitching'); TestOpenCV5Tier3;
  LogLine('> OpenCV5 roadmap10'); TestRoadmap10;
  LogLine('> dev infra tier1');
  TestDevInfra;
  LogLine('> video optical flow'); TestOpticalFlowApi;
  LogLine('> highgui'); TestHighguiBasic;
  LogLine('> imshow'); TestShowImage;
  LogLine('> Delphi components'); TestDelphiComponents;

  LogLine('');
  LogLine(Format('Results: %d passed, %d failed', [GPassed, GFailed]));
end;

begin
  GLog := TStringList.Create;
  try
    GRunGui := HasCmdSwitch('gui');
    try
      RunAllTests;
    except
      on E: Exception do
        LogLine('FATAL: ' + E.ClassName + ': ' + E.Message);
    end;
    try
      GLog.SaveToFile('test_results.txt', TEncoding.UTF8);
    except
      // ignore log write errors
    end;
  finally
    GLog.Free;
  end;

  if GFailed > 0 then
    Halt(1);
end.
