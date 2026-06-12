program DemoOpenCV5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Winapi.Windows,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Imgcodecs in '..\..\source\OpenCV5.Imgcodecs.pas',
  OpenCV5.Highgui in '..\..\source\OpenCV5.Highgui.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas';

const
  CV_8UC1 = 0;
  CV_8UC3 = 16;
  CV_32FC1 = 5;
  CV_64FC1 = 6;
  IMREAD_COLOR = 1;
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

var
  GShowGui: Boolean = False;
  GOutDir: string = '';
  GRu: TStringList;

function Tr(const Key, Default: string): string;
begin
  if Assigned(GRu) and (GRu.IndexOfName(Key) >= 0) then
    Result := GRu.Values[Key]
  else
    Result := Default;
end;

procedure LoadLocale;
var
  Path: string;
begin
  GRu := TStringList.Create;
  GRu.NameValueSeparator := '=';
  Path := TPath.Combine(GOutDir, 'demo.ru.txt');
  if TFile.Exists(Path) then
    GRu.LoadFromFile(Path, TEncoding.UTF8);
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

procedure Info(const Msg: string);
begin
  OutLn('  ' + Msg);
end;

function SaveImage(const Mat: TCVMat; const FileName: string): Boolean;
var
  Path: AnsiString;
begin
  Path := AnsiString(TPath.Combine(GOutDir, FileName));
  Result := imwrite(PAnsiChar(Path), Mat.Handle);
  if Result then
    Info('Saved: ' + FileName)
  else
    Info('Failed to save: ' + FileName);
end;

function ReadByte(const Mat: TCVMat; Row, Col: Integer): Byte;
begin
  Result := PByte(Mat.ptr(Row, Col))^;
end;

function ReadFloat(const Mat: TCVMat; Row, Col: Integer): Single;
begin
  Result := PSingle(Mat.ptr(Row, Col))^;
end;

function ToBgr(const Gray: TCVMat): TCVMat;
begin
  Result := TCVMat.Create_1(TCVSize.Create(Gray.cols, Gray.rows), CV_8UC3);
  cvtColor(Gray.Handle, Result.Handle, COLOR_GRAY2BGR, 0, 0);
end;

procedure ShowImage(const WinName, FileName: string; const Mat: TCVMat);
var
  Name: AnsiString;
begin
  if not GShowGui then
    Exit;
  if Mat.empty then
  begin
    Info(Format('Skip empty image for window "%s"', [WinName]));
    Exit;
  end;
  Name := AnsiString(WinName);
  namedWindow(PAnsiChar(Name), WINDOW_AUTOSIZE);
  imshow(PAnsiChar(Name), Mat.Handle);
  waitKey(1);
  Info(Format(Tr('win_key', 'Window "%s" - press any key'), [WinName]));
  waitKey(0);
  destroyWindow(PAnsiChar(Name));
end;

procedure BuildSceneImage(out Gray: TCVMat; out Bgr: TCVMat);
begin
  Gray := TCVMat.Create_2(240, 320, CV_8UC1, TCVScalar.Create(30));
  rectangle(Gray.Handle, TCVPoint.Create(40, 40), TCVPoint.Create(140, 140),
    TCVScalar.Create(80), FILLED, LINE_8, 0);
  rectangle(Gray.Handle, TCVPoint.Create(180, 60), TCVPoint.Create(280, 180),
    TCVScalar.Create(200), FILLED, LINE_8, 0);
  circle(Gray.Handle, TCVPoint.Create(160, 190), 45, TCVScalar.Create(160), FILLED, LINE_8, 0);

  Bgr := ToBgr(Gray);
end;

procedure DemoClipLine;
var
  Gray, Canvas: TCVMat;
  Pt1, Pt2, Orig1, Orig2: TCVPoint;
  Pt1l, Pt2l: TCVPoint2l;
  Ok: Boolean;
