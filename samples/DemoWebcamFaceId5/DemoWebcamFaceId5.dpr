program DemoWebcamFaceId5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math,
  System.Generics.Collections,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Videoio in '..\..\source\OpenCV5.Videoio.pas',
  OpenCV5.Imgproc in '..\..\source\OpenCV5.Imgproc.pas',
  OpenCV5.Highgui in '..\..\source\OpenCV5.Highgui.pas',
  OpenCV5.Imgcodecs in '..\..\source\OpenCV5.Imgcodecs.pas',
  OpenCV5.Objdetect in '..\..\source\OpenCV5.Objdetect.pas',
  DemoUtils in '..\common\DemoUtils.pas';

const
  WIN_NAME = 'Face ID Webcam';
  MAX_ENROLLED = 8;

type
  TEnrolledFace = record
    Name: string;
    Feature: TCVMat;
  end;

var
  GEnrolled: TArray<TEnrolledFace>;

procedure ClearEnrolled;
var
  I: Integer;
begin
  for I := 0 to High(GEnrolled) do
    GEnrolled[I].Feature.Release;
  SetLength(GEnrolled, 0);
end;

procedure AddEnrolled(const AName: string; const Feature: TCVMat);
var
  Item: TEnrolledFace;
  N: Integer;
begin
  Item.Name := AName;
  Item.Feature := TCVMat.Create_6(Feature);
  N := Length(GEnrolled);
  SetLength(GEnrolled, N + 1);
  GEnrolled[N] := Item;
end;

function IdentifyFace(const Rec: TCVFaceRecognizerSF; const Feature: TCVMat;
  out BestName: string): Double;
var
  I: Integer;
  Dist, BestDist: Double;
begin
  BestDist := MaxDouble;
  BestName := 'unknown';
  for I := 0 to High(GEnrolled) do
  begin
    Dist := Rec.match(Feature.Handle, GEnrolled[I].Feature.Handle, FR_COSINE);
    if Dist < BestDist then
    begin
      BestDist := Dist;
      BestName := GEnrolled[I].Name;
    end;
  end;
  Result := BestDist;
end;

function LoadDetector(const ModelPath: string; const ScoreThreshold: Single): TCVFaceDetectorYN;
var
  Path: string;
begin
  Path := ResolveFaceDetectorModelPath(ModelPath);
  if not FileExists(Path) then
    raise Exception.Create('Detector model not found: ' + Path + sLineBreak + FaceDetectorModelMissingHint);
  Result := TCVFaceDetectorYN.Create(PAnsiChar(AnsiString(Path)), nil,
    TCVSize.Create(320, 320), ScoreThreshold, 0.3, 5000);
  if Result.Handle = nil then
    raise Exception.Create('Failed to create FaceDetectorYN');
end;

function LoadRecognizer(const ModelPath: string): TCVFaceRecognizerSF;
var
  Path: string;
begin
  Path := ResolveFaceRecognizerModelPath(ModelPath);
  if not FileExists(Path) then
    raise Exception.Create('Recognizer model not found: ' + Path + sLineBreak + FaceRecognizerModelMissingHint);
  Result := TCVFaceRecognizerSF.Create(PAnsiChar(AnsiString(Path)), nil);
  if Result.Handle = nil then
    raise Exception.Create('Failed to create FaceRecognizerSF');
end;

function ExtractFirstFaceFeature(const Det: TCVFaceDetectorYN; const Rec: TCVFaceRecognizerSF;
  const Frame, Faces: TCVMat; out Feature: TCVMat): Boolean;
var
  FaceRow, Aligned: TCVMat;
begin
  Result := False;
  if Det.detect(Frame.Handle, Faces.Handle) <= 0 then
    Exit;
  FaceRow := Faces.row(0);
  Aligned := TCVMat.Create_0(0, 0, CV_8UC3);
  Feature := TCVMat.Create_0(0, 0, CV_32FC1);
  Rec.alignCrop(Frame.Handle, FaceRow.Handle, Aligned.Handle);
  Rec.feature(Aligned.Handle, Feature.Handle);
  Result := True;
end;

procedure EnrollFromImage(const Det: TCVFaceDetectorYN; const Rec: TCVFaceRecognizerSF;
  const ImagePath, PersonName: string);
var
  Img, Faces, Feature: TCVMat;
begin
  if not FileExists(ImagePath) then
    raise Exception.Create('Enroll image not found: ' + ImagePath);
  Img := imread(PAnsiChar(AnsiString(ImagePath)), IMREAD_COLOR);
  if Img.empty then
    raise Exception.Create('Cannot read enroll image: ' + ImagePath);
  Faces := TCVMat.Create_0(0, 0, CV_32FC1);
  Det.setInputSize(TCVSize.Create(Img.cols, Img.rows));
  if not ExtractFirstFaceFeature(Det, Rec, Img, Faces, Feature) then
    raise Exception.Create('No face found in enroll image: ' + ImagePath);
  AddEnrolled(PersonName, Feature);
  DemoOutLn(Format('Enrolled: %s from %s', [PersonName, ImagePath]));
end;

procedure DrawOverlay(const Frame: TCVMat; const FaceCount: Integer);
var
  Txt: AnsiString;
begin
  Txt := AnsiString(Format('faces: %d  enrolled: %d  [E=enroll  ESC/Q exit]',
    [FaceCount, Length(GEnrolled)]));
  putText(Frame.Handle, PAnsiChar(Txt), TCVPoint.Create(8, 28),
    FONT_HERSHEY_SIMPLEX, 0.6, TCVScalar.Create(0, 255, 0), 2, LINE_8, False);
