unit OpenCV5.Components.Pipeline;

{$IFNDEF WIN64}
  {$IFNDEF PACKAGE}
    {$MESSAGE ERROR 'OpenCV 5.0 components are only supported in Win64 applications.'}
  {$ENDIF}
{$ENDIF}

interface

uses
  System.Classes, System.SysUtils,
  OpenCV5.Core, OpenCV5.Types, OpenCV5.Imgproc, OpenCV5.Components.Base, OpenCV5.Arith;

type
  TcvStageType = (stColor, stBlur, stThreshold, stCanny, stMorphology, stResize, stCustom,
    stAdaptiveThreshold, stBilateralFilter, stEqualizeHist, stSobel, stInvert,
    stClahe, stInRange, stMorphologyEx, stColorMap, stBrightnessContrast, stPyrDown,
    stPyrUp, stLaplacian, stScharr, stDenoise, stDistanceTransform, stCrop,
    stNormalize, stSharpen, stBitwise, stRotate, stWarpPolar, stFilter2D,
    stCornerHarris, stTemporalBlend, stMatchTemplate, stContours, stChannelExtract,
    stFlip, stOrthoRotate, stGamma, stAddWeighted,
    stPyrMeanShift, stSepFilter2D, stSqrBoxFilter, stSpatialGradient, stCornerMinEigenVal,
    stIntegral, stAbsDiff, stAutoContrast, stMergeChannels, stInpaint, stUndistort, stRemap,
    stCustomLUT,
    stHoughLinesP, stHoughCircles, stConnectedComponents, stBackgroundSubtract,
    stDebugText, stPhaseCorrelate,
    stBlendLinear, stReferenceDiff, stOpticalFlow, stRunningAvg, stGrabCut, stWatershed);
  TcvColorPreset = (cpGray, cpHSV, cpLab, cpRGB, cpCustom);
  TcvInRangePreset = (irNone, irRed, irGreen, irBlue);
  TcvBorderMode = (bmDefault, bmConstant, bmReplicate);
  TcvResizeMode = (rmFixedSize, rmScale);
  TcvBlurType = (btGaussian, btMedian, btBlur, btStackBlur, btBoxFilter);
  TcvThresholdMode = (tmBinary, tmBinaryInv, tmTrunc, tmToZero, tmToZeroInv, tmOtsu, tmTriangle);
  TcvInterpolation = (intNearest, intLinear, intArea, intCubic, intLanczos4);
  TcvMorphOp = (moDilate, moErode);
  TcvMorphShape = (msRect, msCross, msEllipse);
  TcvMorphExOp = (meOpen, meClose, meGradient, meTopHat, meBlackHat);
  TcvInRangeColorSpace = (csNone, csHSV);
  TcvPipelineErrorPolicy = (epPassthrough, epSkipStage, epStop);
  TcvPipelinePreset = (ppNone, ppEdges, ppNightVision, ppDenoiseSharp, ppContours,
    ppMotionDetect, ppLines, ppOpticalFlow, ppGrabCut);

  TcvPipeline = class;
  TcvPipelineStage = class;

  TcvPipelineStageEvent = procedure(Sender: TObject; const InFrame: TCVMat; var OutFrame: TCVMat) of object;
  TcvPipelineStageNotifyEvent = procedure(Sender: TObject; StageIndex: Integer;
    Stage: TcvPipelineStage; const InFrame: TCVMat; var OutFrame: TCVMat; var Cancel: Boolean) of object;
  TcvPipelineStageTimingEvent = procedure(Sender: TObject; StageIndex: Integer;
    const StageName: string; ElapsedMs: Double) of object;

  TcvCustomPipelineOperation = class(TPersistent)
  private
    [weak]
    FOwner: TcvPipelineStage;
  protected
    function GetOwner: TPersistent; override;
    procedure Changed; virtual;
  public
    constructor Create(AOwner: TcvPipelineStage); virtual;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); virtual; abstract;
    function GetDisplayName: string; virtual; abstract;
  end;

  TcvPipelineOperationClass = class of TcvCustomPipelineOperation;

  TcvColorOperation = class(TcvCustomPipelineOperation)
  private
    FColorPreset: TcvColorPreset;
    FColorCode: Integer;
    procedure SetColorPreset(const Value: TcvColorPreset);
    procedure SetColorCode(const Value: Integer);
    function EffectiveColorCode: Integer;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ColorPreset: TcvColorPreset read FColorPreset write SetColorPreset default cpGray;
    property ColorCode: Integer read FColorCode write SetColorCode default COLOR_BGR2GRAY;
  end;

  TcvBlurOperation = class(TcvCustomPipelineOperation)
  private
    FBlurType: TcvBlurType;
    FBlurSize: Integer;
    FBlurSigma: Double;
    procedure SetBlurType(const Value: TcvBlurType);
    procedure SetBlurSize(const Value: Integer);
    procedure SetBlurSigma(const Value: Double);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property BlurType: TcvBlurType read FBlurType write SetBlurType default btGaussian;
    property BlurSize: Integer read FBlurSize write SetBlurSize default 3;
    property BlurSigma: Double read FBlurSigma write SetBlurSigma;
  end;

  TcvThresholdOperation = class(TcvCustomPipelineOperation)
  private
    FThresholdMode: TcvThresholdMode;
    FThresholdValue: Double;
    FThresholdMaxVal: Double;
    procedure SetThresholdMode(const Value: TcvThresholdMode);
    procedure SetThresholdValue(const Value: Double);
    procedure SetThresholdMaxVal(const Value: Double);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ThresholdMode: TcvThresholdMode read FThresholdMode write SetThresholdMode default tmBinary;
    property ThresholdValue: Double read FThresholdValue write SetThresholdValue;
    property ThresholdMaxVal: Double read FThresholdMaxVal write SetThresholdMaxVal;
  end;

  TcvCannyOperation = class(TcvCustomPipelineOperation)
  private
    FThresh1: Double;
    FThresh2: Double;
    FAperture: Integer;
    FL2gradient: Boolean;
    procedure SetThresh1(const Value: Double);
    procedure SetThresh2(const Value: Double);
    procedure SetAperture(const Value: Integer);
    procedure SetL2gradient(const Value: Boolean);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Thresh1: Double read FThresh1 write SetThresh1;
    property Thresh2: Double read FThresh2 write SetThresh2;
    property Aperture: Integer read FAperture write SetAperture default 3;
    property L2gradient: Boolean read FL2gradient write SetL2gradient default False;
  end;

  TcvMorphologyOperation = class(TcvCustomPipelineOperation)
  private
    FMorphOp: TcvMorphOp;
    FMorphShape: TcvMorphShape;
    FMorphSize: Integer;
    FIterations: Integer;
    FBorderMode: TcvBorderMode;
    FBorderValue: TCVScalar;
    procedure SetMorphOp(const Value: TcvMorphOp);
    procedure SetMorphShape(const Value: TcvMorphShape);
    procedure SetMorphSize(const Value: Integer);
    procedure SetIterations(const Value: Integer);
    procedure SetBorderMode(const Value: TcvBorderMode);
    procedure SetBorderValue(const Value: TCVScalar);
    function BorderCode: Integer;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property MorphOp: TcvMorphOp read FMorphOp write SetMorphOp default moDilate;
    property MorphShape: TcvMorphShape read FMorphShape write SetMorphShape default msRect;
    property MorphSize: Integer read FMorphSize write SetMorphSize default 3;
    property Iterations: Integer read FIterations write SetIterations default 1;
    property BorderMode: TcvBorderMode read FBorderMode write SetBorderMode default bmDefault;
    property BorderValue: TCVScalar read FBorderValue write SetBorderValue;
  end;

  TcvResizeOperation = class(TcvCustomPipelineOperation)
  private
    FResizeMode: TcvResizeMode;
    FResizeWidth: Integer;
    FResizeHeight: Integer;
    FScaleX: Double;
    FScaleY: Double;
    FKeepAspect: Boolean;
    FInterpolation: TcvInterpolation;
    procedure SetResizeMode(const Value: TcvResizeMode);
    procedure SetResizeWidth(const Value: Integer);
    procedure SetResizeHeight(const Value: Integer);
    procedure SetScaleX(const Value: Double);
    procedure SetScaleY(const Value: Double);
    procedure SetKeepAspect(const Value: Boolean);
    procedure SetInterpolation(const Value: TcvInterpolation);
    function InterpCode: Integer;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ResizeMode: TcvResizeMode read FResizeMode write SetResizeMode default rmFixedSize;
    property Width: Integer read FResizeWidth write SetResizeWidth default 320;
    property Height: Integer read FResizeHeight write SetResizeHeight default 240;
    property ScaleX: Double read FScaleX write SetScaleX;
    property ScaleY: Double read FScaleY write SetScaleY;
    property KeepAspect: Boolean read FKeepAspect write SetKeepAspect default True;
    property Interpolation: TcvInterpolation read FInterpolation write SetInterpolation default intLinear;
  end;

  TcvCustomOperation = class(TcvCustomPipelineOperation)
  private
    FOnProcess: TcvPipelineStageEvent;
    procedure SetOnProcess(const Value: TcvPipelineStageEvent);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property OnProcess: TcvPipelineStageEvent read FOnProcess write SetOnProcess;
  end;

  TcvAdaptiveMethod = (amMean, amGaussian);
  TcvAdaptiveThresholdType = (attBinary, attBinaryInv);

  TcvAdaptiveThresholdOperation = class(TcvCustomPipelineOperation)
  private
    FAdaptiveMethod: TcvAdaptiveMethod;
    FThresholdType: TcvAdaptiveThresholdType;
    FBlockSize: Integer;
    FC: Double;
    FMaxValue: Double;
    procedure SetAdaptiveMethod(const Value: TcvAdaptiveMethod);
    procedure SetThresholdType(const Value: TcvAdaptiveThresholdType);
    procedure SetBlockSize(const Value: Integer);
    procedure SetC(const Value: Double);
    procedure SetMaxValue(const Value: Double);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property AdaptiveMethod: TcvAdaptiveMethod read FAdaptiveMethod write SetAdaptiveMethod default amMean;
    property ThresholdType: TcvAdaptiveThresholdType read FThresholdType write SetThresholdType default attBinary;
    property BlockSize: Integer read FBlockSize write SetBlockSize default 3;
    property C: Double read FC write SetC;
    property MaxValue: Double read FMaxValue write SetMaxValue;
  end;

  TcvBilateralFilterOperation = class(TcvCustomPipelineOperation)
  private
    FD: Integer;
    FSigmaColor: Double;
    FSigmaSpace: Double;
    procedure SetD(const Value: Integer);
    procedure SetSigmaColor(const Value: Double);
    procedure SetSigmaSpace(const Value: Double);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property D: Integer read FD write SetD default 5;
    property SigmaColor: Double read FSigmaColor write SetSigmaColor;
    property SigmaSpace: Double read FSigmaSpace write SetSigmaSpace;
  end;

  TcvEqualizeHistOperation = class(TcvCustomPipelineOperation)
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TcvSobelOperation = class(TcvCustomPipelineOperation)
  private
    Fdx: Integer;
    Fdy: Integer;
    Fksize: Integer;
    FScale: Double;
    FDelta: Double;
    procedure Setdx(const Value: Integer);
    procedure Setdy(const Value: Integer);
    procedure Setksize(const Value: Integer);
    procedure SetScale(const Value: Double);
    procedure SetDelta(const Value: Double);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property dx: Integer read Fdx write Setdx default 1;
    property dy: Integer read Fdy write Setdy default 0;
    property ksize: Integer read Fksize write Setksize default 3;
    property Scale: Double read FScale write SetScale;
    property Delta: Double read FDelta write SetDelta;
  end;

  TcvInvertOperation = class(TcvCustomPipelineOperation)
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TcvClaheOperation = class(TcvCustomPipelineOperation)
  private
    FClipLimit: Double;
    FTileWidth: Integer;
    FTileHeight: Integer;
    FClahe: TCVCLAHE;
    FClaheReady: Boolean;
    procedure SetClipLimit(const Value: Double);
    procedure SetTileWidth(const Value: Integer);
    procedure SetTileHeight(const Value: Integer);
    procedure ResetClahe;
    procedure EnsureClahe;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    destructor Destroy; override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ClipLimit: Double read FClipLimit write SetClipLimit;
    property TileWidth: Integer read FTileWidth write SetTileWidth default 8;
    property TileHeight: Integer read FTileHeight write SetTileHeight default 8;
  end;

  TcvInRangeOperation = class(TcvCustomPipelineOperation)
  private
    FPreset: TcvInRangePreset;
    FColorSpace: TcvInRangeColorSpace;
    FLowerBound: TCVScalar;
    FUpperBound: TCVScalar;
    FOutputMaskOnly: Boolean;
    procedure SetPreset(const Value: TcvInRangePreset);
    procedure SetColorSpace(const Value: TcvInRangeColorSpace);
    procedure SetLowerBound(const Value: TCVScalar);
    procedure SetUpperBound(const Value: TCVScalar);
    procedure SetOutputMaskOnly(const Value: Boolean);
    procedure ApplyPresetBounds;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Preset: TcvInRangePreset read FPreset write SetPreset default irNone;
    property ColorSpace: TcvInRangeColorSpace read FColorSpace write SetColorSpace default csNone;
    property LowerBound: TCVScalar read FLowerBound write SetLowerBound;
    property UpperBound: TCVScalar read FUpperBound write SetUpperBound;
    property OutputMaskOnly: Boolean read FOutputMaskOnly write SetOutputMaskOnly default False;
  end;

  TcvMorphologyExOperation = class(TcvCustomPipelineOperation)
  private
    FMorphExOp: TcvMorphExOp;
    FMorphShape: TcvMorphShape;
    FMorphSize: Integer;
    FIterations: Integer;
    FBorderMode: TcvBorderMode;
    FBorderValue: TCVScalar;
    procedure SetMorphExOp(const Value: TcvMorphExOp);
    procedure SetMorphShape(const Value: TcvMorphShape);
    procedure SetMorphSize(const Value: Integer);
    procedure SetIterations(const Value: Integer);
    procedure SetBorderMode(const Value: TcvBorderMode);
    procedure SetBorderValue(const Value: TCVScalar);
    function MorphExCode: Integer;
    function StructShape: Integer;
    function BorderCode: Integer;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property MorphExOp: TcvMorphExOp read FMorphExOp write SetMorphExOp default meOpen;
    property MorphShape: TcvMorphShape read FMorphShape write SetMorphShape default msRect;
    property MorphSize: Integer read FMorphSize write SetMorphSize default 3;
    property Iterations: Integer read FIterations write SetIterations default 1;
    property BorderMode: TcvBorderMode read FBorderMode write SetBorderMode default bmDefault;
    property BorderValue: TCVScalar read FBorderValue write SetBorderValue;
  end;

  TcvColorMapOperation = class(TcvCustomPipelineOperation)
  private
    FColormap: Integer;
    procedure SetColormap(const Value: Integer);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Colormap: Integer read FColormap write SetColormap default COLORMAP_JET;
  end;

  TcvBrightnessContrastOperation = class(TcvCustomPipelineOperation)
  private
    FAlpha: Double;
    FBeta: Double;
    procedure SetAlpha(const Value: Double);
    procedure SetBeta(const Value: Double);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Alpha: Double read FAlpha write SetAlpha;
    property Beta: Double read FBeta write SetBeta;
  end;

  TcvPyrDownOperation = class(TcvCustomPipelineOperation)
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TcvPipelineStage = class(TCollectionItem)
  private
    FEnabled: Boolean;
    FStageType: TcvStageType;
    FOperation: TcvCustomPipelineOperation;
    procedure SetEnabled(const Value: Boolean);
    procedure SetStageType(const Value: TcvStageType);
    procedure SetOperation(const Value: TcvCustomPipelineOperation);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat);
    procedure NotifyChanged;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property StageType: TcvStageType read FStageType write SetStageType default stColor;
    property Operation: TcvCustomPipelineOperation read FOperation write SetOperation;
  end;

  TcvPipelineStages = class(TCollection)
  private
    FOwner: TcvPipeline;
    function GetItem(Index: Integer): TcvPipelineStage;
    procedure SetItem(Index: Integer; Value: TcvPipelineStage);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TcvPipeline);
    function Add: TcvPipelineStage;
    property Items[Index: Integer]: TcvPipelineStage read GetItem write SetItem; default;
  end;

  TcvPipeline = class(TCVDataProxy)
  private
    FStages: TcvPipelineStages;
    FProcessEveryN: Integer;
    FFrameCounter: Integer;
    FErrorPolicy: TcvPipelineErrorPolicy;
    FPreset: TcvPipelinePreset;
    FOnBeforeStage: TcvPipelineStageNotifyEvent;
    FOnAfterStage: TcvPipelineStageNotifyEvent;
    FOnStageTiming: TcvPipelineStageTimingEvent;
    procedure SetStages(const Value: TcvPipelineStages);
    procedure SetProcessEveryN(const Value: Integer);
    procedure SetErrorPolicy(const Value: TcvPipelineErrorPolicy);
    procedure SetPreset(const Value: TcvPipelinePreset);
    function GetPreset: TcvPipelinePreset;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    class function ComponentPlatforms: Integer;
    procedure Process(const Src: TCVMat; var Dst: TCVMat);
    procedure TakeMat(const AMat: TCVMat); override;
    procedure ApplyPreset(const Preset: TcvPipelinePreset);
    procedure SaveToIni(const FileName: string);
    procedure LoadFromIni(const FileName: string);
  published
    property Source;
    property Preset: TcvPipelinePreset read GetPreset write SetPreset default ppNone;
    property Stages: TcvPipelineStages read FStages write SetStages;
    property ProcessEveryN: Integer read FProcessEveryN write SetProcessEveryN default 1;
    property ErrorPolicy: TcvPipelineErrorPolicy read FErrorPolicy write SetErrorPolicy default epPassthrough;
    property OnBeforeStage: TcvPipelineStageNotifyEvent read FOnBeforeStage write FOnBeforeStage;
    property OnAfterStage: TcvPipelineStageNotifyEvent read FOnAfterStage write FOnAfterStage;
    property OnStageTiming: TcvPipelineStageTimingEvent read FOnStageTiming write FOnStageTiming;
  end;

