unit OpenCV5.Features2d;

interface

uses
  OpenCV5.Core,
  OpenCV5.Types;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

  MATCH_IDX_QUERY = 0;
  MATCH_IDX_TRAIN = 1;
  MATCH_IDX_IMG = 2;
  MATCH_IDX_DISTANCE = 3;

  KP_IDX_X = 0;
  KP_IDX_Y = 1;
  KP_IDX_SIZE = 2;
  KP_IDX_ANGLE = 3;

type
  TCVORB = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FNFeatures: Integer;
    procedure ReleaseHandle;
    procedure CreateOwned;
  public
    class operator Initialize(out Dest: TCVORB);
    class operator Finalize(var Dest: TCVORB);
    class operator Assign(var Dest: TCVORB; const [ref] Src: TCVORB);
    class function Create(const nfeatures: Integer = 500): TCVORB; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVORB; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function detectAndCompute(const image, mask, keypoints, descriptors: Pointer): Integer;
  end;

  TCVBFMatcher = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FNormType: Integer;
    FCrossCheck: Boolean;
    procedure ReleaseHandle;
    procedure CreateOwned;
  public
    class operator Initialize(out Dest: TCVBFMatcher);
    class operator Finalize(var Dest: TCVBFMatcher);
    class operator Assign(var Dest: TCVBFMatcher; const [ref] Src: TCVBFMatcher);
    class function Create(const normType: Integer = NORM_HAMMING;
      const crossCheck: Boolean = False): TCVBFMatcher; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVBFMatcher; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function match(const queryDescriptors, trainDescriptors, matches: Pointer): Integer;
    function knnMatch(const queryDescriptors, trainDescriptors, matches: Pointer; const k: Integer): Integer;
  end;

  TCVGFTT = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FMaxCorners: Integer;
    FQualityLevel: Double;
    FMinDistance: Double;
    FBlockSize: Integer;
    FUseHarris: Boolean;
    FK: Double;
    procedure ReleaseHandle;
    procedure CreateOwned;
  public
    class operator Initialize(out Dest: TCVGFTT);
    class operator Finalize(var Dest: TCVGFTT);
    class operator Assign(var Dest: TCVGFTT; const [ref] Src: TCVGFTT);
    class function Create(const maxCorners: Integer = 1000; const qualityLevel: Double = 0.01;
      const minDistance: Double = 1; const blockSize: Integer = 3;
      const useHarris: Boolean = False; const k: Double = 0.04): TCVGFTT; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVGFTT; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function detectAndCompute(const image, mask, keypoints, descriptors: Pointer): Integer;
  end;

  TCVSIFT = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FNFeatures: Integer;
    procedure ReleaseHandle;
    procedure CreateOwned;
  public
    class operator Initialize(out Dest: TCVSIFT);
    class operator Finalize(var Dest: TCVSIFT);
    class operator Assign(var Dest: TCVSIFT; const [ref] Src: TCVSIFT);
    class function Create(const nfeatures: Integer = 0): TCVSIFT; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVSIFT; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function detectAndCompute(const image, mask, keypoints, descriptors: Pointer): Integer;
  end;

  TCVMSER = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FDelta: Integer;
    FMinArea: Integer;
    FMaxArea: Integer;
    procedure ReleaseHandle;
    procedure CreateOwned;
  public
    class operator Initialize(out Dest: TCVMSER);
    class operator Finalize(var Dest: TCVMSER);
    class operator Assign(var Dest: TCVMSER; const [ref] Src: TCVMSER);
    class function Create(const delta: Integer = 5; const minArea: Integer = 60;
      const maxArea: Integer = 14400): TCVMSER; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVMSER; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function detectAndCompute(const image, mask, keypoints, descriptors: Pointer): Integer;
  end;

  TCVFAST = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FThreshold: Integer;
    FNonmaxSuppression: Boolean;
    FType: Integer;
    procedure ReleaseHandle;
  public
    class operator Initialize(out Dest: TCVFAST);
    class operator Finalize(var Dest: TCVFAST);
    class function Create(const threshold: Integer = 10;
      const nonmaxSuppression: Boolean = True; const detectorType: Integer = FAST_TYPE_9_16): TCVFAST; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function detectAndCompute(const image, mask, keypoints, descriptors: Pointer): Integer;
  end;

  TCVFlannMatcher = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FIndexParamsType: Integer;
    procedure ReleaseHandle;
    procedure CreateOwned;
  public
    class operator Initialize(out Dest: TCVFlannMatcher);
    class operator Finalize(var Dest: TCVFlannMatcher);
    class operator Assign(var Dest: TCVFlannMatcher; const [ref] Src: TCVFlannMatcher);
    class function Create(const indexParamsType: Integer = FLANN_INDEX_KDTREE): TCVFlannMatcher; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVFlannMatcher; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function match(const queryDescriptors, trainDescriptors, matches: Pointer): Integer;
    function knnMatch(const queryDescriptors, trainDescriptors, matches: Pointer; const k: Integer): Integer;
  end;

