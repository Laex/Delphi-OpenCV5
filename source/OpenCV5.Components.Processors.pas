unit OpenCV5.Components.Processors;

{$IFNDEF WIN64}
  {$IFNDEF PACKAGE}
    {$MESSAGE ERROR 'OpenCV 5.0 components are only supported in Win64 applications.'}
  {$ENDIF}
{$ENDIF}

{$POINTERMATH ON}

interface

uses
  System.Classes, System.SysUtils,
  OpenCV5.Core, OpenCV5.Types, OpenCV5.Objdetect, OpenCV5.Components.Base,
  OpenCV5.Utils;

type
  TcvFaceDetector = class(TCVDataProxy)
  private
    FDetector: TCVFaceDetectorYN;
    FModelPath: string;
    FScoreThreshold: Single;
    FNmsThreshold: Single;
    FTopK: Integer;
    FInputWidth: Integer;
    FInputHeight: Integer;
    FInitialized: Boolean;
    procedure SetModelPath(const Value: string);
    procedure SetScoreThreshold(const Value: Single);
    procedure SetNmsThreshold(const Value: Single);
    procedure SetTopK(const Value: Integer);
    procedure SetInputWidth(const Value: Integer);
    procedure SetInputHeight(const Value: Integer);
    procedure CheckInit;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Detect(const Frame: TCVMat; const Faces: TCVMat): Integer;
    class function ComponentPlatforms: Integer;
    procedure TakeMat(const AMat: TCVMat); override;
  published
    property Source;
    property ModelPath: string read FModelPath write SetModelPath;
    property ScoreThreshold: Single read FScoreThreshold write SetScoreThreshold;
    property NmsThreshold: Single read FNmsThreshold write SetNmsThreshold;
    property TopK: Integer read FTopK write SetTopK default 5000;
    property InputWidth: Integer read FInputWidth write SetInputWidth default 320;
    property InputHeight: Integer read FInputHeight write SetInputHeight default 240;
  end;

  TcvFaceRecognizer = class(TCVDataProxy)
  private
    FRecognizer: TCVFaceRecognizerSF;
    FModelPath: string;
    FInitialized: Boolean;
    procedure SetModelPath(const Value: string);
    procedure CheckInit;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function ComponentPlatforms: Integer;
    procedure AlignCrop(const SrcImg, FaceBox, AlignedImg: TCVMat);
    procedure Feature(const AlignedImg, FaceFeature: TCVMat);
    function Match(const Feature1, Feature2: TCVMat; const DisType: Integer = FR_COSINE): Double;
    procedure TakeMat(const AMat: TCVMat); override;
  published
    property Source;
    property ModelPath: string read FModelPath write SetModelPath;
  end;

implementation

uses
  OpenCV5.Imgproc;

{ TcvFaceDetector }

class function TcvFaceDetector.ComponentPlatforms: Integer;
begin
  Result := $0002 or $0800; // pidWin64 ($0002) + pidWin64x ($0800)
end;

constructor TcvFaceDetector.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := True;
  FScoreThreshold := 0.9;
  FNmsThreshold := 0.3;
  FTopK := 5000;
  FInputWidth := 320;
  FInputHeight := 240;
  FInitialized := False;
end;

destructor TcvFaceDetector.Destroy;
begin
  if FInitialized then
    FDetector.Release;
  inherited Destroy;
end;

procedure TcvFaceDetector.CheckInit;
var
  InputSize: TCVSize;
begin
  if FInitialized then
  begin
    InputSize := TCVSize.Create(FInputWidth, FInputHeight);
    FDetector.setInputSize(InputSize);
    Exit;
  end;

  if FModelPath = '' then
    Exit;

  if not FileExists(FModelPath) then
    raise Exception.CreateFmt('Model file not found: %s', [FModelPath]);

  InputSize := TCVSize.Create(FInputWidth, FInputHeight);
  FDetector := TCVFaceDetectorYN.Create(
    PAnsiChar(PathToUTF8(FModelPath)),
    nil,
    InputSize,
    FScoreThreshold,
    FNmsThreshold,
    FTopK
  );
  FInitialized := True;
end;

function TcvFaceDetector.Detect(const Frame: TCVMat; const Faces: TCVMat): Integer;
begin
  CheckInit;
  if not FInitialized then
    raise Exception.Create('Face detector is not initialized. Please specify ModelPath.');
  Result := FDetector.detect(Frame.Handle, Faces.Handle);
end;

procedure TcvFaceDetector.TakeMat(const AMat: TCVMat);
var
  Faces: TCVMat;
  I: Integer;
  P1, P2: TCVPoint;
  Color: TCVScalar;
  FPtr: PSingle;
  X, Y, W, H: Integer;