implementation

uses
  System.Diagnostics, System.IniFiles,
  OpenCV5.Components.Pipeline.Extended;

const
  BlurTypeNames: array[TcvBlurType] of string = ('Gaussian', 'Median', 'Box Blur', 'StackBlur', 'BoxFilter');
  ThresholdModeNames: array[TcvThresholdMode] of string = ('Binary', 'BinaryInv', 'Trunc', 'ToZero', 'ToZeroInv', 'Otsu', 'Triangle');
  MorphOpNames: array[TcvMorphOp] of string = ('Dilate', 'Erode');
  MorphExOpNames: array[TcvMorphExOp] of string = ('Open', 'Close', 'Gradient', 'TopHat', 'BlackHat');
  AdaptiveMethodNames: array[TcvAdaptiveMethod] of string = ('Mean', 'Gaussian');
  ColorPresetNames: array[TcvColorPreset] of string = ('Gray', 'HSV', 'Lab', 'RGB', 'Custom');
  InRangePresetNames: array[TcvInRangePreset] of string = ('None', 'Red', 'Green', 'Blue');
  AdaptiveThresholdTypeNames: array[TcvAdaptiveThresholdType] of string = ('Binary', 'BinaryInv');

{ TcvCustomPipelineOperation }

constructor TcvCustomPipelineOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TcvCustomPipelineOperation.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TcvCustomPipelineOperation.Changed;
begin
  if FOwner <> nil then
    FOwner.NotifyChanged;