procedure goodFeaturesToTrack(const image, corners: Pointer; const maxCorners: Integer;
  const qualityLevel, minDistance: Double; const mask: Pointer = nil;
  const blockSize: Integer = 3; const useHarris: Boolean = False; const k: Double = 0.04);

function drawFeatureMatches(const img1, img2, keypoints1, keypoints2, matches: Pointer;
  const outImg: Pointer; const maxMatches: Integer = 50): Integer;

procedure drawKeypoints(const image, keypoints, outImage: Pointer; const flags: Integer = 0);

procedure drawMatches(const img1, keypoints1, img2, keypoints2, matches, outImg: Pointer;
  const maxMatches: Integer = 50);

function filterMatchesByRatio(const knnMatches: Pointer; const k: Integer;
  const ratio: Single; const goodMatches: Pointer): Integer;

implementation

function Features2d_ORB_Create(nfeatures: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Features2d_ORB_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function Features2d_ORB_detectAndCompute(self, image, mask, keypoints, descriptors: Pointer): Integer; stdcall; external OpenCVLib delayed;

procedure Features2d_goodFeaturesToTrack(image, corners: Pointer; maxCorners: Integer;
  qualityLevel, minDistance: Double; mask: Pointer; blockSize: Integer;
  useHarris: Boolean; k: Double); stdcall; external OpenCVLib delayed;

function Features2d_BFMatcher_Create(normType: Integer; crossCheck: Boolean): Pointer; stdcall; external OpenCVLib delayed;
procedure Features2d_BFMatcher_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function Features2d_BFMatcher_match(self, queryDescriptors, trainDescriptors, matches: Pointer): Integer; stdcall; external OpenCVLib delayed;
function Features2d_BFMatcher_knnMatch(self, queryDescriptors, trainDescriptors, matches: Pointer; k: Integer): Integer; stdcall; external OpenCVLib delayed;
function Features2d_filterMatchesByRatio(knnMatches: Pointer; k: Integer; ratio: Single; goodMatches: Pointer): Integer; stdcall; external OpenCVLib delayed;
procedure Features2d_drawKeypoints(image, keypoints, outImage: Pointer; flags: Integer); stdcall; external OpenCVLib delayed;
procedure Features2d_drawMatches(img1, keypoints1, img2, keypoints2, matches, outImg: Pointer; maxMatches: Integer); stdcall; external OpenCVLib delayed;
function Features2d_drawFeatureMatches(img1, img2, keypoints1, keypoints2, matches, outImg: Pointer;
  maxMatches: Integer): Integer; stdcall; external OpenCVLib delayed;

function Features2d_GFTT_Create(maxCorners: Integer; qualityLevel, minDistance: Double;
  blockSize: Integer; useHarris: Boolean; k: Double): Pointer; stdcall; external OpenCVLib delayed;
procedure Features2d_GFTT_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function Features2d_GFTT_detectAndCompute(self, image, mask, keypoints, descriptors: Pointer): Integer; stdcall; external OpenCVLib delayed;

function Features2d_MSER_Create(delta, minArea, maxArea: Integer; maxVariation, minDiversity: Double;
  maxEvolution: Integer; areaThreshold, minMargin: Double; edgeBlurSize: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Features2d_MSER_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function Features2d_MSER_detectAndCompute(self, image, mask, keypoints, descriptors: Pointer): Integer; stdcall; external OpenCVLib delayed;

function Features2d_FAST_Create(threshold: Integer; nonmaxSuppression: Boolean; detectorType: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Features2d_FAST_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function Features2d_FAST_detectAndCompute(self, image, mask, keypoints, descriptors: Pointer): Integer; stdcall; external OpenCVLib delayed;

function Features2d_SIFT_Create(nfeatures: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Features2d_SIFT_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function Features2d_SIFT_detectAndCompute(self, image, mask, keypoints, descriptors: Pointer): Integer; stdcall; external OpenCVLib delayed;

function Features2d_FlannMatcher_Create(indexParamsType: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Features2d_FlannMatcher_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function Features2d_FlannMatcher_match(self, queryDescriptors, trainDescriptors, matches: Pointer): Integer; stdcall; external OpenCVLib delayed;
function Features2d_FlannMatcher_knnMatch(self, queryDescriptors, trainDescriptors, matches: Pointer; k: Integer): Integer; stdcall; external OpenCVLib delayed;

function drawFeatureMatches(const img1, img2, keypoints1, keypoints2, matches: Pointer;
  const outImg: Pointer; const maxMatches: Integer): Integer;
begin
  Result := Features2d_drawFeatureMatches(img1, img2, keypoints1, keypoints2, matches, outImg, maxMatches);
end;

procedure drawKeypoints(const image, keypoints, outImage: Pointer; const flags: Integer);
begin
  Features2d_drawKeypoints(image, keypoints, outImage, flags);
end;

procedure drawMatches(const img1, keypoints1, img2, keypoints2, matches, outImg: Pointer;
  const maxMatches: Integer);
begin
  Features2d_drawMatches(img1, keypoints1, img2, keypoints2, matches, outImg, maxMatches);
end;

function filterMatchesByRatio(const knnMatches: Pointer; const k: Integer;
  const ratio: Single; const goodMatches: Pointer): Integer;
begin
  Result := Features2d_filterMatchesByRatio(knnMatches, k, ratio, goodMatches);
end;

procedure goodFeaturesToTrack(const image, corners: Pointer; const maxCorners: Integer;
  const qualityLevel, minDistance: Double; const mask: Pointer;
  const blockSize: Integer; const useHarris: Boolean; const k: Double);
begin
  Features2d_goodFeaturesToTrack(image, corners, maxCorners, qualityLevel, minDistance,
    mask, blockSize, useHarris, k);
end;

{ TCVORB }

procedure TCVORB.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Features2d_ORB_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVORB.CreateOwned;
begin
  ReleaseHandle;
  FHandle := Features2d_ORB_Create(FNFeatures);
  FOwnsHandle := True;
end;

class operator TCVORB.Initialize(out Dest: TCVORB);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FNFeatures := 500;
end;

class operator TCVORB.Finalize(var Dest: TCVORB);
begin
  Dest.ReleaseHandle;
end;

class operator TCVORB.Assign(var Dest: TCVORB; const [ref] Src: TCVORB);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FNFeatures := Src.FNFeatures;
  if Src.FOwnsHandle then
  begin
    Dest.FHandle := Features2d_ORB_Create(Dest.FNFeatures);
    Dest.FOwnsHandle := True;
  end
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVORB.Create(const nfeatures: Integer): TCVORB;
begin
  Result.FNFeatures := nfeatures;
  Result.FHandle := Features2d_ORB_Create(nfeatures);
  Result.FOwnsHandle := True;
end;

class function TCVORB.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVORB;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FNFeatures := 500;
end;

procedure TCVORB.Release;
begin
  ReleaseHandle;
end;

function TCVORB.detectAndCompute(const image, mask, keypoints, descriptors: Pointer): Integer;
begin
  Result := Features2d_ORB_detectAndCompute(FHandle, image, mask, keypoints, descriptors);
end;

{ TCVBFMatcher }

procedure TCVBFMatcher.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Features2d_BFMatcher_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVBFMatcher.CreateOwned;
begin
  ReleaseHandle;
  FHandle := Features2d_BFMatcher_Create(FNormType, FCrossCheck);
  FOwnsHandle := True;
end;

class operator TCVBFMatcher.Initialize(out Dest: TCVBFMatcher);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FNormType := NORM_HAMMING;
  Dest.FCrossCheck := False;
end;

class operator TCVBFMatcher.Finalize(var Dest: TCVBFMatcher);
begin
  Dest.ReleaseHandle;
end;

class operator TCVBFMatcher.Assign(var Dest: TCVBFMatcher; const [ref] Src: TCVBFMatcher);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FNormType := Src.FNormType;
  Dest.FCrossCheck := Src.FCrossCheck;
  if Src.FOwnsHandle then
    Dest.CreateOwned
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVBFMatcher.Create(const normType: Integer; const crossCheck: Boolean): TCVBFMatcher;
begin
  Result.FNormType := normType;
  Result.FCrossCheck := crossCheck;
  Result.FHandle := Features2d_BFMatcher_Create(normType, crossCheck);
  Result.FOwnsHandle := True;
end;

class function TCVBFMatcher.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVBFMatcher;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FNormType := NORM_HAMMING;
  Result.FCrossCheck := False;
end;

procedure TCVBFMatcher.Release;
begin
  ReleaseHandle;
end;

function TCVBFMatcher.match(const queryDescriptors, trainDescriptors, matches: Pointer): Integer;
begin
  Result := Features2d_BFMatcher_match(FHandle, queryDescriptors, trainDescriptors, matches);
end;

function TCVBFMatcher.knnMatch(const queryDescriptors, trainDescriptors, matches: Pointer;
  const k: Integer): Integer;
begin
  Result := Features2d_BFMatcher_knnMatch(FHandle, queryDescriptors, trainDescriptors, matches, k);
end;

{ TCVGFTT }

procedure TCVGFTT.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Features2d_GFTT_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVGFTT.CreateOwned;
begin
  ReleaseHandle;
  FHandle := Features2d_GFTT_Create(FMaxCorners, FQualityLevel, FMinDistance,
    FBlockSize, FUseHarris, FK);
  FOwnsHandle := True;
end;

class operator TCVGFTT.Initialize(out Dest: TCVGFTT);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FMaxCorners := 1000;
  Dest.FQualityLevel := 0.01;
  Dest.FMinDistance := 1;
  Dest.FBlockSize := 3;
  Dest.FUseHarris := False;
  Dest.FK := 0.04;
end;

class operator TCVGFTT.Finalize(var Dest: TCVGFTT);
begin
  Dest.ReleaseHandle;
end;

class operator TCVGFTT.Assign(var Dest: TCVGFTT; const [ref] Src: TCVGFTT);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FMaxCorners := Src.FMaxCorners;
  Dest.FQualityLevel := Src.FQualityLevel;
  Dest.FMinDistance := Src.FMinDistance;
  Dest.FBlockSize := Src.FBlockSize;
  Dest.FUseHarris := Src.FUseHarris;
  Dest.FK := Src.FK;
  if Src.FOwnsHandle then
    Dest.CreateOwned
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVGFTT.Create(const maxCorners: Integer; const qualityLevel, minDistance: Double;
  const blockSize: Integer; const useHarris: Boolean; const k: Double): TCVGFTT;
begin
  Result.FMaxCorners := maxCorners;
  Result.FQualityLevel := qualityLevel;
  Result.FMinDistance := minDistance;
  Result.FBlockSize := blockSize;
  Result.FUseHarris := useHarris;
  Result.FK := k;
  Result.FHandle := Features2d_GFTT_Create(maxCorners, qualityLevel, minDistance,
    blockSize, useHarris, k);
  Result.FOwnsHandle := True;
end;

class function TCVGFTT.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVGFTT;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FMaxCorners := 1000;
  Result.FQualityLevel := 0.01;
  Result.FMinDistance := 1;
  Result.FBlockSize := 3;
  Result.FUseHarris := False;
  Result.FK := 0.04;
end;

procedure TCVGFTT.Release;
begin
  ReleaseHandle;
end;

function TCVGFTT.detectAndCompute(const image, mask, keypoints, descriptors: Pointer): Integer;
begin
  Result := Features2d_GFTT_detectAndCompute(FHandle, image, mask, keypoints, descriptors);
end;

{ TCVMSER }

procedure TCVMSER.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Features2d_MSER_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVMSER.CreateOwned;
begin
  ReleaseHandle;
  FHandle := Features2d_MSER_Create(FDelta, FMinArea, FMaxArea, 0.25, 0.2, 200, 1.01, 0.003, 5);
  FOwnsHandle := True;
end;

class operator TCVMSER.Initialize(out Dest: TCVMSER);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FDelta := 5;
  Dest.FMinArea := 60;
  Dest.FMaxArea := 14400;
end;

class operator TCVMSER.Finalize(var Dest: TCVMSER);
begin
  Dest.ReleaseHandle;
end;

class operator TCVMSER.Assign(var Dest: TCVMSER; const [ref] Src: TCVMSER);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FDelta := Src.FDelta;
  Dest.FMinArea := Src.FMinArea;
  Dest.FMaxArea := Src.FMaxArea;
  if Src.FOwnsHandle then
    Dest.CreateOwned
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVMSER.Create(const delta, minArea, maxArea: Integer): TCVMSER;
begin
  Result.FDelta := delta;
  Result.FMinArea := minArea;
  Result.FMaxArea := maxArea;
  Result.FHandle := Features2d_MSER_Create(delta, minArea, maxArea, 0.25, 0.2, 200, 1.01, 0.003, 5);
  Result.FOwnsHandle := True;
end;

class function TCVMSER.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVMSER;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FDelta := 5;
  Result.FMinArea := 60;
  Result.FMaxArea := 14400;
end;

procedure TCVMSER.Release;
begin
  ReleaseHandle;
end;

function TCVMSER.detectAndCompute(const image, mask, keypoints, descriptors: Pointer): Integer;
begin
  Result := Features2d_MSER_detectAndCompute(FHandle, image, mask, keypoints, descriptors);
end;

{ TCVFAST }

procedure TCVFAST.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Features2d_FAST_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

class operator TCVFAST.Initialize(out Dest: TCVFAST);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FThreshold := 10;
  Dest.FNonmaxSuppression := True;
  Dest.FType := FAST_TYPE_9_16;
end;

class operator TCVFAST.Finalize(var Dest: TCVFAST);
begin
  Dest.ReleaseHandle;
end;

class function TCVFAST.Create(const threshold: Integer; const nonmaxSuppression: Boolean;
  const detectorType: Integer): TCVFAST;
begin
  Result.FThreshold := threshold;
  Result.FNonmaxSuppression := nonmaxSuppression;
  Result.FType := detectorType;
  Result.FHandle := Features2d_FAST_Create(threshold, nonmaxSuppression, detectorType);
  Result.FOwnsHandle := True;
end;

procedure TCVFAST.Release;
begin
  ReleaseHandle;
end;

function TCVFAST.detectAndCompute(const image, mask, keypoints, descriptors: Pointer): Integer;
begin
  Result := Features2d_FAST_detectAndCompute(FHandle, image, mask, keypoints, descriptors);
end;

{ TCVSIFT }

procedure TCVSIFT.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Features2d_SIFT_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVSIFT.CreateOwned;
begin
  ReleaseHandle;
  FHandle := Features2d_SIFT_Create(FNFeatures);
  FOwnsHandle := True;
end;

class operator TCVSIFT.Initialize(out Dest: TCVSIFT);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FNFeatures := 0;
end;

class operator TCVSIFT.Finalize(var Dest: TCVSIFT);
begin
  Dest.ReleaseHandle;
end;

class operator TCVSIFT.Assign(var Dest: TCVSIFT; const [ref] Src: TCVSIFT);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FNFeatures := Src.FNFeatures;
  if Src.FOwnsHandle then
    Dest.CreateOwned
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVSIFT.Create(const nfeatures: Integer): TCVSIFT;
begin
  Result.FNFeatures := nfeatures;
  Result.FHandle := Features2d_SIFT_Create(nfeatures);
  Result.FOwnsHandle := True;
end;

class function TCVSIFT.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVSIFT;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FNFeatures := 0;
end;

procedure TCVSIFT.Release;
begin
  ReleaseHandle;
end;

function TCVSIFT.detectAndCompute(const image, mask, keypoints, descriptors: Pointer): Integer;
begin
  Result := Features2d_SIFT_detectAndCompute(FHandle, image, mask, keypoints, descriptors);
end;

{ TCVFlannMatcher }

procedure TCVFlannMatcher.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Features2d_FlannMatcher_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVFlannMatcher.CreateOwned;
begin
  ReleaseHandle;
  FHandle := Features2d_FlannMatcher_Create(FIndexParamsType);
  FOwnsHandle := True;
end;

class operator TCVFlannMatcher.Initialize(out Dest: TCVFlannMatcher);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FIndexParamsType := FLANN_INDEX_KDTREE;
end;

class operator TCVFlannMatcher.Finalize(var Dest: TCVFlannMatcher);
begin
  Dest.ReleaseHandle;
end;

class operator TCVFlannMatcher.Assign(var Dest: TCVFlannMatcher; const [ref] Src: TCVFlannMatcher);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FIndexParamsType := Src.FIndexParamsType;
  if Src.FOwnsHandle then
    Dest.CreateOwned
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVFlannMatcher.Create(const indexParamsType: Integer): TCVFlannMatcher;
begin
  Result.FIndexParamsType := indexParamsType;
  Result.FHandle := Features2d_FlannMatcher_Create(indexParamsType);
  Result.FOwnsHandle := True;
end;

class function TCVFlannMatcher.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVFlannMatcher;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FIndexParamsType := FLANN_INDEX_KDTREE;
end;

procedure TCVFlannMatcher.Release;
begin
  ReleaseHandle;
end;

function TCVFlannMatcher.match(const queryDescriptors, trainDescriptors, matches: Pointer): Integer;
begin
  Result := Features2d_FlannMatcher_match(FHandle, queryDescriptors, trainDescriptors, matches);
end;

function TCVFlannMatcher.knnMatch(const queryDescriptors, trainDescriptors, matches: Pointer;
  const k: Integer): Integer;
begin
  Result := Features2d_FlannMatcher_knnMatch(FHandle, queryDescriptors, trainDescriptors, matches, k);
end;

end.
