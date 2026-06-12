unit OpenCV5.Dnn;

interface

uses
  OpenCV5.Core,
  OpenCV5.Types;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

  SOFTNMS_LINEAR = 1;
  SOFTNMS_GAUSSIAN = 2;

type
  TCVNet = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FModelPath: AnsiString;
    FConfigPath: AnsiString;
    FBackendId: Integer;
    FTargetId: Integer;
    procedure ReleaseHandle;
    procedure CreateOwned;
  public
    class operator Initialize(out Dest: TCVNet);
    class operator Finalize(var Dest: TCVNet);
    class operator Assign(var Dest: TCVNet; const [ref] Src: TCVNet);
    class function readNet(const modelPath, configPath: PAnsiChar;
      const backendId: Integer = DNN_BACKEND_DEFAULT;
      const targetId: Integer = DNN_TARGET_CPU): TCVNet; static;
    class function readNetFromONNX(const modelPath: PAnsiChar;
      const backendId: Integer = DNN_BACKEND_DEFAULT;
      const targetId: Integer = DNN_TARGET_CPU): TCVNet; static;
    class function readNetFromTensorflow(const modelPath, configPath: PAnsiChar;
      const backendId: Integer = DNN_BACKEND_DEFAULT;
      const targetId: Integer = DNN_TARGET_CPU): TCVNet; static;
    class function readNetFromTFLite(const modelPath: PAnsiChar;
      const engine: Integer = 0;
      const backendId: Integer = DNN_BACKEND_DEFAULT;
      const targetId: Integer = DNN_TARGET_CPU): TCVNet; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVNet; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function empty: Boolean;
    procedure setPreferableBackend(const backendId: Integer);
    procedure setPreferableTarget(const targetId: Integer);
    procedure setInput(const blob: Pointer; const name: PAnsiChar; const scale: Double; const mean: TCVScalar); overload;
    procedure setInput(const blob: Pointer); overload;
    function forwardOutput(const outputName: PAnsiChar = nil): TCVMat;
    function forwardMulti(const outputNames: array of AnsiString; out outputs: array of TCVMat): Integer;
    function getLayerNames: string;
    function getPerfProfile(out timings: TCVMat): Int64;
    function getUnconnectedOutLayersNames: string;
  end;

  TCVDetectionModel = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    procedure ReleaseHandle;
  public
    class operator Initialize(out Dest: TCVDetectionModel);
    class operator Finalize(var Dest: TCVDetectionModel);
    class function Create(const modelPath, configPath: PAnsiChar): TCVDetectionModel; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure setInputSize(const width, height: Integer);
    function detect(const frame, classIds, confidences, boxes: Pointer;
      const confThreshold: Single = 0.5; const nmsThreshold: Single = 0.0): Integer;
  end;

  TCVClassificationModel = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    procedure ReleaseHandle;
  public
    class operator Initialize(out Dest: TCVClassificationModel);
    class operator Finalize(var Dest: TCVClassificationModel);
    class function Create(const modelPath, configPath: PAnsiChar): TCVClassificationModel; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure setInputSize(const width, height: Integer);
    function classify(const frame: Pointer; out classId: Integer; out conf: Single): Boolean;
  end;

  TCVSegmentationModel = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    procedure ReleaseHandle;
  public
    class operator Initialize(out Dest: TCVSegmentationModel);
    class operator Finalize(var Dest: TCVSegmentationModel);
    class function Create(const modelPath, configPath: PAnsiChar): TCVSegmentationModel; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure setInputSize(const width, height: Integer);
    function segment(const frame, mask: Pointer): Boolean;
  end;

  TCVTextDetectionEAST = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    procedure ReleaseHandle;
  public
    class operator Initialize(out Dest: TCVTextDetectionEAST);
    class operator Finalize(var Dest: TCVTextDetectionEAST);
    class function Create(const modelPath, configPath: PAnsiChar): TCVTextDetectionEAST; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure setInputSize(const width, height: Integer);
    function detectText(const frame, boxes, confidences: Pointer;
      const confThreshold, nmsThreshold: Single): Integer;
  end;

  TCVTextDetectionDB = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    procedure ReleaseHandle;
  public
    class operator Initialize(out Dest: TCVTextDetectionDB);
    class operator Finalize(var Dest: TCVTextDetectionDB);
    class function Create(const modelPath, configPath: PAnsiChar): TCVTextDetectionDB; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure setInputSize(const width, height: Integer);
    function detectText(const frame, polygons, confidences: Pointer;
      const confThreshold: Single = 0.3): Integer;
  end;