end;

{ TcvColorOperation }

constructor TcvColorOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FColorPreset := cpGray;
  FColorCode := COLOR_BGR2GRAY;
end;

procedure TcvColorOperation.Assign(Source: TPersistent);
begin
  if Source is TcvColorOperation then
  begin
    FColorPreset := TcvColorOperation(Source).ColorPreset;
    FColorCode := TcvColorOperation(Source).ColorCode;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvColorOperation.EffectiveColorCode: Integer;
begin
  case FColorPreset of
    cpHSV: Result := COLOR_BGR2HSV;
    cpLab: Result := COLOR_BGR2Lab;
    cpRGB: Result := COLOR_BGR2RGB;
    cpCustom: Result := FColorCode;
  else
    Result := COLOR_BGR2GRAY;
  end;
end;

function TcvColorOperation.GetDisplayName: string;
begin
  if FColorPreset = cpCustom then
    Result := Format('Color Conversion (Code %d)', [FColorCode])
  else
    Result := Format('Color (%s)', [ColorPresetNames[FColorPreset]]);
end;

procedure TcvColorOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
  Code: Integer;
begin
  Code := EffectiveColorCode;
  if Code = COLOR_BGR2GRAY then
    Temp := TCVMat.Create_0(0, 0, CV_8UC1)
  else
    Temp := TCVMat.Create_0(0, 0, CV_8UC3);
  cvtColor(Src.Handle, Temp.Handle, Code, 0, 0);
  Dst := Temp;
end;

procedure TcvColorOperation.SetColorCode(const Value: Integer);
begin
  if FColorCode <> Value then
  begin
    FColorCode := Value;
    Changed;
  end;
end;

procedure TcvColorOperation.SetColorPreset(const Value: TcvColorPreset);
begin
  if FColorPreset <> Value then
  begin
    FColorPreset := Value;
    Changed;
  end;
end;

{ TcvBlurOperation }

constructor TcvBlurOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FBlurType := btGaussian;
  FBlurSize := 3;
  FBlurSigma := 0.0;
end;

procedure TcvBlurOperation.Assign(Source: TPersistent);
begin
  if Source is TcvBlurOperation then
  begin
    FBlurType := TcvBlurOperation(Source).BlurType;
    FBlurSize := TcvBlurOperation(Source).BlurSize;
    FBlurSigma := TcvBlurOperation(Source).BlurSigma;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvBlurOperation.GetDisplayName: string;
begin
  Result := Format('Blur (%s, Size %d)', [BlurTypeNames[FBlurType], FBlurSize]);
end;

procedure TcvBlurOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  case FBlurType of
    btGaussian:
      GaussianBlur(Src.Handle, Temp.Handle, TCVSize.Create(FBlurSize, FBlurSize), FBlurSigma, FBlurSigma, 4 {BORDER_DEFAULT}, 0);
    btMedian:
      medianBlur(Src.Handle, Temp.Handle, FBlurSize);
    btBlur:
      blur(Src.Handle, Temp.Handle, TCVSize.Create(FBlurSize, FBlurSize), TCVPoint.Create(-1, -1), 4 {BORDER_DEFAULT});
    btStackBlur:
      stackBlur(Src.Handle, Temp.Handle, TCVSize.Create(FBlurSize, FBlurSize));
    btBoxFilter:
      boxFilter(Src.Handle, Temp.Handle, -1, TCVSize.Create(FBlurSize, FBlurSize),
        TCVPoint.Create(-1, -1), True, 4 {BORDER_DEFAULT});
  end;
  Dst := Temp;
end;

procedure TcvBlurOperation.SetBlurSigma(const Value: Double);
begin
  if FBlurSigma <> Value then
  begin
    FBlurSigma := Value;
    Changed;
  end;
end;

procedure TcvBlurOperation.SetBlurSize(const Value: Integer);
var
  V: Integer;
begin
  // Snap to nearest positive odd integer
  V := Value;
  if V < 1 then V := 1;
  if V mod 2 = 0 then Inc(V);
  if FBlurSize <> V then
  begin
    FBlurSize := V;
    Changed;
  end;
end;

procedure TcvBlurOperation.SetBlurType(const Value: TcvBlurType);
begin
  if FBlurType <> Value then
  begin
    FBlurType := Value;
    Changed;
  end;
end;

{ TcvThresholdOperation }

constructor TcvThresholdOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FThresholdMode := tmBinary;
  FThresholdValue := 128.0;
  FThresholdMaxVal := 255.0;
end;

procedure TcvThresholdOperation.Assign(Source: TPersistent);
begin
  if Source is TcvThresholdOperation then
  begin
    FThresholdMode := TcvThresholdOperation(Source).ThresholdMode;
    FThresholdValue := TcvThresholdOperation(Source).ThresholdValue;
    FThresholdMaxVal := TcvThresholdOperation(Source).ThresholdMaxVal;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvThresholdOperation.GetDisplayName: string;
begin
  Result := Format('Threshold (%s, Val %.0f)', [ThresholdModeNames[FThresholdMode], FThresholdValue]);
end;

procedure TcvThresholdOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  case FThresholdMode of
    tmBinary: threshold(Src.Handle, Temp.Handle, FThresholdValue, FThresholdMaxVal, THRESH_BINARY);
    tmBinaryInv: threshold(Src.Handle, Temp.Handle, FThresholdValue, FThresholdMaxVal, THRESH_BINARY_INV);
    tmTrunc: threshold(Src.Handle, Temp.Handle, FThresholdValue, FThresholdMaxVal, THRESH_TRUNC);
    tmToZero: threshold(Src.Handle, Temp.Handle, FThresholdValue, FThresholdMaxVal, THRESH_TOZERO);
    tmToZeroInv: threshold(Src.Handle, Temp.Handle, FThresholdValue, FThresholdMaxVal, THRESH_TOZERO_INV);
    tmOtsu: threshold(Src.Handle, Temp.Handle, FThresholdValue, FThresholdMaxVal, THRESH_BINARY or THRESH_OTSU);
    tmTriangle: threshold(Src.Handle, Temp.Handle, FThresholdValue, FThresholdMaxVal, THRESH_BINARY or THRESH_TRIANGLE);
  end;
  Dst := Temp;