end;

procedure RunDemo;
var
  Cap: TCVVideoCapture;
  Det: TCVFaceDetectorYN;
  Rec: TCVFaceRecognizerSF;
  Frame, Faces, Feature, Aligned, FaceRow: TCVMat;
  CameraIndex, Width, Height, Key, LastW, LastH, FaceCount, Frames, I: Integer;
  BackendId: Integer;
  ScoreThreshold: Single;
  DetModel, RecModel, EnrollImage, EnrollName, LabelName, BestName: string;
  Dist: Double;
  X, Y, W, H: Integer;
  Txt: AnsiString;
begin
  DetModel := ResolveFaceDetectorModelPath(DemoCmdValue('model', ''));
  RecModel := ResolveFaceRecognizerModelPath(DemoCmdValue('rec-model', ''));
  EnrollImage := DemoCmdValue('enroll', '');
  EnrollName := DemoCmdValue('name', 'person1');
  CameraIndex := StrToIntDef(DemoCmdValue('camera', '0'), 0);
  Width := StrToIntDef(DemoCmdValue('width', '0'), 0);
  Height := StrToIntDef(DemoCmdValue('height', '0'), 0);
  BackendId := DemoParseBackend(LowerCase(DemoCmdValue('backend', '')));
  ScoreThreshold := StrToFloatDef(DemoCmdValue('score', '0.7'), 0.7);

  DemoOutLn('OpenCV 5.0 Webcam Face Identification');
  DemoOutLn('Options: --model=  --rec-model=  --enroll=photo.jpg --name=Alice');
  DemoOutLn('         --camera=0 --score=0.7  Press E to enroll current face.');
  DemoOutLn('');

  Det := LoadDetector(DetModel, ScoreThreshold);
  Rec := LoadRecognizer(RecModel);
  if EnrollImage <> '' then
    EnrollFromImage(Det, Rec, EnrollImage, EnrollName);

  Cap := DemoOpenCamera(CameraIndex, BackendId);
  if Width > 0 then
    Cap.setProp(CAP_PROP_FRAME_WIDTH, Width);
  if Height > 0 then
    Cap.setProp(CAP_PROP_FRAME_HEIGHT, Height);

  Frame := TCVMat.Create_0(0, 0, CV_8UC3);
  Faces := TCVMat.Create_0(0, 0, CV_32FC1);
  Feature := TCVMat.Create_0(0, 0, CV_32FC1);
  Aligned := TCVMat.Create_0(0, 0, CV_8UC3);
  namedWindow(PAnsiChar(AnsiString(WIN_NAME)), WINDOW_AUTOSIZE);

  LastW := -1;
  LastH := -1;
  Frames := 0;

  while True do
  begin
    if not Cap.read(Frame) then
      Break;

    if (Frame.cols <> LastW) or (Frame.rows <> LastH) then
    begin
      LastW := Frame.cols;
      LastH := Frame.rows;
      Det.setInputSize(TCVSize.Create(LastW, LastH));
    end;

    FaceCount := Det.detect(Frame.Handle, Faces.Handle);
    if FaceCount > 0 then
    begin
      drawDetectedFaces(Frame.Handle, Faces);
      if Length(GEnrolled) > 0 then
      begin
        for I := 0 to FaceCount - 1 do
        begin
          FaceRow := Faces.row(I);
          Rec.alignCrop(Frame.Handle, FaceRow.Handle, Aligned.Handle);
          Rec.feature(Aligned.Handle, Feature.Handle);
          Dist := IdentifyFace(Rec, Feature, BestName);
          X := Trunc(ReadFaceFloat(Faces, I, FACE_IDX_X));
          Y := Trunc(ReadFaceFloat(Faces, I, FACE_IDX_Y));
          W := Trunc(ReadFaceFloat(Faces, I, FACE_IDX_W));
          H := Trunc(ReadFaceFloat(Faces, I, FACE_IDX_H));
          if Dist <= FACE_REC_MATCH_THRESHOLD then
            LabelName := BestName
          else
            LabelName := 'unknown';
          Txt := AnsiString(Format('%s (%.2f)', [LabelName, Dist]));
          putText(Frame.Handle, PAnsiChar(Txt), TCVPoint.Create(X, Max(20, Y - 8)),
            FONT_HERSHEY_SIMPLEX, 0.55, TCVScalar.Create(255, 255, 0), 2, LINE_8, False);
        end;
      end;
    end;

    DrawOverlay(Frame, FaceCount);
    imshow(PAnsiChar(AnsiString(WIN_NAME)), Frame.Handle);
    Inc(Frames);

    Key := waitKey(1);
    if Key in [27, Ord('q'), Ord('Q')] then
      Break;
    if (Key in [Ord('e'), Ord('E')]) and (FaceCount > 0) and (Length(GEnrolled) < MAX_ENROLLED) then
    begin
      if ExtractFirstFaceFeature(Det, Rec, Frame, Faces, Feature) then
      begin
        AddEnrolled(Format('live%d', [Length(GEnrolled) + 1]), Feature);
        DemoOutLn(Format('Live enrolled face #%d', [Length(GEnrolled)]));
      end;
    end;
  end;

  DemoOutLn(Format('Frames processed: %d', [Frames]));
  destroyAllWindows;
  ClearEnrolled;
end;

begin
  try
    RunDemo;
  except
    on E: Exception do
    begin
      DemoOutLn('ERROR: ' + E.Message);
      destroyAllWindows;
      ClearEnrolled;
      ExitCode := 1;
    end;
  end;
end.
