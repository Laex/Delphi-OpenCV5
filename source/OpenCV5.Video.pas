unit OpenCV5.Video;

interface

uses
  OpenCV5.Core;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

type
  TCVMOG2 = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FHistory: Integer;
    FVarThreshold: Double;
    FDetectShadows: Boolean;
    procedure ReleaseHandle;
    procedure CreateOwned;
  public
    class operator Initialize(out Dest: TCVMOG2);
    class operator Finalize(var Dest: TCVMOG2);
    class operator Assign(var Dest: TCVMOG2; const [ref] Src: TCVMOG2);
    class function Create(const history: Integer = 500; const varThreshold: Double = 16;
      const detectShadows: Boolean = True): TCVMOG2; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVMOG2; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure apply(const image, fgmask: Pointer; const learningRate: Double = -1);
  end;

  TCVKNN = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FHistory: Integer;
    FDist2Threshold: Double;
    FDetectShadows: Boolean;
    procedure ReleaseHandle;
    procedure CreateOwned;
  public
    class operator Initialize(out Dest: TCVKNN);
    class operator Finalize(var Dest: TCVKNN);
    class operator Assign(var Dest: TCVKNN; const [ref] Src: TCVKNN);
    class function Create(const history: Integer = 500; const dist2Threshold: Double = 400;
      const detectShadows: Boolean = True): TCVKNN; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVKNN; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure apply(const image, fgmask: Pointer; const learningRate: Double = -1);
  end;

function buildOpticalFlowPyramid(const img: Pointer; const pyramid: Pointer; const winSize: TCVSize; const maxLevel: Integer; const withDerivatives: Boolean; const pyrBorder: Integer; const derivBorder: Integer; const tryReuseInputImage: Boolean): Integer;
procedure calcOpticalFlowPyrLK(const prevImg: Pointer; const nextImg: Pointer; const prevPts: Pointer; const nextPts: Pointer; const status: Pointer; const err: Pointer; const winSize: TCVSize; const maxLevel: Integer; const criteria: TCVTermCriteria; const flags: Integer; const minEigThreshold: Double);
procedure calcOpticalFlowFarneback(const prev: Pointer; const next: Pointer; const flow: Pointer; const pyr_scale: Double; const levels: Integer; const winsize: Integer; const iterations: Integer; const poly_n: Integer; const poly_sigma: Double; const flags: Integer);

implementation

function Video_createBackgroundSubtractorMOG2(history: Integer; varThreshold: Double;
  detectShadows: Boolean): Pointer; stdcall; external OpenCVLib delayed;
procedure Video_MOG2_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Video_MOG2_apply(self: Pointer; image, fgmask: Pointer; learningRate: Double); stdcall; external OpenCVLib delayed;
function Video_createBackgroundSubtractorKNN(history: Integer; dist2Threshold: Double;
  detectShadows: Boolean): Pointer; stdcall; external OpenCVLib delayed;
procedure Video_KNN_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Video_KNN_apply(self: Pointer; image, fgmask: Pointer; learningRate: Double); stdcall; external OpenCVLib delayed;

function Video_buildOpticalFlowPyramid(img: Pointer; pyramid: Pointer; winSize: Pointer; maxLevel: Integer; withDerivatives: Boolean; pyrBorder: Integer; derivBorder: Integer; tryReuseInputImage: Boolean): Integer; stdcall; external OpenCVLib delayed;
procedure Video_calcOpticalFlowPyrLK(prevImg: Pointer; nextImg: Pointer; prevPts: Pointer; nextPts: Pointer; status: Pointer; err: Pointer; winSize: Pointer; maxLevel: Integer; criteria: Pointer; flags: Integer; minEigThreshold: Double); stdcall; external OpenCVLib delayed;
procedure Video_calcOpticalFlowFarneback(prev: Pointer; next: Pointer; flow: Pointer; pyr_scale: Double; levels: Integer; winsize: Integer; iterations: Integer; poly_n: Integer; poly_sigma: Double; flags: Integer); stdcall; external OpenCVLib delayed;

{ TCVMOG2 }

procedure TCVMOG2.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Video_MOG2_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVMOG2.CreateOwned;
begin
  ReleaseHandle;
  FHandle := Video_createBackgroundSubtractorMOG2(FHistory, FVarThreshold, FDetectShadows);
  FOwnsHandle := True;
end;

class operator TCVMOG2.Initialize(out Dest: TCVMOG2);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FHistory := 500;
  Dest.FVarThreshold := 16;
  Dest.FDetectShadows := True;
end;

