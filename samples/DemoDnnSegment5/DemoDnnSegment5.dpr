program DemoDnnSegment5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Dnn in '..\..\source\OpenCV5.Dnn.pas',
  OpenCV5.Utils in '..\..\source\OpenCV5.Utils.pas',
  DemoUtils in '..\common\DemoUtils.pas';

procedure RunDemo;
var
  ModelPath, ImagePath, OutPath: string;
  Model: TCVSegmentationModel;
  Img, Mask: TCVMat;
begin
  ModelPath := DemoCmdValue('model', 'models\human_segmentation_pphumanseg_2023mar.onnx');
  ImagePath := DemoCmdValue('image', 'test.png');
  OutPath := DemoCmdValue('out', 'segment_mask.png');

  DemoOutLn('OpenCV 5.0 SegmentationModel demo');
  DemoOutLn('Options: --model=... --image=test.png [--out=segment_mask.png]');
  DemoOutLn('');

  if not FileExists(ModelPath) then
    raise Exception.Create('Model not found: ' + ModelPath);
  if not FileExists(ImagePath) then
    raise Exception.Create('Image not found: ' + ImagePath);

  Model := TCVSegmentationModel.Create(PAnsiChar(PathToUTF8(ModelPath)), nil);
  if Model.Handle = nil then
    raise Exception.Create('Failed to create SegmentationModel');

  Img := imreadPath(ImagePath, IMREAD_COLOR);
  if Img.empty then
    raise Exception.Create('Failed to read image');

  Model.setInputSize(192, 192);
  Mask := TCVMat.Create_0(0, 0, CV_8UC1);
  if not Model.segment(Img.Handle, Mask.Handle) then
    raise Exception.Create('segment failed');

  DemoOutLn(Format('Mask: %dx%d channels=%d', [Mask.cols, Mask.rows, Mask.channels]));
  if not imwritePath(OutPath, Mask.Handle) then
    raise Exception.Create('Failed to write ' + OutPath);
  DemoOutLn('Saved ' + OutPath);
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