function blobFromImage(const image: Pointer; const scalefactor: Double;
  const size: TCVSize; const mean: TCVScalar; const swapRB, crop: Boolean): TCVMat; overload;
function blobFromImage(const image: Pointer): TCVMat; overload;
function blobFromImages(const images: array of TCVMat; const scalefactor: Double;
  const size: TCVSize; const mean: TCVScalar; const swapRB, crop: Boolean): TCVMat; overload;
function NMSBoxes(const bboxes, scores, indices: Pointer;
  const scoreThreshold, nmsThreshold: Single; const eta: Single = 1.0;
  const topK: Integer = 0): Integer;

function softNMSBoxes(const bboxes, scores, updatedScores, indices: Pointer;
  const scoreThreshold, nmsThreshold: Single; const topK: Integer = 0;
  const sigma: Single = 0.5; const method: Integer = SOFTNMS_GAUSSIAN): Integer;

implementation

uses
  System.Classes,
  System.SysUtils;

function Dnn_readNet(model, config: PAnsiChar): Pointer; stdcall; external OpenCVLib delayed;
function Dnn_readNetFromONNX(model: PAnsiChar): Pointer; stdcall; external OpenCVLib delayed;
function Dnn_readNetFromTensorflow(model, config: PAnsiChar): Pointer; stdcall; external OpenCVLib delayed;
function Dnn_readNetFromTFLite(model: PAnsiChar; engine: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Dnn_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function Dnn_empty(self: Pointer): Boolean; stdcall; external OpenCVLib delayed;
procedure Dnn_setPreferableBackend(self: Pointer; backendId: Integer); stdcall; external OpenCVLib delayed;
procedure Dnn_setPreferableTarget(self: Pointer; targetId: Integer); stdcall; external OpenCVLib delayed;
procedure Dnn_setInput(self: Pointer; blob: Pointer; name: PAnsiChar; scale: Double; mean: Pointer); stdcall; external OpenCVLib delayed;
function Dnn_forward(self: Pointer; outputName: PAnsiChar): Pointer; stdcall; external OpenCVLib delayed;
function Dnn_blobFromImage(image: Pointer; scalefactor: Double; size: Pointer; mean: Pointer;
  swapRB, crop: Boolean): Pointer; stdcall; external OpenCVLib delayed;
function Dnn_blobFromImages(images: Pointer; count: Integer; scalefactor: Double; size: Pointer;
  mean: Pointer; swapRB, crop: Boolean): Pointer; stdcall; external OpenCVLib delayed;
function Dnn_NMSBoxes(bboxes, scores: Pointer; scoreThreshold, nmsThreshold: Single;
  indices: Pointer; eta: Single; topK: Integer): Integer; stdcall; external OpenCVLib delayed;
function Dnn_softNMSBoxes(bboxes, scores, updatedScores: Pointer;
  scoreThreshold, nmsThreshold: Single; indices: Pointer;
  topK: Integer; sigma: Single; method: Integer): Integer; stdcall; external OpenCVLib delayed;
function Dnn_getLayerNames(self: Pointer; buffer: PAnsiChar; bufferSize: Integer): Integer; stdcall; external OpenCVLib delayed;
function Dnn_getPerfProfile(self: Pointer; timingsOut: Pointer): Int64; stdcall; external OpenCVLib delayed;
function Dnn_forwardMulti(self: Pointer; outputNames: PPAnsiChar; nameCount: Integer;
  outputMats: Pointer; maxOutputs: Integer): Integer; stdcall; external OpenCVLib delayed;
function Dnn_DetectionModel_Create(modelPath, configPath: PAnsiChar): Pointer; stdcall; external OpenCVLib delayed;
procedure Dnn_DetectionModel_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Dnn_DetectionModel_setInputSize(self: Pointer; width, height: Integer); stdcall; external OpenCVLib delayed;
function Dnn_DetectionModel_detect(self, frame, classIds, confidences, boxes: Pointer;
  confThreshold, nmsThreshold: Single): Integer; stdcall; external OpenCVLib delayed;
function Dnn_getUnconnectedOutLayersNames(self: Pointer; buffer: PAnsiChar; bufferSize: Integer): Integer; stdcall; external OpenCVLib delayed;
function Dnn_ClassificationModel_Create(modelPath, configPath: PAnsiChar): Pointer; stdcall; external OpenCVLib delayed;
procedure Dnn_ClassificationModel_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Dnn_ClassificationModel_setInputSize(self: Pointer; width, height: Integer); stdcall; external OpenCVLib delayed;
function Dnn_ClassificationModel_classify(self, frame: Pointer; classId: PInteger; conf: PSingle): Integer; stdcall; external OpenCVLib delayed;
function Dnn_SegmentationModel_Create(modelPath, configPath: PAnsiChar): Pointer; stdcall; external OpenCVLib delayed;
procedure Dnn_SegmentationModel_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Dnn_SegmentationModel_setInputSize(self: Pointer; width, height: Integer); stdcall; external OpenCVLib delayed;
function Dnn_SegmentationModel_segment(self, frame, mask: Pointer): Integer; stdcall; external OpenCVLib delayed;
function Dnn_TextDetectionEAST_Create(modelPath, configPath: PAnsiChar): Pointer; stdcall; external OpenCVLib delayed;
procedure Dnn_TextDetectionEAST_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Dnn_TextDetectionEAST_setInputSize(self: Pointer; width, height: Integer); stdcall; external OpenCVLib delayed;
function Dnn_TextDetectionEAST_detect(self, frame, boxes, confidences: Pointer;
  confThreshold, nmsThreshold: Single): Integer; stdcall; external OpenCVLib delayed;

function Dnn_TextDetectionDB_Create(modelPath, configPath: PAnsiChar): Pointer; stdcall; external OpenCVLib delayed;
procedure Dnn_TextDetectionDB_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Dnn_TextDetectionDB_setInputSize(self: Pointer; width, height: Integer); stdcall; external OpenCVLib delayed;
function Dnn_TextDetectionDB_detect(self, frame, polygons, confidences: Pointer;
  confThreshold: Single): Integer; stdcall; external OpenCVLib delayed;

function blobFromImage(const image: Pointer; const scalefactor: Double;
  const size: TCVSize; const mean: TCVScalar; const swapRB, crop: Boolean): TCVMat;
var
  MeanCopy: TCVScalar;
begin
  MeanCopy := mean;
  Result := TCVMat.FromHandle(Dnn_blobFromImage(image, scalefactor, @size, @MeanCopy, swapRB, crop));
end;

function blobFromImage(const image: Pointer): TCVMat;
var
  EmptySize: TCVSize;
  ZeroMean: TCVScalar;
begin
  EmptySize := TCVSize.Create(0, 0);
  ZeroMean := TCVScalar.Create(0, 0, 0, 0);
  Result := blobFromImage(image, 1.0, EmptySize, ZeroMean, False, False);
end;

function blobFromImages(const images: array of TCVMat; const scalefactor: Double;
  const size: TCVSize; const mean: TCVScalar; const swapRB, crop: Boolean): TCVMat;
var
  Handles: array of Pointer;
  I: Integer;
  MeanCopy: TCVScalar;
begin
  SetLength(Handles, Length(images));
  for I := 0 to High(images) do
    Handles[I] := images[I].Handle;
  MeanCopy := mean;
  if Length(Handles) = 0 then
    Exit(TCVMat.Create_0(0, 0, CV_32F));
  Result := TCVMat.FromHandle(Dnn_blobFromImages(@Handles[0], Length(Handles),
    scalefactor, @size, @MeanCopy, swapRB, crop));
end;

function NMSBoxes(const bboxes, scores, indices: Pointer;
  const scoreThreshold, nmsThreshold: Single; const eta: Single; const topK: Integer): Integer;
begin
  Result := Dnn_NMSBoxes(bboxes, scores, scoreThreshold, nmsThreshold, indices, eta, topK);
end;

function softNMSBoxes(const bboxes, scores, updatedScores, indices: Pointer;
  const scoreThreshold, nmsThreshold: Single; const topK: Integer;
  const sigma: Single; const method: Integer): Integer;
begin
  Result := Dnn_softNMSBoxes(bboxes, scores, updatedScores, scoreThreshold, nmsThreshold,
    indices, topK, sigma, method);
end;

function ParseNullSeparatedNames(const Buffer: PAnsiChar): string;
var
  P: PAnsiChar;
  Names: TStringList;
begin
  Result := '';
  if Buffer = nil then
    Exit;
  Names := TStringList.Create;
  try
    P := Buffer;
    while P^ <> #0 do
    begin
      Names.Add(string(P));
      Inc(P, Length(P) + 1);
    end;
    Result := Trim(Names.Text);
  finally
    Names.Free;
  end;
end;

{ TCVNet }

procedure TCVNet.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Dnn_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVNet.CreateOwned;
begin
  ReleaseHandle;
  FHandle := Dnn_readNet(PAnsiChar(FModelPath), PAnsiChar(FConfigPath));
  if FHandle <> nil then
  begin
    Dnn_setPreferableBackend(FHandle, FBackendId);
    Dnn_setPreferableTarget(FHandle, FTargetId);
  end;
  FOwnsHandle := True;
end;

class operator TCVNet.Initialize(out Dest: TCVNet);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FModelPath := '';
  Dest.FConfigPath := '';
  Dest.FBackendId := DNN_BACKEND_DEFAULT;
  Dest.FTargetId := DNN_TARGET_CPU;
end;

class operator TCVNet.Finalize(var Dest: TCVNet);
begin
  Dest.ReleaseHandle;
end;

class operator TCVNet.Assign(var Dest: TCVNet; const [ref] Src: TCVNet);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FModelPath := Src.FModelPath;
  Dest.FConfigPath := Src.FConfigPath;
  Dest.FBackendId := Src.FBackendId;
  Dest.FTargetId := Src.FTargetId;
  if Src.FOwnsHandle then
    Dest.CreateOwned
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVNet.readNet(const modelPath, configPath: PAnsiChar;
  const backendId, targetId: Integer): TCVNet;
begin
  if modelPath <> nil then
    Result.FModelPath := modelPath
  else
    Result.FModelPath := '';
  if configPath <> nil then
    Result.FConfigPath := configPath
  else
    Result.FConfigPath := '';
  Result.FBackendId := backendId;
  Result.FTargetId := targetId;
  Result.FHandle := Dnn_readNet(PAnsiChar(Result.FModelPath), PAnsiChar(Result.FConfigPath));
  if Result.FHandle <> nil then
  begin
    Dnn_setPreferableBackend(Result.FHandle, backendId);
    Dnn_setPreferableTarget(Result.FHandle, targetId);
  end;
  Result.FOwnsHandle := True;
end;

class function TCVNet.readNetFromONNX(const modelPath: PAnsiChar;
  const backendId, targetId: Integer): TCVNet;
begin
  if modelPath <> nil then
    Result.FModelPath := modelPath
  else
    Result.FModelPath := '';
  Result.FConfigPath := '';
  Result.FBackendId := backendId;
  Result.FTargetId := targetId;
  Result.FHandle := Dnn_readNetFromONNX(PAnsiChar(Result.FModelPath));
  if Result.FHandle <> nil then
  begin
    Dnn_setPreferableBackend(Result.FHandle, backendId);
    Dnn_setPreferableTarget(Result.FHandle, targetId);
  end;
  Result.FOwnsHandle := True;
end;

class function TCVNet.readNetFromTensorflow(const modelPath, configPath: PAnsiChar;
  const backendId, targetId: Integer): TCVNet;
begin
  if modelPath <> nil then
    Result.FModelPath := modelPath
  else
    Result.FModelPath := '';
  if configPath <> nil then
    Result.FConfigPath := configPath
  else
    Result.FConfigPath := '';
  Result.FBackendId := backendId;
  Result.FTargetId := targetId;
  Result.FHandle := Dnn_readNetFromTensorflow(PAnsiChar(Result.FModelPath),
    PAnsiChar(Result.FConfigPath));
  if Result.FHandle <> nil then
  begin
    Dnn_setPreferableBackend(Result.FHandle, backendId);
    Dnn_setPreferableTarget(Result.FHandle, targetId);
  end;
  Result.FOwnsHandle := True;
end;

class function TCVNet.readNetFromTFLite(const modelPath: PAnsiChar;
  const engine, backendId, targetId: Integer): TCVNet;
begin
  if modelPath <> nil then
    Result.FModelPath := modelPath
  else
    Result.FModelPath := '';
  Result.FConfigPath := '';
  Result.FBackendId := backendId;
  Result.FTargetId := targetId;
  Result.FHandle := Dnn_readNetFromTFLite(PAnsiChar(Result.FModelPath), engine);
  if Result.FHandle <> nil then
  begin
    Dnn_setPreferableBackend(Result.FHandle, backendId);
    Dnn_setPreferableTarget(Result.FHandle, targetId);
  end;
  Result.FOwnsHandle := True;
end;

class function TCVNet.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVNet;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FModelPath := '';
  Result.FConfigPath := '';
  Result.FBackendId := DNN_BACKEND_DEFAULT;
  Result.FTargetId := DNN_TARGET_CPU;
end;

procedure TCVNet.Release;
begin
  ReleaseHandle;
end;

function TCVNet.empty: Boolean;
begin
  if FHandle = nil then
    Exit(True);
  Result := Dnn_empty(FHandle);
end;

procedure TCVNet.setPreferableBackend(const backendId: Integer);
begin
  FBackendId := backendId;
  if FHandle <> nil then
    Dnn_setPreferableBackend(FHandle, backendId);
end;

procedure TCVNet.setPreferableTarget(const targetId: Integer);
begin
  FTargetId := targetId;
  if FHandle <> nil then
    Dnn_setPreferableTarget(FHandle, targetId);
end;

procedure TCVNet.setInput(const blob: Pointer; const name: PAnsiChar;
  const scale: Double; const mean: TCVScalar);
var
  MeanCopy: TCVScalar;
begin
  MeanCopy := mean;
  if FHandle <> nil then
    Dnn_setInput(FHandle, blob, name, scale, @MeanCopy);
end;

procedure TCVNet.setInput(const blob: Pointer);
begin
  setInput(blob, nil, 1.0, TCVScalar.Create(0, 0, 0, 0));
end;

function TCVNet.forwardOutput(const outputName: PAnsiChar): TCVMat;
begin
  Result := TCVMat.FromHandle(Dnn_forward(FHandle, outputName));
end;

function TCVNet.forwardMulti(const outputNames: array of AnsiString; out outputs: array of TCVMat): Integer;
var
  NamePtrs: array of PAnsiChar;
  MatPtrs: array of Pointer;
  I: Integer;
begin
  Result := 0;
  if (FHandle = nil) or (Length(outputNames) = 0) or (Length(outputs) = 0) then
    Exit;
  SetLength(NamePtrs, Length(outputNames));
  SetLength(MatPtrs, Length(outputs));
  for I := 0 to High(outputNames) do
    NamePtrs[I] := PAnsiChar(outputNames[I]);
  for I := 0 to High(outputs) do
    MatPtrs[I] := outputs[I].Handle;
  Result := Dnn_forwardMulti(FHandle, @NamePtrs[0], Length(NamePtrs), @MatPtrs[0], Length(MatPtrs));
end;

function TCVNet.getLayerNames: string;
const
  MAX_NAMES = 65536;
var
  Buffer: array[0..MAX_NAMES - 1] of AnsiChar;
begin
  FillChar(Buffer, SizeOf(Buffer), 0);
  if (FHandle = nil) or (Dnn_getLayerNames(FHandle, @Buffer[0], MAX_NAMES) <= 0) then
    Exit('');
  Result := ParseNullSeparatedNames(@Buffer[0]);
end;

function TCVNet.getPerfProfile(out timings: TCVMat): Int64;
begin
  Result := Dnn_getPerfProfile(FHandle, timings.Handle);
end;

function TCVNet.getUnconnectedOutLayersNames: string;
const
  MAX_NAMES = 65536;
var
  Buffer: array[0..MAX_NAMES - 1] of AnsiChar;
begin
  FillChar(Buffer, SizeOf(Buffer), 0);
  if (FHandle = nil) or (Dnn_getUnconnectedOutLayersNames(FHandle, @Buffer[0], MAX_NAMES) <= 0) then
    Exit('');
  Result := ParseNullSeparatedNames(@Buffer[0]);
end;

{ TCVDetectionModel }

procedure TCVDetectionModel.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Dnn_DetectionModel_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

class operator TCVDetectionModel.Initialize(out Dest: TCVDetectionModel);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
end;

class operator TCVDetectionModel.Finalize(var Dest: TCVDetectionModel);
begin
  Dest.ReleaseHandle;
end;

class function TCVDetectionModel.Create(const modelPath, configPath: PAnsiChar): TCVDetectionModel;
begin
  Result.FHandle := Dnn_DetectionModel_Create(modelPath, configPath);
  Result.FOwnsHandle := True;
end;

procedure TCVDetectionModel.Release;
begin
  ReleaseHandle;
end;

procedure TCVDetectionModel.setInputSize(const width, height: Integer);
begin
  if FHandle <> nil then
    Dnn_DetectionModel_setInputSize(FHandle, width, height);
end;

function TCVDetectionModel.detect(const frame, classIds, confidences, boxes: Pointer;
  const confThreshold, nmsThreshold: Single): Integer;
begin
  if FHandle = nil then
    Exit(0);
  Result := Dnn_DetectionModel_detect(FHandle, frame, classIds, confidences, boxes,
    confThreshold, nmsThreshold);
end;

{ TCVClassificationModel }

procedure TCVClassificationModel.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Dnn_ClassificationModel_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

class operator TCVClassificationModel.Initialize(out Dest: TCVClassificationModel);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
end;

class operator TCVClassificationModel.Finalize(var Dest: TCVClassificationModel);
begin
  Dest.ReleaseHandle;
end;

class function TCVClassificationModel.Create(const modelPath, configPath: PAnsiChar): TCVClassificationModel;
begin
  Result.FHandle := Dnn_ClassificationModel_Create(modelPath, configPath);
  Result.FOwnsHandle := True;
end;

procedure TCVClassificationModel.Release;
begin
  ReleaseHandle;
end;

procedure TCVClassificationModel.setInputSize(const width, height: Integer);
begin
  if FHandle <> nil then
    Dnn_ClassificationModel_setInputSize(FHandle, width, height);
end;

function TCVClassificationModel.classify(const frame: Pointer; out classId: Integer;
  out conf: Single): Boolean;
begin
  Result := False;
  if FHandle = nil then
    Exit;
  Result := Dnn_ClassificationModel_classify(FHandle, frame, @classId, @conf) > 0;
end;

{ TCVSegmentationModel }

procedure TCVSegmentationModel.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Dnn_SegmentationModel_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

class operator TCVSegmentationModel.Initialize(out Dest: TCVSegmentationModel);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
end;

class operator TCVSegmentationModel.Finalize(var Dest: TCVSegmentationModel);
begin
  Dest.ReleaseHandle;
end;

class function TCVSegmentationModel.Create(const modelPath, configPath: PAnsiChar): TCVSegmentationModel;
begin
  Result.FHandle := Dnn_SegmentationModel_Create(modelPath, configPath);
  Result.FOwnsHandle := True;
end;

procedure TCVSegmentationModel.Release;
begin
  ReleaseHandle;
end;

procedure TCVSegmentationModel.setInputSize(const width, height: Integer);
begin
  if FHandle <> nil then
    Dnn_SegmentationModel_setInputSize(FHandle, width, height);
end;

function TCVSegmentationModel.segment(const frame, mask: Pointer): Boolean;
begin
  if FHandle = nil then
    Exit(False);
  Result := Dnn_SegmentationModel_segment(FHandle, frame, mask) > 0;
end;

{ TCVTextDetectionEAST }

procedure TCVTextDetectionEAST.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Dnn_TextDetectionEAST_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

class operator TCVTextDetectionEAST.Initialize(out Dest: TCVTextDetectionEAST);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
end;

class operator TCVTextDetectionEAST.Finalize(var Dest: TCVTextDetectionEAST);
begin
  Dest.ReleaseHandle;
end;

class function TCVTextDetectionEAST.Create(const modelPath, configPath: PAnsiChar): TCVTextDetectionEAST;
begin
  Result.FHandle := Dnn_TextDetectionEAST_Create(modelPath, configPath);
  Result.FOwnsHandle := True;
end;

procedure TCVTextDetectionEAST.Release;
begin
  ReleaseHandle;
end;

procedure TCVTextDetectionEAST.setInputSize(const width, height: Integer);
begin
  if FHandle <> nil then
    Dnn_TextDetectionEAST_setInputSize(FHandle, width, height);
end;

function TCVTextDetectionEAST.detectText(const frame, boxes, confidences: Pointer;
  const confThreshold, nmsThreshold: Single): Integer;
begin
  if FHandle = nil then
    Exit(0);
  Result := Dnn_TextDetectionEAST_detect(FHandle, frame, boxes, confidences,
    confThreshold, nmsThreshold);
end;

{ TCVTextDetectionDB }

procedure TCVTextDetectionDB.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Dnn_TextDetectionDB_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

class operator TCVTextDetectionDB.Initialize(out Dest: TCVTextDetectionDB);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
end;

class operator TCVTextDetectionDB.Finalize(var Dest: TCVTextDetectionDB);
begin
  Dest.ReleaseHandle;
end;

class function TCVTextDetectionDB.Create(const modelPath, configPath: PAnsiChar): TCVTextDetectionDB;
begin
  Result.FHandle := Dnn_TextDetectionDB_Create(modelPath, configPath);
  Result.FOwnsHandle := True;
end;

procedure TCVTextDetectionDB.Release;
begin
  ReleaseHandle;
end;

procedure TCVTextDetectionDB.setInputSize(const width, height: Integer);
begin
  if FHandle <> nil then
    Dnn_TextDetectionDB_setInputSize(FHandle, width, height);
end;

function TCVTextDetectionDB.detectText(const frame, polygons, confidences: Pointer;
  const confThreshold: Single): Integer;
begin
  if FHandle = nil then
    Exit(0);
  Result := Dnn_TextDetectionDB_detect(FHandle, frame, polygons, confidences, confThreshold);
end;

end.
