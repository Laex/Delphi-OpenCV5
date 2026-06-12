program DemoHomography5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Calib3d in '..\..\source\OpenCV5.Calib3d.pas',
  OpenCV5.Dnn in '..\..\source\OpenCV5.Dnn.pas',
  DemoUtils in '..\common\DemoUtils.pas';

procedure RunDemo;
var
  Src, Dst, H, Rvec, Rmat, Bboxes, Scores, Indices: TCVMat;
  I: Integer;
  NmsCount: Integer;
  Pt: PSingle;
begin
  DemoOutLn('OpenCV 5.0 Homography + DNN NMSBoxes Demo');
  DemoOutLn('');

  Src := TCVMat.Create_0(4, 2, CV_32F);
  Dst := TCVMat.Create_0(4, 2, CV_32F);
  Pt := Src.ptr(0, 0); Pt^ := 0; Inc(Pt); Pt^ := 0;
  Pt := Src.ptr(1, 0); Pt^ := 100; Inc(Pt); Pt^ := 0;
  Pt := Src.ptr(2, 0); Pt^ := 100; Inc(Pt); Pt^ := 100;
  Pt := Src.ptr(3, 0); Pt^ := 0; Inc(Pt); Pt^ := 100;

  Pt := Dst.ptr(0, 0); Pt^ := 10; Inc(Pt); Pt^ := 10;
  Pt := Dst.ptr(1, 0); Pt^ := 110; Inc(Pt); Pt^ := 5;
  Pt := Dst.ptr(2, 0); Pt^ := 105; Inc(Pt); Pt^ := 105;
  Pt := Dst.ptr(3, 0); Pt^ := 5; Inc(Pt); Pt^ := 110;

  H := findHomography(Src.Handle, Dst.Handle, HOMOGRAPHY_RANSAC, 3.0, nil);
  if H.empty then
    raise Exception.Create('findHomography failed');
  DemoOutLn(Format('Homography %d x %d, H[0,0]=%.3f', [H.rows, H.cols,
    PDouble(H.ptr(0, 0))^]));

  Rvec := TCVMat.Create_0(3, 1, CV_64F);
  Rmat := TCVMat.Create_0(3, 3, CV_64F);
  PDouble(Rvec.ptr(0, 0))^ := 0.1;
  PDouble(Rvec.ptr(1, 0))^ := 0.2;
  PDouble(Rvec.ptr(2, 0))^ := 0.3;
  Rodrigues(Rvec.Handle, Rmat.Handle, nil);
  DemoOutLn(Format('Rodrigues matrix trace: %.3f',
    [PDouble(Rmat.ptr(0, 0))^ + PDouble(Rmat.ptr(1, 1))^ + PDouble(Rmat.ptr(2, 2))^]));

  Bboxes := TCVMat.Create_0(3, 4, CV_32F);
  Scores := TCVMat.Create_0(3, 1, CV_32F);
  Indices := TCVMat.Create_0(0, 1, CV_32S);
  for I := 0 to 2 do
  begin
    PSingle(Bboxes.ptr(I, 0))^ := 10 * I;
    PSingle(Bboxes.ptr(I, 1))^ := 10;
    PSingle(Bboxes.ptr(I, 2))^ := 50;
    PSingle(Bboxes.ptr(I, 3))^ := 50;
    PSingle(Scores.ptr(I, 0))^ := 0.9 - I * 0.1;
  end;
  NmsCount := NMSBoxes(Bboxes.Handle, Scores.Handle, Indices.Handle, 0.5, 0.4);
  DemoOutLn(Format('NMSBoxes kept %d of %d', [NmsCount, Bboxes.rows]));
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