begin
  Section(Tr('clipLine', 'clipLine - clip segment to image bounds'));

  Orig1 := TCVPoint.Create(-30, 120);
  Orig2 := TCVPoint.Create(350, 120);
  Pt1 := Orig1;
  Pt2 := Orig2;
  Ok := clipLine(TCVSize.Create(320, 240), @Pt1, @Pt2);
  Info(Format(Tr('clip_orig', 'Original segment: (%d,%d) - (%d,%d)'),
    [Orig1.X, Orig1.Y, Orig2.X, Orig2.Y]));
  Info(Format('clipLine = %s', [BoolToStr(Ok, True)]));
  Info(Format(Tr('clip_clipped', 'Clipped segment: (%d,%d) - (%d,%d)'), [Pt1.X, Pt1.Y, Pt2.X, Pt2.Y]));

  Pt1l := TCVPoint2l.Create(-100, 2000);
  Pt2l := TCVPoint2l.Create(8000, 2000);
  Ok := clipLine(TCVSize2l.Create(4000, 4000), @Pt1l, @Pt2l);
  Info(Format('clipLine(Size2l): (%d,%d) - (%d,%d)', [Pt1l.X, Pt1l.Y, Pt2l.X, Pt2l.Y]));
  Info(Format('clipLine(Size2l) = %s', [BoolToStr(Ok, True)]));

  Gray := TCVMat.Create_2(240, 320, CV_8UC1, TCVScalar.Create(40));
  try
    line(Gray.Handle, Pt1, Pt2, TCVScalar.Create(200), 3, LINE_8, 0);
    circle(Gray.Handle, Pt1, 4, TCVScalar.Create(255), FILLED, LINE_8, 0);
    circle(Gray.Handle, Pt2, 4, TCVScalar.Create(255), FILLED, LINE_8, 0);
    rectangle(Gray.Handle, TCVPoint.Create(0, 0), TCVPoint.Create(319, 239),
      TCVScalar.Create(255), 1, LINE_8, 0);
    Canvas := ToBgr(Gray);
    try
      SaveImage(Canvas, 'demo_clip_line.png');
      ShowImage('clipLine', 'demo_clip_line.png', Canvas);
    finally
    end;
  finally
  end;
end;

procedure DemoEllipse2Poly;
var
  Gray, Canvas: TCVMat;
  Pts: array[0..255] of TCVPoint;
  Count, I: Integer;
begin
  Section(Tr('ellipse2Poly', 'ellipse2Poly - approximate ellipse as polygon'));

  Gray := TCVMat.Create_2(200, 200, CV_8UC1, TCVScalar.Create(30));
  try
    Count := ellipse2Poly(TCVPoint.Create(100, 100), TCVSize.Create(70, 35),
      30, 0, 360, 5, @Pts[0], Length(Pts));
    Info(Format(Tr('poly_points', 'Polygon points: %d'), [Count]));

    for I := 0 to Count - 2 do
      line(Gray.Handle, Pts[I], Pts[I + 1], TCVScalar.Create(200), 2, LINE_8, 0);
    if Count > 1 then
      line(Gray.Handle, Pts[Count - 1], Pts[0], TCVScalar.Create(200), 2, LINE_8, 0);

    circle(Gray.Handle, TCVPoint.Create(100, 100), 3, TCVScalar.Create(255), FILLED, LINE_8, 0);
    Canvas := ToBgr(Gray);
    try
      SaveImage(Canvas, 'demo_ellipse_poly.png');
      ShowImage('ellipse2Poly', 'demo_ellipse_poly.png', Canvas);
    finally
    end;
  finally
  end;
end;

function RenderHistogram(const Hist: TCVMat): TCVMat;
var
  Gray, ResultBgr: TCVMat;
  I, H, MaxVal: Integer;
  V: Single;
begin
  Gray := TCVMat.Create_2(120, 256, CV_8UC1, TCVScalar.Create(20));
  MaxVal := 1;
  for I := 0 to 255 do
  begin
    V := ReadFloat(Hist, I, 0);
    if V > MaxVal then
      MaxVal := Trunc(V);
  end;

  for I := 0 to 255 do
  begin
    V := ReadFloat(Hist, I, 0);
    H := Trunc(V / MaxVal * 100);
    if H > 0 then
      line(Gray.Handle, TCVPoint.Create(I, 119), TCVPoint.Create(I, 119 - H),
        TCVScalar.Create(200), 1, LINE_8, 0);
  end;
  ResultBgr := ToBgr(Gray);
  Result := ResultBgr;
end;

procedure DemoHistogram(const Scene: TCVMat);
var
  Hist: TCVMat;
  HistImg: TCVMat;
  HistSize: Integer;
  Ranges: array[0..1] of Single;
  PeakBin: Integer;
  PeakVal: Single;
  I: Integer;
begin
  Section(Tr('histogram', 'calcHist / calcHistSimple - brightness histogram'));

  Hist := TCVMat.Create_0(256, 1, CV_32FC1);
  try
    HistSize := 256;
    Ranges[0] := 0;
    Ranges[1] := 256;
    calcHistSimple(Scene.Handle, Hist.Handle, 0, nil, @HistSize, @Ranges[0], 1, False);

    PeakBin := 0;
    PeakVal := 0;
    for I := 0 to 255 do
    begin
      if ReadFloat(Hist, I, 0) > PeakVal then
      begin
        PeakVal := ReadFloat(Hist, I, 0);
        PeakBin := I;
      end;
    end;
    Info(Format(Tr('hist_peak', 'Histogram peak: bin=%d, count=%.0f'), [PeakBin, PeakVal]));
    Info(Format('bin[80]=%.0f, bin[200]=%.0f',
      [ReadFloat(Hist, 80, 0), ReadFloat(Hist, 200, 0)]));

    HistImg := RenderHistogram(Hist);
    try
      SaveImage(HistImg, 'demo_histogram.png');
      ShowImage('histogram', 'demo_histogram.png', HistImg);
    finally
    end;
  finally
  end;
