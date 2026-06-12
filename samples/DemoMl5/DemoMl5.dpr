program DemoMl5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Ml in '..\..\source\OpenCV5.Ml.pas',
  DemoUtils in '..\common\DemoUtils.pas';

procedure RunDemo;
var
  Samples, Responses, TestSample, ResultMat, NeighborResp, Dist: TCVMat;
  Knn: TCVKNearest;
  PcaData, PcaVec, PcaOut: TCVMat;
  Pca: TCVPCA;
  Pred: Single;
  I: Integer;
  Pt: PSingle;
begin
  DemoOutLn('OpenCV 5.0 ML Demo (KNN + PCA via core)');
  DemoOutLn('');

  Samples := TCVMat.Create_0(6, 2, CV_32F);
  Responses := TCVMat.Create_0(6, 1, CV_32F);
  TestSample := TCVMat.Create_0(1, 2, CV_32F);
  ResultMat := TCVMat.Create_0(1, 1, CV_32F);
  NeighborResp := TCVMat.Create_0(1, 3, CV_32F);
  Dist := TCVMat.Create_0(1, 3, CV_32F);

  Pt := Samples.ptr(0, 0); Pt^ := 0; Inc(Pt); Pt^ := 0;
  Pt := Samples.ptr(1, 0); Pt^ := 1; Inc(Pt); Pt^ := 0;
  Pt := Samples.ptr(2, 0); Pt^ := 0; Inc(Pt); Pt^ := 1;
  Pt := Samples.ptr(3, 0); Pt^ := 5; Inc(Pt); Pt^ := 5;
  Pt := Samples.ptr(4, 0); Pt^ := 6; Inc(Pt); Pt^ := 5;
  Pt := Samples.ptr(5, 0); Pt^ := 5; Inc(Pt); Pt^ := 6;

  for I := 0 to 2 do
    PSingle(Responses.ptr(I, 0))^ := 0;
  for I := 3 to 5 do
    PSingle(Responses.ptr(I, 0))^ := 1;

  Pt := TestSample.ptr(0, 0); Pt^ := 0.2; Inc(Pt); Pt^ := 0.1;

  Knn := TCVKNearest.Create;
  if not Knn.train(Samples.Handle, Responses.Handle) then
    raise Exception.Create('KNN train failed');
  Pred := Knn.findNearest(TestSample.Handle, ResultMat.Handle,
    NeighborResp.Handle, Dist.Handle, 3);
  DemoOutLn(Format('KNN nearest label: %.0f (dist %.3f)', [
    PSingle(ResultMat.ptr(0, 0))^, Pred]));

  PcaData := TCVMat.Create_0(4, 3, CV_32F);
  for I := 0 to 3 do
  begin
    PSingle(PcaData.ptr(I, 0))^ := I;
    PSingle(PcaData.ptr(I, 1))^ := I * 2;
    PSingle(PcaData.ptr(I, 2))^ := I * 3;
  end;
  Pca := TCVPCA.Create(PcaData.Handle, 2, PCA_DATA_AS_ROW);
  PcaVec := TCVMat.Create_0(1, 3, CV_32F);
  PSingle(PcaVec.ptr(0, 0))^ := 1;
  PSingle(PcaVec.ptr(0, 1))^ := 2;
  PSingle(PcaVec.ptr(0, 2))^ := 3;
  PcaOut := Pca.project(PcaVec.Handle);
  DemoOutLn(Format('PCA components: %d, projected dims: %d x %d', [
    Pca.getComponents, PcaOut.rows, PcaOut.cols]));
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