begin
  if (ComponentState * [csDestroying, csDesigning]) <> [] then
  begin
    NotifyReceiver(AMat);
    Exit;
  end;

  if not Enabled then
  begin
    NotifyReceiver(AMat);
    Exit;
  end;

  if (FModelPath <> '') and not AMat.empty then
  begin
    Faces := TCVMat.Create_0(0, 0, CV_32F);
    try
      if (FInputWidth <> AMat.cols) or (FInputHeight <> AMat.rows) then
      begin
        FInputWidth := AMat.cols;
        FInputHeight := AMat.rows;
        if FInitialized then
        begin
          FDetector.Release;
          FInitialized := False;
        end;
      end;

      Detect(AMat, Faces);

      if Faces.rows > 0 then
      begin
        for I := 0 to Faces.rows - 1 do
        begin
          FPtr := PSingle(Faces.ptr(I));
          X := Round(FPtr[0]);
          Y := Round(FPtr[1]);
          W := Round(FPtr[2]);
          H := Round(FPtr[3]);

          P1 := TCVPoint.Create(X, Y);
          P2 := TCVPoint.Create(X + W, Y + H);
          Color := TCVScalar.Create(0, 255, 0); // Зеленый цвет

          rectangle(AMat.Handle, P1, P2, Color, 2, 8, 0);
        end;
      end;
    except
      // Игнорируем исключения при детекции в реальном времени
    end;
  end;

  NotifyReceiver(AMat);
end;

procedure TcvFaceDetector.SetModelPath(const Value: string);
begin
  if FModelPath <> Value then
  begin
    if FInitialized then
    begin
      FDetector.Release;
      FInitialized := False;
    end;
    FModelPath := Value;
  end;
end;

procedure TcvFaceDetector.SetScoreThreshold(const Value: Single);
begin
  if FScoreThreshold <> Value then
  begin
    FScoreThreshold := Value;
    if FInitialized then
      FDetector.setScoreThreshold(FScoreThreshold);
  end;
end;

procedure TcvFaceDetector.SetNmsThreshold(const Value: Single);
begin
  if FNmsThreshold <> Value then
  begin
    FNmsThreshold := Value;
    if FInitialized then
      FDetector.setNmsThreshold(FNmsThreshold);
  end;
end;

procedure TcvFaceDetector.SetTopK(const Value: Integer);
begin
  if FTopK <> Value then
  begin
    FTopK := Value;
    if FInitialized then
      FDetector.setTopK(FTopK);
  end;
end;

procedure TcvFaceDetector.SetInputWidth(const Value: Integer);
begin
  if FInputWidth <> Value then
    FInputWidth := Value;
end;

procedure TcvFaceDetector.SetInputHeight(const Value: Integer);
begin
  if FInputHeight <> Value then
    FInputHeight := Value;
end;

{ TcvFaceRecognizer }

class function TcvFaceRecognizer.ComponentPlatforms: Integer;
begin
  Result := $0002 or $0800; // pidWin64 ($0002) + pidWin64x ($0800)
end;

constructor TcvFaceRecognizer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := True;
  FInitialized := False;
end;

destructor TcvFaceRecognizer.Destroy;
begin
  if FInitialized then
    FRecognizer.Release;
  inherited Destroy;
end;

procedure TcvFaceRecognizer.CheckInit;
begin
  if FInitialized then
    Exit;

  if FModelPath = '' then
    Exit;

  if not FileExists(FModelPath) then
    raise Exception.CreateFmt('Model file not found: %s', [FModelPath]);

  FRecognizer := TCVFaceRecognizerSF.Create(
    PAnsiChar(PathToUTF8(FModelPath)),
    nil
  );
  FInitialized := True;
end;

procedure TcvFaceRecognizer.TakeMat(const AMat: TCVMat);
begin
  if not Enabled then
  begin
    NotifyReceiver(AMat);
    Exit;
  end;
  NotifyReceiver(AMat); // Распознаватель просто передает кадр без изменений
end;

procedure TcvFaceRecognizer.AlignCrop(const SrcImg, FaceBox, AlignedImg: TCVMat);
begin
  CheckInit;
  if not FInitialized then
    raise Exception.Create('Face recognizer is not initialized. Please specify ModelPath.');
  FRecognizer.alignCrop(SrcImg.Handle, FaceBox.Handle, AlignedImg.Handle);
end;

procedure TcvFaceRecognizer.Feature(const AlignedImg, FaceFeature: TCVMat);
begin
  CheckInit;
  if not FInitialized then
    raise Exception.Create('Face recognizer is not initialized. Please specify ModelPath.');
  FRecognizer.feature(AlignedImg.Handle, FaceFeature.Handle);
end;

function TcvFaceRecognizer.Match(const Feature1, Feature2: TCVMat; const DisType: Integer): Double;
begin
  CheckInit;
  if not FInitialized then
    raise Exception.Create('Face recognizer is not initialized. Please specify ModelPath.');
  Result := FRecognizer.match(Feature1.Handle, Feature2.Handle, DisType);
end;

procedure TcvFaceRecognizer.SetModelPath(const Value: string);
begin
  if FModelPath <> Value then
  begin
    if FInitialized then
    begin
      FRecognizer.Release;
      FInitialized := False;
    end;
    FModelPath := Value;
  end;
end;

end.