end;

procedure DemoBackProject(const Scene: TCVMat);
var
  Hist, Back, View: TCVMat;
  HistSize: Integer;
  Ranges: array[0..1] of Single;
  Sum: Int64;
  Y, X: Integer;
begin
  Section(Tr('backproject', 'calcBackProject - histogram back projection'));

  Hist := TCVMat.Create_0(256, 1, CV_32FC1);
  Back := TCVMat.Create_0(0, 0, CV_8UC1);
  try
    HistSize := 256;
    Ranges[0] := 0;
    Ranges[1] := 256;
    calcHistSimple(Scene.Handle, Hist.Handle, 0, nil, @HistSize, @Ranges[0], 1, False);
    calcBackProjectSimple(Scene.Handle, Hist.Handle, Back.Handle, @Ranges[0], 2, 255.0);

    Info(Format(Tr('map_size', 'Map size: %d x %d, depth=CV_8U'), [Back.cols, Back.rows]));
    Sum := 0;
    for Y := 0 to Back.rows - 1 do
      for X := 0 to Back.cols - 1 do
        Inc(Sum, ReadByte(Back, Y, X));
    Info(Format(Tr('map_sum', 'Map value sum: %d'), [Sum]));

    View := ToBgr(Back);
    try
      SaveImage(View, 'demo_backproject.png');
      ShowImage('backProject', 'demo_backproject.png', View);
    finally
    end;
  finally
  end;
end;

procedure DemoCLAHE;
var
  Src, Dst, SrcBgr, DstBgr: TCVMat;
  Clahe: TCVCLAHE;
  X: Integer;
begin
  Section(Tr('clahe', 'createCLAHE - contrast limited adaptive histogram equalization'));

  Src := TCVMat.Create_2(160, 160, CV_8UC1, TCVScalar.Create(0));
  Dst := TCVMat.Create_1(TCVSize.Create(160, 160), CV_8UC1);
  Clahe := createCLAHE(3.0, TCVSize.Create(8, 8));
  try
    for X := 0 to 159 do
      rectangle(Src.Handle, TCVPoint.Create(X, 0), TCVPoint.Create(X, 159),
        TCVScalar.Create(X), FILLED, LINE_8, 0);

    Info(Format('clipLimit = %.1f', [Clahe.getClipLimit]));
    Clahe.apply(Src.Handle, Dst.Handle);
    Info(Format(Tr('clahe_pixel', 'Pixel (80,80): before=%d, after=%d'),
      [ReadByte(Src, 80, 80), ReadByte(Dst, 80, 80)]));

    SrcBgr := ToBgr(Src);
    DstBgr := ToBgr(Dst);
    try
      SaveImage(SrcBgr, 'demo_clahe_before.png');
      SaveImage(DstBgr, 'demo_clahe_after.png');
      ShowImage('CLAHE before', 'demo_clahe_before.png', SrcBgr);
      ShowImage('CLAHE after', 'demo_clahe_after.png', DstBgr);
    finally
    end;
  finally
  end;
end;

procedure DemoMoments(const Scene: TCVMat);
var
  M: TCVMoments;
  Hu: TCVMat;
  Cx, Cy: Double;
  I: Integer;
begin
  Section(Tr('moments', 'moments / HuMoments - shape descriptors'));

  M := moments(Scene.Handle, True);
  if M.m00 <> 0 then
  begin
    Cx := M.m10 / M.m00;
    Cy := M.m01 / M.m00;
    Info(Format(Tr('centroid', 'm00=%.0f, centroid=(%.1f, %.1f)'), [M.m00, Cx, Cy]));
  end
  else
    Info('m00 = 0');

  Hu := TCVMat.Create_2(1, 7, CV_64FC1, TCVScalar.Create(0));
  try
    HuMoments(M, Hu.Handle);
    for I := 0 to 6 do
      Info(Format('Hu[%d] = %.6e', [I, PDouble(Hu.ptr(0, I))^]));
  finally
  end;
end;

procedure DemoFloodFill;
var
  Img, View: TCVMat;
  Area: Integer;
