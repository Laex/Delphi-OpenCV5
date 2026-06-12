program DemoTemplateMatch5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Imgcodecs in '..\..\source\OpenCV5.Imgcodecs.pas',
  OpenCV5.Arith in '..\..\source\OpenCV5.Arith.pas',
  DemoUtils in '..\common\DemoUtils.pas';

procedure RunDemo;
var
  ImagePath, TemplatePath, OutPath: string;
  Image, Template, Gray, TemplGray, ResultMat, OutImg: TCVMat;
  MinVal, MaxVal: Double;
  MinLoc, MaxLoc: TCVPoint;
  MatchRect: TCVRect;
begin
  ImagePath := DemoCmdValue('image', 'test.png');
  TemplatePath := DemoCmdValue('template', 'test.png');
  OutPath := DemoCmdValue('out', 'output\template_match.png');

  DemoOutLn('OpenCV 5.0 Template Matching Demo (matchTemplate + minMaxLoc)');
  DemoOutLn('Options: --image=test.png --template=test.png --out=output\template_match.png');
  DemoOutLn('');

  if not FileExists(ImagePath) then
    raise Exception.Create('Image not found: ' + ImagePath);
  if not FileExists(TemplatePath) then
    raise Exception.Create('Template not found: ' + TemplatePath);

  Image := imread(PAnsiChar(AnsiString(ImagePath)), IMREAD_COLOR);
  Template := imread(PAnsiChar(AnsiString(TemplatePath)), IMREAD_COLOR);
  if Image.empty or Template.empty then
    raise Exception.Create('Failed to read images');

  Gray := TCVMat.Create_0(0, 0, CV_8UC1);
  TemplGray := TCVMat.Create_0(0, 0, CV_8UC1);
  cvtColor(Image.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
  cvtColor(Template.Handle, TemplGray.Handle, COLOR_BGR2GRAY, 0, 0);

  ResultMat := TCVMat.Create_0(0, 0, CV_32F);
  matchTemplate(Gray.Handle, TemplGray.Handle, ResultMat.Handle, TM_CCOEFF_NORMED, nil);
  minMaxLoc(ResultMat.Handle, MinVal, MaxVal, MinLoc, MaxLoc);
  DemoOutLn(Format('Best match score: %.4f at (%d, %d)', [MaxVal, MaxLoc.X, MaxLoc.Y]));

  OutImg := Image.clone;
  MatchRect := TCVRect.Create(MaxLoc.X, MaxLoc.Y, Template.cols, Template.rows);
  rectangle(OutImg.Handle, MatchRect, TCVScalar.Create(0, 255, 0), 2, LINE_8, 0);

  if not DirectoryExists(ExtractFilePath(OutPath)) then
    ForceDirectories(ExtractFilePath(OutPath));
  if not imwrite(PAnsiChar(AnsiString(OutPath)), OutImg.Handle) then
    raise Exception.Create('Failed to write: ' + OutPath);
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
