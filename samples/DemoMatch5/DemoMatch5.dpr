program DemoMatch5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Imgcodecs in '..\..\source\OpenCV5.Imgcodecs.pas',
  OpenCV5.Features2d in '..\..\source\OpenCV5.Features2d.pas',
  DemoUtils in '..\common\DemoUtils.pas';

procedure RunDemo;
var
  QueryPath, TrainPath, OutPath: string;
  Query, Train, GrayQ, GrayT, KeyQ, KeyT, DescQ, DescT, Matches, OutImg: TCVMat;
  Orb: TCVORB;
  Matcher: TCVBFMatcher;
  Nq, Nt, MatchCount, Drawn: Integer;
begin
  QueryPath := DemoCmdValue('query', 'test.png');
  TrainPath := DemoCmdValue('train', 'test.png');
  OutPath := DemoCmdValue('out', 'output\match_result.png');

  DemoOutLn('OpenCV 5.0 ORB Feature Matching Demo');
  DemoOutLn('Options: --query=test.png --train=test.png --out=output\match_result.png');
  DemoOutLn('');

  if not FileExists(QueryPath) then
    raise Exception.Create('Query image not found: ' + QueryPath);
  if not FileExists(TrainPath) then
    raise Exception.Create('Train image not found: ' + TrainPath);

  Query := imread(PAnsiChar(AnsiString(QueryPath)), IMREAD_COLOR);
  Train := imread(PAnsiChar(AnsiString(TrainPath)), IMREAD_COLOR);
  if Query.empty or Train.empty then
    raise Exception.Create('Failed to read input images');

  GrayQ := TCVMat.Create_0(0, 0, CV_8UC1);
  GrayT := TCVMat.Create_0(0, 0, CV_8UC1);
  cvtColor(Query.Handle, GrayQ.Handle, COLOR_BGR2GRAY, 0, 0);
  cvtColor(Train.Handle, GrayT.Handle, COLOR_BGR2GRAY, 0, 0);

  Orb := TCVORB.Create(500);
  Matcher := TCVBFMatcher.Create(NORM_HAMMING, False);
  KeyQ := TCVMat.Create_0(0, 0, CV_32FC1);
  KeyT := TCVMat.Create_0(0, 0, CV_32FC1);
  DescQ := TCVMat.Create_0(0, 0, CV_8UC1);
  DescT := TCVMat.Create_0(0, 0, CV_8UC1);
  Matches := TCVMat.Create_0(0, 0, CV_32FC1);
  OutImg := TCVMat.Create_0(0, 0, CV_8UC3);

  Nq := Orb.detectAndCompute(GrayQ.Handle, nil, KeyQ.Handle, DescQ.Handle);
  Nt := Orb.detectAndCompute(GrayT.Handle, nil, KeyT.Handle, DescT.Handle);
  MatchCount := Matcher.match(DescQ.Handle, DescT.Handle, Matches.Handle);
  Drawn := drawFeatureMatches(Query.Handle, Train.Handle, KeyQ.Handle, KeyT.Handle,
    Matches.Handle, OutImg.Handle, 80);

  if not DirectoryExists(ExtractFilePath(OutPath)) then
    ForceDirectories(ExtractFilePath(OutPath));
  imwrite(PAnsiChar(AnsiString(OutPath)), OutImg.Handle);

  DemoOutLn(Format('Query keypoints : %d', [Nq]));
  DemoOutLn(Format('Train keypoints : %d', [Nt]));
  DemoOutLn(Format('Matches         : %d', [MatchCount]));
  DemoOutLn(Format('Drawn           : %d', [Drawn]));
  DemoOutLn('Saved: ' + OutPath);
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