end;

procedure TcvThresholdOperation.SetThresholdMaxVal(const Value: Double);
begin
  if FThresholdMaxVal <> Value then
  begin
    FThresholdMaxVal := Value;
    Changed;
  end;
end;

procedure TcvThresholdOperation.SetThresholdMode(const Value: TcvThresholdMode);
begin
  if FThresholdMode <> Value then
  begin
    FThresholdMode := Value;
    Changed;
  end;
end;

procedure TcvThresholdOperation.SetThresholdValue(const Value: Double);
begin
  if FThresholdValue <> Value then
  begin
    FThresholdValue := Value;
    Changed;
  end;
end;

{ TcvCannyOperation }

constructor TcvCannyOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FThresh1 := 50.0;
  FThresh2 := 150.0;
  FAperture := 3;
  FL2gradient := False;
end;

procedure TcvCannyOperation.Assign(Source: TPersistent);
begin
  if Source is TcvCannyOperation then
  begin
    FThresh1 := TcvCannyOperation(Source).Thresh1;
    FThresh2 := TcvCannyOperation(Source).Thresh2;
    FAperture := TcvCannyOperation(Source).Aperture;
    FL2gradient := TcvCannyOperation(Source).L2gradient;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvCannyOperation.GetDisplayName: string;
begin
  if FL2gradient then
    Result := Format('Canny Edge L2 (T1=%.0f, T2=%.0f)', [FThresh1, FThresh2])
  else
    Result := Format('Canny Edge (T1=%.0f, T2=%.0f)', [FThresh1, FThresh2]);
end;

procedure TcvCannyOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, CV_8UC1);
  Canny(Src.Handle, Temp.Handle, FThresh1, FThresh2, FAperture, FL2gradient);
  Dst := Temp;
end;

procedure TcvCannyOperation.SetAperture(const Value: Integer);
var
  V: Integer;
begin
  // Clamp to valid values: 3, 5, 7
  if Value <= 4 then V := 3
  else if Value <= 6 then V := 5
  else V := 7;
  if FAperture <> V then
  begin
    FAperture := V;
    Changed;
  end;
end;

procedure TcvCannyOperation.SetThresh1(const Value: Double);
begin
  if FThresh1 <> Value then
  begin
    FThresh1 := Value;
    Changed;
  end;
end;

procedure TcvCannyOperation.SetThresh2(const Value: Double);
begin
  if FThresh2 <> Value then
  begin
    FThresh2 := Value;
    Changed;
  end;
end;

procedure TcvCannyOperation.SetL2gradient(const Value: Boolean);
begin
  if FL2gradient <> Value then
  begin
    FL2gradient := Value;
    Changed;
  end;
end;

{ TcvMorphologyOperation }

constructor TcvMorphologyOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FMorphOp := moDilate;
  FMorphShape := msRect;
  FMorphSize := 3;
  FIterations := 1;
  FBorderMode := bmDefault;
  FBorderValue := TCVScalar.Create(0);
end;

function TcvMorphologyOperation.BorderCode: Integer;
begin
  case FBorderMode of
    bmConstant: Result := BORDER_CONSTANT;
    bmReplicate: Result := BORDER_REPLICATE;
  else
    Result := BORDER_DEFAULT;
  end;
end;

procedure TcvMorphologyOperation.Assign(Source: TPersistent);
begin
  if Source is TcvMorphologyOperation then
  begin
    FMorphOp := TcvMorphologyOperation(Source).MorphOp;
    FMorphShape := TcvMorphologyOperation(Source).MorphShape;
    FMorphSize := TcvMorphologyOperation(Source).MorphSize;
    FIterations := TcvMorphologyOperation(Source).Iterations;
    FBorderMode := TcvMorphologyOperation(Source).BorderMode;
    FBorderValue := TcvMorphologyOperation(Source).BorderValue;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvMorphologyOperation.GetDisplayName: string;
begin
  Result := Format('Morphology (%s, Size %d, x%d)', [MorphOpNames[FMorphOp], FMorphSize, FIterations]);
end;

procedure TcvMorphologyOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp, K: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  K := getStructuringElement(Ord(FMorphShape), TCVSize.Create(FMorphSize, FMorphSize), TCVPoint.Create(-1, -1));
  case FMorphOp of
    moDilate:
      dilate(Src.Handle, Temp.Handle, K.Handle, TCVPoint.Create(-1, -1), FIterations, BorderCode, FBorderValue);
    moErode:
      erode(Src.Handle, Temp.Handle, K.Handle, TCVPoint.Create(-1, -1), FIterations, BorderCode, FBorderValue);
  end;
  Dst := Temp;
end;

