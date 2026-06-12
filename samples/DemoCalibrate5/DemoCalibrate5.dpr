program DemoCalibrate5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Imgcodecs in '..\..\source\OpenCV5.Imgcodecs.pas',
  OpenCV5.Objdetect in '..\..\source\OpenCV5.Objdetect.pas',
  OpenCV5.Calib3d in '..\..\source\OpenCV5.Calib3d.pas',
  DemoUtils in '..\common\DemoUtils.pas';

const
  VIEW_COUNT = 5;
  ROTATIONS: array[0..4] of Double = (-12, -6, 0, 6, 12);

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

procedure RunDemo;
var
  PatternSize, ImageSize: TCVSize;
  SquareSize, Angle, Rms: Double;
  Cell, Border, I, ViewIdx, Flags: Integer;
  Base, View, Corners, CameraMatrix, DistCoeffs, Rvecs, Tvecs, Rvec, Tvec: TCVMat;
  Undistorted, RotM, ColorView: TCVMat;
  ObjViews, ImgViews: array of TCVMat;
  ObjPtrs, ImgPtrs: array of Pointer;
  Criteria: TCVTermCriteria;
  OutDir: string;
  Found: Boolean;
  Center: TCVPoint2f;
begin
  PatternSize := TCVSize.Create(9, 6);
  Cell := StrToIntDef(DemoCmdValue('cell', '40'), 40);
  Border := StrToIntDef(DemoCmdValue('border', '40'), 40);
  SquareSize := StrToFloatDef(DemoCmdValue('square', '25'), 25);
  OutDir := DemoCmdValue('out', 'output');

  DemoOutLn('OpenCV 5.0 Camera Calibration Demo');
  DemoOutLn('Options: --cell=40 --border=40 --square=25 --out=output');
  DemoOutLn('Uses synthetic chessboard views with small rotations.');
  DemoOutLn('');

  if not DirectoryExists(OutDir) then
    ForceDirectories(OutDir);

  SetLength(ObjViews, VIEW_COUNT);
  SetLength(ImgViews, VIEW_COUNT);
  SetLength(ObjPtrs, VIEW_COUNT);
  SetLength(ImgPtrs, VIEW_COUNT);

  MakeChessboardGray(PatternSize.Width, PatternSize.Height, Cell, Border, Base);
  ImageSize := TCVSize.Create(Base.cols, Base.rows);
  Center := TCVPoint2f.Create(ImageSize.Width * 0.5, ImageSize.Height * 0.5);

  for I := 0 to VIEW_COUNT - 1 do
  begin
    Angle := ROTATIONS[I];
    RotM := getRotationMatrix2D(Center, Angle, 1.0);
    View := TCVMat.Create_0(0, 0, CV_8UC1);
    warpAffine(Base.Handle, View.Handle, RotM.Handle, ImageSize, INTER_LINEAR, BORDER_CONSTANT,
      TCVScalar.Create(255), ALGO_HINT_DEFAULT);
    Corners := TCVMat.Create_0(0, 0, CV_32FC2);
    Found := findChessboardCorners(View.Handle, PatternSize, Corners.Handle,
      CALIB_CB_ADAPTIVE_THRESH + CALIB_CB_NORMALIZE_IMAGE + CALIB_CB_FAST_CHECK);
    if not Found then
      raise Exception.CreateFmt('Chessboard not found in synthetic view %d', [I + 1]);

    cornerSubPix(View.Handle, Corners.Handle, TCVSize.Create(11, 11), TCVSize.Create(-1, -1),
      TCVTermCriteria.Create(TERM_CRITERIA_COUNT or TERM_CRITERIA_EPS, 30, 0.001));

    ObjViews[I] := BuildChessboardObjectPoints(PatternSize, SquareSize);
    ImgViews[I] := Corners;
    ObjPtrs[I] := ObjViews[I].Handle;
    ImgPtrs[I] := ImgViews[I].Handle;

    ColorView := TCVMat.Create_0(0, 0, CV_8UC3);
    cvtColor(View.Handle, ColorView.Handle, COLOR_GRAY2BGR, 0, 0);
    drawChessboardCorners(ColorView.Handle, PatternSize, Corners.Handle, True);
    imwrite(PAnsiChar(AnsiString(Format('%s\calib_view_%02d.png', [OutDir, I + 1]))), ColorView.Handle);
  end;

  CameraMatrix := initCameraMatrix2D(@ObjPtrs[0], @ImgPtrs[0], VIEW_COUNT, ImageSize, 1.0);
  DistCoeffs := TCVMat.Create_0(5, 1, CV_64FC1);
  Rvecs := TCVMat.Create_0(0, 0, CV_64FC1);
  Tvecs := TCVMat.Create_0(0, 0, CV_64FC1);
  Criteria := TCVTermCriteria.Create(TERM_CRITERIA_COUNT or TERM_CRITERIA_EPS, 30, 1E-6);
  Flags := CALIB_ZERO_TANGENT_DIST or CALIB_USE_INTRINSIC_GUESS;

  Rms := calibrateCamera(@ObjPtrs[0], @ImgPtrs[0], VIEW_COUNT, ImageSize,
    CameraMatrix.Handle, DistCoeffs.Handle, Rvecs.Handle, Tvecs.Handle, Flags, Criteria);

  DemoOutLn(Format('Views used     : %d', [VIEW_COUNT]));
  DemoOutLn(Format('Image size     : %d x %d', [ImageSize.Width, ImageSize.Height]));
  DemoOutLn(Format('Square size    : %.1f mm', [SquareSize]));
  DemoOutLn(Format('RMS reprojection error: %.4f', [Rms]));
  DemoOutLn(Format('fx=%.2f  fy=%.2f  cx=%.2f  cy=%.2f',
    [PDouble(CameraMatrix.ptr(0, 0))^, PDouble(CameraMatrix.ptr(1, 1))^,
     PDouble(CameraMatrix.ptr(0, 2))^, PDouble(CameraMatrix.ptr(1, 2))^]));

  ViewIdx := VIEW_COUNT div 2;
  RotM := getRotationMatrix2D(Center, ROTATIONS[ViewIdx], 1.0);
  View := TCVMat.Create_0(0, 0, CV_8UC1);
  warpAffine(Base.Handle, View.Handle, RotM.Handle, ImageSize, INTER_LINEAR, BORDER_CONSTANT,
    TCVScalar.Create(255), ALGO_HINT_DEFAULT);
  Undistorted := TCVMat.Create_0(0, 0, CV_8UC1);
  undistort(View.Handle, Undistorted.Handle, CameraMatrix.Handle, DistCoeffs.Handle, nil);
  imwrite(PAnsiChar(AnsiString(OutDir + '\calib_undistorted.png')), Undistorted.Handle);
  DemoOutLn('Saved: ' + OutDir + '\calib_view_*.png, calib_undistorted.png');

  Rvec := TCVMat.Create_0(3, 1, CV_64FC1);
  Tvec := TCVMat.Create_0(3, 1, CV_64FC1);
  if solvePnP(ObjViews[ViewIdx].Handle, ImgViews[ViewIdx].Handle,
    CameraMatrix.Handle, DistCoeffs.Handle, Rvec.Handle, Tvec.Handle, False, SOLVEPNP_ITERATIVE) then
    DemoOutLn('solvePnP: OK for middle view')
  else
    DemoOutLn('solvePnP: failed');
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