class operator TCVMOG2.Finalize(var Dest: TCVMOG2);
begin
  Dest.ReleaseHandle;
end;

class operator TCVMOG2.Assign(var Dest: TCVMOG2; const [ref] Src: TCVMOG2);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FHistory := Src.FHistory;
  Dest.FVarThreshold := Src.FVarThreshold;
  Dest.FDetectShadows := Src.FDetectShadows;
  if Src.FOwnsHandle then
    Dest.CreateOwned
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVMOG2.Create(const history: Integer; const varThreshold: Double;
  const detectShadows: Boolean): TCVMOG2;
begin
  Result.FHistory := history;
  Result.FVarThreshold := varThreshold;
  Result.FDetectShadows := detectShadows;
  Result.FHandle := Video_createBackgroundSubtractorMOG2(history, varThreshold, detectShadows);
  Result.FOwnsHandle := True;
end;

class function TCVMOG2.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVMOG2;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FHistory := 500;
  Result.FVarThreshold := 16;
  Result.FDetectShadows := True;
end;

procedure TCVMOG2.Release;
begin
  ReleaseHandle;
end;

procedure TCVMOG2.apply(const image, fgmask: Pointer; const learningRate: Double);
begin
  if FHandle <> nil then
    Video_MOG2_apply(FHandle, image, fgmask, learningRate);
end;

{ TCVKNN }

procedure TCVKNN.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Video_KNN_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVKNN.CreateOwned;
begin
  ReleaseHandle;
  FHandle := Video_createBackgroundSubtractorKNN(FHistory, FDist2Threshold, FDetectShadows);
  FOwnsHandle := True;
end;

class operator TCVKNN.Initialize(out Dest: TCVKNN);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FHistory := 500;
  Dest.FDist2Threshold := 400;
  Dest.FDetectShadows := True;
end;

class operator TCVKNN.Finalize(var Dest: TCVKNN);
begin
  Dest.ReleaseHandle;
end;

class operator TCVKNN.Assign(var Dest: TCVKNN; const [ref] Src: TCVKNN);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FHistory := Src.FHistory;
  Dest.FDist2Threshold := Src.FDist2Threshold;
  Dest.FDetectShadows := Src.FDetectShadows;
  if Src.FOwnsHandle then
    Dest.CreateOwned
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVKNN.Create(const history: Integer; const dist2Threshold: Double;
  const detectShadows: Boolean): TCVKNN;
begin
  Result.FHistory := history;
  Result.FDist2Threshold := dist2Threshold;
  Result.FDetectShadows := detectShadows;
  Result.FHandle := Video_createBackgroundSubtractorKNN(history, dist2Threshold, detectShadows);
  Result.FOwnsHandle := True;
end;

class function TCVKNN.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVKNN;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FHistory := 500;
  Result.FDist2Threshold := 400;
  Result.FDetectShadows := True;
end;

procedure TCVKNN.Release;
begin
  ReleaseHandle;
end;

procedure TCVKNN.apply(const image, fgmask: Pointer; const learningRate: Double);
begin
  if FHandle <> nil then
    Video_KNN_apply(FHandle, image, fgmask, learningRate);
end;

function buildOpticalFlowPyramid(const img: Pointer; const pyramid: Pointer; const winSize: TCVSize; const maxLevel: Integer; const withDerivatives: Boolean; const pyrBorder: Integer; const derivBorder: Integer; const tryReuseInputImage: Boolean): Integer;
begin
  Result := Video_buildOpticalFlowPyramid(img, pyramid, @winSize, maxLevel, withDerivatives, pyrBorder, derivBorder, tryReuseInputImage);
end;

procedure calcOpticalFlowPyrLK(const prevImg: Pointer; const nextImg: Pointer; const prevPts: Pointer; const nextPts: Pointer; const status: Pointer; const err: Pointer; const winSize: TCVSize; const maxLevel: Integer; const criteria: TCVTermCriteria; const flags: Integer; const minEigThreshold: Double);
begin
  Video_calcOpticalFlowPyrLK(prevImg, nextImg, prevPts, nextPts, status, err, @winSize, maxLevel, @criteria, flags, minEigThreshold);
end;

procedure calcOpticalFlowFarneback(const prev: Pointer; const next: Pointer; const flow: Pointer; const pyr_scale: Double; const levels: Integer; const winsize: Integer; const iterations: Integer; const poly_n: Integer; const poly_sigma: Double; const flags: Integer);
begin
  Video_calcOpticalFlowFarneback(prev, next, flow, pyr_scale, levels, winsize, iterations, poly_n, poly_sigma, flags);
end;

end.