procedure TcvMorphologyOperation.SetIterations(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if V < 1 then V := 1;
  if FIterations <> V then
  begin
    FIterations := V;
    Changed;
  end;
end;

procedure TcvMorphologyOperation.SetMorphOp(const Value: TcvMorphOp);
begin
  if FMorphOp <> Value then
  begin
    FMorphOp := Value;
    Changed;
  end;
end;

procedure TcvMorphologyOperation.SetMorphShape(const Value: TcvMorphShape);
begin
  if FMorphShape <> Value then
  begin
    FMorphShape := Value;
    Changed;
  end;
end;

procedure TcvMorphologyOperation.SetMorphSize(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if V < 1 then V := 1;
  if FMorphSize <> V then
  begin
    FMorphSize := V;
    Changed;
  end;
end;

procedure TcvMorphologyOperation.SetBorderMode(const Value: TcvBorderMode);
begin
  if FBorderMode <> Value then
  begin
    FBorderMode := Value;
    Changed;
  end;
end;

procedure TcvMorphologyOperation.SetBorderValue(const Value: TCVScalar);
begin
  FBorderValue := Value;
  Changed;
end;

{ TcvResizeOperation }

constructor TcvResizeOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FResizeMode := rmFixedSize;
  FResizeWidth := 320;
  FResizeHeight := 240;
  FScaleX := 1.0;
  FScaleY := 1.0;
  FKeepAspect := True;
  FInterpolation := intLinear;
end;

procedure TcvResizeOperation.Assign(Source: TPersistent);
begin
  if Source is TcvResizeOperation then
  begin
    FResizeMode := TcvResizeOperation(Source).ResizeMode;
    FResizeWidth := TcvResizeOperation(Source).Width;
    FResizeHeight := TcvResizeOperation(Source).Height;
    FScaleX := TcvResizeOperation(Source).ScaleX;
    FScaleY := TcvResizeOperation(Source).ScaleY;
    FKeepAspect := TcvResizeOperation(Source).KeepAspect;
    FInterpolation := TcvResizeOperation(Source).Interpolation;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvResizeOperation.GetDisplayName: string;
begin
  if FResizeMode = rmScale then
  begin
    if FKeepAspect then
      Result := Format('Resize (scale %.2f)', [FScaleX])
    else
      Result := Format('Resize (scale %.2fx%.2f)', [FScaleX, FScaleY]);
  end
  else
    Result := Format('Resize (%dx%d)', [FResizeWidth, FResizeHeight]);
end;

function TcvResizeOperation.InterpCode: Integer;
begin
  case FInterpolation of
    intNearest: Result := INTER_NEAREST;
    intArea: Result := INTER_AREA;
    intCubic: Result := INTER_CUBIC;
    intLanczos4: Result := INTER_LANCZOS4;
  else
    Result := INTER_LINEAR;
  end;
end;

procedure TcvResizeOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
  Fx, Fy: Double;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  if FResizeMode = rmScale then
  begin
    Fx := FScaleX;
    if Fx <= 0 then Fx := 1.0;
    if FKeepAspect then
      Fy := Fx
    else
    begin
      Fy := FScaleY;
      if Fy <= 0 then Fy := 1.0;
    end;
    resize(Src.Handle, Temp.Handle, TCVSize.Create(0, 0), Fx, Fy, InterpCode);
  end
  else
    resize(Src.Handle, Temp.Handle, TCVSize.Create(FResizeWidth, FResizeHeight), 0.0, 0.0, InterpCode);
  Dst := Temp;
end;

procedure TcvResizeOperation.SetResizeMode(const Value: TcvResizeMode);
begin
  if FResizeMode <> Value then
  begin
    FResizeMode := Value;
    Changed;
  end;
end;

procedure TcvResizeOperation.SetInterpolation(const Value: TcvInterpolation);
begin
  if FInterpolation <> Value then
  begin
    FInterpolation := Value;
    Changed;
  end;
end;

procedure TcvResizeOperation.SetResizeHeight(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if V < 1 then V := 1;
  if FResizeHeight <> V then
  begin
    FResizeHeight := V;
    Changed;
  end;
end;

procedure TcvResizeOperation.SetResizeWidth(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if V < 1 then V := 1;
  if FResizeWidth <> V then
  begin
    FResizeWidth := V;
    Changed;
  end;
end;

procedure TcvResizeOperation.SetScaleX(const Value: Double);
begin
  if FScaleX <> Value then
  begin
    FScaleX := Value;
    Changed;
  end;
end;

procedure TcvResizeOperation.SetScaleY(const Value: Double);
begin
  if FScaleY <> Value then
  begin
    FScaleY := Value;
    Changed;
  end;
end;

procedure TcvResizeOperation.SetKeepAspect(const Value: Boolean);
begin
  if FKeepAspect <> Value then
  begin
    FKeepAspect := Value;
    Changed;
  end;
end;

{ TcvCustomOperation }

constructor TcvCustomOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FOnProcess := nil;
end;

procedure TcvCustomOperation.Assign(Source: TPersistent);
begin
  if Source is TcvCustomOperation then
  begin
    FOnProcess := TcvCustomOperation(Source).OnProcess;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvCustomOperation.GetDisplayName: string;
begin
  Result := 'Custom Event';
end;

procedure TcvCustomOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  if Assigned(FOnProcess) then
  begin
    Temp := Src;
    FOnProcess(FOwner, Src, Temp);
    Dst := Temp;
  end
  else
  begin
    if Src.Handle <> Dst.Handle then
      Src.copyTo(Dst.Handle);
  end;
end;

procedure TcvCustomOperation.SetOnProcess(const Value: TcvPipelineStageEvent);
begin
  FOnProcess := Value;
  Changed;
end;

{ TcvAdaptiveThresholdOperation }

constructor TcvAdaptiveThresholdOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FAdaptiveMethod := amMean;
  FThresholdType := attBinary;
  FBlockSize := 3;
  FC := 5.0;
  FMaxValue := 255.0;
end;

procedure TcvAdaptiveThresholdOperation.Assign(Source: TPersistent);
begin
  if Source is TcvAdaptiveThresholdOperation then
  begin
    FAdaptiveMethod := TcvAdaptiveThresholdOperation(Source).AdaptiveMethod;
    FThresholdType := TcvAdaptiveThresholdOperation(Source).ThresholdType;
    FBlockSize := TcvAdaptiveThresholdOperation(Source).BlockSize;
    FC := TcvAdaptiveThresholdOperation(Source).C;
    FMaxValue := TcvAdaptiveThresholdOperation(Source).MaxValue;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvAdaptiveThresholdOperation.GetDisplayName: string;
begin
  Result := Format('Adaptive Threshold (%s, Block %d)', [AdaptiveMethodNames[FAdaptiveMethod], FBlockSize]);
end;

procedure TcvAdaptiveThresholdOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp, Gray: TCVMat;
  Method, ThType: Integer;
begin
  if Src.channels > 1 then
  begin
    Gray := TCVMat.Create_0(0, 0, CV_8UC1);
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
  end
  else
    Gray := Src;

  Temp := TCVMat.Create_0(0, 0, CV_8UC1);

  case FAdaptiveMethod of
    amMean: Method := 0; // ADAPTIVE_THRESH_MEAN_C
    amGaussian: Method := 1; // ADAPTIVE_THRESH_GAUSSIAN_C
  else
    Method := 0;
  end;

  case FThresholdType of
    attBinary: ThType := 0; // THRESH_BINARY
    attBinaryInv: ThType := 1; // THRESH_BINARY_INV
  else
    ThType := 0;
  end;

  adaptiveThreshold(Gray.Handle, Temp.Handle, FMaxValue, Method, ThType, FBlockSize, FC);
  Dst := Temp;
end;

procedure TcvAdaptiveThresholdOperation.SetAdaptiveMethod(const Value: TcvAdaptiveMethod);
begin
  if FAdaptiveMethod <> Value then
  begin
    FAdaptiveMethod := Value;
    Changed;
  end;
end;

procedure TcvAdaptiveThresholdOperation.SetThresholdType(const Value: TcvAdaptiveThresholdType);
begin
  if FThresholdType <> Value then
  begin
    FThresholdType := Value;
    Changed;
  end;
end;

procedure TcvAdaptiveThresholdOperation.SetBlockSize(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if V < 3 then V := 3;
  if V mod 2 = 0 then Inc(V);
  if FBlockSize <> V then
  begin
    FBlockSize := V;
    Changed;
  end;
end;

procedure TcvAdaptiveThresholdOperation.SetC(const Value: Double);
begin
  if FC <> Value then
  begin
    FC := Value;
    Changed;
  end;
end;

procedure TcvAdaptiveThresholdOperation.SetMaxValue(const Value: Double);
begin
  if FMaxValue <> Value then
  begin
    FMaxValue := Value;
    Changed;
  end;
end;

{ TcvBilateralFilterOperation }

constructor TcvBilateralFilterOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FD := 5;
  FSigmaColor := 50.0;
  FSigmaSpace := 50.0;
end;

procedure TcvBilateralFilterOperation.Assign(Source: TPersistent);
begin
  if Source is TcvBilateralFilterOperation then
  begin
    FD := TcvBilateralFilterOperation(Source).D;
    FSigmaColor := TcvBilateralFilterOperation(Source).SigmaColor;
    FSigmaSpace := TcvBilateralFilterOperation(Source).SigmaSpace;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvBilateralFilterOperation.GetDisplayName: string;
begin
  Result := Format('Bilateral Filter (D %d, Color %.1f, Space %.1f)', [FD, FSigmaColor, FSigmaSpace]);
end;

procedure TcvBilateralFilterOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  bilateralFilter(Src.Handle, Temp.Handle, FD, FSigmaColor, FSigmaSpace, 4 {BORDER_DEFAULT});
  Dst := Temp;
end;

procedure TcvBilateralFilterOperation.SetD(const Value: Integer);
begin
  if FD <> Value then
  begin
    FD := Value;
    Changed;
  end;
end;

procedure TcvBilateralFilterOperation.SetSigmaColor(const Value: Double);
begin
  if FSigmaColor <> Value then
  begin
    FSigmaColor := Value;
    Changed;
  end;
end;

procedure TcvBilateralFilterOperation.SetSigmaSpace(const Value: Double);
begin
  if FSigmaSpace <> Value then
  begin
    FSigmaSpace := Value;
    Changed;
  end;
end;

{ TcvEqualizeHistOperation }

constructor TcvEqualizeHistOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
end;

procedure TcvEqualizeHistOperation.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
end;

function TcvEqualizeHistOperation.GetDisplayName: string;
begin
  Result := 'Equalize Hist';
end;

procedure TcvEqualizeHistOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp, Gray: TCVMat;
begin
  if Src.channels > 1 then
  begin
    Gray := TCVMat.Create_0(0, 0, CV_8UC1);
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
  end
  else
    Gray := Src;

  Temp := TCVMat.Create_0(0, 0, CV_8UC1);
  equalizeHist(Gray.Handle, Temp.Handle);
  Dst := Temp;
end;

{ TcvSobelOperation }

constructor TcvSobelOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  Fdx := 1;
  Fdy := 0;
  Fksize := 3;
  FScale := 1.0;
  FDelta := 0.0;
end;

procedure TcvSobelOperation.Assign(Source: TPersistent);
begin
  if Source is TcvSobelOperation then
  begin
    Fdx := TcvSobelOperation(Source).dx;
    Fdy := TcvSobelOperation(Source).dy;
    Fksize := TcvSobelOperation(Source).ksize;
    FScale := TcvSobelOperation(Source).Scale;
    FDelta := TcvSobelOperation(Source).Delta;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvSobelOperation.GetDisplayName: string;
begin
  Result := Format('Sobel (dx %d, dy %d, ksize %d)', [Fdx, Fdy, Fksize]);
end;

procedure TcvSobelOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  Sobel(Src.Handle, Temp.Handle, Src.depth, Fdx, Fdy, Fksize, FScale, FDelta, 4 {BORDER_DEFAULT});
  Dst := Temp;
end;

procedure TcvSobelOperation.Setdx(const Value: Integer);
begin
  if Fdx <> Value then
  begin
    Fdx := Value;
    Changed;
  end;
end;

procedure TcvSobelOperation.Setdy(const Value: Integer);
begin
  if Fdy <> Value then
  begin
    Fdy := Value;
    Changed;
  end;
end;

procedure TcvSobelOperation.Setksize(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if V < 1 then V := 1;
  if V mod 2 = 0 then Inc(V);
  if V > 7 then V := 7;
  if Fksize <> V then
  begin
    Fksize := V;
    Changed;
  end;
end;

procedure TcvSobelOperation.SetScale(const Value: Double);
begin
  if FScale <> Value then
  begin
    FScale := Value;
    Changed;
  end;
end;

procedure TcvSobelOperation.SetDelta(const Value: Double);
begin
  if FDelta <> Value then
  begin
    FDelta := Value;
    Changed;
  end;
end;

{ TcvInvertOperation }

constructor TcvInvertOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
end;

procedure TcvInvertOperation.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
end;

function TcvInvertOperation.GetDisplayName: string;
begin
  Result := 'Invert';
end;

procedure TcvInvertOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  bitwise_not(Src.Handle, Temp.Handle, nil);
  Dst := Temp;
end;

{ TcvClaheOperation }

constructor TcvClaheOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FClipLimit := 2.0;
  FTileWidth := 8;
  FTileHeight := 8;
  FClaheReady := False;
end;

destructor TcvClaheOperation.Destroy;
begin
  ResetClahe;
  inherited Destroy;
end;

procedure TcvClaheOperation.ResetClahe;
begin
  if FClaheReady then
  begin
    FClahe.Release;
    FClaheReady := False;
  end;
end;

procedure TcvClaheOperation.EnsureClahe;
begin
  if not FClaheReady then
  begin
    FClahe := TCVCLAHE.Create(FClipLimit, TCVSize.Create(FTileWidth, FTileHeight));
    FClaheReady := True;
  end;
end;

procedure TcvClaheOperation.Assign(Source: TPersistent);
begin
  if Source is TcvClaheOperation then
  begin
    FClipLimit := TcvClaheOperation(Source).ClipLimit;
    FTileWidth := TcvClaheOperation(Source).TileWidth;
    FTileHeight := TcvClaheOperation(Source).TileHeight;
    ResetClahe;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvClaheOperation.GetDisplayName: string;
begin
  Result := Format('CLAHE (clip %.1f, tile %dx%d)', [FClipLimit, FTileWidth, FTileHeight]);
end;

procedure TcvClaheOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Gray, Enhanced, Color: TCVMat;
begin
  EnsureClahe;
  if Src.channels > 1 then
  begin
    Gray := TCVMat.Create_0(0, 0, CV_8UC1);
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
  end
  else
    Gray := Src;

  Enhanced := TCVMat.Create_0(0, 0, CV_8UC1);
  FClahe.apply(Gray.Handle, Enhanced.Handle);

  if Src.channels > 1 then
  begin
    Color := TCVMat.Create_0(0, 0, CV_8UC3);
    cvtColor(Enhanced.Handle, Color.Handle, COLOR_GRAY2BGR, 0, 0);
    Dst := Color;
  end
  else
    Dst := Enhanced;
end;

procedure TcvClaheOperation.SetClipLimit(const Value: Double);
begin
  if FClipLimit <> Value then
  begin
    FClipLimit := Value;
    ResetClahe;
    Changed;
  end;
end;

procedure TcvClaheOperation.SetTileWidth(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if V < 1 then V := 1;
  if FTileWidth <> V then
  begin
    FTileWidth := V;
    ResetClahe;
    Changed;
  end;
end;

procedure TcvClaheOperation.SetTileHeight(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if V < 1 then V := 1;
  if FTileHeight <> V then
  begin
    FTileHeight := V;
    ResetClahe;
    Changed;
  end;
end;

{ TcvInRangeOperation }

constructor TcvInRangeOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FPreset := irNone;
  FColorSpace := csNone;
  FLowerBound := TCVScalar.Create(0, 0, 0);
  FUpperBound := TCVScalar.Create(255, 255, 255);
  FOutputMaskOnly := False;
end;

procedure TcvInRangeOperation.ApplyPresetBounds;
begin
  FColorSpace := csHSV;
  case FPreset of
    irRed:
    begin
      FLowerBound := TCVScalar.Create(0, 100, 100);
      FUpperBound := TCVScalar.Create(10, 255, 255);
    end;
    irGreen:
    begin
      FLowerBound := TCVScalar.Create(35, 100, 100);
      FUpperBound := TCVScalar.Create(85, 255, 255);
    end;
    irBlue:
    begin
      FLowerBound := TCVScalar.Create(100, 100, 100);
      FUpperBound := TCVScalar.Create(130, 255, 255);
    end;
  end;
end;

procedure TcvInRangeOperation.Assign(Source: TPersistent);
begin
  if Source is TcvInRangeOperation then
  begin
    FPreset := TcvInRangeOperation(Source).Preset;
    FColorSpace := TcvInRangeOperation(Source).ColorSpace;
    FLowerBound := TcvInRangeOperation(Source).LowerBound;
    FUpperBound := TcvInRangeOperation(Source).UpperBound;
    FOutputMaskOnly := TcvInRangeOperation(Source).OutputMaskOnly;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvInRangeOperation.GetDisplayName: string;
begin
  if FPreset <> irNone then
    Result := Format('InRange (%s HSV)', [InRangePresetNames[FPreset]])
  else if FColorSpace = csHSV then
    Result := 'InRange (HSV)'
  else
    Result := 'InRange';
  if FOutputMaskOnly then
    Result := Result + ' mask';
end;

procedure TcvInRangeOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Work, Mask: TCVMat;
begin
  if FColorSpace = csHSV then
  begin
    Work := TCVMat.Create_0(0, 0, CV_8UC3);
    cvtColor(Src.Handle, Work.Handle, COLOR_BGR2HSV, 0, 0);
  end
  else
    Work := Src;

  Mask := TCVMat.Create_0(0, 0, CV_8UC1);
  inRange(Work.Handle, FLowerBound, FUpperBound, Mask.Handle);

  if FOutputMaskOnly then
    Dst := Mask
  else
  begin
    Dst := TCVMat.Create_0(0, 0, Src.dataType);
    bitwise_and(Src.Handle, Src.Handle, Dst.Handle, Mask.Handle);
  end;
end;

procedure TcvInRangeOperation.SetColorSpace(const Value: TcvInRangeColorSpace);
begin
  if FColorSpace <> Value then
  begin
    FColorSpace := Value;
    Changed;
  end;
end;

procedure TcvInRangeOperation.SetPreset(const Value: TcvInRangePreset);
begin
  if FPreset <> Value then
  begin
    FPreset := Value;
    if FPreset <> irNone then
      ApplyPresetBounds;
    Changed;
  end;
end;

procedure TcvInRangeOperation.SetLowerBound(const Value: TCVScalar);
begin
  FLowerBound := Value;
  Changed;
end;

procedure TcvInRangeOperation.SetUpperBound(const Value: TCVScalar);
begin
  FUpperBound := Value;
  Changed;
end;

procedure TcvInRangeOperation.SetOutputMaskOnly(const Value: Boolean);
begin
  if FOutputMaskOnly <> Value then
  begin
    FOutputMaskOnly := Value;
    Changed;
  end;
end;

{ TcvMorphologyExOperation }

constructor TcvMorphologyExOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FMorphExOp := meOpen;
  FMorphShape := msRect;
  FMorphSize := 3;
  FIterations := 1;
  FBorderMode := bmDefault;
  FBorderValue := TCVScalar.Create(0);
end;

function TcvMorphologyExOperation.BorderCode: Integer;
begin
  case FBorderMode of
    bmConstant: Result := BORDER_CONSTANT;
    bmReplicate: Result := BORDER_REPLICATE;
  else
    Result := BORDER_DEFAULT;
  end;
end;

function TcvMorphologyExOperation.MorphExCode: Integer;
begin
  case FMorphExOp of
    meOpen: Result := MORPH_OPEN;
    meClose: Result := MORPH_CLOSE;
    meGradient: Result := MORPH_GRADIENT;
    meTopHat: Result := MORPH_TOPHAT;
    meBlackHat: Result := MORPH_BLACKHAT;
  else
    Result := MORPH_OPEN;
  end;
end;

function TcvMorphologyExOperation.StructShape: Integer;
begin
  case FMorphShape of
    msRect: Result := MORPH_RECT;
    msCross: Result := MORPH_CROSS;
    msEllipse: Result := MORPH_ELLIPSE;
  else
    Result := MORPH_RECT;
  end;
end;

procedure TcvMorphologyExOperation.Assign(Source: TPersistent);
begin
  if Source is TcvMorphologyExOperation then
  begin
    FMorphExOp := TcvMorphologyExOperation(Source).MorphExOp;
    FMorphShape := TcvMorphologyExOperation(Source).MorphShape;
    FMorphSize := TcvMorphologyExOperation(Source).MorphSize;
    FIterations := TcvMorphologyExOperation(Source).Iterations;
    FBorderMode := TcvMorphologyExOperation(Source).BorderMode;
    FBorderValue := TcvMorphologyExOperation(Source).BorderValue;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvMorphologyExOperation.GetDisplayName: string;
begin
  Result := Format('MorphologyEx (%s, %d)', [MorphExOpNames[FMorphExOp], FMorphSize]);
end;

procedure TcvMorphologyExOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp, K: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  K := getStructuringElement(StructShape, TCVSize.Create(FMorphSize, FMorphSize), TCVPoint.Create(-1, -1));
  morphologyEx(Src.Handle, Temp.Handle, MorphExCode, K.Handle,
    TCVPoint.Create(-1, -1), FIterations, BorderCode, FBorderValue);
  Dst := Temp;
end;

procedure TcvMorphologyExOperation.SetMorphExOp(const Value: TcvMorphExOp);
begin
  if FMorphExOp <> Value then
  begin
    FMorphExOp := Value;
    Changed;
  end;
end;

procedure TcvMorphologyExOperation.SetMorphShape(const Value: TcvMorphShape);
begin
  if FMorphShape <> Value then
  begin
    FMorphShape := Value;
    Changed;
  end;
end;

procedure TcvMorphologyExOperation.SetMorphSize(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if V < 1 then V := 1;
  if FMorphSize <> V then
  begin
    FMorphSize := V;
    Changed;
  end;
end;

procedure TcvMorphologyExOperation.SetIterations(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if V < 1 then V := 1;
  if FIterations <> V then
  begin
    FIterations := V;
    Changed;
  end;
end;

procedure TcvMorphologyExOperation.SetBorderMode(const Value: TcvBorderMode);
begin
  if FBorderMode <> Value then
  begin
    FBorderMode := Value;
    Changed;
  end;
end;

procedure TcvMorphologyExOperation.SetBorderValue(const Value: TCVScalar);
begin
  FBorderValue := Value;
  Changed;
end;

{ TcvColorMapOperation }

constructor TcvColorMapOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FColormap := COLORMAP_JET;
end;

procedure TcvColorMapOperation.Assign(Source: TPersistent);
begin
  if Source is TcvColorMapOperation then
  begin
    FColormap := TcvColorMapOperation(Source).Colormap;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvColorMapOperation.GetDisplayName: string;
begin
  Result := Format('ColorMap (%d)', [FColormap]);
end;

procedure TcvColorMapOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Gray, Mapped: TCVMat;
begin
  if Src.channels > 1 then
  begin
    Gray := TCVMat.Create_0(0, 0, CV_8UC1);
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
  end
  else
    Gray := Src;

  Mapped := TCVMat.Create_0(0, 0, CV_8UC3);
  applyColorMap(Gray.Handle, Mapped.Handle, FColormap);
  Dst := Mapped;
end;

procedure TcvColorMapOperation.SetColormap(const Value: Integer);
begin
  if FColormap <> Value then
  begin
    FColormap := Value;
    Changed;
  end;
end;

{ TcvBrightnessContrastOperation }

constructor TcvBrightnessContrastOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FAlpha := 1.0;
  FBeta := 0.0;
end;

procedure TcvBrightnessContrastOperation.Assign(Source: TPersistent);
begin
  if Source is TcvBrightnessContrastOperation then
  begin
    FAlpha := TcvBrightnessContrastOperation(Source).Alpha;
    FBeta := TcvBrightnessContrastOperation(Source).Beta;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvBrightnessContrastOperation.GetDisplayName: string;
begin
  Result := Format('Brightness/Contrast (a=%.2f, b=%.0f)', [FAlpha, FBeta]);
end;

procedure TcvBrightnessContrastOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  Src.convertTo(Temp.Handle, Src.dataType, FAlpha, FBeta);
  Dst := Temp;
end;

procedure TcvBrightnessContrastOperation.SetAlpha(const Value: Double);
begin
  if FAlpha <> Value then
  begin
    FAlpha := Value;
    Changed;
  end;
end;

procedure TcvBrightnessContrastOperation.SetBeta(const Value: Double);
begin
  if FBeta <> Value then
  begin
    FBeta := Value;
    Changed;
  end;
end;

{ TcvPyrDownOperation }

constructor TcvPyrDownOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
end;

procedure TcvPyrDownOperation.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
end;

function TcvPyrDownOperation.GetDisplayName: string;
begin
  Result := 'PyrDown (x2)';
end;

procedure TcvPyrDownOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  pyrDown(Src.Handle, Temp.Handle, TCVSize.Create(0, 0), 4 {BORDER_DEFAULT});
  Dst := Temp;
end;

{ TcvPipelineStage }

constructor TcvPipelineStage.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FEnabled := True;
  FStageType := stColor;
  FOperation := TcvColorOperation.Create(Self);
end;

destructor TcvPipelineStage.Destroy;
begin
  FOperation.Free;
  inherited Destroy;
end;

procedure TcvPipelineStage.Assign(Source: TPersistent);
begin
  if Source is TcvPipelineStage then
  begin
    FEnabled := TcvPipelineStage(Source).Enabled;
    SetStageType(TcvPipelineStage(Source).StageType);
    if (FOperation <> nil) and (TcvPipelineStage(Source).Operation <> nil) then
      FOperation.Assign(TcvPipelineStage(Source).Operation);
  end
  else
    inherited Assign(Source);
end;

function TcvPipelineStage.GetDisplayName: string;
begin
  if FOperation <> nil then
    Result := FOperation.GetDisplayName
  else
    Result := 'Pipeline Stage';
  if not FEnabled then
    Result := Result + ' (Disabled)';
end;

procedure TcvPipelineStage.Process(const Src: TCVMat; var Dst: TCVMat);
begin
  if not FEnabled then
  begin
    if Src.Handle <> Dst.Handle then
      Src.copyTo(Dst.Handle);
    Exit;
  end;

  if FOperation <> nil then
    FOperation.Process(Src, Dst)
  else
  begin
    if Src.Handle <> Dst.Handle then
      Src.copyTo(Dst.Handle);
  end;
end;

procedure TcvPipelineStage.NotifyChanged;
begin
  Changed(False);
end;

procedure TcvPipelineStage.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed(False);
  end;
end;

procedure TcvPipelineStage.SetOperation(const Value: TcvCustomPipelineOperation);
begin
  if FOperation <> nil then
    FOperation.Assign(Value);
end;

procedure TcvPipelineStage.SetStageType(const Value: TcvStageType);
begin
  if FStageType <> Value then
  begin
    FStageType := Value;
    FOperation.Free;
    FOperation := nil;
    case FStageType of
      stColor: FOperation := TcvColorOperation.Create(Self);
      stBlur: FOperation := TcvBlurOperation.Create(Self);
      stThreshold: FOperation := TcvThresholdOperation.Create(Self);
      stCanny: FOperation := TcvCannyOperation.Create(Self);
      stMorphology: FOperation := TcvMorphologyOperation.Create(Self);
      stResize: FOperation := TcvResizeOperation.Create(Self);
      stCustom: FOperation := TcvCustomOperation.Create(Self);
      stAdaptiveThreshold: FOperation := TcvAdaptiveThresholdOperation.Create(Self);
      stBilateralFilter: FOperation := TcvBilateralFilterOperation.Create(Self);
      stEqualizeHist: FOperation := TcvEqualizeHistOperation.Create(Self);
      stSobel: FOperation := TcvSobelOperation.Create(Self);
      stInvert: FOperation := TcvInvertOperation.Create(Self);
      stClahe: FOperation := TcvClaheOperation.Create(Self);
      stInRange: FOperation := TcvInRangeOperation.Create(Self);
      stMorphologyEx: FOperation := TcvMorphologyExOperation.Create(Self);
      stColorMap: FOperation := TcvColorMapOperation.Create(Self);
      stBrightnessContrast: FOperation := TcvBrightnessContrastOperation.Create(Self);
      stPyrDown: FOperation := TcvPyrDownOperation.Create(Self);
    else
      if IsExtendedPipelineStage(FStageType) then
        FOperation := CreateExtendedPipelineOperation(FStageType, Self);
    end;
    Changed(False);
  end;
end;

{ TcvPipelineStages }

constructor TcvPipelineStages.Create(AOwner: TcvPipeline);
begin
  inherited Create(TcvPipelineStage);
  FOwner := AOwner;
end;

function TcvPipelineStages.Add: TcvPipelineStage;
begin
  Result := TcvPipelineStage(inherited Add);
end;

function TcvPipelineStages.GetItem(Index: Integer): TcvPipelineStage;
begin
  Result := TcvPipelineStage(inherited GetItem(Index));
end;

procedure TcvPipelineStages.SetItem(Index: Integer; Value: TcvPipelineStage);
begin
  inherited SetItem(Index, Value);
end;

function TcvPipelineStages.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

{ TcvPipeline }

class function TcvPipeline.ComponentPlatforms: Integer;
begin
  Result := $0002 or $0800; // pidWin64 ($0002) + pidWin64x ($0800)
end;

constructor TcvPipeline.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := True;
  FProcessEveryN := 1;
  FFrameCounter := 0;
  FErrorPolicy := epPassthrough;
  FPreset := ppNone;
  FStages := TcvPipelineStages.Create(Self);
end;

destructor TcvPipeline.Destroy;
begin
  FStages.Free;
  inherited Destroy;
end;

procedure TcvPipeline.Loaded;
begin
  inherited;
  if FPreset <> ppNone then
    ApplyPreset(FPreset);
end;

procedure TcvPipeline.Process(const Src: TCVMat; var Dst: TCVMat);
var
  I: Integer;
  CurrentSrc, CurrentDst, StageIn: TCVMat;
  Cancel: Boolean;
  Sw: TStopwatch;
  ElapsedMs: Double;
begin
  if Src.empty then
  begin
    Dst := Src;
    Exit;
  end;

  CurrentSrc := Src;

  for I := 0 to FStages.Count - 1 do
  begin
    if not FStages[I].Enabled then
      Continue;

    StageIn := CurrentSrc;
    Cancel := False;
    if Assigned(FOnBeforeStage) then
      FOnBeforeStage(Self, I, FStages[I], StageIn, CurrentDst, Cancel);
    if Cancel then
      Continue;

    Sw := TStopwatch.StartNew;
    try
      FStages[I].Process(StageIn, CurrentDst);
    except
      on E: Exception do
      begin
        case FErrorPolicy of
          epStop:
            raise;
          epSkipStage:
            CurrentDst := StageIn;
        else
          CurrentDst := StageIn;
        end;
      end;
    end;
    Sw.Stop;
    ElapsedMs := Sw.Elapsed.TotalMilliseconds;
    if Assigned(FOnStageTiming) then
      FOnStageTiming(Self, I, FStages[I].GetDisplayName, ElapsedMs);
    if Assigned(FOnAfterStage) then
      FOnAfterStage(Self, I, FStages[I], StageIn, CurrentDst, Cancel);

    CurrentSrc := CurrentDst;
  end;

  Dst := CurrentSrc;
end;

procedure TcvPipeline.SetProcessEveryN(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if V < 1 then V := 1;
  FProcessEveryN := V;
end;

procedure TcvPipeline.SetErrorPolicy(const Value: TcvPipelineErrorPolicy);
begin
  FErrorPolicy := Value;
end;

function TcvPipeline.GetPreset: TcvPipelinePreset;
begin
  Result := FPreset;
end;

procedure TcvPipeline.SetPreset(const Value: TcvPipelinePreset);
begin
  if FPreset = Value then
    Exit;
  FPreset := Value;
  if csReading in ComponentState then
    Exit;
  if FPreset <> ppNone then
    ApplyPreset(FPreset);
end;

procedure TcvPipeline.ApplyPreset(const Preset: TcvPipelinePreset);
var
  S: TcvPipelineStage;
  I: Integer;
begin
  if Preset = ppNone then
    Exit;
  FStages.Clear;
  case Preset of
    ppEdges:
      begin
        S := FStages.Add;
        S.StageType := stColor;
        S := FStages.Add;
        S.StageType := stBlur;
        TcvBlurOperation(S.Operation).BlurSize := 5;
        S := FStages.Add;
        S.StageType := stCanny;
        TcvCannyOperation(S.Operation).Thresh1 := 80;
        TcvCannyOperation(S.Operation).Thresh2 := 160;
      end;
    ppNightVision:
      begin
        S := FStages.Add;
        S.StageType := stClahe;
        S := FStages.Add;
        S.StageType := stBrightnessContrast;
        TcvBrightnessContrastOperation(S.Operation).Alpha := 1.2;
        TcvBrightnessContrastOperation(S.Operation).Beta := 10;
      end;
    ppDenoiseSharp:
      begin
        S := FStages.Add;
        S.StageType := stDenoise;
        S := FStages.Add;
        S.StageType := stSharpen;
      end;
    ppContours:
      begin
        S := FStages.Add;
        S.StageType := stColor;
        S := FStages.Add;
        S.StageType := stContours;
      end;
    ppMotionDetect:
      begin
        S := FStages.Add;
        S.StageType := stBackgroundSubtract;
      end;
    ppLines:
      begin
        S := FStages.Add;
        S.StageType := stHoughLinesP;
      end;
    ppOpticalFlow:
      begin
        S := FStages.Add;
        S.StageType := stOpticalFlow;
      end;
    ppGrabCut:
      begin
        S := FStages.Add;
        S.StageType := stGrabCut;
      end;
  end;
  for I := 0 to FStages.Count - 1 do
    FStages[I].Changed(False);
end;

procedure TcvPipeline.SaveToIni(const FileName: string);
var
  Ini: TIniFile;
  I: Integer;
  S: TcvPipelineStage;
begin
  Ini := TIniFile.Create(FileName);
  try
    Ini.WriteInteger('Pipeline', 'ProcessEveryN', FProcessEveryN);
    Ini.WriteInteger('Pipeline', 'ErrorPolicy', Ord(FErrorPolicy));
    Ini.WriteInteger('Pipeline', 'StageCount', FStages.Count);
    for I := 0 to FStages.Count - 1 do
    begin
      S := FStages[I];
      Ini.WriteBool(Format('Stage%d', [I]), 'Enabled', S.Enabled);
      Ini.WriteString(Format('Stage%d', [I]), 'Type', StageTypeToStr(S.StageType));
    end;
  finally
    Ini.Free;
  end;
end;

procedure TcvPipeline.LoadFromIni(const FileName: string);
var
  Ini: TIniFile;
  I, Count: Integer;
  S: TcvPipelineStage;
  StageType: TcvStageType;
  TypeName: string;
begin
  if not FileExists(FileName) then
    Exit;
  Ini := TIniFile.Create(FileName);
  try
    FProcessEveryN := Ini.ReadInteger('Pipeline', 'ProcessEveryN', 1);
    FErrorPolicy := TcvPipelineErrorPolicy(Ini.ReadInteger('Pipeline', 'ErrorPolicy', 0));
    Count := Ini.ReadInteger('Pipeline', 'StageCount', 0);
    FStages.Clear;
    for I := 0 to Count - 1 do
    begin
      TypeName := Ini.ReadString(Format('Stage%d', [I]), 'Type', '');
      if not StrToStageType(TypeName, StageType) then
        Continue;
      S := FStages.Add;
      S.StageType := StageType;
      S.Enabled := Ini.ReadBool(Format('Stage%d', [I]), 'Enabled', True);
    end;
  finally
    Ini.Free;
  end;
end;

procedure TcvPipeline.TakeMat(const AMat: TCVMat);
var
  OutMat: TCVMat;
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

  Inc(FFrameCounter);
  if (FProcessEveryN > 1) and ((FFrameCounter mod FProcessEveryN) <> 0) then
  begin
    NotifyReceiver(AMat);
    Exit;
  end;

  if not AMat.empty then
  begin
    try
      Process(AMat, OutMat);
    except
      OutMat := AMat;
    end;
    NotifyReceiver(OutMat);
  end
  else
    NotifyReceiver(AMat);
end;

procedure TcvPipeline.SetStages(const Value: TcvPipelineStages);
begin
  FStages.Assign(Value);
end;

initialization
  RegisterClass(TcvColorOperation);
  RegisterClass(TcvBlurOperation);
  RegisterClass(TcvThresholdOperation);
  RegisterClass(TcvCannyOperation);
  RegisterClass(TcvMorphologyOperation);
  RegisterClass(TcvResizeOperation);
  RegisterClass(TcvCustomOperation);
  RegisterClass(TcvAdaptiveThresholdOperation);
  RegisterClass(TcvBilateralFilterOperation);
  RegisterClass(TcvEqualizeHistOperation);
  RegisterClass(TcvSobelOperation);
  RegisterClass(TcvInvertOperation);
  RegisterClass(TcvClaheOperation);
  RegisterClass(TcvInRangeOperation);
  RegisterClass(TcvMorphologyExOperation);
  RegisterClass(TcvColorMapOperation);
  RegisterClass(TcvBrightnessContrastOperation);
  RegisterClass(TcvPyrDownOperation);

end.