begin
  Section(Tr('floodfill', 'floodFill - flood fill region'));

  Img := TCVMat.Create_2(120, 120, CV_8UC1, TCVScalar.Create(0));
  try
    rectangle(Img.Handle, TCVPoint.Create(20, 20), TCVPoint.Create(99, 99),
      TCVScalar.Create(255), FILLED, LINE_8, 0);
    Info(Format(Tr('fill_before', 'Center before fill: %d'), [ReadByte(Img, 60, 60)]));

    Area := floodFill(Img.Handle, TCVPoint.Create(60, 60), TCVScalar.Create(128),
      nil, TCVScalar.Create(30), TCVScalar.Create(30), 4);
    Info(Format(Tr('fill_pixels', 'Filled pixels: %d'), [Area]));
    Info(Format(Tr('fill_after', 'Center after fill: %d'), [ReadByte(Img, 60, 60)]));

    View := ToBgr(Img);
    try
      SaveImage(View, 'demo_floodfill.png');
      ShowImage('floodFill', 'demo_floodfill.png', View);
    finally
    end;
  finally
  end;
end;

procedure DemoCompareHist(const Scene: TCVMat);
var
  Hist1, Hist2: TCVMat;
  HistSize: Integer;
  Ranges: array[0..1] of Single;
  Other: TCVMat;
  ScoreSame, ScoreDiff: Double;
begin
  Section(Tr('comparehist', 'compareHist - compare histograms'));

  Hist1 := TCVMat.Create_0(256, 1, CV_32FC1);
  Hist2 := TCVMat.Create_0(256, 1, CV_32FC1);
  Other := TCVMat.Create_2(240, 320, CV_8UC1, TCVScalar.Create(255));
  try
    HistSize := 256;
    Ranges[0] := 0;
    Ranges[1] := 256;
    calcHistSimple(Scene.Handle, Hist1.Handle, 0, nil, @HistSize, @Ranges[0], 1, False);
    calcHistSimple(Scene.Handle, Hist2.Handle, 0, nil, @HistSize, @Ranges[0], 1, False);
    ScoreSame := compareHist(Hist1.Handle, Hist2.Handle, HISTCMP_CORREL);
    Info(Format(Tr('hist_same', 'Identical histograms (CORREL): %.4f'), [ScoreSame]));

    calcHistSimple(Other.Handle, Hist2.Handle, 0, nil, @HistSize, @Ranges[0], 1, False);
    ScoreDiff := compareHist(Hist1.Handle, Hist2.Handle, HISTCMP_CORREL);
    Info(Format(Tr('hist_diff', 'Different histograms (CORREL): %.4f'), [ScoreDiff]));
  finally
  end;
end;

procedure DemoImwriteImread(const Scene: TCVMat);
var
  Path: AnsiString;
  Loaded, View: TCVMat;
begin
  Section(Tr('ior', 'imwrite / imread - save and load image'));

  Path := AnsiString(TPath.Combine(GOutDir, 'demo_roundtrip.png'));
  if imwrite(PAnsiChar(Path), Scene.Handle) then
    Info(Tr('written', 'Written: demo_roundtrip.png'))
  else
    Info(Tr('write_fail', 'Failed to write demo_roundtrip.png'));

  Loaded := imread(PAnsiChar(Path), IMREAD_COLOR);
  try
    Info(Format(Tr('loaded', 'Loaded: %d x %d, channels=%d'),
      [Loaded.cols, Loaded.rows, Loaded.channels]));
    View := ToBgr(Scene);
    try
      ShowImage('original', 'demo_roundtrip.png', View);
    finally
    end;
  finally
  end;
end;

procedure RunDemo;
var
  Scene, SceneBgr: TCVMat;
begin
  OutLn(Tr('title', 'OpenCV 5.0 - Delphi wrapper demo'));
  OutLn(Tr('outdir', 'Output directory:') + ' ' + GOutDir);
  if GShowGui then
    OutLn(Tr('gui_on', 'GUI mode: imshow windows (press a key to continue)'))
  else
    OutLn(Tr('gui_off', 'Use /gui or --gui to show imshow windows'));

  BuildSceneImage(Scene, SceneBgr);
  try
    SaveImage(SceneBgr, 'demo_scene.png');
    ShowImage('scene', 'demo_scene.png', SceneBgr);

    DemoClipLine;
    DemoEllipse2Poly;
    DemoHistogram(Scene);
    DemoBackProject(Scene);
    DemoCLAHE;
    DemoMoments(Scene);
    DemoFloodFill;
    DemoCompareHist(Scene);
    DemoImwriteImread(Scene);
  finally
  end;

  OutLn;
  OutLn(Tr('finished', 'Demo finished.'));
end;

begin
  try
    GShowGui := HasCmdSwitch('gui');
    GOutDir := ExtractFilePath(ParamStr(0));
    ForceDirectories(GOutDir);
    LoadLocale;
    try
      RunDemo;
    finally
      GRu.Free;
    end;
  except
    on E: Exception do
    begin
      OutLn(Tr('error', 'Error:') + ' ' + E.ClassName + ': ' + E.Message);
      ExitCode := 1;
    end;
  end;
end.
