unit OpenCV5.Components.Pipeline.Extended;

{$IFNDEF WIN64}
  {$IFNDEF PACKAGE}
    {$MESSAGE ERROR 'OpenCV 5.0 components are only supported in Win64 applications.'}
  {$ENDIF}
{$ENDIF}

interface

uses
  System.Classes, System.SysUtils, System.Math,
  OpenCV5.Core, OpenCV5.Types, OpenCV5.Imgproc, OpenCV5.Imgcodecs, OpenCV5.Photo,
  OpenCV5.Arith, OpenCV5.Video, OpenCV5.Helpers, OpenCV5.Components.Pipeline;

function IsExtendedPipelineStage(const StageType: TcvStageType): Boolean;
function CreateExtendedPipelineOperation(const StageType: TcvStageType;
  AOwner: TcvPipelineStage): TcvCustomPipelineOperation;
function StageTypeToStr(const StageType: TcvStageType): string;
function StrToStageType(const S: string; out StageType: TcvStageType): Boolean;

type
  TcvBitwiseOp = (boAnd, boOr, boXor, boNot);

  TcvPyrUpOperation = class(TcvCustomPipelineOperation)
  public
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
  end;

  TcvLaplacianOperation = class(TcvCustomPipelineOperation)
  private
    Fksize: Integer;
    procedure Setksize(const Value: Integer);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ksize: Integer read Fksize write Setksize default 1;
  end;

  TcvScharrOperation = class(TcvCustomPipelineOperation)
  private
    Fdx: Integer;
    Fdy: Integer;
    procedure Setdx(const Value: Integer);
    procedure Setdy(const Value: Integer);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property dx: Integer read Fdx write Setdx default 1;
    property dy: Integer read Fdy write Setdy default 0;
  end;

  TcvDenoiseOperation = class(TcvCustomPipelineOperation)
  private
    FH: Single;
    FTemplateWindow: Integer;
    FSearchWindow: Integer;
    procedure SetH(const Value: Single);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property H: Single read FH write SetH;
    property TemplateWindow: Integer read FTemplateWindow write FTemplateWindow default 7;
    property SearchWindow: Integer read FSearchWindow write FSearchWindow default 21;
  end;

  TcvDistanceTransformOperation = class(TcvCustomPipelineOperation)
  private
    FMaskSize: Integer;
    procedure SetMaskSize(const Value: Integer);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property MaskSize: Integer read FMaskSize write SetMaskSize default 5;
  end;

  TcvCropOperation = class(TcvCustomPipelineOperation)
  private
    FX: Integer;
    FY: Integer;
    FWidth: Integer;
    FHeight: Integer;
    procedure SetX(const Value: Integer);
    procedure SetY(const Value: Integer);
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(const Value: Integer);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property X: Integer read FX write SetX;
    property Y: Integer read FY write SetY;
    property Width: Integer read FWidth write SetWidth default 320;
    property Height: Integer read FHeight write SetHeight default 240;
  end;

  TcvNormalizeOperation = class(TcvCustomPipelineOperation)
  public
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
  end;

  TcvSharpenOperation = class(TcvCustomPipelineOperation)
  private
    FAmount: Double;
    procedure SetAmount(const Value: Double);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Amount: Double read FAmount write SetAmount;
  end;

  TcvBitwiseOperation = class(TcvCustomPipelineOperation)
  private
    FBitwiseOp: TcvBitwiseOp;
    FOperand: TCVMat;
    FOperandPath: string;
    FOperandPathLoaded: string;
    FOperandLoaded: Boolean;
    procedure SetBitwiseOp(const Value: TcvBitwiseOp);
    procedure SetOperandPath(const Value: string);
    procedure EnsureOperand;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property BitwiseOp: TcvBitwiseOp read FBitwiseOp write SetBitwiseOp default boNot;
    property OperandPath: string read FOperandPath write SetOperandPath;
  end;

  TcvRotateOperation = class(TcvCustomPipelineOperation)
  private
    FAngle: Double;
    FScale: Double;
    procedure SetAngle(const Value: Double);
    procedure SetScale(const Value: Double);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Angle: Double read FAngle write SetAngle;
    property Scale: Double read FScale write SetScale;
  end;

  TcvWarpPolarOperation = class(TcvCustomPipelineOperation)
  private
    FMaxRadius: Double;
    procedure SetMaxRadius(const Value: Double);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property MaxRadius: Double read FMaxRadius write SetMaxRadius;
  end;

  TcvFilter2DOperation = class(TcvCustomPipelineOperation)
  private
    FKernelSize: Integer;
    FSharpen: Boolean;
    procedure SetKernelSize(const Value: Integer);
    procedure SetSharpen(const Value: Boolean);
    function BuildKernel: TCVMat;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property KernelSize: Integer read FKernelSize write SetKernelSize default 3;
    property SharpenKernel: Boolean read FSharpen write SetSharpen default True;
  end;

  TcvCornerHarrisOperation = class(TcvCustomPipelineOperation)
  private
    FBlockSize: Integer;
    Fksize: Integer;
    FK: Double;
    procedure SetBlockSize(const Value: Integer);
    procedure Setksize(const Value: Integer);
    procedure SetK(const Value: Double);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property BlockSize: Integer read FBlockSize write SetBlockSize default 2;
    property ksize: Integer read Fksize write Setksize default 3;
    property K: Double read FK write SetK;
  end;

  TcvTemporalBlendOperation = class(TcvCustomPipelineOperation)
  private
    FAlpha: Double;
    FAccum: TCVMat;
    FAccumReady: Boolean;
    procedure SetAlpha(const Value: Double);
    procedure ResetAccum;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    destructor Destroy; override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Alpha: Double read FAlpha write SetAlpha;
  end;

  TcvPipelineMatchResult = record
    Found: Boolean;
    MatchRect: TCVRect;
    MaxLocation: TCVPoint;
    MinLocation: TCVPoint;
    MaxValue: Double;
    MinValue: Double;
    TemplateWidth: Integer;
    TemplateHeight: Integer;
  end;

  TcvPipelineContourItem = record
    Index: Integer;
    Area: Double;
    ArcLength: Double;
    BoundingRect: TCVRect;
    Points: TArray<TCVPoint>;
  end;

  TcvPipelineContoursResult = record
    Count: Integer;
    Items: TArray<TcvPipelineContourItem>;
  end;

  TcvPipelineMatchTemplateEvent = procedure(Sender: TObject; const Src: TCVMat;
    const MatchResult: TcvPipelineMatchResult) of object;
  TcvPipelineContoursEvent = procedure(Sender: TObject; const Src: TCVMat;
    const ContoursResult: TcvPipelineContoursResult) of object;

  TcvMatchTemplateOperation = class(TcvCustomPipelineOperation)
  private
    FTemplatePath: string;
    FMethod: Integer;
    FDrawOverlay: Boolean;
    FOnMatchResult: TcvPipelineMatchTemplateEvent;
    FTemplate: TCVMat;
    FTemplatePathLoaded: string;
    procedure SetTemplatePath(const Value: string);
    procedure SetMethod(const Value: Integer);
    procedure SetDrawOverlay(const Value: Boolean);
    procedure SetOnMatchResult(const Value: TcvPipelineMatchTemplateEvent);
    procedure EnsureTemplate;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property TemplatePath: string read FTemplatePath write SetTemplatePath;
    property Method: Integer read FMethod write SetMethod default 5;
    property DrawOverlay: Boolean read FDrawOverlay write SetDrawOverlay default True;
    property OnMatchResult: TcvPipelineMatchTemplateEvent read FOnMatchResult write SetOnMatchResult;
  end;

  TcvContoursOperation = class(TcvCustomPipelineOperation)
  private
    FThickness: Integer;
    FDrawOverlay: Boolean;
    FOnContoursResult: TcvPipelineContoursEvent;
    procedure SetThickness(const Value: Integer);
    procedure SetDrawOverlay(const Value: Boolean);
    procedure SetOnContoursResult(const Value: TcvPipelineContoursEvent);
    function BuildContoursResult(const Contours: TCVMatVector): TcvPipelineContoursResult;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Thickness: Integer read FThickness write SetThickness default 2;
    property DrawOverlay: Boolean read FDrawOverlay write SetDrawOverlay default True;
    property OnContoursResult: TcvPipelineContoursEvent read FOnContoursResult write SetOnContoursResult;
  end;

  TcvPipelineLineSegment = record
    X1, Y1, X2, Y2: Integer;
  end;

  TcvPipelineHoughLinesResult = record
    Count: Integer;
    Lines: TArray<TcvPipelineLineSegment>;
  end;

  TcvPipelineCircle = record
    Center: TCVPoint;
    Radius: Integer;
  end;

  TcvPipelineHoughCirclesResult = record
    Count: Integer;
    Circles: TArray<TcvPipelineCircle>;
  end;

  TcvPipelineBlobItem = record
    LabelId: Integer;
    Area: Integer;
    Centroid: TCVPoint;
    BoundingRect: TCVRect;
  end;

  TcvPipelineConnectedComponentsResult = record
    Count: Integer;
    Items: TArray<TcvPipelineBlobItem>;
  end;

  TcvPipelineForegroundResult = record
    ForegroundPixelCount: Integer;
    ForegroundRatio: Double;
  end;

  TcvPipelineHoughLinesEvent = procedure(Sender: TObject; const Src: TCVMat;
    const LinesResult: TcvPipelineHoughLinesResult) of object;
  TcvPipelineHoughCirclesEvent = procedure(Sender: TObject; const Src: TCVMat;
    const CirclesResult: TcvPipelineHoughCirclesResult) of object;
  TcvPipelineConnectedComponentsEvent = procedure(Sender: TObject; const Src: TCVMat;
    const ComponentsResult: TcvPipelineConnectedComponentsResult) of object;
  TcvPipelineForegroundMaskEvent = procedure(Sender: TObject; const Src: TCVMat;
    const ForegroundResult: TcvPipelineForegroundResult) of object;

  TcvBackgroundSubtractAlgorithm = (bsMOG2, bsKNN);

  TcvHoughLinesPOperation = class(TcvCustomPipelineOperation)
  private
    FRho: Double;
    FTheta: Double;
    FThreshold: Integer;
    FMinLineLength: Double;
    FMaxLineGap: Double;
    FUseCanny: Boolean;
    FCannyThresh1: Double;
    FCannyThresh2: Double;
    FCannyAperture: Integer;
    FLineThickness: Integer;
    FLineColor: TCVScalar;
    FDrawOverlay: Boolean;
    FOnHoughLinesResult: TcvPipelineHoughLinesEvent;
    procedure SetRho(const Value: Double);
    procedure SetTheta(const Value: Double);
    procedure SetThreshold(const Value: Integer);
    procedure SetMinLineLength(const Value: Double);
    procedure SetMaxLineGap(const Value: Double);
    procedure SetUseCanny(const Value: Boolean);
    procedure SetCannyThresh1(const Value: Double);
    procedure SetCannyThresh2(const Value: Double);
    procedure SetCannyAperture(const Value: Integer);
    procedure SetLineThickness(const Value: Integer);
    procedure SetLineColor(const Value: TCVScalar);
    procedure SetDrawOverlay(const Value: Boolean);
    procedure SetOnHoughLinesResult(const Value: TcvPipelineHoughLinesEvent);
    function ParseLines(const LinesMat: TCVMat): TcvPipelineHoughLinesResult;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Rho: Double read FRho write SetRho;
    property Theta: Double read FTheta write SetTheta;
    property Threshold: Integer read FThreshold write SetThreshold default 50;
    property MinLineLength: Double read FMinLineLength write SetMinLineLength;
    property MaxLineGap: Double read FMaxLineGap write SetMaxLineGap;
    property UseCanny: Boolean read FUseCanny write SetUseCanny default True;
    property CannyThresh1: Double read FCannyThresh1 write SetCannyThresh1;
    property CannyThresh2: Double read FCannyThresh2 write SetCannyThresh2;
    property CannyAperture: Integer read FCannyAperture write SetCannyAperture default 3;
    property LineThickness: Integer read FLineThickness write SetLineThickness default 2;
    property LineColor: TCVScalar read FLineColor write SetLineColor;
    property DrawOverlay: Boolean read FDrawOverlay write SetDrawOverlay default True;
    property OnHoughLinesResult: TcvPipelineHoughLinesEvent read FOnHoughLinesResult write SetOnHoughLinesResult;
  end;

  TcvHoughCirclesOperation = class(TcvCustomPipelineOperation)
  private
    FMethod: Integer;
    FDp: Double;
    FMinDist: Double;
    FParam1: Double;
    FParam2: Double;
    FMinRadius: Integer;
    FMaxRadius: Integer;
    FCircleThickness: Integer;
    FCircleColor: TCVScalar;
    FDrawOverlay: Boolean;
    FOnHoughCirclesResult: TcvPipelineHoughCirclesEvent;
    procedure SetMethod(const Value: Integer);
    procedure SetDp(const Value: Double);
    procedure SetMinDist(const Value: Double);
    procedure SetParam1(const Value: Double);
    procedure SetParam2(const Value: Double);
    procedure SetMinRadius(const Value: Integer);
    procedure SetMaxRadius(const Value: Integer);
    procedure SetCircleThickness(const Value: Integer);
    procedure SetCircleColor(const Value: TCVScalar);
    procedure SetDrawOverlay(const Value: Boolean);
    procedure SetOnHoughCirclesResult(const Value: TcvPipelineHoughCirclesEvent);
    function ParseCircles(const CirclesMat: TCVMat): TcvPipelineHoughCirclesResult;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Method: Integer read FMethod write SetMethod default 3;
    property Dp: Double read FDp write SetDp;
    property MinDist: Double read FMinDist write SetMinDist;
    property Param1: Double read FParam1 write SetParam1;
    property Param2: Double read FParam2 write SetParam2;
    property MinRadius: Integer read FMinRadius write SetMinRadius default 0;
    property MaxRadius: Integer read FMaxRadius write SetMaxRadius default 0;
    property CircleThickness: Integer read FCircleThickness write SetCircleThickness default 2;
    property CircleColor: TCVScalar read FCircleColor write SetCircleColor;
    property DrawOverlay: Boolean read FDrawOverlay write SetDrawOverlay default True;
    property OnHoughCirclesResult: TcvPipelineHoughCirclesEvent read FOnHoughCirclesResult write SetOnHoughCirclesResult;
  end;

  TcvConnectedComponentsOperation = class(TcvCustomPipelineOperation)
  private
    FThresholdValue: Double;
    FMinArea: Integer;
    FMaxArea: Integer;
    FConnectivity: Integer;
    FBoxThickness: Integer;
    FBoxColor: TCVScalar;
    FDrawOverlay: Boolean;
    FColormapSeed: Integer;
    FOnConnectedComponentsResult: TcvPipelineConnectedComponentsEvent;
    procedure SetThresholdValue(const Value: Double);
    procedure SetMinArea(const Value: Integer);
    procedure SetMaxArea(const Value: Integer);
    procedure SetConnectivity(const Value: Integer);
    procedure SetBoxThickness(const Value: Integer);
    procedure SetBoxColor(const Value: TCVScalar);
    procedure SetDrawOverlay(const Value: Boolean);
    procedure SetColormapSeed(const Value: Integer);
    procedure SetOnConnectedComponentsResult(const Value: TcvPipelineConnectedComponentsEvent);
    function AreaPassesFilter(const Area: Integer): Boolean;
    function BuildComponentsResult(const Labels: TCVMat; const Stats, Centroids: TCVMat;
      LabelCount: Integer): TcvPipelineConnectedComponentsResult;
    procedure BuildLabels8(const Labels: TCVMat; var Labels8: TCVMat);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ThresholdValue: Double read FThresholdValue write SetThresholdValue;
    property MinArea: Integer read FMinArea write SetMinArea default 0;
    property MaxArea: Integer read FMaxArea write SetMaxArea default 0;
    property Connectivity: Integer read FConnectivity write SetConnectivity default 8;
    property BoxThickness: Integer read FBoxThickness write SetBoxThickness default 2;
    property BoxColor: TCVScalar read FBoxColor write SetBoxColor;
    property DrawOverlay: Boolean read FDrawOverlay write SetDrawOverlay default True;
    property ColormapSeed: Integer read FColormapSeed write SetColormapSeed default 0;
    property OnConnectedComponentsResult: TcvPipelineConnectedComponentsEvent
      read FOnConnectedComponentsResult write SetOnConnectedComponentsResult;
  end;

  TcvBackgroundSubtractOperation = class(TcvCustomPipelineOperation)
  private
    FAlgorithm: TcvBackgroundSubtractAlgorithm;
    FHistory: Integer;
    FVarThreshold: Double;
    FDist2Threshold: Double;
    FDetectShadows: Boolean;
    FLearningRate: Double;
    FShowShadows: Boolean;
    FDrawOverlay: Boolean;
    FResetOnAssign: Boolean;
    FOnForegroundMaskResult: TcvPipelineForegroundMaskEvent;
    FMOG2: TCVMOG2;
    FKNN: TCVKNN;
    FActiveAlgorithm: TcvBackgroundSubtractAlgorithm;
    FSubtractorReady: Boolean;
    FFrameCount: Integer;
    procedure SetAlgorithm(const Value: TcvBackgroundSubtractAlgorithm);
    procedure SetHistory(const Value: Integer);
    procedure SetVarThreshold(const Value: Double);
    procedure SetDist2Threshold(const Value: Double);
    procedure SetDetectShadows(const Value: Boolean);
    procedure SetLearningRate(const Value: Double);
    procedure SetShowShadows(const Value: Boolean);
    procedure SetDrawOverlay(const Value: Boolean);
    procedure SetResetOnAssign(const Value: Boolean);
    procedure SetOnForegroundMaskResult(const Value: TcvPipelineForegroundMaskEvent);
    procedure ResetSubtractor;
    procedure EnsureSubtractor;
    procedure PrepareMask(const Mask: TCVMat; out WorkMask: TCVMat; out NeedRelease: Boolean);
    function BuildForegroundResult(const Mask: TCVMat): TcvPipelineForegroundResult;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    destructor Destroy; override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
    procedure Reset;
  published
    property Algorithm: TcvBackgroundSubtractAlgorithm read FAlgorithm write SetAlgorithm default bsMOG2;
    property History: Integer read FHistory write SetHistory default 500;
    property VarThreshold: Double read FVarThreshold write SetVarThreshold;
    property Dist2Threshold: Double read FDist2Threshold write SetDist2Threshold;
    property DetectShadows: Boolean read FDetectShadows write SetDetectShadows default True;
    property LearningRate: Double read FLearningRate write SetLearningRate;
    property ShowShadows: Boolean read FShowShadows write SetShowShadows default True;
    property DrawOverlay: Boolean read FDrawOverlay write SetDrawOverlay default True;
    property ResetOnAssign: Boolean read FResetOnAssign write SetResetOnAssign default True;
    property OnForegroundMaskResult: TcvPipelineForegroundMaskEvent
      read FOnForegroundMaskResult write SetOnForegroundMaskResult;
  end;

  TcvPipelinePhaseCorrelateResult = record
    Shift: TCVPoint2d;
    Response: Double;
    HasPrevious: Boolean;
  end;

  TcvPipelinePhaseCorrelateEvent = procedure(Sender: TObject; const Src: TCVMat;
    const PhaseResult: TcvPipelinePhaseCorrelateResult) of object;

  TcvDebugTextOperation = class(TcvCustomPipelineOperation)
  private
    FText: string;
    FOrgX: Integer;
    FOrgY: Integer;
    FFontFace: Integer;
    FFontScale: Double;
    FTextColor: TCVScalar;
    FTextThickness: Integer;
    FDrawRect: Boolean;
    FRect: TCVRect;
    FRectColor: TCVScalar;
    FRectThickness: Integer;
    FDrawOverlay: Boolean;
    procedure SetText(const Value: string);
    procedure SetOrgX(const Value: Integer);
    procedure SetOrgY(const Value: Integer);
    procedure SetFontFace(const Value: Integer);
    procedure SetFontScale(const Value: Double);
    procedure SetTextColor(const Value: TCVScalar);
    procedure SetTextThickness(const Value: Integer);
    procedure SetDrawRect(const Value: Boolean);
    procedure SetRect(const Value: TCVRect);
    procedure SetRectColor(const Value: TCVScalar);
    procedure SetRectThickness(const Value: Integer);
    procedure SetDrawOverlay(const Value: Boolean);
    function EnsureColorImage(const Src: TCVMat): TCVMat;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Text: string read FText write SetText;
    property OrgX: Integer read FOrgX write SetOrgX;
    property OrgY: Integer read FOrgY write SetOrgY;
    property FontFace: Integer read FFontFace write SetFontFace default 0;
    property FontScale: Double read FFontScale write SetFontScale;
    property TextColor: TCVScalar read FTextColor write SetTextColor;
    property TextThickness: Integer read FTextThickness write SetTextThickness default 1;
    property DrawRect: Boolean read FDrawRect write SetDrawRect default False;
    property Rect: TCVRect read FRect write SetRect;
    property RectColor: TCVScalar read FRectColor write SetRectColor;
    property RectThickness: Integer read FRectThickness write SetRectThickness default 2;
    property DrawOverlay: Boolean read FDrawOverlay write SetDrawOverlay default True;
  end;

  TcvPhaseCorrelateOperation = class(TcvCustomPipelineOperation)
  private
    FReferencePath: string;
    FReference: TCVMat;
    FReferencePathLoaded: string;
    FReferenceReady: Boolean;
    FPrev: TCVMat;
    FPrevReady: Boolean;
    FDrawOverlay: Boolean;
    FArrowScale: Double;
    FOnPhaseCorrelateResult: TcvPipelinePhaseCorrelateEvent;
    procedure SetReferencePath(const Value: string);
    procedure SetDrawOverlay(const Value: Boolean);
    procedure SetArrowScale(const Value: Double);
    procedure SetOnPhaseCorrelateResult(const Value: TcvPipelinePhaseCorrelateEvent);
    procedure ResetPrev;
    procedure EnsureReference(const Src: TCVMat);
    function ToGrayFloat(const Src: TCVMat): TCVMat;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    destructor Destroy; override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ReferencePath: string read FReferencePath write SetReferencePath;
    property DrawOverlay: Boolean read FDrawOverlay write SetDrawOverlay default True;
    property ArrowScale: Double read FArrowScale write SetArrowScale;
    property OnPhaseCorrelateResult: TcvPipelinePhaseCorrelateEvent
      read FOnPhaseCorrelateResult write SetOnPhaseCorrelateResult;
  end;

  TcvChannelExtractOperation = class(TcvCustomPipelineOperation)
  private
    FChannelIndex: Integer;
    procedure SetChannelIndex(const Value: Integer);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ChannelIndex: Integer read FChannelIndex write SetChannelIndex;
  end;

  TcvFlipMode = (fmVertical, fmHorizontal, fmBoth);
  TcvOrthoRotateMode = (or90CW, or180, or90CCW);

  TcvFlipOperation = class(TcvCustomPipelineOperation)
  private
    FFlipMode: TcvFlipMode;
    procedure SetFlipMode(const Value: TcvFlipMode);
    function FlipCode: Integer;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property FlipMode: TcvFlipMode read FFlipMode write SetFlipMode default fmHorizontal;
  end;

  TcvOrthoRotateOperation = class(TcvCustomPipelineOperation)
  private
    FRotateMode: TcvOrthoRotateMode;
    procedure SetRotateMode(const Value: TcvOrthoRotateMode);
    function RotateCode: Integer;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property RotateMode: TcvOrthoRotateMode read FRotateMode write SetRotateMode default or90CW;
  end;

  TcvGammaOperation = class(TcvCustomPipelineOperation)
  private
    FGamma: Double;
    FLut: TCVMat;
    FLutReady: Boolean;
    FLutGamma: Double;
    procedure SetGamma(const Value: Double);
    procedure EnsureLut;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    destructor Destroy; override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Gamma: Double read FGamma write SetGamma;
  end;

  TcvAddWeightedOperation = class(TcvCustomPipelineOperation)
  private
    FAlpha: Double;
    FBeta: Double;
    FBlendGamma: Double;
    FOperandPath: string;
    FOperandPathLoaded: string;
    FOperand: TCVMat;
    FOperandLoaded: Boolean;
    procedure SetAlpha(const Value: Double);
    procedure SetBeta(const Value: Double);
    procedure SetBlendGamma(const Value: Double);
    procedure SetOperandPath(const Value: string);
    procedure EnsureOperand(const Src: TCVMat; out Src2: TCVMat; out NeedRelease: Boolean);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Alpha: Double read FAlpha write SetAlpha;
    property Beta: Double read FBeta write SetBeta;
    property BlendGamma: Double read FBlendGamma write SetBlendGamma;
    property OperandPath: string read FOperandPath write SetOperandPath;
  end;

  TcvSpatialGradientOutput = (sgDx, sgDy, sgAbsSum);
  TcvInpaintMethod = (imNavierStokes, imTelea);

  TcvPyrMeanShiftOperation = class(TcvCustomPipelineOperation)
  private
    FSp: Double;
    FSr: Double;
    FMaxLevel: Integer;
    procedure SetSp(const Value: Double);
    procedure SetSr(const Value: Double);
    procedure SetMaxLevel(const Value: Integer);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Sp: Double read FSp write SetSp;
    property Sr: Double read FSr write SetSr;
    property MaxLevel: Integer read FMaxLevel write SetMaxLevel default 1;
  end;

  TcvSepFilter2DOperation = class(TcvCustomPipelineOperation)
  private
    FKernelSize: Integer;
    FSigma: Double;
    procedure SetKernelSize(const Value: Integer);
    procedure SetSigma(const Value: Double);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property KernelSize: Integer read FKernelSize write SetKernelSize default 5;
    property Sigma: Double read FSigma write SetSigma;
  end;

  TcvSqrBoxFilterOperation = class(TcvCustomPipelineOperation)
  private
    FKernelSize: Integer;
    FNormalize: Boolean;
    procedure SetKernelSize(const Value: Integer);
    procedure SetNormalize(const Value: Boolean);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property KernelSize: Integer read FKernelSize write SetKernelSize default 5;
    property Normalize: Boolean read FNormalize write SetNormalize default True;
  end;

  TcvSpatialGradientOperation = class(TcvCustomPipelineOperation)
  private
    Fksize: Integer;
    FOutput: TcvSpatialGradientOutput;
    procedure Setksize(const Value: Integer);
    procedure SetOutput(const Value: TcvSpatialGradientOutput);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ksize: Integer read Fksize write Setksize default 3;
    property Output: TcvSpatialGradientOutput read FOutput write SetOutput default sgDx;
  end;

  TcvCornerMinEigenValOperation = class(TcvCustomPipelineOperation)
  private
    FBlockSize: Integer;
    Fksize: Integer;
    procedure SetBlockSize(const Value: Integer);
    procedure Setksize(const Value: Integer);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property BlockSize: Integer read FBlockSize write SetBlockSize default 3;
    property ksize: Integer read Fksize write Setksize default 3;
  end;

  TcvIntegralOperation = class(TcvCustomPipelineOperation)
  private
    FNormalizeView: Boolean;
    procedure SetNormalizeView(const Value: Boolean);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property NormalizeView: Boolean read FNormalizeView write SetNormalizeView default True;
  end;

  TcvAbsDiffOperation = class(TcvCustomPipelineOperation)
  private
    FPrev: TCVMat;
    FPrevReady: Boolean;
    procedure ResetPrev;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    destructor Destroy; override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TcvAutoContrastOperation = class(TcvCustomPipelineOperation)
  private
    FTargetMean: Double;
    FTargetStd: Double;
    procedure SetTargetMean(const Value: Double);
    procedure SetTargetStd(const Value: Double);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property TargetMean: Double read FTargetMean write SetTargetMean;
    property TargetStd: Double read FTargetStd write SetTargetStd;
  end;

  TcvMergeChannelsOperation = class(TcvCustomPipelineOperation)
  private
    FChannel1Path: string;
    FChannel2Path: string;
    FChannel1Loaded: TCVMat;
    FChannel2Loaded: TCVMat;
    FChannel1PathLoaded: string;
    FChannel2PathLoaded: string;
    procedure SetChannel1Path(const Value: string);
    procedure SetChannel2Path(const Value: string);
    function EnsureGrayChannel(const Src: TCVMat; const Path: string; var Loaded: TCVMat;
      var PathLoaded: string): TCVMat;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Channel1Path: string read FChannel1Path write SetChannel1Path;
    property Channel2Path: string read FChannel2Path write SetChannel2Path;
  end;

  TcvInpaintOperation = class(TcvCustomPipelineOperation)
  private
    FMaskPath: string;
    FRadius: Double;
    FMethod: TcvInpaintMethod;
    FMask: TCVMat;
    FMaskPathLoaded: string;
    procedure SetMaskPath(const Value: string);
    procedure SetRadius(const Value: Double);
    procedure SetMethod(const Value: TcvInpaintMethod);
    procedure EnsureMask(const Src: TCVMat);
    function InpaintFlags: Integer;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property MaskPath: string read FMaskPath write SetMaskPath;
    property Radius: Double read FRadius write SetRadius;
    property Method: TcvInpaintMethod read FMethod write SetMethod default imNavierStokes;
  end;

  TcvUndistortOperation = class(TcvCustomPipelineOperation)
  private
    FCameraMatrix: string;
    FDistCoeffs: string;
    FK: TCVMat;
    FD: TCVMat;
    FParamsLoaded: string;
    FParamsReady: Boolean;
    procedure SetCameraMatrix(const Value: string);
    procedure SetDistCoeffs(const Value: string);
    procedure EnsureParams;
    function ParseDoubles(const S: string; out Values: TArray<Double>): Boolean;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    destructor Destroy; override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property CameraMatrix: string read FCameraMatrix write SetCameraMatrix;
    property DistCoeffs: string read FDistCoeffs write SetDistCoeffs;
  end;

  TcvRemapOperation = class(TcvCustomPipelineOperation)
  private
    FMap1Path: string;
    FMap2Path: string;
    FMap1: TCVMat;
    FMap2: TCVMat;
    FMap1PathLoaded: string;
    FMap2PathLoaded: string;
    FMapsReady: Boolean;
    procedure SetMap1Path(const Value: string);
    procedure SetMap2Path(const Value: string);
    procedure EnsureMaps;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    destructor Destroy; override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Map1Path: string read FMap1Path write SetMap1Path;
    property Map2Path: string read FMap2Path write SetMap2Path;
  end;

  TcvCustomLUTOperation = class(TcvCustomPipelineOperation)
  private
    FLUTPath: string;
    FLUT: TCVMat;
    FLUTPathLoaded: string;
    FLUTReady: Boolean;
    procedure SetLUTPath(const Value: string);
    procedure EnsureLUT;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    destructor Destroy; override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property LUTPath: string read FLUTPath write SetLUTPath;
  end;

  TcvOpticalFlowOutput = (ofoMagnitude, ofoHSV, ofoSourceOverlay);
  TcvGrabCutOutput = (gcoMask, gcoForeground, gcoOverlay);
  TcvWatershedOutput = (wsoBoundaries, wsoMarkers);

  TcvPipelineOpticalFlowResult = record
    MeanMagnitude: Double;
    HasPrevious: Boolean;
  end;
  TcvPipelineOpticalFlowEvent = procedure(Sender: TObject; const Src: TCVMat;
    const FlowResult: TcvPipelineOpticalFlowResult) of object;

  TcvBlendLinearOperation = class(TcvCustomPipelineOperation)
  private
    FOperandPath: string;
    FOperand: TCVMat;
    FOperandPathLoaded: string;
    FOperandLoaded: Boolean;
    FWeight1: Double;
    FWeight2: Double;
    procedure SetOperandPath(const Value: string);
    procedure SetWeight1(const Value: Double);
    procedure SetWeight2(const Value: Double);
    procedure EnsureOperand(const Src: TCVMat; out Src2: TCVMat; out NeedRelease: Boolean);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property OperandPath: string read FOperandPath write SetOperandPath;
    property Weight1: Double read FWeight1 write SetWeight1;
    property Weight2: Double read FWeight2 write SetWeight2;
  end;

  TcvReferenceDiffOperation = class(TcvCustomPipelineOperation)
  private
    FReferencePath: string;
    FReference: TCVMat;
    FReferencePathLoaded: string;
    FReferenceLoaded: Boolean;
    FDrawOverlay: Boolean;
    procedure SetReferencePath(const Value: string);
    procedure SetDrawOverlay(const Value: Boolean);
    procedure EnsureReference(const Src: TCVMat; out Ref: TCVMat; out NeedRelease: Boolean);
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ReferencePath: string read FReferencePath write SetReferencePath;
    property DrawOverlay: Boolean read FDrawOverlay write SetDrawOverlay default True;
  end;

  TcvOpticalFlowOperation = class(TcvCustomPipelineOperation)
  private
    FPrevGray: TCVMat;
    FPrevReady: Boolean;
    FOutput: TcvOpticalFlowOutput;
    FPyrScale: Double;
    FLevels: Integer;
    FWinSize: Integer;
    FIterations: Integer;
    FPolyN: Integer;
    FPolySigma: Double;
    FMagScale: Double;
    FDrawOverlay: Boolean;
    FOnOpticalFlowResult: TcvPipelineOpticalFlowEvent;
    procedure SetOutput(const Value: TcvOpticalFlowOutput);
    procedure SetPyrScale(const Value: Double);
    procedure SetLevels(const Value: Integer);
    procedure SetWinSize(const Value: Integer);
    procedure SetIterations(const Value: Integer);
    procedure SetPolyN(const Value: Integer);
    procedure SetPolySigma(const Value: Double);
    procedure SetMagScale(const Value: Double);
    procedure SetDrawOverlay(const Value: Boolean);
    procedure SetOnOpticalFlowResult(const Value: TcvPipelineOpticalFlowEvent);
    procedure ResetPrev;
    function FlowToVisualization(const Flow, Src: TCVMat): TCVMat;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    destructor Destroy; override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Output: TcvOpticalFlowOutput read FOutput write SetOutput default ofoHSV;
    property PyrScale: Double read FPyrScale write SetPyrScale;
    property Levels: Integer read FLevels write SetLevels default 3;
    property WinSize: Integer read FWinSize write SetWinSize default 15;
    property Iterations: Integer read FIterations write SetIterations default 3;
    property PolyN: Integer read FPolyN write SetPolyN default 5;
    property PolySigma: Double read FPolySigma write SetPolySigma;
    property MagScale: Double read FMagScale write SetMagScale;
    property DrawOverlay: Boolean read FDrawOverlay write SetDrawOverlay default True;
    property OnOpticalFlowResult: TcvPipelineOpticalFlowEvent read FOnOpticalFlowResult
      write SetOnOpticalFlowResult;
  end;

  TcvRunningAvgOperation = class(TcvCustomPipelineOperation)
  private
    FAccum: TCVMat;
    FAccumReady: Boolean;
    FFrameCount: Integer;
    procedure ResetAccum;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    destructor Destroy; override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  end;

  TcvGrabCutOperation = class(TcvCustomPipelineOperation)
  private
    FRectX: Integer;
    FRectY: Integer;
    FRectWidth: Integer;
    FRectHeight: Integer;
    FIterCount: Integer;
    FOutput: TcvGrabCutOutput;
    FDrawOverlay: Boolean;
    procedure SetRectX(const Value: Integer);
    procedure SetRectY(const Value: Integer);
    procedure SetRectWidth(const Value: Integer);
    procedure SetRectHeight(const Value: Integer);
    procedure SetIterCount(const Value: Integer);
    procedure SetOutput(const Value: TcvGrabCutOutput);
    procedure SetDrawOverlay(const Value: Boolean);
    function EffectiveRect(const Src: TCVMat): TCVRect;
    function EnsureColorImage(const Src: TCVMat): TCVMat;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property RectX: Integer read FRectX write SetRectX;
    property RectY: Integer read FRectY write SetRectY;
    property RectWidth: Integer read FRectWidth write SetRectWidth;
    property RectHeight: Integer read FRectHeight write SetRectHeight;
    property IterCount: Integer read FIterCount write SetIterCount default 3;
    property Output: TcvGrabCutOutput read FOutput write SetOutput default gcoOverlay;
    property DrawOverlay: Boolean read FDrawOverlay write SetDrawOverlay default True;
  end;

  TcvWatershedOperation = class(TcvCustomPipelineOperation)
  private
    FFgRectX: Integer;
    FFgRectY: Integer;
    FFgRectWidth: Integer;
    FFgRectHeight: Integer;
    FOutput: TcvWatershedOutput;
    FDrawOverlay: Boolean;
    procedure SetFgRectX(const Value: Integer);
    procedure SetFgRectY(const Value: Integer);
    procedure SetFgRectWidth(const Value: Integer);
    procedure SetFgRectHeight(const Value: Integer);
    procedure SetOutput(const Value: TcvWatershedOutput);
    procedure SetDrawOverlay(const Value: Boolean);
    function EffectiveFgRect(const Src: TCVMat): TCVRect;
    function EnsureColorImage(const Src: TCVMat): TCVMat;
  public
    constructor Create(AOwner: TcvPipelineStage); override;
    procedure Process(const Src: TCVMat; var Dst: TCVMat); override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
  published
    property FgRectX: Integer read FFgRectX write SetFgRectX;
    property FgRectY: Integer read FFgRectY write SetFgRectY;
    property FgRectWidth: Integer read FFgRectWidth write SetFgRectWidth;
    property FgRectHeight: Integer read FFgRectHeight write SetFgRectHeight;
    property Output: TcvWatershedOutput read FOutput write SetOutput default wsoBoundaries;
    property DrawOverlay: Boolean read FDrawOverlay write SetDrawOverlay default True;
  end;

implementation

const
  BitwiseOpNames: array[TcvBitwiseOp] of string = ('AND', 'OR', 'XOR', 'NOT');
  FlipModeNames: array[TcvFlipMode] of string = ('Vertical', 'Horizontal', 'Both');
  OrthoRotateModeNames: array[TcvOrthoRotateMode] of string = ('90 CW', '180', '90 CCW');

  SpatialGradientOutputNames: array[TcvSpatialGradientOutput] of string = ('Dx', 'Dy', 'AbsSum');
  InpaintMethodNames: array[TcvInpaintMethod] of string = ('NS', 'Telea');

function IsExtendedPipelineStage(const StageType: TcvStageType): Boolean;
begin
  Result := StageType in [stPyrUp, stLaplacian, stScharr, stDenoise, stDistanceTransform,
    stCrop, stNormalize, stSharpen, stBitwise, stRotate, stWarpPolar, stFilter2D,
    stCornerHarris, stTemporalBlend, stMatchTemplate, stContours, stChannelExtract,
    stFlip, stOrthoRotate, stGamma, stAddWeighted,
    stPyrMeanShift, stSepFilter2D, stSqrBoxFilter, stSpatialGradient, stCornerMinEigenVal,
    stIntegral, stAbsDiff, stAutoContrast, stMergeChannels, stInpaint, stUndistort, stRemap,
    stCustomLUT,
    stHoughLinesP, stHoughCircles, stConnectedComponents, stBackgroundSubtract,
    stDebugText, stPhaseCorrelate,
    stBlendLinear, stReferenceDiff, stOpticalFlow, stRunningAvg, stGrabCut, stWatershed];
end;

function CreateExtendedPipelineOperation(const StageType: TcvStageType;
  AOwner: TcvPipelineStage): TcvCustomPipelineOperation;
begin
  case StageType of
    stPyrUp: Result := TcvPyrUpOperation.Create(AOwner);
    stLaplacian: Result := TcvLaplacianOperation.Create(AOwner);
    stScharr: Result := TcvScharrOperation.Create(AOwner);
    stDenoise: Result := TcvDenoiseOperation.Create(AOwner);
    stDistanceTransform: Result := TcvDistanceTransformOperation.Create(AOwner);
    stCrop: Result := TcvCropOperation.Create(AOwner);
    stNormalize: Result := TcvNormalizeOperation.Create(AOwner);
    stSharpen: Result := TcvSharpenOperation.Create(AOwner);
    stBitwise: Result := TcvBitwiseOperation.Create(AOwner);
    stRotate: Result := TcvRotateOperation.Create(AOwner);
    stWarpPolar: Result := TcvWarpPolarOperation.Create(AOwner);
    stFilter2D: Result := TcvFilter2DOperation.Create(AOwner);
    stCornerHarris: Result := TcvCornerHarrisOperation.Create(AOwner);
    stTemporalBlend: Result := TcvTemporalBlendOperation.Create(AOwner);
    stMatchTemplate: Result := TcvMatchTemplateOperation.Create(AOwner);
    stContours: Result := TcvContoursOperation.Create(AOwner);
    stChannelExtract: Result := TcvChannelExtractOperation.Create(AOwner);
    stFlip: Result := TcvFlipOperation.Create(AOwner);
    stOrthoRotate: Result := TcvOrthoRotateOperation.Create(AOwner);
    stGamma: Result := TcvGammaOperation.Create(AOwner);
    stAddWeighted: Result := TcvAddWeightedOperation.Create(AOwner);
    stPyrMeanShift: Result := TcvPyrMeanShiftOperation.Create(AOwner);
    stSepFilter2D: Result := TcvSepFilter2DOperation.Create(AOwner);
    stSqrBoxFilter: Result := TcvSqrBoxFilterOperation.Create(AOwner);
    stSpatialGradient: Result := TcvSpatialGradientOperation.Create(AOwner);
    stCornerMinEigenVal: Result := TcvCornerMinEigenValOperation.Create(AOwner);
    stIntegral: Result := TcvIntegralOperation.Create(AOwner);
    stAbsDiff: Result := TcvAbsDiffOperation.Create(AOwner);
    stAutoContrast: Result := TcvAutoContrastOperation.Create(AOwner);
    stMergeChannels: Result := TcvMergeChannelsOperation.Create(AOwner);
    stInpaint: Result := TcvInpaintOperation.Create(AOwner);
    stUndistort: Result := TcvUndistortOperation.Create(AOwner);
    stRemap: Result := TcvRemapOperation.Create(AOwner);
    stCustomLUT: Result := TcvCustomLUTOperation.Create(AOwner);
    stHoughLinesP: Result := TcvHoughLinesPOperation.Create(AOwner);
    stHoughCircles: Result := TcvHoughCirclesOperation.Create(AOwner);
    stConnectedComponents: Result := TcvConnectedComponentsOperation.Create(AOwner);
    stBackgroundSubtract: Result := TcvBackgroundSubtractOperation.Create(AOwner);
    stDebugText: Result := TcvDebugTextOperation.Create(AOwner);
    stPhaseCorrelate: Result := TcvPhaseCorrelateOperation.Create(AOwner);
    stBlendLinear: Result := TcvBlendLinearOperation.Create(AOwner);
    stReferenceDiff: Result := TcvReferenceDiffOperation.Create(AOwner);
    stOpticalFlow: Result := TcvOpticalFlowOperation.Create(AOwner);
    stRunningAvg: Result := TcvRunningAvgOperation.Create(AOwner);
    stGrabCut: Result := TcvGrabCutOperation.Create(AOwner);
    stWatershed: Result := TcvWatershedOperation.Create(AOwner);
  else
    Result := nil;
  end;
end;

function StageTypeToStr(const StageType: TcvStageType): string;
const
  Names: array[TcvStageType] of string = (
    'Color', 'Blur', 'Threshold', 'Canny', 'Morphology', 'Resize', 'Custom',
    'AdaptiveThreshold', 'BilateralFilter', 'EqualizeHist', 'Sobel', 'Invert',
    'Clahe', 'InRange', 'MorphologyEx', 'ColorMap', 'BrightnessContrast', 'PyrDown',
    'PyrUp', 'Laplacian', 'Scharr', 'Denoise', 'DistanceTransform', 'Crop',
    'Normalize', 'Sharpen', 'Bitwise', 'Rotate', 'WarpPolar', 'Filter2D',
    'CornerHarris', 'TemporalBlend', 'MatchTemplate', 'Contours', 'ChannelExtract',
    'Flip', 'OrthoRotate', 'Gamma', 'AddWeighted',
    'PyrMeanShift', 'SepFilter2D', 'SqrBoxFilter', 'SpatialGradient', 'CornerMinEigenVal',
    'Integral', 'AbsDiff', 'AutoContrast', 'MergeChannels', 'Inpaint', 'Undistort', 'Remap',
    'CustomLUT',
    'HoughLinesP', 'HoughCircles', 'ConnectedComponents', 'BackgroundSubtract',
    'DebugText', 'PhaseCorrelate',
    'BlendLinear', 'ReferenceDiff', 'OpticalFlow', 'RunningAvg', 'GrabCut', 'Watershed');
begin
  Result := Names[StageType];
end;

function StrToStageType(const S: string; out StageType: TcvStageType): Boolean;
var
  T: TcvStageType;
begin
  for T := Low(TcvStageType) to High(TcvStageType) do
    if SameText(StageTypeToStr(T), S) then
    begin
      StageType := T;
      Exit(True);
    end;
  Result := False;
end;

procedure SetKernelValue(const K: TCVMat; Row, Col: Integer; Value: Single);
var
  P: PSingle;
begin
  P := K.ptr(Row, Col);
  P^ := Value;
end;

{ TcvPyrUpOperation }

function TcvPyrUpOperation.GetDisplayName: string;
begin
  Result := 'PyrUp (x2)';
end;

procedure TcvPyrUpOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  pyrUp(Src.Handle, Temp.Handle, TCVSize.Create(0, 0), 4);
  Dst := Temp;
end;

{ TcvLaplacianOperation }

constructor TcvLaplacianOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  Fksize := 1;
end;

procedure TcvLaplacianOperation.Assign(Source: TPersistent);
begin
  if Source is TcvLaplacianOperation then
  begin
    Fksize := TcvLaplacianOperation(Source).ksize;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvLaplacianOperation.GetDisplayName: string;
begin
  Result := Format('Laplacian (k=%d)', [Fksize]);
end;

procedure TcvLaplacianOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, CV_16S);
  Laplacian(Src.Handle, Temp.Handle, CV_16S, Fksize, 1.0, 0.0, 4);
  Temp.convertTo(Temp.Handle, CV_8U, 1.0, 128.0);
  Dst := Temp;
end;

procedure TcvLaplacianOperation.Setksize(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if (V mod 2 = 0) and (V > 0) then Inc(V);
  if Fksize <> V then
  begin
    Fksize := V;
    Changed;
  end;
end;

{ TcvScharrOperation }

constructor TcvScharrOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  Fdx := 1;
  Fdy := 0;
end;

procedure TcvScharrOperation.Assign(Source: TPersistent);
begin
  if Source is TcvScharrOperation then
  begin
    Fdx := TcvScharrOperation(Source).dx;
    Fdy := TcvScharrOperation(Source).dy;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvScharrOperation.GetDisplayName: string;
begin
  Result := Format('Scharr (dx=%d, dy=%d)', [Fdx, Fdy]);
end;

procedure TcvScharrOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, CV_16S);
  Scharr(Src.Handle, Temp.Handle, CV_16S, Fdx, Fdy, 1.0, 0.0, 4);
  Temp.convertTo(Temp.Handle, CV_8U, 1.0, 128.0);
  Dst := Temp;
end;

procedure TcvScharrOperation.Setdx(const Value: Integer);
begin
  if Fdx <> Value then begin Fdx := Value; Changed; end;
end;

procedure TcvScharrOperation.Setdy(const Value: Integer);
begin
  if Fdy <> Value then begin Fdy := Value; Changed; end;
end;

{ TcvDenoiseOperation }

constructor TcvDenoiseOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FH := 3.0;
  FTemplateWindow := 7;
  FSearchWindow := 21;
end;

procedure TcvDenoiseOperation.Assign(Source: TPersistent);
begin
  if Source is TcvDenoiseOperation then
  begin
    FH := TcvDenoiseOperation(Source).H;
    FTemplateWindow := TcvDenoiseOperation(Source).TemplateWindow;
    FSearchWindow := TcvDenoiseOperation(Source).SearchWindow;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvDenoiseOperation.GetDisplayName: string;
begin
  Result := Format('Denoise (h=%.1f)', [FH]);
end;

procedure TcvDenoiseOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  if Src.channels > 1 then
    fastNlMeansDenoisingColored(Src.Handle, Temp.Handle, FH, FH,
      FTemplateWindow, FSearchWindow)
  else
    fastNlMeansDenoising(Src.Handle, Temp.Handle, FH, FTemplateWindow, FSearchWindow);
  Dst := Temp;
end;

procedure TcvDenoiseOperation.SetH(const Value: Single);
begin
  if FH <> Value then begin FH := Value; Changed; end;
end;

{ TcvDistanceTransformOperation }

constructor TcvDistanceTransformOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FMaskSize := 5;
end;

procedure TcvDistanceTransformOperation.Assign(Source: TPersistent);
begin
  if Source is TcvDistanceTransformOperation then
  begin
    FMaskSize := TcvDistanceTransformOperation(Source).MaskSize;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvDistanceTransformOperation.GetDisplayName: string;
begin
  Result := Format('DistanceTransform (mask=%d)', [FMaskSize]);
end;

procedure TcvDistanceTransformOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp, Gray: TCVMat;
  MaskSize: Integer;
begin
  Gray := TCVMat.Create_0(0, 0, CV_8U);
  if Src.channels > 1 then
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0)
  else
    Src.copyTo(Gray.Handle);
  Temp := TCVMat.Create_0(0, 0, CV_32F);
  if FMaskSize = 3 then
    MaskSize := DIST_MASK_3
  else
    MaskSize := DIST_MASK_5;
  distanceTransform(Gray.Handle, Temp.Handle, 2, MaskSize, CV_32F);
  Temp.convertTo(Temp.Handle, CV_8U, 255.0, 0.0);
  Dst := Temp;
end;

procedure TcvDistanceTransformOperation.SetMaskSize(const Value: Integer);
begin
  if FMaskSize <> Value then begin FMaskSize := Value; Changed; end;
end;

{ TcvCropOperation }

constructor TcvCropOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FWidth := 320;
  FHeight := 240;
end;

procedure TcvCropOperation.Assign(Source: TPersistent);
begin
  if Source is TcvCropOperation then
  begin
    FX := TcvCropOperation(Source).X;
    FY := TcvCropOperation(Source).Y;
    FWidth := TcvCropOperation(Source).Width;
    FHeight := TcvCropOperation(Source).Height;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvCropOperation.GetDisplayName: string;
begin
  Result := Format('Crop (%d,%d %dx%d)', [FX, FY, FWidth, FHeight]);
end;

procedure TcvCropOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  X1, Y1, W, H: Integer;
begin
  X1 := FX;
  Y1 := FY;
  W := FWidth;
  H := FHeight;
  if X1 < 0 then X1 := 0;
  if Y1 < 0 then Y1 := 0;
  if X1 + W > Src.cols then W := Src.cols - X1;
  if Y1 + H > Src.rows then H := Src.rows - Y1;
  if (W <= 0) or (H <= 0) then
  begin
    Dst := Src.clone;
    Exit;
  end;
  Dst := Src.rowRange(Y1, Y1 + H).colRange(X1, X1 + W).clone;
end;

procedure TcvCropOperation.SetHeight(const Value: Integer);
begin
  if FHeight <> Value then begin FHeight := Value; Changed; end;
end;

procedure TcvCropOperation.SetWidth(const Value: Integer);
begin
  if FWidth <> Value then begin FWidth := Value; Changed; end;
end;

procedure TcvCropOperation.SetX(const Value: Integer);
begin
  if FX <> Value then begin FX := Value; Changed; end;
end;

procedure TcvCropOperation.SetY(const Value: Integer);
begin
  if FY <> Value then begin FY := Value; Changed; end;
end;

{ TcvNormalizeOperation }

function TcvNormalizeOperation.GetDisplayName: string;
begin
  Result := 'Normalize (0..255)';
end;

procedure TcvNormalizeOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
  MinVal, MaxVal: Double;
  MinLoc, MaxLoc: TCVPoint;
  Scale, Delta: Double;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  minMaxLoc(Src.Handle, MinVal, MaxVal, MinLoc, MaxLoc, nil);
  if MaxVal <= MinVal then
    Src.copyTo(Temp.Handle)
  else
  begin
    Scale := 255.0 / (MaxVal - MinVal);
    Delta := -MinVal * Scale;
    Src.convertTo(Temp.Handle, CV_8U, Scale, Delta);
  end;
  Dst := Temp;
end;

{ TcvSharpenOperation }

constructor TcvSharpenOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FAmount := 1.0;
end;

procedure TcvSharpenOperation.Assign(Source: TPersistent);
begin
  if Source is TcvSharpenOperation then
  begin
    FAmount := TcvSharpenOperation(Source).Amount;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvSharpenOperation.GetDisplayName: string;
begin
  Result := Format('Sharpen (%.1f)', [FAmount]);
end;

procedure TcvSharpenOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  BlurMat, Diff, Temp: TCVMat;
begin
  BlurMat := TCVMat.Create_0(0, 0, Src.dataType);
  Diff := TCVMat.Create_0(0, 0, Src.dataType);
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  GaussianBlur(Src.Handle, BlurMat.Handle, TCVSize.Create(0, 0), 3.0, 3.0, 4, 0);
  subtractMat(Src.Handle, BlurMat.Handle, Diff.Handle);
  Diff.convertTo(Diff.Handle, Src.dataType, FAmount, 0.0);
  addMat(Src.Handle, Diff.Handle, Temp.Handle);
  Dst := Temp;
end;

procedure TcvSharpenOperation.SetAmount(const Value: Double);
begin
  if FAmount <> Value then begin FAmount := Value; Changed; end;
end;

{ TcvBitwiseOperation }

constructor TcvBitwiseOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FBitwiseOp := boNot;
  FOperandLoaded := False;
end;

procedure TcvBitwiseOperation.Assign(Source: TPersistent);
begin
  if Source is TcvBitwiseOperation then
  begin
    FBitwiseOp := TcvBitwiseOperation(Source).BitwiseOp;
    FOperandPath := TcvBitwiseOperation(Source).OperandPath;
    FOperandPathLoaded := '';
    FOperandLoaded := False;
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TcvBitwiseOperation.EnsureOperand;
begin
  if (FBitwiseOp = boNot) or (FOperandPath = '') then
    Exit;
  if SameText(FOperandPath, FOperandPathLoaded) then
    Exit;
  if FOperandPathLoaded <> '' then
    FOperand.Release;
  FOperand := imread(PAnsiChar(AnsiString(FOperandPath)), 0);
  FOperandPathLoaded := FOperandPath;
  FOperandLoaded := not FOperand.empty;
end;

function TcvBitwiseOperation.GetDisplayName: string;
begin
  Result := Format('Bitwise (%s)', [BitwiseOpNames[FBitwiseOp]]);
end;

procedure TcvBitwiseOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  case FBitwiseOp of
    boNot:
      bitwise_not(Src.Handle, Temp.Handle);
    boAnd, boOr, boXor:
      begin
        EnsureOperand;
        if FOperandLoaded then
        begin
          case FBitwiseOp of
            boAnd: bitwise_and(Src.Handle, FOperand.Handle, Temp.Handle);
            boOr: bitwise_or(Src.Handle, FOperand.Handle, Temp.Handle);
            boXor: bitwise_xor(Src.Handle, FOperand.Handle, Temp.Handle);
          end;
        end
        else
          Src.copyTo(Temp.Handle);
      end;
  end;
  Dst := Temp;
end;

procedure TcvBitwiseOperation.SetBitwiseOp(const Value: TcvBitwiseOp);
begin
  if FBitwiseOp <> Value then begin FBitwiseOp := Value; Changed; end;
end;

procedure TcvBitwiseOperation.SetOperandPath(const Value: string);
begin
  if FOperandPath <> Value then
  begin
    FOperandPath := Value;
    FOperandPathLoaded := '';
    FOperandLoaded := False;
    Changed;
  end;
end;

{ TcvRotateOperation }

constructor TcvRotateOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FScale := 1.0;
end;

procedure TcvRotateOperation.Assign(Source: TPersistent);
begin
  if Source is TcvRotateOperation then
  begin
    FAngle := TcvRotateOperation(Source).Angle;
    FScale := TcvRotateOperation(Source).Scale;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvRotateOperation.GetDisplayName: string;
begin
  Result := Format('Rotate warp (%.0f deg)', [FAngle]);
end;

procedure TcvRotateOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp, M: TCVMat;
  Center: TCVPoint2f;
begin
  Center := TCVPoint2f.Create(Src.cols * 0.5, Src.rows * 0.5);
  M := getRotationMatrix2D(Center, FAngle, FScale);
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  warpAffine(Src.Handle, Temp.Handle, M.Handle, TCVSize.Create(Src.cols, Src.rows),
    INTER_LINEAR, 4, TCVScalar.Create(0), 0);
  Dst := Temp;
end;

procedure TcvRotateOperation.SetAngle(const Value: Double);
begin
  if FAngle <> Value then begin FAngle := Value; Changed; end;
end;

procedure TcvRotateOperation.SetScale(const Value: Double);
begin
  if FScale <> Value then begin FScale := Value; Changed; end;
end;

{ TcvWarpPolarOperation }

constructor TcvWarpPolarOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FMaxRadius := 0;
end;

procedure TcvWarpPolarOperation.Assign(Source: TPersistent);
begin
  if Source is TcvWarpPolarOperation then
  begin
    FMaxRadius := TcvWarpPolarOperation(Source).MaxRadius;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvWarpPolarOperation.GetDisplayName: string;
begin
  Result := 'WarpPolar';
end;

procedure TcvWarpPolarOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
  Center: TCVPoint2f;
  MaxR: Double;
begin
  Center := TCVPoint2f.Create(Src.cols * 0.5, Src.rows * 0.5);
  MaxR := FMaxRadius;
  if MaxR <= 0 then
    MaxR := Min(Src.cols, Src.rows) * 0.5;
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  warpPolar(Src.Handle, Temp.Handle, TCVSize.Create(Src.cols, Src.rows), Center, MaxR,
    WARP_POLAR_LINEAR);
  Dst := Temp;
end;

procedure TcvWarpPolarOperation.SetMaxRadius(const Value: Double);
begin
  if FMaxRadius <> Value then begin FMaxRadius := Value; Changed; end;
end;

{ TcvFilter2DOperation }

constructor TcvFilter2DOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FKernelSize := 3;
  FSharpen := True;
end;

procedure TcvFilter2DOperation.Assign(Source: TPersistent);
begin
  if Source is TcvFilter2DOperation then
  begin
    FKernelSize := TcvFilter2DOperation(Source).KernelSize;
    FSharpen := TcvFilter2DOperation(Source).SharpenKernel;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvFilter2DOperation.BuildKernel: TCVMat;
var
  C, R: Integer;
  Center: Double;
begin
  Result := TCVMat.Create_0(FKernelSize, FKernelSize, CV_32F);
  if FSharpen and (FKernelSize = 3) then
  begin
    SetKernelValue(Result, 0, 1, -1);
    SetKernelValue(Result, 1, 0, -1);
    SetKernelValue(Result, 1, 1, 5);
    SetKernelValue(Result, 1, 2, -1);
    SetKernelValue(Result, 2, 1, -1);
  end
  else
  begin
    Center := 1.0 / (FKernelSize * FKernelSize);
    for R := 0 to FKernelSize - 1 do
      for C := 0 to FKernelSize - 1 do
        SetKernelValue(Result, R, C, Center);
  end;
end;

function TcvFilter2DOperation.GetDisplayName: string;
begin
  if FSharpen then
    Result := 'Filter2D (Sharpen)'
  else
    Result := Format('Filter2D (%dx%d)', [FKernelSize, FKernelSize]);
end;

procedure TcvFilter2DOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp, K: TCVMat;
begin
  K := BuildKernel;
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  filter2D(Src.Handle, Temp.Handle, -1, K.Handle, TCVPoint.Create(-1, -1), 0.0, 4);
  Dst := Temp;
end;

procedure TcvFilter2DOperation.SetKernelSize(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if V < 1 then V := 1;
  if V mod 2 = 0 then Inc(V);
  if FKernelSize <> V then begin FKernelSize := V; Changed; end;
end;

procedure TcvFilter2DOperation.SetSharpen(const Value: Boolean);
begin
  if FSharpen <> Value then begin FSharpen := Value; Changed; end;
end;

{ TcvCornerHarrisOperation }

constructor TcvCornerHarrisOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FBlockSize := 2;
  Fksize := 3;
  FK := 0.04;
end;

procedure TcvCornerHarrisOperation.Assign(Source: TPersistent);
begin
  if Source is TcvCornerHarrisOperation then
  begin
    FBlockSize := TcvCornerHarrisOperation(Source).BlockSize;
    Fksize := TcvCornerHarrisOperation(Source).ksize;
    FK := TcvCornerHarrisOperation(Source).K;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvCornerHarrisOperation.GetDisplayName: string;
begin
  Result := 'CornerHarris';
end;

procedure TcvCornerHarrisOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Gray, Temp: TCVMat;
  MinVal, MaxVal: Double;
  MinLoc, MaxLoc: TCVPoint;
begin
  Gray := TCVMat.Create_0(0, 0, CV_8U);
  if Src.channels > 1 then
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0)
  else
    Src.copyTo(Gray.Handle);
  Temp := TCVMat.Create_0(0, 0, CV_32F);
  cornerHarris(Gray.Handle, Temp.Handle, FBlockSize, Fksize, FK, 4);
  minMaxLoc(Temp.Handle, MinVal, MaxVal, MinLoc, MaxLoc, nil);
  if MaxVal > MinVal then
    Temp.convertTo(Temp.Handle, CV_8U, 255.0 / (MaxVal - MinVal), -MinVal * 255.0 / (MaxVal - MinVal))
  else
    Temp.convertTo(Temp.Handle, CV_8U, 1.0, 0.0);
  Dst := Temp;
end;

procedure TcvCornerHarrisOperation.SetBlockSize(const Value: Integer);
begin
  if FBlockSize <> Value then begin FBlockSize := Value; Changed; end;
end;

procedure TcvCornerHarrisOperation.SetK(const Value: Double);
begin
  if FK <> Value then begin FK := Value; Changed; end;
end;

procedure TcvCornerHarrisOperation.Setksize(const Value: Integer);
begin
  if Fksize <> Value then begin Fksize := Value; Changed; end;
end;

{ TcvTemporalBlendOperation }

constructor TcvTemporalBlendOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FAlpha := 0.2;
  FAccumReady := False;
end;

destructor TcvTemporalBlendOperation.Destroy;
begin
  if FAccumReady then
    FAccum.Release;
  inherited Destroy;
end;

procedure TcvTemporalBlendOperation.Assign(Source: TPersistent);
begin
  if Source is TcvTemporalBlendOperation then
  begin
    FAlpha := TcvTemporalBlendOperation(Source).Alpha;
    ResetAccum;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvTemporalBlendOperation.GetDisplayName: string;
begin
  Result := Format('TemporalBlend (a=%.2f)', [FAlpha]);
end;

procedure TcvTemporalBlendOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  if not FAccumReady or (FAccum.rows <> Src.rows) or (FAccum.cols <> Src.cols) or
     (FAccum.dataType <> Src.dataType) then
  begin
    if FAccumReady then
      FAccum.Release;
    FAccum := Src.clone;
    FAccumReady := True;
    Dst := FAccum.clone;
    Exit;
  end;
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  accumulateWeighted(Src.Handle, FAccum.Handle, FAlpha, nil);
  FAccum.copyTo(Temp.Handle);
  Dst := Temp;
end;

procedure TcvTemporalBlendOperation.ResetAccum;
begin
  if FAccumReady then
  begin
    FAccum.Release;
    FAccumReady := False;
  end;
end;

procedure TcvTemporalBlendOperation.SetAlpha(const Value: Double);
begin
  if FAlpha <> Value then begin FAlpha := Value; Changed; end;
end;

{ TcvMatchTemplateOperation }

constructor TcvMatchTemplateOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FMethod := 5;
  FDrawOverlay := True;
end;

procedure TcvMatchTemplateOperation.Assign(Source: TPersistent);
begin
  if Source is TcvMatchTemplateOperation then
  begin
    FTemplatePath := TcvMatchTemplateOperation(Source).TemplatePath;
    FMethod := TcvMatchTemplateOperation(Source).Method;
    FDrawOverlay := TcvMatchTemplateOperation(Source).DrawOverlay;
    FOnMatchResult := TcvMatchTemplateOperation(Source).OnMatchResult;
    FTemplatePathLoaded := '';
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TcvMatchTemplateOperation.EnsureTemplate;
begin
  if (FTemplatePath = '') or SameText(FTemplatePath, FTemplatePathLoaded) then
    Exit;
  if FTemplatePathLoaded <> '' then
    FTemplate.Release;
  FTemplate := imread(PAnsiChar(AnsiString(FTemplatePath)), 0);
  FTemplatePathLoaded := FTemplatePath;
end;

function TcvMatchTemplateOperation.GetDisplayName: string;
begin
  Result := 'MatchTemplate';
end;

procedure TcvMatchTemplateOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  ResultMat, Gray, TemplGray, OutImg: TCVMat;
  MinVal, MaxVal: Double;
  MinLoc, MaxLoc: TCVPoint;
  R: TCVRect;
  MatchResult: TcvPipelineMatchResult;
begin
  EnsureTemplate;
  if FTemplate.empty then
  begin
    Dst := Src.clone;
    Exit;
  end;
  Gray := TCVMat.Create_0(0, 0, CV_8U);
  TemplGray := TCVMat.Create_0(0, 0, CV_8U);
  if Src.channels > 1 then
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0)
  else
    Src.copyTo(Gray.Handle);
  if FTemplate.channels > 1 then
    cvtColor(FTemplate.Handle, TemplGray.Handle, COLOR_BGR2GRAY, 0, 0)
  else
    FTemplate.copyTo(TemplGray.Handle);
  ResultMat := TCVMat.Create_0(0, 0, CV_32F);
  matchTemplate(Gray.Handle, TemplGray.Handle, ResultMat.Handle, FMethod, nil);
  minMaxLoc(ResultMat.Handle, MinVal, MaxVal, MinLoc, MaxLoc, nil);
  R := TCVRect.Create(MaxLoc.X, MaxLoc.Y, TemplGray.cols, TemplGray.rows);
  MatchResult.Found := True;
  MatchResult.MatchRect := R;
  MatchResult.MaxLocation := MaxLoc;
  MatchResult.MinLocation := MinLoc;
  MatchResult.MaxValue := MaxVal;
  MatchResult.MinValue := MinVal;
  MatchResult.TemplateWidth := TemplGray.cols;
  MatchResult.TemplateHeight := TemplGray.rows;
  if Assigned(FOnMatchResult) then
    FOnMatchResult(Self, Src, MatchResult);
  if FDrawOverlay then
  begin
    OutImg := Src.clone;
    rectangle(OutImg.Handle, R, TCVScalar.Create(0, 255, 0), 2, 8, 0);
    Dst := OutImg;
  end
  else
  begin
    ResultMat.convertTo(ResultMat.Handle, CV_8U, 255.0, 0.0);
    Dst := ResultMat;
  end;
end;

procedure TcvMatchTemplateOperation.SetDrawOverlay(const Value: Boolean);
begin
  if FDrawOverlay <> Value then begin FDrawOverlay := Value; Changed; end;
end;

procedure TcvMatchTemplateOperation.SetOnMatchResult(const Value: TcvPipelineMatchTemplateEvent);
begin
  FOnMatchResult := Value;
end;

procedure TcvMatchTemplateOperation.SetMethod(const Value: Integer);
begin
  if FMethod <> Value then begin FMethod := Value; Changed; end;
end;

procedure TcvMatchTemplateOperation.SetTemplatePath(const Value: string);
begin
  if FTemplatePath <> Value then
  begin
    FTemplatePath := Value;
    FTemplatePathLoaded := '';
    Changed;
  end;
end;

{ TcvContoursOperation }

constructor TcvContoursOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FThickness := 2;
  FDrawOverlay := True;
end;

procedure TcvContoursOperation.Assign(Source: TPersistent);
begin
  if Source is TcvContoursOperation then
  begin
    FThickness := TcvContoursOperation(Source).Thickness;
    FDrawOverlay := TcvContoursOperation(Source).DrawOverlay;
    FOnContoursResult := TcvContoursOperation(Source).OnContoursResult;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvContoursOperation.BuildContoursResult(const Contours: TCVMatVector): TcvPipelineContoursResult;
var
  I: Integer;
  ContourMat: TCVMat;
begin
  Result.Count := Contours.Count;
  SetLength(Result.Items, Result.Count);
  for I := 0 to Result.Count - 1 do
  begin
    ContourMat := Contours.At(I);
    Result.Items[I].Index := I;
    Result.Items[I].Points := ContourToPoints(ContourMat);
    Result.Items[I].Area := contourArea(ContourMat.Handle, False);
    Result.Items[I].ArcLength := arcLength(ContourMat.Handle, True);
    Result.Items[I].BoundingRect := boundingRect(ContourMat.Handle);
  end;
end;

function TcvContoursOperation.GetDisplayName: string;
begin
  if FDrawOverlay then
    Result := 'Contours (overlay)'
  else
    Result := 'Contours';
end;

procedure TcvContoursOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Gray, Binary, OutImg: TCVMat;
  Contours: TCVMatVector;
  ContoursResult: TcvPipelineContoursResult;
  I: Integer;
begin
  Gray := TCVMat.Create_0(0, 0, CV_8U);
  if Src.channels > 1 then
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0)
  else
    Src.copyTo(Gray.Handle);
  Binary := TCVMat.Create_0(0, 0, CV_8U);
  threshold(Gray.Handle, Binary.Handle, 127, 255, THRESH_BINARY);
  Contours := TCVMatVector.Create;
  try
    findContoursEx(Binary.Handle, Contours, nil, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE,
      TCVPoint.Create(0, 0));
    ContoursResult := BuildContoursResult(Contours);
    if Assigned(FOnContoursResult) then
      FOnContoursResult(Self, Src, ContoursResult);
    if FDrawOverlay then
    begin
      if Src.channels > 1 then
        OutImg := Src.clone
      else
      begin
        OutImg := TCVMat.Create_0(0, 0, CV_8UC3);
        cvtColor(Src.Handle, OutImg.Handle, COLOR_GRAY2BGR, 0, 0);
      end;
      for I := 0 to Contours.Count - 1 do
        drawContoursEx(OutImg.Handle, Contours, I, TCVScalar.Create(0, 255, 0), FThickness);
      Dst := OutImg;
    end
    else
      Dst := Binary.clone;
  finally
    Contours.Release;
  end;
end;

procedure TcvContoursOperation.SetDrawOverlay(const Value: Boolean);
begin
  if FDrawOverlay <> Value then begin FDrawOverlay := Value; Changed; end;
end;

procedure TcvContoursOperation.SetOnContoursResult(const Value: TcvPipelineContoursEvent);
begin
  FOnContoursResult := Value;
end;

procedure TcvContoursOperation.SetThickness(const Value: Integer);
begin
  if FThickness <> Value then begin FThickness := Value; Changed; end;
end;

{ TcvHoughLinesPOperation }

constructor TcvHoughLinesPOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FRho := 1.0;
  FTheta := Pi / 180;
  FThreshold := 50;
  FMinLineLength := 50.0;
  FMaxLineGap := 10.0;
  FUseCanny := True;
  FCannyThresh1 := 50.0;
  FCannyThresh2 := 150.0;
  FCannyAperture := 3;
  FLineThickness := 2;
  FLineColor := TCVScalar.Create(0, 0, 255);
  FDrawOverlay := True;
end;

procedure TcvHoughLinesPOperation.Assign(Source: TPersistent);
begin
  if Source is TcvHoughLinesPOperation then
  begin
    FRho := TcvHoughLinesPOperation(Source).Rho;
    FTheta := TcvHoughLinesPOperation(Source).Theta;
    FThreshold := TcvHoughLinesPOperation(Source).Threshold;
    FMinLineLength := TcvHoughLinesPOperation(Source).MinLineLength;
    FMaxLineGap := TcvHoughLinesPOperation(Source).MaxLineGap;
    FUseCanny := TcvHoughLinesPOperation(Source).UseCanny;
    FCannyThresh1 := TcvHoughLinesPOperation(Source).CannyThresh1;
    FCannyThresh2 := TcvHoughLinesPOperation(Source).CannyThresh2;
    FCannyAperture := TcvHoughLinesPOperation(Source).CannyAperture;
    FLineThickness := TcvHoughLinesPOperation(Source).LineThickness;
    FLineColor := TcvHoughLinesPOperation(Source).LineColor;
    FDrawOverlay := TcvHoughLinesPOperation(Source).DrawOverlay;
    FOnHoughLinesResult := TcvHoughLinesPOperation(Source).OnHoughLinesResult;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvHoughLinesPOperation.GetDisplayName: string;
begin
  if FDrawOverlay then
    Result := 'HoughLinesP (overlay)'
  else
    Result := 'HoughLinesP';
end;

function TcvHoughLinesPOperation.ParseLines(const LinesMat: TCVMat): TcvPipelineHoughLinesResult;
var
  I: Integer;
  Row: array[0..3] of Single;
  P: PSingle;
begin
  Result.Count := LinesMat.rows;
  SetLength(Result.Lines, Result.Count);
  for I := 0 to Result.Count - 1 do
  begin
    P := LinesMat.ptr(I, 0);
    Move(P^, Row[0], SizeOf(Row));
    Result.Lines[I].X1 := Round(Row[0]);
    Result.Lines[I].Y1 := Round(Row[1]);
    Result.Lines[I].X2 := Round(Row[2]);
    Result.Lines[I].Y2 := Round(Row[3]);
  end;
end;

procedure TcvHoughLinesPOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Gray, Work, LinesMat, OutImg: TCVMat;
  LinesResult: TcvPipelineHoughLinesResult;
  I: Integer;
  Seg: TcvPipelineLineSegment;
begin
  Gray := TCVMat.Create_0(0, 0, CV_8UC1);
  if Src.channels > 1 then
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0)
  else
    Src.copyTo(Gray.Handle);
  if FUseCanny then
  begin
    Work := TCVMat.Create_0(0, 0, CV_8UC1);
    Canny(Gray.Handle, Work.Handle, FCannyThresh1, FCannyThresh2, FCannyAperture, False);
  end
  else
    Work := Gray.clone;
  LinesMat := TCVMat.Create_0(0, 0, CV_32F);
  HoughLinesP(Work.Handle, LinesMat.Handle, FRho, FTheta, FThreshold, FMinLineLength, FMaxLineGap);
  LinesResult := ParseLines(LinesMat);
  if Assigned(FOnHoughLinesResult) then
    FOnHoughLinesResult(Self, Src, LinesResult);
  if FDrawOverlay then
  begin
    if Src.channels > 1 then
      OutImg := Src.clone
    else
    begin
      OutImg := TCVMat.Create_0(0, 0, CV_8UC3);
      cvtColor(Src.Handle, OutImg.Handle, COLOR_GRAY2BGR, 0, 0);
    end;
    for I := 0 to LinesResult.Count - 1 do
    begin
      Seg := LinesResult.Lines[I];
      line(OutImg.Handle, TCVPoint.Create(Seg.X1, Seg.Y1), TCVPoint.Create(Seg.X2, Seg.Y2),
        FLineColor, FLineThickness, LINE_8, 0);
    end;
    Dst := OutImg;
  end
  else
    Dst := Work.clone;
  if FUseCanny and (Work.Handle <> Gray.Handle) then
    Work.Release;
  if Gray.Handle <> Src.Handle then
    Gray.Release;
end;

procedure TcvHoughLinesPOperation.SetCannyAperture(const Value: Integer);
begin
  if FCannyAperture <> Value then begin FCannyAperture := Value; Changed; end;
end;

procedure TcvHoughLinesPOperation.SetCannyThresh1(const Value: Double);
begin
  if FCannyThresh1 <> Value then begin FCannyThresh1 := Value; Changed; end;
end;

procedure TcvHoughLinesPOperation.SetCannyThresh2(const Value: Double);
begin
  if FCannyThresh2 <> Value then begin FCannyThresh2 := Value; Changed; end;
end;

procedure TcvHoughLinesPOperation.SetDrawOverlay(const Value: Boolean);
begin
  if FDrawOverlay <> Value then begin FDrawOverlay := Value; Changed; end;
end;

procedure TcvHoughLinesPOperation.SetLineColor(const Value: TCVScalar);
begin
  FLineColor := Value;
  Changed;
end;

procedure TcvHoughLinesPOperation.SetLineThickness(const Value: Integer);
begin
  if FLineThickness <> Value then begin FLineThickness := Value; Changed; end;
end;

procedure TcvHoughLinesPOperation.SetMaxLineGap(const Value: Double);
begin
  if FMaxLineGap <> Value then begin FMaxLineGap := Value; Changed; end;
end;

procedure TcvHoughLinesPOperation.SetMinLineLength(const Value: Double);
begin
  if FMinLineLength <> Value then begin FMinLineLength := Value; Changed; end;
end;

procedure TcvHoughLinesPOperation.SetOnHoughLinesResult(const Value: TcvPipelineHoughLinesEvent);
begin
  FOnHoughLinesResult := Value;
end;

procedure TcvHoughLinesPOperation.SetRho(const Value: Double);
begin
  if FRho <> Value then begin FRho := Value; Changed; end;
end;

procedure TcvHoughLinesPOperation.SetTheta(const Value: Double);
begin
  if FTheta <> Value then begin FTheta := Value; Changed; end;
end;

procedure TcvHoughLinesPOperation.SetThreshold(const Value: Integer);
begin
  if FThreshold <> Value then begin FThreshold := Value; Changed; end;
end;

procedure TcvHoughLinesPOperation.SetUseCanny(const Value: Boolean);
begin
  if FUseCanny <> Value then begin FUseCanny := Value; Changed; end;
end;

{ TcvHoughCirclesOperation }

constructor TcvHoughCirclesOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FMethod := HOUGH_GRADIENT;
  FDp := 1.0;
  FMinDist := 20.0;
  FParam1 := 100.0;
  FParam2 := 30.0;
  FMinRadius := 0;
  FMaxRadius := 0;
  FCircleThickness := 2;
  FCircleColor := TCVScalar.Create(0, 255, 0);
  FDrawOverlay := True;
end;

procedure TcvHoughCirclesOperation.Assign(Source: TPersistent);
begin
  if Source is TcvHoughCirclesOperation then
  begin
    FMethod := TcvHoughCirclesOperation(Source).Method;
    FDp := TcvHoughCirclesOperation(Source).Dp;
    FMinDist := TcvHoughCirclesOperation(Source).MinDist;
    FParam1 := TcvHoughCirclesOperation(Source).Param1;
    FParam2 := TcvHoughCirclesOperation(Source).Param2;
    FMinRadius := TcvHoughCirclesOperation(Source).MinRadius;
    FMaxRadius := TcvHoughCirclesOperation(Source).MaxRadius;
    FCircleThickness := TcvHoughCirclesOperation(Source).CircleThickness;
    FCircleColor := TcvHoughCirclesOperation(Source).CircleColor;
    FDrawOverlay := TcvHoughCirclesOperation(Source).DrawOverlay;
    FOnHoughCirclesResult := TcvHoughCirclesOperation(Source).OnHoughCirclesResult;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvHoughCirclesOperation.GetDisplayName: string;
begin
  if FDrawOverlay then
    Result := 'HoughCircles (overlay)'
  else
    Result := 'HoughCircles';
end;

function TcvHoughCirclesOperation.ParseCircles(const CirclesMat: TCVMat): TcvPipelineHoughCirclesResult;
var
  I, N: Integer;
  P: PSingle;
  Row: array[0..2] of Single;
begin
  if CirclesMat.empty then
  begin
    Result.Count := 0;
    SetLength(Result.Circles, 0);
    Exit;
  end;
  if CirclesMat.channels >= 3 then
    N := CirclesMat.rows
  else if CirclesMat.rows = 1 then
    N := CirclesMat.cols
  else
    N := CirclesMat.rows;
  Result.Count := N;
  SetLength(Result.Circles, N);
  for I := 0 to N - 1 do
  begin
    if CirclesMat.rows = 1 then
      P := CirclesMat.ptr(0, I)
    else
      P := CirclesMat.ptr(I, 0);
    Move(P^, Row[0], SizeOf(Row));
    Result.Circles[I].Center := TCVPoint.Create(Round(Row[0]), Round(Row[1]));
    Result.Circles[I].Radius := Round(Row[2]);
  end;
end;

procedure TcvHoughCirclesOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Gray, CirclesMat, OutImg: TCVMat;
  CirclesResult: TcvPipelineHoughCirclesResult;
  I: Integer;
  C: TcvPipelineCircle;
begin
  Gray := TCVMat.Create_0(0, 0, CV_8UC1);
  if Src.channels > 1 then
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0)
  else
    Src.copyTo(Gray.Handle);
  CirclesMat := TCVMat.Create_0(0, 0, CV_32F);
  HoughCircles(Gray.Handle, CirclesMat.Handle, FMethod, FDp, FMinDist, FParam1, FParam2,
    FMinRadius, FMaxRadius);
  CirclesResult := ParseCircles(CirclesMat);
  if Assigned(FOnHoughCirclesResult) then
    FOnHoughCirclesResult(Self, Src, CirclesResult);
  if FDrawOverlay then
  begin
    if Src.channels > 1 then
      OutImg := Src.clone
    else
    begin
      OutImg := TCVMat.Create_0(0, 0, CV_8UC3);
      cvtColor(Src.Handle, OutImg.Handle, COLOR_GRAY2BGR, 0, 0);
    end;
    for I := 0 to CirclesResult.Count - 1 do
    begin
      C := CirclesResult.Circles[I];
      circle(OutImg.Handle, C.Center, C.Radius, FCircleColor, FCircleThickness, LINE_8, 0);
    end;
    Dst := OutImg;
  end
  else
    Dst := Gray.clone;
  if Gray.Handle <> Src.Handle then
    Gray.Release;
end;

procedure TcvHoughCirclesOperation.SetCircleColor(const Value: TCVScalar);
begin
  FCircleColor := Value;
  Changed;
end;

procedure TcvHoughCirclesOperation.SetCircleThickness(const Value: Integer);
begin
  if FCircleThickness <> Value then begin FCircleThickness := Value; Changed; end;
end;

procedure TcvHoughCirclesOperation.SetDp(const Value: Double);
begin
  if FDp <> Value then begin FDp := Value; Changed; end;
end;

procedure TcvHoughCirclesOperation.SetDrawOverlay(const Value: Boolean);
begin
  if FDrawOverlay <> Value then begin FDrawOverlay := Value; Changed; end;
end;

procedure TcvHoughCirclesOperation.SetMaxRadius(const Value: Integer);
begin
  if FMaxRadius <> Value then begin FMaxRadius := Value; Changed; end;
end;

procedure TcvHoughCirclesOperation.SetMethod(const Value: Integer);
begin
  if FMethod <> Value then begin FMethod := Value; Changed; end;
end;

procedure TcvHoughCirclesOperation.SetMinDist(const Value: Double);
begin
  if FMinDist <> Value then begin FMinDist := Value; Changed; end;
end;

procedure TcvHoughCirclesOperation.SetMinRadius(const Value: Integer);
begin
  if FMinRadius <> Value then begin FMinRadius := Value; Changed; end;
end;

procedure TcvHoughCirclesOperation.SetOnHoughCirclesResult(const Value: TcvPipelineHoughCirclesEvent);
begin
  FOnHoughCirclesResult := Value;
end;

procedure TcvHoughCirclesOperation.SetParam1(const Value: Double);
begin
  if FParam1 <> Value then begin FParam1 := Value; Changed; end;
end;

procedure TcvHoughCirclesOperation.SetParam2(const Value: Double);
begin
  if FParam2 <> Value then begin FParam2 := Value; Changed; end;
end;

{ TcvConnectedComponentsOperation }

constructor TcvConnectedComponentsOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FThresholdValue := 127.0;
  FMinArea := 0;
  FMaxArea := 0;
  FConnectivity := 8;
  FBoxThickness := 2;
  FBoxColor := TCVScalar.Create(0, 255, 0);
  FDrawOverlay := True;
  FColormapSeed := 0;
end;

procedure TcvConnectedComponentsOperation.Assign(Source: TPersistent);
begin
  if Source is TcvConnectedComponentsOperation then
  begin
    FThresholdValue := TcvConnectedComponentsOperation(Source).ThresholdValue;
    FMinArea := TcvConnectedComponentsOperation(Source).MinArea;
    FMaxArea := TcvConnectedComponentsOperation(Source).MaxArea;
    FConnectivity := TcvConnectedComponentsOperation(Source).Connectivity;
    FBoxThickness := TcvConnectedComponentsOperation(Source).BoxThickness;
    FBoxColor := TcvConnectedComponentsOperation(Source).BoxColor;
    FDrawOverlay := TcvConnectedComponentsOperation(Source).DrawOverlay;
    FColormapSeed := TcvConnectedComponentsOperation(Source).ColormapSeed;
    FOnConnectedComponentsResult := TcvConnectedComponentsOperation(Source).OnConnectedComponentsResult;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvConnectedComponentsOperation.AreaPassesFilter(const Area: Integer): Boolean;
begin
  Result := (FMinArea <= 0) or (Area >= FMinArea);
  if Result and (FMaxArea > 0) then
    Result := Area <= FMaxArea;
end;

function TcvConnectedComponentsOperation.BuildComponentsResult(const Labels: TCVMat;
  const Stats, Centroids: TCVMat; LabelCount: Integer): TcvPipelineConnectedComponentsResult;
var
  LabelIdx, ItemIdx, Area: Integer;
  Left, Top, Width, Height: Integer;
  Cx, Cy: Double;
begin
  ItemIdx := 0;
  SetLength(Result.Items, LabelCount);
  for LabelIdx := 1 to LabelCount - 1 do
  begin
    Area := PInteger(Stats.ptr(LabelIdx, CC_STAT_AREA))^;
    if not AreaPassesFilter(Area) then
      Continue;
    Left := PInteger(Stats.ptr(LabelIdx, CC_STAT_LEFT))^;
    Top := PInteger(Stats.ptr(LabelIdx, CC_STAT_TOP))^;
    Width := PInteger(Stats.ptr(LabelIdx, CC_STAT_WIDTH))^;
    Height := PInteger(Stats.ptr(LabelIdx, CC_STAT_HEIGHT))^;
    Cx := PDouble(Centroids.ptr(LabelIdx, 0))^;
    Cy := PDouble(Centroids.ptr(LabelIdx, 1))^;
    Result.Items[ItemIdx].LabelId := LabelIdx;
    Result.Items[ItemIdx].Area := Area;
    Result.Items[ItemIdx].Centroid := TCVPoint.Create(Round(Cx), Round(Cy));
    Result.Items[ItemIdx].BoundingRect := TCVRect.Create(Left, Top, Width, Height);
    Inc(ItemIdx);
  end;
  Result.Count := ItemIdx;
  SetLength(Result.Items, ItemIdx);
end;

procedure TcvConnectedComponentsOperation.BuildLabels8(const Labels: TCVMat; var Labels8: TCVMat);
var
  I, J, L: Integer;
  MinVal, MaxVal: Double;
  MinLoc, MaxLoc: TCVPoint;
begin
  Labels8 := TCVMat.Create_0(Labels.rows, Labels.cols, CV_8UC1);
  if FColormapSeed <> 0 then
  begin
    for I := 0 to Labels.rows - 1 do
      for J := 0 to Labels.cols - 1 do
      begin
        L := PInteger(Labels.ptr(I, J))^;
        if L = 0 then
          PByte(Labels8.ptr(I, J))^ := 0
        else
          PByte(Labels8.ptr(I, J))^ := Byte((L * FColormapSeed) mod 254 + 1);
      end;
  end
  else
  begin
    minMaxLoc(Labels.Handle, MinVal, MaxVal, MinLoc, MaxLoc, nil);
    if MaxVal > MinVal then
      Labels.convertTo(Labels8.Handle, CV_8U, 255.0 / MaxVal, 0.0)
    else
      Labels8 := Labels8.setZero;
  end;
end;

function TcvConnectedComponentsOperation.GetDisplayName: string;
begin
  if FDrawOverlay then
    Result := 'ConnectedComponents (overlay)'
  else
    Result := 'ConnectedComponents';
end;

procedure TcvConnectedComponentsOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Gray, Binary, Labels, Stats, Centroids, Labels8, Colored, OutImg: TCVMat;
  LabelCount, I: Integer;
  ComponentsResult: TcvPipelineConnectedComponentsResult;
  Item: TcvPipelineBlobItem;
begin
  Gray := TCVMat.Create_0(0, 0, CV_8UC1);
  if Src.channels > 1 then
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0)
  else
    Src.copyTo(Gray.Handle);
  Binary := TCVMat.Create_0(0, 0, CV_8UC1);
  threshold(Gray.Handle, Binary.Handle, FThresholdValue, 255, THRESH_BINARY);
  Labels := TCVMat.Create_0(0, 0, CV_32S);
  Stats := TCVMat.Create_0(0, 0, CV_32S);
  Centroids := TCVMat.Create_0(0, 0, CV_64F);
  LabelCount := connectedComponentsWithStats(Binary.Handle, Labels.Handle, Stats.Handle,
    Centroids.Handle, FConnectivity, CV_32S);
  ComponentsResult := BuildComponentsResult(Labels, Stats, Centroids, LabelCount);
  if Assigned(FOnConnectedComponentsResult) then
    FOnConnectedComponentsResult(Self, Src, ComponentsResult);
  if FDrawOverlay then
  begin
    if Src.channels > 1 then
      OutImg := Src.clone
    else
    begin
      OutImg := TCVMat.Create_0(0, 0, CV_8UC3);
      cvtColor(Src.Handle, OutImg.Handle, COLOR_GRAY2BGR, 0, 0);
    end;
    for I := 0 to ComponentsResult.Count - 1 do
    begin
      Item := ComponentsResult.Items[I];
      rectangle(OutImg.Handle, Item.BoundingRect, FBoxColor, FBoxThickness, LINE_8, 0);
    end;
    Dst := OutImg;
  end
  else
  begin
    BuildLabels8(Labels, Labels8);
    Colored := TCVMat.Create_0(0, 0, CV_8UC3);
    applyColorMap(Labels8.Handle, Colored.Handle, COLORMAP_JET);
    Dst := Colored;
  end;
  if Gray.Handle <> Src.Handle then
    Gray.Release;
end;

procedure TcvConnectedComponentsOperation.SetBoxColor(const Value: TCVScalar);
begin
  FBoxColor := Value;
  Changed;
end;

procedure TcvConnectedComponentsOperation.SetColormapSeed(const Value: Integer);
begin
  if FColormapSeed <> Value then begin FColormapSeed := Value; Changed; end;
end;

procedure TcvConnectedComponentsOperation.SetBoxThickness(const Value: Integer);
begin
  if FBoxThickness <> Value then begin FBoxThickness := Value; Changed; end;
end;

procedure TcvConnectedComponentsOperation.SetConnectivity(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if (V <> 4) and (V <> 8) then V := 8;
  if FConnectivity <> V then begin FConnectivity := V; Changed; end;
end;

procedure TcvConnectedComponentsOperation.SetDrawOverlay(const Value: Boolean);
begin
  if FDrawOverlay <> Value then begin FDrawOverlay := Value; Changed; end;
end;

procedure TcvConnectedComponentsOperation.SetMaxArea(const Value: Integer);
begin
  if FMaxArea <> Value then begin FMaxArea := Value; Changed; end;
end;

procedure TcvConnectedComponentsOperation.SetMinArea(const Value: Integer);
begin
  if FMinArea <> Value then begin FMinArea := Value; Changed; end;
end;

procedure TcvConnectedComponentsOperation.SetOnConnectedComponentsResult(
  const Value: TcvPipelineConnectedComponentsEvent);
begin
  FOnConnectedComponentsResult := Value;
end;

procedure TcvConnectedComponentsOperation.SetThresholdValue(const Value: Double);
begin
  if FThresholdValue <> Value then begin FThresholdValue := Value; Changed; end;
end;

{ TcvBackgroundSubtractOperation }

constructor TcvBackgroundSubtractOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FAlgorithm := bsMOG2;
  FHistory := 500;
  FVarThreshold := 16.0;
  FDist2Threshold := 400.0;
  FDetectShadows := True;
  FLearningRate := -1.0;
  FShowShadows := True;
  FDrawOverlay := True;
  FResetOnAssign := True;
  FSubtractorReady := False;
  FFrameCount := 0;
end;

destructor TcvBackgroundSubtractOperation.Destroy;
begin
  ResetSubtractor;
  inherited Destroy;
end;

procedure TcvBackgroundSubtractOperation.Assign(Source: TPersistent);
begin
  if Source is TcvBackgroundSubtractOperation then
  begin
    FAlgorithm := TcvBackgroundSubtractOperation(Source).Algorithm;
    FHistory := TcvBackgroundSubtractOperation(Source).History;
    FVarThreshold := TcvBackgroundSubtractOperation(Source).VarThreshold;
    FDist2Threshold := TcvBackgroundSubtractOperation(Source).Dist2Threshold;
    FDetectShadows := TcvBackgroundSubtractOperation(Source).DetectShadows;
    FLearningRate := TcvBackgroundSubtractOperation(Source).LearningRate;
    FShowShadows := TcvBackgroundSubtractOperation(Source).ShowShadows;
    FDrawOverlay := TcvBackgroundSubtractOperation(Source).DrawOverlay;
    FResetOnAssign := TcvBackgroundSubtractOperation(Source).ResetOnAssign;
    FOnForegroundMaskResult := TcvBackgroundSubtractOperation(Source).OnForegroundMaskResult;
    if FResetOnAssign then
      ResetSubtractor;
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TcvBackgroundSubtractOperation.Reset;
begin
  ResetSubtractor;
end;

function TcvBackgroundSubtractOperation.BuildForegroundResult(const Mask: TCVMat): TcvPipelineForegroundResult;
var
  TotalPixels: Integer;
begin
  Result.ForegroundPixelCount := countNonZero(Mask.Handle, nil);
  TotalPixels := Mask.rows * Mask.cols;
  if TotalPixels > 0 then
    Result.ForegroundRatio := Result.ForegroundPixelCount / TotalPixels
  else
    Result.ForegroundRatio := 0.0;
end;

procedure TcvBackgroundSubtractOperation.EnsureSubtractor;
begin
  if FSubtractorReady and (FActiveAlgorithm = FAlgorithm) then
    Exit;
  ResetSubtractor;
  case FAlgorithm of
    bsKNN:
    begin
      FKNN := TCVKNN.Create(FHistory, FDist2Threshold, FDetectShadows);
      FActiveAlgorithm := bsKNN;
    end;
  else
    begin
      FMOG2 := TCVMOG2.Create(FHistory, FVarThreshold, FDetectShadows);
      FActiveAlgorithm := bsMOG2;
    end;
  end;
  FSubtractorReady := True;
  FFrameCount := 0;
end;

function TcvBackgroundSubtractOperation.GetDisplayName: string;
begin
  if FAlgorithm = bsKNN then
    Result := 'BackgroundSubtract (KNN)'
  else
    Result := 'BackgroundSubtract (MOG2)';
end;

procedure TcvBackgroundSubtractOperation.PrepareMask(const Mask: TCVMat; out WorkMask: TCVMat;
  out NeedRelease: Boolean);
begin
  NeedRelease := False;
  if FShowShadows then
    WorkMask := Mask
  else
  begin
    WorkMask := TCVMat.Create_0(0, 0, CV_8UC1);
    threshold(Mask.Handle, WorkMask.Handle, 254, 255, THRESH_BINARY);
    NeedRelease := True;
  end;
end;

procedure TcvBackgroundSubtractOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Input, FgMask, WorkMask, OutImg, GreenLayer: TCVMat;
  ForegroundResult: TcvPipelineForegroundResult;
  NeedRelease: Boolean;
  Green: TCVScalar;
begin
  EnsureSubtractor;
  if Src.channels = 1 then
  begin
    Input := TCVMat.Create_0(0, 0, CV_8UC3);
    cvtColor(Src.Handle, Input.Handle, COLOR_GRAY2BGR, 0, 0);
  end
  else
    Input := Src;
  FgMask := TCVMat.Create_0(0, 0, CV_8UC1);
  case FAlgorithm of
    bsKNN:
      FKNN.apply(Input.Handle, FgMask.Handle, FLearningRate);
  else
    FMOG2.apply(Input.Handle, FgMask.Handle, FLearningRate);
  end;
  Inc(FFrameCount);
  PrepareMask(FgMask, WorkMask, NeedRelease);
  ForegroundResult := BuildForegroundResult(WorkMask);
  if Assigned(FOnForegroundMaskResult) then
    FOnForegroundMaskResult(Self, Src, ForegroundResult);
  if FDrawOverlay then
  begin
    if Src.channels > 1 then
      OutImg := Src.clone
    else
    begin
      OutImg := TCVMat.Create_0(0, 0, CV_8UC3);
      cvtColor(Src.Handle, OutImg.Handle, COLOR_GRAY2BGR, 0, 0);
    end;
    GreenLayer := TCVMat.Create_0(OutImg.rows, OutImg.cols, CV_8UC3);
    Green := TCVScalar.Create(0, 255, 0);
    GreenLayer.setTo(@Green, nil);
    GreenLayer.copyTo(OutImg.Handle, WorkMask.Handle);
    GreenLayer.Release;
    Dst := OutImg;
  end
  else
    Dst := WorkMask.clone;
  if NeedRelease then
    WorkMask.Release;
  if Input.Handle <> Src.Handle then
    Input.Release;
end;

procedure TcvBackgroundSubtractOperation.ResetSubtractor;
begin
  if FSubtractorReady then
  begin
    if FActiveAlgorithm = bsKNN then
      FKNN.Release
    else
      FMOG2.Release;
    FSubtractorReady := False;
  end;
  FFrameCount := 0;
end;

procedure TcvBackgroundSubtractOperation.SetAlgorithm(const Value: TcvBackgroundSubtractAlgorithm);
begin
  if FAlgorithm <> Value then
  begin
    FAlgorithm := Value;
    ResetSubtractor;
    Changed;
  end;
end;

procedure TcvBackgroundSubtractOperation.SetDetectShadows(const Value: Boolean);
begin
  if FDetectShadows <> Value then
  begin
    FDetectShadows := Value;
    ResetSubtractor;
    Changed;
  end;
end;

procedure TcvBackgroundSubtractOperation.SetDist2Threshold(const Value: Double);
begin
  if FDist2Threshold <> Value then
  begin
    FDist2Threshold := Value;
    ResetSubtractor;
    Changed;
  end;
end;

procedure TcvBackgroundSubtractOperation.SetDrawOverlay(const Value: Boolean);
begin
  if FDrawOverlay <> Value then begin FDrawOverlay := Value; Changed; end;
end;

procedure TcvBackgroundSubtractOperation.SetHistory(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if V < 1 then V := 1;
  if FHistory <> V then
  begin
    FHistory := V;
    ResetSubtractor;
    Changed;
  end;
end;

procedure TcvBackgroundSubtractOperation.SetLearningRate(const Value: Double);
begin
  if FLearningRate <> Value then begin FLearningRate := Value; Changed; end;
end;

procedure TcvBackgroundSubtractOperation.SetOnForegroundMaskResult(
  const Value: TcvPipelineForegroundMaskEvent);
begin
  FOnForegroundMaskResult := Value;
end;

procedure TcvBackgroundSubtractOperation.SetResetOnAssign(const Value: Boolean);
begin
  if FResetOnAssign <> Value then begin FResetOnAssign := Value; Changed; end;
end;

procedure TcvBackgroundSubtractOperation.SetShowShadows(const Value: Boolean);
begin
  if FShowShadows <> Value then begin FShowShadows := Value; Changed; end;
end;

procedure TcvBackgroundSubtractOperation.SetVarThreshold(const Value: Double);
begin
  if FVarThreshold <> Value then
  begin
    FVarThreshold := Value;
    ResetSubtractor;
    Changed;
  end;
end;

{ TcvDebugTextOperation }

constructor TcvDebugTextOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FText := 'Debug';
  FOrgX := 10;
  FOrgY := 30;
  FFontFace := FONT_HERSHEY_SIMPLEX;
  FFontScale := 0.7;
  FTextColor := TCVScalar.Create(0, 255, 0);
  FTextThickness := 1;
  FDrawRect := False;
  FRect := TCVRect.Create(0, 0, 100, 50);
  FRectColor := TCVScalar.Create(0, 255, 0);
  FRectThickness := 2;
  FDrawOverlay := True;
end;

procedure TcvDebugTextOperation.Assign(Source: TPersistent);
begin
  if Source is TcvDebugTextOperation then
  begin
    FText := TcvDebugTextOperation(Source).Text;
    FOrgX := TcvDebugTextOperation(Source).OrgX;
    FOrgY := TcvDebugTextOperation(Source).OrgY;
    FFontFace := TcvDebugTextOperation(Source).FontFace;
    FFontScale := TcvDebugTextOperation(Source).FontScale;
    FTextColor := TcvDebugTextOperation(Source).TextColor;
    FTextThickness := TcvDebugTextOperation(Source).TextThickness;
    FDrawRect := TcvDebugTextOperation(Source).DrawRect;
    FRect := TcvDebugTextOperation(Source).Rect;
    FRectColor := TcvDebugTextOperation(Source).RectColor;
    FRectThickness := TcvDebugTextOperation(Source).RectThickness;
    FDrawOverlay := TcvDebugTextOperation(Source).DrawOverlay;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvDebugTextOperation.EnsureColorImage(const Src: TCVMat): TCVMat;
begin
  if Src.channels > 1 then
    Result := Src.clone
  else
  begin
    Result := TCVMat.Create_0(0, 0, CV_8UC3);
    cvtColor(Src.Handle, Result.Handle, COLOR_GRAY2BGR, 0, 0);
  end;
end;

function TcvDebugTextOperation.GetDisplayName: string;
begin
  if FDrawOverlay then
    Result := Format('DebugText (%s)', [FText])
  else
    Result := 'DebugText';
end;

procedure TcvDebugTextOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  OutImg: TCVMat;
  TextAnsi: AnsiString;
begin
  if not FDrawOverlay then
  begin
    Dst := Src.clone;
    Exit;
  end;
  OutImg := EnsureColorImage(Src);
  if FText <> '' then
  begin
    TextAnsi := AnsiString(FText);
    putText(OutImg.Handle, PAnsiChar(TextAnsi), TCVPoint.Create(FOrgX, FOrgY),
      FFontFace, FFontScale, FTextColor, FTextThickness, LINE_8, False);
  end;
  if FDrawRect then
    rectangle(OutImg.Handle, FRect, FRectColor, FRectThickness, LINE_8, 0);
  Dst := OutImg;
end;

procedure TcvDebugTextOperation.SetDrawOverlay(const Value: Boolean);
begin
  if FDrawOverlay <> Value then begin FDrawOverlay := Value; Changed; end;
end;

procedure TcvDebugTextOperation.SetDrawRect(const Value: Boolean);
begin
  if FDrawRect <> Value then begin FDrawRect := Value; Changed; end;
end;

procedure TcvDebugTextOperation.SetFontFace(const Value: Integer);
begin
  if FFontFace <> Value then begin FFontFace := Value; Changed; end;
end;

procedure TcvDebugTextOperation.SetFontScale(const Value: Double);
begin
  if FFontScale <> Value then begin FFontScale := Value; Changed; end;
end;

procedure TcvDebugTextOperation.SetOrgX(const Value: Integer);
begin
  if FOrgX <> Value then begin FOrgX := Value; Changed; end;
end;

procedure TcvDebugTextOperation.SetOrgY(const Value: Integer);
begin
  if FOrgY <> Value then begin FOrgY := Value; Changed; end;
end;

procedure TcvDebugTextOperation.SetRect(const Value: TCVRect);
begin
  FRect := Value;
  Changed;
end;

procedure TcvDebugTextOperation.SetRectColor(const Value: TCVScalar);
begin
  FRectColor := Value;
  Changed;
end;

procedure TcvDebugTextOperation.SetRectThickness(const Value: Integer);
begin
  if FRectThickness <> Value then begin FRectThickness := Value; Changed; end;
end;

procedure TcvDebugTextOperation.SetText(const Value: string);
begin
  if FText <> Value then begin FText := Value; Changed; end;
end;

procedure TcvDebugTextOperation.SetTextColor(const Value: TCVScalar);
begin
  FTextColor := Value;
  Changed;
end;

procedure TcvDebugTextOperation.SetTextThickness(const Value: Integer);
begin
  if FTextThickness <> Value then begin FTextThickness := Value; Changed; end;
end;

{ TcvPhaseCorrelateOperation }

constructor TcvPhaseCorrelateOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FReferencePath := '';
  FReferencePathLoaded := '';
  FReferenceReady := False;
  FPrevReady := False;
  FDrawOverlay := True;
  FArrowScale := 5.0;
end;

destructor TcvPhaseCorrelateOperation.Destroy;
begin
  if FReferenceReady then
    FReference.Release;
  if FPrevReady then
    FPrev.Release;
  inherited Destroy;
end;

procedure TcvPhaseCorrelateOperation.Assign(Source: TPersistent);
begin
  if Source is TcvPhaseCorrelateOperation then
  begin
    FReferencePath := TcvPhaseCorrelateOperation(Source).ReferencePath;
    FDrawOverlay := TcvPhaseCorrelateOperation(Source).DrawOverlay;
    FArrowScale := TcvPhaseCorrelateOperation(Source).ArrowScale;
    FOnPhaseCorrelateResult := TcvPhaseCorrelateOperation(Source).OnPhaseCorrelateResult;
    FReferencePathLoaded := '';
    if FReferenceReady then
    begin
      FReference.Release;
      FReferenceReady := False;
    end;
    ResetPrev;
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TcvPhaseCorrelateOperation.EnsureReference(const Src: TCVMat);
var
  Temp: TCVMat;
begin
  if FReferencePath = '' then
    Exit;
  if SameText(FReferencePath, FReferencePathLoaded) then
    Exit;
  if FReferencePathLoaded <> '' then
    FReference.Release;
  FReference := imread(PAnsiChar(AnsiString(FReferencePath)), IMREAD_GRAYSCALE);
  FReferencePathLoaded := FReferencePath;
  FReferenceReady := not FReference.empty;
  if not FReferenceReady then
    Exit;
  if (FReference.rows <> Src.rows) or (FReference.cols <> Src.cols) then
  begin
    Temp := TCVMat.Create_0(0, 0, CV_8UC1);
    resize(FReference.Handle, Temp.Handle, TCVSize.Create(Src.cols, Src.rows), 0, 0, INTER_LINEAR);
    FReference.Release;
    FReference := Temp;
  end;
end;

function TcvPhaseCorrelateOperation.GetDisplayName: string;
begin
  if FReferencePath <> '' then
    Result := 'PhaseCorrelate (ref)'
  else
    Result := 'PhaseCorrelate (prev)';
end;

function TcvPhaseCorrelateOperation.ToGrayFloat(const Src: TCVMat): TCVMat;
var
  Gray, GrayF: TCVMat;
begin
  if Src.channels = 1 then
    Gray := Src
  else
  begin
    Gray := TCVMat.Create_0(0, 0, CV_8UC1);
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
  end;
  GrayF := TCVMat.Create_0(0, 0, CV_32F);
  Gray.convertTo(GrayF.Handle, CV_32F, 1.0 / 255.0, 0.0);
  if (Src.channels <> 1) and (Gray.Handle <> Src.Handle) then
    Gray.Release;
  Result := GrayF;
end;

procedure TcvPhaseCorrelateOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  CurrF, RefF, OutImg: TCVMat;
  PhaseResult: TcvPipelinePhaseCorrelateResult;
  Shift: TCVPoint2d;
  Response: Double;
  Cx, Cy: Integer;
  P1, P2: TCVPoint;
  LabelText: AnsiString;
  NeedReleaseRef: Boolean;
begin
  CurrF := ToGrayFloat(Src);
  PhaseResult.HasPrevious := False;
  PhaseResult.Shift := TCVPoint2d.Create(0, 0);
  PhaseResult.Response := 0.0;

  if FReferencePath <> '' then
  begin
    EnsureReference(Src);
    if not FReferenceReady then
    begin
      Dst := Src.clone;
      CurrF.Release;
      Exit;
    end;
    RefF := TCVMat.Create_0(0, 0, CV_32F);
    FReference.convertTo(RefF.Handle, CV_32F, 1.0 / 255.0, 0.0);
    NeedReleaseRef := True;
    PhaseResult.HasPrevious := True;
  end
  else if FPrevReady then
  begin
    RefF := FPrev;
    NeedReleaseRef := False;
    PhaseResult.HasPrevious := True;
  end
  else
  begin
    FPrev := CurrF.clone;
    FPrevReady := True;
    if Assigned(FOnPhaseCorrelateResult) then
      FOnPhaseCorrelateResult(Self, Src, PhaseResult);
    Dst := Src.clone;
    CurrF.Release;
    Exit;
  end;

  Shift := phaseCorrelate(RefF.Handle, CurrF.Handle, nil, Response);
  PhaseResult.Shift := Shift;
  PhaseResult.Response := Response;
  if Assigned(FOnPhaseCorrelateResult) then
    FOnPhaseCorrelateResult(Self, Src, PhaseResult);

  if FReferencePath = '' then
  begin
    FPrev.Release;
    FPrev := CurrF.clone;
  end;

  if FDrawOverlay and PhaseResult.HasPrevious then
  begin
    if Src.channels > 1 then
      OutImg := Src.clone
    else
    begin
      OutImg := TCVMat.Create_0(0, 0, CV_8UC3);
      cvtColor(Src.Handle, OutImg.Handle, COLOR_GRAY2BGR, 0, 0);
    end;
    Cx := Src.cols div 2;
    Cy := Src.rows div 2;
    P1 := TCVPoint.Create(Cx, Cy);
    P2 := TCVPoint.Create(Cx + Round(Shift.X * FArrowScale), Cy + Round(Shift.Y * FArrowScale));
    arrowedLine(OutImg.Handle, P1, P2, TCVScalar.Create(0, 255, 255), 2, LINE_8, 0, 0.2);
    LabelText := AnsiString(Format('dx=%.1f dy=%.1f r=%.3f', [Shift.X, Shift.Y, Response]));
    putText(OutImg.Handle, PAnsiChar(LabelText), TCVPoint.Create(10, 30),
      FONT_HERSHEY_SIMPLEX, 0.6, TCVScalar.Create(0, 255, 255), 1, LINE_8, False);
    Dst := OutImg;
  end
  else
    Dst := Src.clone;

  if NeedReleaseRef then
    RefF.Release;
  CurrF.Release;
end;

procedure TcvPhaseCorrelateOperation.ResetPrev;
begin
  if FPrevReady then
  begin
    FPrev.Release;
    FPrevReady := False;
  end;
end;

procedure TcvPhaseCorrelateOperation.SetArrowScale(const Value: Double);
begin
  if FArrowScale <> Value then begin FArrowScale := Value; Changed; end;
end;

procedure TcvPhaseCorrelateOperation.SetDrawOverlay(const Value: Boolean);
begin
  if FDrawOverlay <> Value then begin FDrawOverlay := Value; Changed; end;
end;

procedure TcvPhaseCorrelateOperation.SetOnPhaseCorrelateResult(
  const Value: TcvPipelinePhaseCorrelateEvent);
begin
  FOnPhaseCorrelateResult := Value;
end;

procedure TcvPhaseCorrelateOperation.SetReferencePath(const Value: string);
begin
  if FReferencePath <> Value then
  begin
    FReferencePath := Value;
    FReferencePathLoaded := '';
    if FReferenceReady then
    begin
      FReference.Release;
      FReferenceReady := False;
    end;
    ResetPrev;
    Changed;
  end;
end;

{ TcvChannelExtractOperation }

constructor TcvChannelExtractOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FChannelIndex := 0;
end;

procedure TcvChannelExtractOperation.Assign(Source: TPersistent);
begin
  if Source is TcvChannelExtractOperation then
  begin
    FChannelIndex := TcvChannelExtractOperation(Source).ChannelIndex;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvChannelExtractOperation.GetDisplayName: string;
begin
  Result := Format('Channel %d', [FChannelIndex]);
end;

procedure TcvChannelExtractOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  ChCount, Ci, Row, Col: Integer;
  Ch: array of TCVMat;
  Sp, Dp: PByte;
  Idx: Integer;
begin
  ChCount := Src.channels;
  if ChCount <= 1 then
  begin
    Dst := Src.clone;
    Exit;
  end;
  Idx := FChannelIndex;
  if Idx < 0 then Idx := 0;
  if Idx >= ChCount then Idx := ChCount - 1;
  SetLength(Ch, ChCount);
  for Ci := 0 to ChCount - 1 do
    Ch[Ci] := TCVMat.Create_0(Src.rows, Src.cols, CV_8U);
  for Row := 0 to Src.rows - 1 do
    for Col := 0 to Src.cols - 1 do
    begin
      Sp := Src.ptr(Row, Col);
      for Ci := 0 to ChCount - 1 do
      begin
        Dp := Ch[Ci].ptr(Row, Col);
        Dp^ := PByte(Sp)[Ci];
      end;
    end;
  Dst := Ch[Idx].clone;
  for Ci := 0 to ChCount - 1 do
    Ch[Ci].Release;
end;

procedure TcvChannelExtractOperation.SetChannelIndex(const Value: Integer);
begin
  if FChannelIndex <> Value then begin FChannelIndex := Value; Changed; end;
end;

{ TcvFlipOperation }

constructor TcvFlipOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FFlipMode := fmHorizontal;
end;

procedure TcvFlipOperation.Assign(Source: TPersistent);
begin
  if Source is TcvFlipOperation then
  begin
    FFlipMode := TcvFlipOperation(Source).FlipMode;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvFlipOperation.FlipCode: Integer;
begin
  case FFlipMode of
    fmVertical: Result := FLIP_VERTICAL;
    fmBoth: Result := FLIP_BOTH;
  else
    Result := FLIP_HORIZONTAL;
  end;
end;

function TcvFlipOperation.GetDisplayName: string;
begin
  Result := Format('Flip (%s)', [FlipModeNames[FFlipMode]]);
end;

procedure TcvFlipOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  flip(Src.Handle, Temp.Handle, FlipCode);
  Dst := Temp;
end;

procedure TcvFlipOperation.SetFlipMode(const Value: TcvFlipMode);
begin
  if FFlipMode <> Value then begin FFlipMode := Value; Changed; end;
end;

{ TcvOrthoRotateOperation }

constructor TcvOrthoRotateOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FRotateMode := or90CW;
end;

procedure TcvOrthoRotateOperation.Assign(Source: TPersistent);
begin
  if Source is TcvOrthoRotateOperation then
  begin
    FRotateMode := TcvOrthoRotateOperation(Source).RotateMode;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvOrthoRotateOperation.GetDisplayName: string;
begin
  Result := Format('Rotate (%s)', [OrthoRotateModeNames[FRotateMode]]);
end;

function TcvOrthoRotateOperation.RotateCode: Integer;
begin
  case FRotateMode of
    or180: Result := ROTATE_180;
    or90CCW: Result := ROTATE_90_COUNTERCLOCKWISE;
  else
    Result := ROTATE_90_CLOCKWISE;
  end;
end;

procedure TcvOrthoRotateOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  rotate(Src.Handle, Temp.Handle, RotateCode);
  Dst := Temp;
end;

procedure TcvOrthoRotateOperation.SetRotateMode(const Value: TcvOrthoRotateMode);
begin
  if FRotateMode <> Value then begin FRotateMode := Value; Changed; end;
end;

{ TcvGammaOperation }

constructor TcvGammaOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FGamma := 1.0;
  FLutReady := False;
  FLutGamma := 0;
end;

destructor TcvGammaOperation.Destroy;
begin
  if FLutReady then
    FLut.Release;
  inherited Destroy;
end;

procedure TcvGammaOperation.Assign(Source: TPersistent);
begin
  if Source is TcvGammaOperation then
  begin
    FGamma := TcvGammaOperation(Source).Gamma;
    FLutReady := False;
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TcvGammaOperation.EnsureLut;
begin
  if FLutReady and (FLutGamma = FGamma) then
    Exit;
  if FLutReady then
    FLut.Release;
  FLut := TCVMat.Create_0(1, 256, CV_8U);
  buildGammaLUT(FLUT.Handle, FGamma);
  FLutReady := True;
  FLutGamma := FGamma;
end;

function TcvGammaOperation.GetDisplayName: string;
begin
  Result := Format('Gamma (%.2f)', [FGamma]);
end;

procedure TcvGammaOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  EnsureLut;
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  LUT(Src.Handle, FLut.Handle, Temp.Handle);
  Dst := Temp;
end;

procedure TcvGammaOperation.SetGamma(const Value: Double);
var
  V: Double;
begin
  V := Value;
  if V <= 0 then V := 0.01;
  if FGamma <> V then
  begin
    FGamma := V;
    Changed;
  end;
end;

{ TcvAddWeightedOperation }

constructor TcvAddWeightedOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FAlpha := 0.7;
  FBeta := 0.3;
  FBlendGamma := 0.0;
  FOperandLoaded := False;
end;

procedure TcvAddWeightedOperation.Assign(Source: TPersistent);
begin
  if Source is TcvAddWeightedOperation then
  begin
    FAlpha := TcvAddWeightedOperation(Source).Alpha;
    FBeta := TcvAddWeightedOperation(Source).Beta;
    FBlendGamma := TcvAddWeightedOperation(Source).BlendGamma;
    FOperandPath := TcvAddWeightedOperation(Source).OperandPath;
    FOperandPathLoaded := '';
    FOperandLoaded := False;
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TcvAddWeightedOperation.EnsureOperand(const Src: TCVMat; out Src2: TCVMat; out NeedRelease: Boolean);
var
  Temp: TCVMat;
begin
  NeedRelease := False;
  if FOperandPath = '' then
  begin
    Temp := TCVMat.Create_0(Src.rows, Src.cols, Src.dataType);
    Temp := Temp.setZero;
    Src2 := Temp;
    NeedRelease := True;
    Exit;
  end;
  if not SameText(FOperandPath, FOperandPathLoaded) then
  begin
    if FOperandPathLoaded <> '' then
      FOperand.Release;
    FOperand := imread(PAnsiChar(AnsiString(FOperandPath)), 0);
    FOperandPathLoaded := FOperandPath;
    FOperandLoaded := not FOperand.empty;
  end;
  if not FOperandLoaded then
  begin
    Temp := TCVMat.Create_0(Src.rows, Src.cols, Src.dataType);
    Temp := Temp.setZero;
    Src2 := Temp;
    NeedRelease := True;
    Exit;
  end;
  if (FOperand.rows = Src.rows) and (FOperand.cols = Src.cols) and
     (FOperand.dataType = Src.dataType) then
    Src2 := FOperand
  else
  begin
    Temp := TCVMat.Create_0(0, 0, Src.dataType);
    resize(FOperand.Handle, Temp.Handle, TCVSize.Create(Src.cols, Src.rows), 0, 0, INTER_LINEAR);
    Src2 := Temp;
    NeedRelease := True;
  end;
end;

function TcvAddWeightedOperation.GetDisplayName: string;
begin
  Result := Format('AddWeighted (a=%.2f, b=%.2f)', [FAlpha, FBeta]);
end;

procedure TcvAddWeightedOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp, Src2: TCVMat;
  NeedRelease: Boolean;
begin
  EnsureOperand(Src, Src2, NeedRelease);
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  addWeighted(Src.Handle, Src2.Handle, Temp.Handle, FAlpha, FBeta, FBlendGamma);
  Dst := Temp;
  if NeedRelease then
    Src2.Release;
end;

procedure TcvAddWeightedOperation.SetAlpha(const Value: Double);
begin
  if FAlpha <> Value then begin FAlpha := Value; Changed; end;
end;

procedure TcvAddWeightedOperation.SetBeta(const Value: Double);
begin
  if FBeta <> Value then begin FBeta := Value; Changed; end;
end;

procedure TcvAddWeightedOperation.SetBlendGamma(const Value: Double);
begin
  if FBlendGamma <> Value then begin FBlendGamma := Value; Changed; end;
end;

procedure TcvAddWeightedOperation.SetOperandPath(const Value: string);
begin
  if FOperandPath <> Value then
  begin
    FOperandPath := Value;
    FOperandPathLoaded := '';
    FOperandLoaded := False;
    Changed;
  end;
end;

function ExtractGrayChannel(const Src: TCVMat): TCVMat;
var
  Gray: TCVMat;
begin
  if Src.channels = 1 then
    Result := Src.clone
  else
  begin
    Gray := TCVMat.Create_0(0, 0, CV_8UC1);
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
    Result := Gray;
  end;
end;

function OddKernelSize(const Value: Integer): Integer;
begin
  Result := Value;
  if Result < 1 then Result := 1;
  if Result mod 2 = 0 then Inc(Result);
end;

{ TcvPyrMeanShiftOperation }

constructor TcvPyrMeanShiftOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FSp := 10.0;
  FSr := 20.0;
  FMaxLevel := 1;
end;

procedure TcvPyrMeanShiftOperation.Assign(Source: TPersistent);
begin
  if Source is TcvPyrMeanShiftOperation then
  begin
    FSp := TcvPyrMeanShiftOperation(Source).Sp;
    FSr := TcvPyrMeanShiftOperation(Source).Sr;
    FMaxLevel := TcvPyrMeanShiftOperation(Source).MaxLevel;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvPyrMeanShiftOperation.GetDisplayName: string;
begin
  Result := Format('PyrMeanShift (sp=%.0f, sr=%.0f)', [FSp, FSr]);
end;

procedure TcvPyrMeanShiftOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
  Crit: TCVTermCriteria;
begin
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  Crit := TCVTermCriteria.Create(TERM_CRITERIA_EPS or TERM_CRITERIA_COUNT, 5, 1.0);
  pyrMeanShiftFiltering(Src.Handle, Temp.Handle, FSp, FSr, FMaxLevel, Crit);
  Dst := Temp;
end;

procedure TcvPyrMeanShiftOperation.SetMaxLevel(const Value: Integer);
var
  V: Integer;
begin
  V := Value;
  if V < 0 then V := 0;
  if FMaxLevel <> V then begin FMaxLevel := V; Changed; end;
end;

procedure TcvPyrMeanShiftOperation.SetSp(const Value: Double);
begin
  if FSp <> Value then begin FSp := Value; Changed; end;
end;

procedure TcvPyrMeanShiftOperation.SetSr(const Value: Double);
begin
  if FSr <> Value then begin FSr := Value; Changed; end;
end;

{ TcvSepFilter2DOperation }

constructor TcvSepFilter2DOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FKernelSize := 5;
  FSigma := 1.0;
end;

procedure TcvSepFilter2DOperation.Assign(Source: TPersistent);
begin
  if Source is TcvSepFilter2DOperation then
  begin
    FKernelSize := TcvSepFilter2DOperation(Source).KernelSize;
    FSigma := TcvSepFilter2DOperation(Source).Sigma;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvSepFilter2DOperation.GetDisplayName: string;
begin
  Result := Format('SepFilter2D (%d, s=%.1f)', [FKernelSize, FSigma]);
end;

procedure TcvSepFilter2DOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp, Kx, Ky: TCVMat;
  KSize: Integer;
begin
  KSize := OddKernelSize(FKernelSize);
  Kx := getGaussianKernel(KSize, FSigma, CV_32F);
  Ky := getGaussianKernel(KSize, FSigma, CV_32F);
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  sepFilter2D(Src.Handle, Temp.Handle, -1, Kx.Handle, Ky.Handle,
    TCVPoint.Create(-1, -1), 0.0, BORDER_DEFAULT);
  Kx.Release;
  Ky.Release;
  Dst := Temp;
end;

procedure TcvSepFilter2DOperation.SetKernelSize(const Value: Integer);
begin
  if FKernelSize <> Value then begin FKernelSize := Value; Changed; end;
end;

procedure TcvSepFilter2DOperation.SetSigma(const Value: Double);
begin
  if FSigma <> Value then begin FSigma := Value; Changed; end;
end;

{ TcvSqrBoxFilterOperation }

constructor TcvSqrBoxFilterOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FKernelSize := 5;
  FNormalize := True;
end;

procedure TcvSqrBoxFilterOperation.Assign(Source: TPersistent);
begin
  if Source is TcvSqrBoxFilterOperation then
  begin
    FKernelSize := TcvSqrBoxFilterOperation(Source).KernelSize;
    FNormalize := TcvSqrBoxFilterOperation(Source).Normalize;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvSqrBoxFilterOperation.GetDisplayName: string;
begin
  Result := Format('SqrBoxFilter (%d)', [FKernelSize]);
end;

procedure TcvSqrBoxFilterOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
  KSize: Integer;
begin
  KSize := OddKernelSize(FKernelSize);
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  sqrBoxFilter(Src.Handle, Temp.Handle, -1, TCVSize.Create(KSize, KSize),
    TCVPoint.Create(-1, -1), FNormalize, BORDER_DEFAULT);
  Dst := Temp;
end;

procedure TcvSqrBoxFilterOperation.SetKernelSize(const Value: Integer);
begin
  if FKernelSize <> Value then begin FKernelSize := Value; Changed; end;
end;

procedure TcvSqrBoxFilterOperation.SetNormalize(const Value: Boolean);
begin
  if FNormalize <> Value then begin FNormalize := Value; Changed; end;
end;

{ TcvSpatialGradientOperation }

constructor TcvSpatialGradientOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  Fksize := 3;
  FOutput := sgDx;
end;

procedure TcvSpatialGradientOperation.Assign(Source: TPersistent);
begin
  if Source is TcvSpatialGradientOperation then
  begin
    Fksize := TcvSpatialGradientOperation(Source).ksize;
    FOutput := TcvSpatialGradientOperation(Source).Output;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvSpatialGradientOperation.GetDisplayName: string;
begin
  Result := Format('SpatialGradient (%s)', [SpatialGradientOutputNames[FOutput]]);
end;

procedure TcvSpatialGradientOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Gray, Dx, Dy, OutMat: TCVMat;
  Row, Col: Integer;
  Dxp, Dyp, Op: PByte;
  DxV, DyV: Integer;
begin
  if Src.channels = 1 then
    Gray := Src
  else
  begin
    Gray := TCVMat.Create_0(0, 0, CV_8UC1);
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
  end;
  Dx := TCVMat.Create_0(0, 0, CV_16SC1);
  Dy := TCVMat.Create_0(0, 0, CV_16SC1);
  spatialGradient(Gray.Handle, Dx.Handle, Dy.Handle, OddKernelSize(Fksize), BORDER_DEFAULT);
  if FOutput = sgDx then
  begin
    OutMat := TCVMat.Create_0(0, 0, CV_8UC1);
    Dx.convertTo(OutMat.Handle, CV_8U, 0.5, 128.0);
  end
  else if FOutput = sgDy then
  begin
    OutMat := TCVMat.Create_0(0, 0, CV_8UC1);
    Dy.convertTo(OutMat.Handle, CV_8U, 0.5, 128.0);
  end
  else
  begin
    OutMat := TCVMat.Create_0(Gray.rows, Gray.cols, CV_8UC1);
    for Row := 0 to Gray.rows - 1 do
      for Col := 0 to Gray.cols - 1 do
      begin
        Dxp := Dx.ptr(Row, Col);
        Dyp := Dy.ptr(Row, Col);
        Op := OutMat.ptr(Row, Col);
        DxV := Abs(PSmallInt(Dxp)^);
        DyV := Abs(PSmallInt(Dyp)^);
        if DxV + DyV > 255 then
          Op^ := 255
        else
          Op^ := DxV + DyV;
      end;
  end;
  if Src.channels <> 1 then
    Gray.Release;
  Dx.Release;
  Dy.Release;
  Dst := OutMat;
end;

procedure TcvSpatialGradientOperation.Setksize(const Value: Integer);
begin
  if Fksize <> Value then begin Fksize := Value; Changed; end;
end;

procedure TcvSpatialGradientOperation.SetOutput(const Value: TcvSpatialGradientOutput);
begin
  if FOutput <> Value then begin FOutput := Value; Changed; end;
end;

{ TcvCornerMinEigenValOperation }

constructor TcvCornerMinEigenValOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FBlockSize := 3;
  Fksize := 3;
end;

procedure TcvCornerMinEigenValOperation.Assign(Source: TPersistent);
begin
  if Source is TcvCornerMinEigenValOperation then
  begin
    FBlockSize := TcvCornerMinEigenValOperation(Source).BlockSize;
    Fksize := TcvCornerMinEigenValOperation(Source).ksize;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvCornerMinEigenValOperation.GetDisplayName: string;
begin
  Result := 'CornerMinEigenVal';
end;

procedure TcvCornerMinEigenValOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Gray, Temp: TCVMat;
  MinVal, MaxVal: Double;
  MinLoc, MaxLoc: TCVPoint;
begin
  if Src.channels = 1 then
    Gray := Src
  else
  begin
    Gray := TCVMat.Create_0(0, 0, CV_8UC1);
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
  end;
  Temp := TCVMat.Create_0(0, 0, CV_32F);
  cornerMinEigenVal(Gray.Handle, Temp.Handle, FBlockSize, OddKernelSize(Fksize), BORDER_DEFAULT);
  minMaxLoc(Temp.Handle, MinVal, MaxVal, MinLoc, MaxLoc, nil);
  if MaxVal > MinVal then
    Temp.convertTo(Temp.Handle, CV_8U, 255.0 / (MaxVal - MinVal), -MinVal * 255.0 / (MaxVal - MinVal))
  else
    Temp.convertTo(Temp.Handle, CV_8U, 1.0, 0.0);
  if Src.channels <> 1 then
    Gray.Release;
  Dst := Temp;
end;

procedure TcvCornerMinEigenValOperation.SetBlockSize(const Value: Integer);
begin
  if FBlockSize <> Value then begin FBlockSize := Value; Changed; end;
end;

procedure TcvCornerMinEigenValOperation.Setksize(const Value: Integer);
begin
  if Fksize <> Value then begin Fksize := Value; Changed; end;
end;

{ TcvIntegralOperation }

constructor TcvIntegralOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FNormalizeView := True;
end;

procedure TcvIntegralOperation.Assign(Source: TPersistent);
begin
  if Source is TcvIntegralOperation then
  begin
    FNormalizeView := TcvIntegralOperation(Source).NormalizeView;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvIntegralOperation.GetDisplayName: string;
begin
  Result := 'Integral';
end;

procedure TcvIntegralOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Gray, Sum, View: TCVMat;
  MinVal, MaxVal: Double;
  MinLoc, MaxLoc: TCVPoint;
begin
  if Src.channels = 1 then
    Gray := Src
  else
  begin
    Gray := TCVMat.Create_0(0, 0, CV_8UC1);
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0);
  end;
  Sum := TCVMat.Create_0(0, 0, CV_32S);
  integral(Gray.Handle, Sum.Handle, CV_32S);
  if FNormalizeView then
  begin
    View := TCVMat.Create_0(0, 0, CV_8UC1);
    minMaxLoc(Sum.Handle, MinVal, MaxVal, MinLoc, MaxLoc, nil);
    if MaxVal > MinVal then
      Sum.convertTo(View.Handle, CV_8U, 255.0 / (MaxVal - MinVal), -MinVal * 255.0 / (MaxVal - MinVal))
    else
      View := View.setZero;
    Sum.Release;
    Dst := View;
  end
  else
    Dst := Sum;
  if Src.channels <> 1 then
    Gray.Release;
end;

procedure TcvIntegralOperation.SetNormalizeView(const Value: Boolean);
begin
  if FNormalizeView <> Value then begin FNormalizeView := Value; Changed; end;
end;

{ TcvAbsDiffOperation }

constructor TcvAbsDiffOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FPrevReady := False;
end;

destructor TcvAbsDiffOperation.Destroy;
begin
  if FPrevReady then
    FPrev.Release;
  inherited Destroy;
end;

procedure TcvAbsDiffOperation.Assign(Source: TPersistent);
begin
  if Source is TcvAbsDiffOperation then
    ResetPrev
  else
    inherited Assign(Source);
end;

function TcvAbsDiffOperation.GetDisplayName: string;
begin
  Result := 'AbsDiff (motion)';
end;

procedure TcvAbsDiffOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  if not FPrevReady then
  begin
    FPrev := Src.clone;
    FPrevReady := True;
    Temp := TCVMat.Create_0(Src.rows, Src.cols, Src.dataType);
    Temp := Temp.setZero;
    Dst := Temp;
    Exit;
  end;
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  absdiff(Src.Handle, FPrev.Handle, Temp.Handle);
  FPrev.Release;
  FPrev := Src.clone;
  Dst := Temp;
end;

procedure TcvAbsDiffOperation.ResetPrev;
begin
  if FPrevReady then
  begin
    FPrev.Release;
    FPrevReady := False;
  end;
end;

{ TcvAutoContrastOperation }

constructor TcvAutoContrastOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FTargetMean := 128.0;
  FTargetStd := 64.0;
end;

procedure TcvAutoContrastOperation.Assign(Source: TPersistent);
begin
  if Source is TcvAutoContrastOperation then
  begin
    FTargetMean := TcvAutoContrastOperation(Source).TargetMean;
    FTargetStd := TcvAutoContrastOperation(Source).TargetStd;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvAutoContrastOperation.GetDisplayName: string;
begin
  Result := Format('AutoContrast (m=%.0f, s=%.0f)', [FTargetMean, FTargetStd]);
end;

procedure TcvAutoContrastOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  MeanVal, StdVal: TCVScalar;
  Alpha, Beta: Double;
  Temp: TCVMat;
begin
  meanStdDev(Src.Handle, MeanVal, StdVal, nil);
  if StdVal.V0 < 0.001 then
    Alpha := 1.0
  else
    Alpha := FTargetStd / StdVal.V0;
  Beta := FTargetMean - MeanVal.V0 * Alpha;
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  Src.convertTo(Temp.Handle, Src.dataType, Alpha, Beta);
  Dst := Temp;
end;

procedure TcvAutoContrastOperation.SetTargetMean(const Value: Double);
begin
  if FTargetMean <> Value then begin FTargetMean := Value; Changed; end;
end;

procedure TcvAutoContrastOperation.SetTargetStd(const Value: Double);
begin
  if FTargetStd <> Value then begin FTargetStd := Value; Changed; end;
end;

{ TcvMergeChannelsOperation }

constructor TcvMergeChannelsOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FChannel1PathLoaded := '';
  FChannel2PathLoaded := '';
end;

procedure TcvMergeChannelsOperation.Assign(Source: TPersistent);
begin
  if Source is TcvMergeChannelsOperation then
  begin
    FChannel1Path := TcvMergeChannelsOperation(Source).Channel1Path;
    FChannel2Path := TcvMergeChannelsOperation(Source).Channel2Path;
    FChannel1PathLoaded := '';
    FChannel2PathLoaded := '';
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvMergeChannelsOperation.EnsureGrayChannel(const Src: TCVMat; const Path: string;
  var Loaded: TCVMat; var PathLoaded: string): TCVMat;
var
  Gray, Temp: TCVMat;
begin
  if Path <> '' then
  begin
    if not SameText(Path, PathLoaded) then
    begin
      if PathLoaded <> '' then
        Loaded.Release;
      Loaded := imread(PAnsiChar(AnsiString(Path)), IMREAD_GRAYSCALE);
      PathLoaded := Path;
    end;
    if Loaded.empty then
      Result := ExtractGrayChannel(Src)
    else if (Loaded.rows = Src.rows) and (Loaded.cols = Src.cols) then
      Result := Loaded.clone
    else
    begin
      Temp := TCVMat.Create_0(0, 0, CV_8UC1);
      resize(Loaded.Handle, Temp.Handle, TCVSize.Create(Src.cols, Src.rows), 0, 0, INTER_LINEAR);
      Result := Temp;
    end;
  end
  else
    Result := ExtractGrayChannel(Src);
end;

function TcvMergeChannelsOperation.GetDisplayName: string;
begin
  Result := 'MergeChannels (BGR)';
end;

procedure TcvMergeChannelsOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Ch0, Ch1, Ch2, Merged: TCVMat;
begin
  Ch0 := ExtractGrayChannel(Src);
  Ch1 := EnsureGrayChannel(Src, FChannel1Path, FChannel1Loaded, FChannel1PathLoaded);
  Ch2 := EnsureGrayChannel(Src, FChannel2Path, FChannel2Loaded, FChannel2PathLoaded);
  Merged := TCVMat.Create_0(Src.rows, Src.cols, CV_8UC3);
  mergeMats([Ch0.Handle, Ch1.Handle, Ch2.Handle], Merged.Handle);
  Ch0.Release;
  Ch1.Release;
  Ch2.Release;
  Dst := Merged;
end;

procedure TcvMergeChannelsOperation.SetChannel1Path(const Value: string);
begin
  if FChannel1Path <> Value then
  begin
    FChannel1Path := Value;
    FChannel1PathLoaded := '';
    Changed;
  end;
end;

procedure TcvMergeChannelsOperation.SetChannel2Path(const Value: string);
begin
  if FChannel2Path <> Value then
  begin
    FChannel2Path := Value;
    FChannel2PathLoaded := '';
    Changed;
  end;
end;

{ TcvInpaintOperation }

constructor TcvInpaintOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FRadius := 3.0;
  FMethod := imNavierStokes;
  FMaskPathLoaded := '';
end;

function TcvInpaintOperation.InpaintFlags: Integer;
begin
  if FMethod = imTelea then
    Result := INPAINT_TELEA
  else
    Result := INPAINT_NS;
end;

procedure TcvInpaintOperation.Assign(Source: TPersistent);
begin
  if Source is TcvInpaintOperation then
  begin
    FMaskPath := TcvInpaintOperation(Source).MaskPath;
    FRadius := TcvInpaintOperation(Source).Radius;
    FMethod := TcvInpaintOperation(Source).Method;
    FMaskPathLoaded := '';
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TcvInpaintOperation.EnsureMask(const Src: TCVMat);
var
  Temp: TCVMat;
begin
  if FMaskPath = '' then
    Exit;
  if SameText(FMaskPath, FMaskPathLoaded) then
    Exit;
  if FMaskPathLoaded <> '' then
    FMask.Release;
  FMask := imread(PAnsiChar(AnsiString(FMaskPath)), IMREAD_GRAYSCALE);
  FMaskPathLoaded := FMaskPath;
  if FMask.empty then
    Exit;
  if (FMask.rows <> Src.rows) or (FMask.cols <> Src.cols) then
  begin
    Temp := TCVMat.Create_0(0, 0, CV_8UC1);
    resize(FMask.Handle, Temp.Handle, TCVSize.Create(Src.cols, Src.rows), 0, 0, INTER_LINEAR);
    FMask.Release;
    FMask := Temp;
  end;
end;

function TcvInpaintOperation.GetDisplayName: string;
begin
  Result := Format('Inpaint (%s)', [InpaintMethodNames[FMethod]]);
end;

procedure TcvInpaintOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  ColorSrc, Temp: TCVMat;
begin
  if FMaskPath = '' then
  begin
    Dst := Src.clone;
    Exit;
  end;
  EnsureMask(Src);
  if FMask.empty then
  begin
    Dst := Src.clone;
    Exit;
  end;
  if Src.channels = 1 then
  begin
    ColorSrc := TCVMat.Create_0(0, 0, CV_8UC3);
    cvtColor(Src.Handle, ColorSrc.Handle, COLOR_GRAY2BGR, 0, 0);
  end
  else
    ColorSrc := Src;
  Temp := TCVMat.Create_0(0, 0, CV_8UC3);
  inpaint(ColorSrc.Handle, FMask.Handle, Temp.Handle, FRadius, InpaintFlags);
  if Src.channels = 1 then
    ColorSrc.Release;
  Dst := Temp;
end;

procedure TcvInpaintOperation.SetMaskPath(const Value: string);
begin
  if FMaskPath <> Value then
  begin
    FMaskPath := Value;
    FMaskPathLoaded := '';
    Changed;
  end;
end;

procedure TcvInpaintOperation.SetMethod(const Value: TcvInpaintMethod);
begin
  if FMethod <> Value then begin FMethod := Value; Changed; end;
end;

procedure TcvInpaintOperation.SetRadius(const Value: Double);
begin
  if FRadius <> Value then begin FRadius := Value; Changed; end;
end;

{ TcvUndistortOperation }

constructor TcvUndistortOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FCameraMatrix := '';
  FDistCoeffs := '';
  FParamsLoaded := '';
  FParamsReady := False;
end;

destructor TcvUndistortOperation.Destroy;
begin
  if FParamsReady then
  begin
    FK.Release;
    FD.Release;
  end;
  inherited Destroy;
end;

procedure TcvUndistortOperation.Assign(Source: TPersistent);
begin
  if Source is TcvUndistortOperation then
  begin
    FCameraMatrix := TcvUndistortOperation(Source).CameraMatrix;
    FDistCoeffs := TcvUndistortOperation(Source).DistCoeffs;
    FParamsLoaded := '';
    if FParamsReady then
    begin
      FK.Release;
      FD.Release;
      FParamsReady := False;
    end;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvUndistortOperation.ParseDoubles(const S: string; out Values: TArray<Double>): Boolean;
var
  Token: string;
  I, P, Start: Integer;
  Ch: Char;
begin
  SetLength(Values, 0);
  Token := '';
  for I := 1 to Length(S) + 1 do
  begin
    if I <= Length(S) then
      Ch := S[I]
    else
      Ch := ',';
    if Ch in [',', ';', ' ', #9] then
    begin
      if Token <> '' then
      begin
        SetLength(Values, Length(Values) + 1);
        Values[High(Values)] := StrToFloatDef(Trim(Token), 0);
        Token := '';
      end;
    end
    else
      Token := Token + Ch;
  end;
  Result := Length(Values) > 0;
end;

procedure TcvUndistortOperation.EnsureParams;
var
  Key: string;
  MatVals, DistVals: TArray<Double>;
  I, J: Integer;
  P: PDouble;
begin
  Key := FCameraMatrix + '|' + FDistCoeffs;
  if FParamsReady and SameText(Key, FParamsLoaded) then
    Exit;
  if FParamsReady then
  begin
    FK.Release;
    FD.Release;
    FParamsReady := False;
  end;
  FK := TCVMat.Create_0(3, 3, CV_64F);
  if (FCameraMatrix = '') or not ParseDoubles(FCameraMatrix, MatVals) or (Length(MatVals) < 9) then
  begin
    P := PDouble(FK.ptr(0, 0)); P^ := 500; Inc(P); P^ := 0; Inc(P); P^ := 320;
    P := PDouble(FK.ptr(1, 0)); P^ := 0; Inc(P); P^ := 500; Inc(P); P^ := 240;
    P := PDouble(FK.ptr(2, 0)); P^ := 0; Inc(P); P^ := 0; Inc(P); P^ := 1;
  end
  else
  begin
    I := 0;
    for J := 0 to 2 do
    begin
      P := PDouble(FK.ptr(J, 0));
      P^ := MatVals[I]; Inc(I); Inc(P);
      P^ := MatVals[I]; Inc(I); Inc(P);
      P^ := MatVals[I]; Inc(I);
    end;
  end;
  if (FDistCoeffs = '') or not ParseDoubles(FDistCoeffs, DistVals) then
  begin
    FD := TCVMat.Create_0(1, 5, CV_64F);
    FD := FD.setZero;
  end
  else
  begin
    FD := TCVMat.Create_0(1, Length(DistVals), CV_64F);
    for I := 0 to High(DistVals) do
      PDouble(FD.ptr(0, I))^ := DistVals[I];
  end;
  FParamsLoaded := Key;
  FParamsReady := True;
end;

function TcvUndistortOperation.GetDisplayName: string;
begin
  Result := 'Undistort';
end;

procedure TcvUndistortOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp, KAdj: TCVMat;
  P: PDouble;
begin
  EnsureParams;
  if (FCameraMatrix = '') and (Src.cols > 0) and (Src.rows > 0) then
  begin
    KAdj := TCVMat.Create_0(3, 3, CV_64F);
    FK.copyTo(KAdj.Handle);
    P := PDouble(KAdj.ptr(0, 2)); P^ := Src.cols * 0.5;
    P := PDouble(KAdj.ptr(1, 2)); P^ := Src.rows * 0.5;
    Temp := TCVMat.Create_0(0, 0, Src.dataType);
    undistort(Src.Handle, Temp.Handle, KAdj.Handle, FD.Handle, nil);
    KAdj.Release;
  end
  else
  begin
    Temp := TCVMat.Create_0(0, 0, Src.dataType);
    undistort(Src.Handle, Temp.Handle, FK.Handle, FD.Handle, nil);
  end;
  Dst := Temp;
end;

procedure TcvUndistortOperation.SetCameraMatrix(const Value: string);
begin
  if FCameraMatrix <> Value then
  begin
    FCameraMatrix := Value;
    FParamsLoaded := '';
    Changed;
  end;
end;

procedure TcvUndistortOperation.SetDistCoeffs(const Value: string);
begin
  if FDistCoeffs <> Value then
  begin
    FDistCoeffs := Value;
    FParamsLoaded := '';
    Changed;
  end;
end;

{ TcvRemapOperation }

constructor TcvRemapOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FMap1PathLoaded := '';
  FMap2PathLoaded := '';
  FMapsReady := False;
end;

destructor TcvRemapOperation.Destroy;
begin
  if FMapsReady then
  begin
    FMap1.Release;
    FMap2.Release;
  end;
  inherited Destroy;
end;

procedure TcvRemapOperation.Assign(Source: TPersistent);
begin
  if Source is TcvRemapOperation then
  begin
    FMap1Path := TcvRemapOperation(Source).Map1Path;
    FMap2Path := TcvRemapOperation(Source).Map2Path;
    FMap1PathLoaded := '';
    FMap2PathLoaded := '';
    if FMapsReady then
    begin
      FMap1.Release;
      FMap2.Release;
      FMapsReady := False;
    end;
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TcvRemapOperation.EnsureMaps;
begin
  if (FMap1Path = '') or (FMap2Path = '') then
    Exit;
  if SameText(FMap1Path, FMap1PathLoaded) and SameText(FMap2Path, FMap2PathLoaded) then
    Exit;
  if FMapsReady then
  begin
    FMap1.Release;
    FMap2.Release;
    FMapsReady := False;
  end;
  FMap1 := imread(PAnsiChar(AnsiString(FMap1Path)), IMREAD_UNCHANGED);
  FMap2 := imread(PAnsiChar(AnsiString(FMap2Path)), IMREAD_UNCHANGED);
  FMap1PathLoaded := FMap1Path;
  FMap2PathLoaded := FMap2Path;
  FMapsReady := not FMap1.empty and not FMap2.empty;
end;

function TcvRemapOperation.GetDisplayName: string;
begin
  Result := 'Remap';
end;

procedure TcvRemapOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  EnsureMaps;
  if not FMapsReady then
  begin
    Dst := Src.clone;
    Exit;
  end;
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  remap(Src.Handle, Temp.Handle, FMap1.Handle, FMap2.Handle, INTER_LINEAR,
    BORDER_CONSTANT, TCVScalar.Create(0), 0);
  Dst := Temp;
end;

procedure TcvRemapOperation.SetMap1Path(const Value: string);
begin
  if FMap1Path <> Value then
  begin
    FMap1Path := Value;
    FMap1PathLoaded := '';
    Changed;
  end;
end;

procedure TcvRemapOperation.SetMap2Path(const Value: string);
begin
  if FMap2Path <> Value then
  begin
    FMap2Path := Value;
    FMap2PathLoaded := '';
    Changed;
  end;
end;

{ TcvCustomLUTOperation }

constructor TcvCustomLUTOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FLUTPathLoaded := '';
  FLUTReady := False;
end;

destructor TcvCustomLUTOperation.Destroy;
begin
  if FLUTReady then
    FLUT.Release;
  inherited Destroy;
end;

procedure TcvCustomLUTOperation.Assign(Source: TPersistent);
begin
  if Source is TcvCustomLUTOperation then
  begin
    FLUTPath := TcvCustomLUTOperation(Source).LUTPath;
    FLUTPathLoaded := '';
    if FLUTReady then
    begin
      FLUT.Release;
      FLUTReady := False;
    end;
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TcvCustomLUTOperation.EnsureLUT;
var
  Loaded: TCVMat;
begin
  if FLUTPath = '' then
    Exit;
  if SameText(FLUTPath, FLUTPathLoaded) then
    Exit;
  if FLUTReady then
    FLUT.Release;
  Loaded := imread(PAnsiChar(AnsiString(FLUTPath)), IMREAD_UNCHANGED);
  if Loaded.empty then
  begin
    FLUTReady := False;
    FLUTPathLoaded := FLUTPath;
    Exit;
  end;
  if (Loaded.rows = 256) and (Loaded.cols = 1) then
    FLUT := Loaded
  else if (Loaded.cols = 256) and (Loaded.rows = 1) then
    FLUT := Loaded
  else
  begin
    FLUT := TCVMat.Create_0(1, 256, CV_8U);
    Loaded.copyTo(FLUT.Handle);
  end;
  FLUTPathLoaded := FLUTPath;
  FLUTReady := not FLUT.empty;
end;

function TcvCustomLUTOperation.GetDisplayName: string;
begin
  Result := 'Custom LUT';
end;

procedure TcvCustomLUTOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp: TCVMat;
begin
  EnsureLUT;
  if not FLUTReady then
  begin
    Dst := Src.clone;
    Exit;
  end;
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  LUT(Src.Handle, FLUT.Handle, Temp.Handle);
  Dst := Temp;
end;

procedure TcvCustomLUTOperation.SetLUTPath(const Value: string);
begin
  if FLUTPath <> Value then
  begin
    FLUTPath := Value;
    FLUTPathLoaded := '';
    Changed;
  end;
end;

{ TcvBlendLinearOperation }

constructor TcvBlendLinearOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FWeight1 := 0.5;
  FWeight2 := 0.5;
  FOperandLoaded := False;
end;

procedure TcvBlendLinearOperation.Assign(Source: TPersistent);
begin
  if Source is TcvBlendLinearOperation then
  begin
    FOperandPath := TcvBlendLinearOperation(Source).OperandPath;
    FWeight1 := TcvBlendLinearOperation(Source).Weight1;
    FWeight2 := TcvBlendLinearOperation(Source).Weight2;
    FOperandPathLoaded := '';
    FOperandLoaded := False;
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TcvBlendLinearOperation.EnsureOperand(const Src: TCVMat; out Src2: TCVMat; out NeedRelease: Boolean);
var
  Temp: TCVMat;
begin
  NeedRelease := False;
  if FOperandPath = '' then
  begin
    Temp := TCVMat.Create_0(Src.rows, Src.cols, Src.dataType);
    Temp := Temp.setZero;
    Src2 := Temp;
    NeedRelease := True;
    Exit;
  end;
  if not SameText(FOperandPath, FOperandPathLoaded) then
  begin
    if FOperandPathLoaded <> '' then
      FOperand.Release;
    FOperand := imread(PAnsiChar(AnsiString(FOperandPath)), IMREAD_COLOR);
    FOperandPathLoaded := FOperandPath;
    FOperandLoaded := not FOperand.empty;
  end;
  if not FOperandLoaded then
  begin
    Temp := TCVMat.Create_0(Src.rows, Src.cols, Src.dataType);
    Temp := Temp.setZero;
    Src2 := Temp;
    NeedRelease := True;
    Exit;
  end;
  if (FOperand.rows = Src.rows) and (FOperand.cols = Src.cols) and
     (FOperand.channels = Src.channels) then
    Src2 := FOperand
  else
  begin
    Temp := TCVMat.Create_0(0, 0, Src.dataType);
    resize(FOperand.Handle, Temp.Handle, TCVSize.Create(Src.cols, Src.rows), 0, 0, INTER_LINEAR);
    Src2 := Temp;
    NeedRelease := True;
  end;
end;

function TcvBlendLinearOperation.GetDisplayName: string;
begin
  Result := Format('BlendLinear (%.2f/%.2f)', [FWeight1, FWeight2]);
end;

procedure TcvBlendLinearOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Temp, Src2, W1, W2: TCVMat;
  NeedRelease: Boolean;
  W1Val, W2Val: TCVScalar;
begin
  EnsureOperand(Src, Src2, NeedRelease);
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  W1Val := TCVScalar.Create(FWeight1);
  W2Val := TCVScalar.Create(FWeight2);
  W1 := TCVMat.Create_2(Src.rows, Src.cols, CV_32FC1, W1Val);
  W2 := TCVMat.Create_2(Src.rows, Src.cols, CV_32FC1, W2Val);
  blendLinear(Src.Handle, Src2.Handle, W1.Handle, W2.Handle, Temp.Handle);
  Dst := Temp;
  if NeedRelease then
    Src2.Release;
end;

procedure TcvBlendLinearOperation.SetOperandPath(const Value: string);
begin
  if FOperandPath <> Value then
  begin
    FOperandPath := Value;
    FOperandPathLoaded := '';
    FOperandLoaded := False;
    Changed;
  end;
end;

procedure TcvBlendLinearOperation.SetWeight1(const Value: Double);
begin
  if FWeight1 <> Value then begin FWeight1 := Value; Changed; end;
end;

procedure TcvBlendLinearOperation.SetWeight2(const Value: Double);
begin
  if FWeight2 <> Value then begin FWeight2 := Value; Changed; end;
end;

{ TcvReferenceDiffOperation }

constructor TcvReferenceDiffOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FReferenceLoaded := False;
  FDrawOverlay := True;
end;

procedure TcvReferenceDiffOperation.Assign(Source: TPersistent);
begin
  if Source is TcvReferenceDiffOperation then
  begin
    FReferencePath := TcvReferenceDiffOperation(Source).ReferencePath;
    FDrawOverlay := TcvReferenceDiffOperation(Source).DrawOverlay;
    if FReferencePathLoaded <> '' then
      FReference.Release;
    FReferencePathLoaded := '';
    FReferenceLoaded := False;
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TcvReferenceDiffOperation.EnsureReference(const Src: TCVMat; out Ref: TCVMat; out NeedRelease: Boolean);
var
  Temp: TCVMat;
begin
  NeedRelease := False;
  if FReferencePath = '' then
  begin
    Temp := TCVMat.Create_0(Src.rows, Src.cols, Src.dataType);
    Temp := Temp.setZero;
    Ref := Temp;
    NeedRelease := True;
    Exit;
  end;
  if not SameText(FReferencePath, FReferencePathLoaded) then
  begin
    if FReferencePathLoaded <> '' then
      FReference.Release;
    FReference := imread(PAnsiChar(AnsiString(FReferencePath)), IMREAD_COLOR);
    FReferencePathLoaded := FReferencePath;
    FReferenceLoaded := not FReference.empty;
  end;
  if not FReferenceLoaded then
  begin
    Temp := TCVMat.Create_0(Src.rows, Src.cols, Src.dataType);
    Temp := Temp.setZero;
    Ref := Temp;
    NeedRelease := True;
    Exit;
  end;
  if (FReference.rows = Src.rows) and (FReference.cols = Src.cols) and
     (FReference.channels = Src.channels) then
    Ref := FReference
  else
  begin
    Temp := TCVMat.Create_0(0, 0, Src.dataType);
    resize(FReference.Handle, Temp.Handle, TCVSize.Create(Src.cols, Src.rows), 0, 0, INTER_LINEAR);
    Ref := Temp;
    NeedRelease := True;
  end;
end;

function TcvReferenceDiffOperation.GetDisplayName: string;
begin
  if FReferencePath <> '' then
    Result := 'ReferenceDiff'
  else
    Result := 'ReferenceDiff (no ref)';
end;

procedure TcvReferenceDiffOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Ref, Diff, GrayDiff, ColorSrc, OutImg, Blended: TCVMat;
  NeedRelease: Boolean;
begin
  EnsureReference(Src, Ref, NeedRelease);
  Diff := TCVMat.Create_0(0, 0, Src.dataType);
  absdiff(Src.Handle, Ref.Handle, Diff.Handle);
  if FDrawOverlay then
  begin
    GrayDiff := TCVMat.Create_0(0, 0, CV_8UC1);
    if Diff.channels > 1 then
      cvtColor(Diff.Handle, GrayDiff.Handle, COLOR_BGR2GRAY, 0, 0)
    else
      Diff.copyTo(GrayDiff.Handle);
    OutImg := TCVMat.Create_0(0, 0, CV_8UC3);
    applyColorMap(GrayDiff.Handle, OutImg.Handle, COLORMAP_JET);
    if Src.channels > 1 then
      ColorSrc := Src.clone
    else
    begin
      ColorSrc := TCVMat.Create_0(0, 0, CV_8UC3);
      cvtColor(Src.Handle, ColorSrc.Handle, COLOR_GRAY2BGR, 0, 0);
    end;
    Blended := TCVMat.Create_0(0, 0, CV_8UC3);
    addWeighted(ColorSrc.Handle, OutImg.Handle, Blended.Handle, 0.6, 0.4, 0.0);
    ColorSrc.Release;
    GrayDiff.Release;
    OutImg.Release;
    Diff.Release;
    Dst := Blended;
  end
  else
    Dst := Diff;
  if NeedRelease then
    Ref.Release;
end;

procedure TcvReferenceDiffOperation.SetDrawOverlay(const Value: Boolean);
begin
  if FDrawOverlay <> Value then begin FDrawOverlay := Value; Changed; end;
end;

procedure TcvReferenceDiffOperation.SetReferencePath(const Value: string);
begin
  if FReferencePath <> Value then
  begin
    FReferencePath := Value;
    if FReferencePathLoaded <> '' then
      FReference.Release;
    FReferencePathLoaded := '';
    FReferenceLoaded := False;
    Changed;
  end;
end;

{ TcvOpticalFlowOperation }

constructor TcvOpticalFlowOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FPrevReady := False;
  FOutput := ofoHSV;
  FPyrScale := 0.5;
  FLevels := 3;
  FWinSize := 15;
  FIterations := 3;
  FPolyN := 5;
  FPolySigma := 1.2;
  FMagScale := 4.0;
  FDrawOverlay := True;
end;

destructor TcvOpticalFlowOperation.Destroy;
begin
  if FPrevReady then
    FPrevGray.Release;
  inherited Destroy;
end;

procedure TcvOpticalFlowOperation.Assign(Source: TPersistent);
begin
  if Source is TcvOpticalFlowOperation then
  begin
    FOutput := TcvOpticalFlowOperation(Source).Output;
    FPyrScale := TcvOpticalFlowOperation(Source).PyrScale;
    FLevels := TcvOpticalFlowOperation(Source).Levels;
    FWinSize := TcvOpticalFlowOperation(Source).WinSize;
    FIterations := TcvOpticalFlowOperation(Source).Iterations;
    FPolyN := TcvOpticalFlowOperation(Source).PolyN;
    FPolySigma := TcvOpticalFlowOperation(Source).PolySigma;
    FMagScale := TcvOpticalFlowOperation(Source).MagScale;
    FDrawOverlay := TcvOpticalFlowOperation(Source).DrawOverlay;
    FOnOpticalFlowResult := TcvOpticalFlowOperation(Source).OnOpticalFlowResult;
    ResetPrev;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvOpticalFlowOperation.FlowToVisualization(const Flow, Src: TCVMat): TCVMat;
var
  I, J, H, W: Integer;
  Fx, Fy, Mag, Angle: Double;
  Hsv, Bgr, Magnitude, Temp: TCVMat;
  HPtr, SPtr, VPtr: PByte;
begin
  H := Flow.rows;
  W := Flow.cols;
  case FOutput of
    ofoMagnitude:
      begin
        Magnitude := TCVMat.Create_2(H, W, CV_8UC1, TCVScalar.Create(0));
        for I := 0 to H - 1 do
          for J := 0 to W - 1 do
          begin
            Fx := PSingle(Flow.ptr(I, J))^;
            Fy := PSingle(PByte(Flow.ptr(I, J)) + SizeOf(Single))^;
            Mag := Sqrt(Fx * Fx + Fy * Fy);
            PByte(Magnitude.ptr(I, J))^ := Byte(Min(255, Trunc(Mag * FMagScale)));
          end;
        Temp := TCVMat.Create_0(0, 0, CV_8UC3);
        cvtColor(Magnitude.Handle, Temp.Handle, COLOR_GRAY2BGR, 0, 0);
        Result := Temp;
      end;
  else
    begin
      Hsv := TCVMat.Create_2(H, W, CV_8UC3, TCVScalar.Create(0));
      for I := 0 to H - 1 do
        for J := 0 to W - 1 do
        begin
          Fx := PSingle(Flow.ptr(I, J))^;
          Fy := PSingle(PByte(Flow.ptr(I, J)) + SizeOf(Single))^;
          Mag := Sqrt(Fx * Fx + Fy * Fy);
          Angle := ArcTan2(Fy, Fx);
          HPtr := PByte(Hsv.ptr(I, J));
          SPtr := PByte(PByte(HPtr) + 1);
          VPtr := PByte(PByte(HPtr) + 2);
          HPtr^ := Byte(Round((Angle + Pi) * 90 / Pi)) mod 180;
          SPtr^ := 255;
          VPtr^ := Byte(Min(255, Trunc(Mag * FMagScale)));
        end;
      Bgr := TCVMat.Create_0(0, 0, CV_8UC3);
      cvtColor(Hsv.Handle, Bgr.Handle, COLOR_HSV2BGR, 0, 0);
      Result := Bgr;
    end;
  end;
end;

function TcvOpticalFlowOperation.GetDisplayName: string;
begin
  Result := 'OpticalFlow (Farneback)';
end;

procedure TcvOpticalFlowOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Gray, Flow, Viz, ColorSrc, OutImg: TCVMat;
  FlowResult: TcvPipelineOpticalFlowResult;
  I, J, H, W: Integer;
  Fx, Fy, Mag, MagSum: Double;
begin
  Gray := TCVMat.Create_0(0, 0, CV_8UC1);
  if Src.channels > 1 then
    cvtColor(Src.Handle, Gray.Handle, COLOR_BGR2GRAY, 0, 0)
  else
    Src.copyTo(Gray.Handle);
  FlowResult.HasPrevious := FPrevReady;
  FlowResult.MeanMagnitude := 0;
  if not FPrevReady then
  begin
    FPrevGray := Gray.clone;
    FPrevReady := True;
    Dst := Src.clone;
    if Assigned(FOnOpticalFlowResult) then
      FOnOpticalFlowResult(Self, Src, FlowResult);
    Exit;
  end;
  Flow := TCVMat.Create_0(Gray.rows, Gray.cols, CV_32FC2);
  calcOpticalFlowFarneback(FPrevGray.Handle, Gray.Handle, Flow.Handle,
    FPyrScale, FLevels, FWinSize, FIterations, FPolyN, FPolySigma, 0);
  H := Flow.rows;
  W := Flow.cols;
  MagSum := 0;
  for I := 0 to H - 1 do
    for J := 0 to W - 1 do
    begin
      Fx := PSingle(Flow.ptr(I, J))^;
      Fy := PSingle(PByte(Flow.ptr(I, J)) + SizeOf(Single))^;
      MagSum := MagSum + Sqrt(Fx * Fx + Fy * Fy);
    end;
  FlowResult.MeanMagnitude := MagSum / (H * W);
  FlowResult.HasPrevious := True;
  if Assigned(FOnOpticalFlowResult) then
    FOnOpticalFlowResult(Self, Src, FlowResult);
  Viz := FlowToVisualization(Flow, Src);
  if (FOutput = ofoSourceOverlay) or (FDrawOverlay and (FOutput <> ofoMagnitude)) then
  begin
    if Src.channels > 1 then
      ColorSrc := Src.clone
    else
    begin
      ColorSrc := TCVMat.Create_0(0, 0, CV_8UC3);
      cvtColor(Src.Handle, ColorSrc.Handle, COLOR_GRAY2BGR, 0, 0);
    end;
    OutImg := TCVMat.Create_0(0, 0, CV_8UC3);
    addWeighted(ColorSrc.Handle, Viz.Handle, OutImg.Handle, 0.5, 0.5, 0.0);
    ColorSrc.Release;
    Viz.Release;
    Dst := OutImg;
  end
  else
    Dst := Viz;
  FPrevGray.Release;
  FPrevGray := Gray.clone;
end;

procedure TcvOpticalFlowOperation.ResetPrev;
begin
  if FPrevReady then
  begin
    FPrevGray.Release;
    FPrevReady := False;
  end;
end;

procedure TcvOpticalFlowOperation.SetDrawOverlay(const Value: Boolean);
begin
  if FDrawOverlay <> Value then begin FDrawOverlay := Value; Changed; end;
end;

procedure TcvOpticalFlowOperation.SetIterations(const Value: Integer);
begin
  if FIterations <> Value then begin FIterations := Value; Changed; end;
end;

procedure TcvOpticalFlowOperation.SetLevels(const Value: Integer);
begin
  if FLevels <> Value then begin FLevels := Value; Changed; end;
end;

procedure TcvOpticalFlowOperation.SetMagScale(const Value: Double);
begin
  if FMagScale <> Value then begin FMagScale := Value; Changed; end;
end;

procedure TcvOpticalFlowOperation.SetOnOpticalFlowResult(const Value: TcvPipelineOpticalFlowEvent);
begin
  FOnOpticalFlowResult := Value;
end;

procedure TcvOpticalFlowOperation.SetOutput(const Value: TcvOpticalFlowOutput);
begin
  if FOutput <> Value then begin FOutput := Value; Changed; end;
end;

procedure TcvOpticalFlowOperation.SetPolyN(const Value: Integer);
begin
  if FPolyN <> Value then begin FPolyN := Value; Changed; end;
end;

procedure TcvOpticalFlowOperation.SetPolySigma(const Value: Double);
begin
  if FPolySigma <> Value then begin FPolySigma := Value; Changed; end;
end;

procedure TcvOpticalFlowOperation.SetPyrScale(const Value: Double);
begin
  if FPyrScale <> Value then begin FPyrScale := Value; Changed; end;
end;

procedure TcvOpticalFlowOperation.SetWinSize(const Value: Integer);
begin
  if FWinSize <> Value then begin FWinSize := Value; Changed; end;
end;

{ TcvRunningAvgOperation }

constructor TcvRunningAvgOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FAccumReady := False;
  FFrameCount := 0;
end;

destructor TcvRunningAvgOperation.Destroy;
begin
  ResetAccum;
  inherited Destroy;
end;

procedure TcvRunningAvgOperation.Assign(Source: TPersistent);
begin
  if Source is TcvRunningAvgOperation then
  begin
    ResetAccum;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvRunningAvgOperation.GetDisplayName: string;
begin
  Result := Format('RunningAvg (%d)', [FFrameCount]);
end;

procedure TcvRunningAvgOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  SrcF, MeanF, Temp: TCVMat;
  AccumType: Integer;
begin
  AccumType := CV_32F + ((Src.channels - 1) shl 3);
  if not FAccumReady or (FAccum.rows <> Src.rows) or (FAccum.cols <> Src.cols) or
     (FAccum.dataType <> AccumType) then
    ResetAccum;
  SrcF := TCVMat.Create_0(0, 0, AccumType);
  Src.convertTo(SrcF.Handle, AccumType, 1.0, 0.0);
  if not FAccumReady then
  begin
    FAccum := SrcF.clone;
    FAccumReady := True;
    FFrameCount := 1;
    Dst := Src.clone;
    Exit;
  end;
  accumulate(SrcF.Handle, FAccum.Handle, nil);
  Inc(FFrameCount);
  MeanF := TCVMat.Create_0(0, 0, AccumType);
  FAccum.copyTo(MeanF.Handle);
  Temp := TCVMat.Create_0(0, 0, Src.dataType);
  MeanF.convertTo(Temp.Handle, Src.dataType, 1.0 / FFrameCount, 0.0);
  Dst := Temp;
end;

procedure TcvRunningAvgOperation.ResetAccum;
begin
  if FAccumReady then
  begin
    FAccum.Release;
    FAccumReady := False;
  end;
  FFrameCount := 0;
end;

{ TcvGrabCutOperation }

constructor TcvGrabCutOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FRectX := 10;
  FRectY := 10;
  FRectWidth := 200;
  FRectHeight := 200;
  FIterCount := 3;
  FOutput := gcoOverlay;
  FDrawOverlay := True;
end;

procedure TcvGrabCutOperation.Assign(Source: TPersistent);
begin
  if Source is TcvGrabCutOperation then
  begin
    FRectX := TcvGrabCutOperation(Source).RectX;
    FRectY := TcvGrabCutOperation(Source).RectY;
    FRectWidth := TcvGrabCutOperation(Source).RectWidth;
    FRectHeight := TcvGrabCutOperation(Source).RectHeight;
    FIterCount := TcvGrabCutOperation(Source).IterCount;
    FOutput := TcvGrabCutOperation(Source).Output;
    FDrawOverlay := TcvGrabCutOperation(Source).DrawOverlay;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvGrabCutOperation.EffectiveRect(const Src: TCVMat): TCVRect;
var
  X, Y, W, H: Integer;
begin
  X := FRectX;
  Y := FRectY;
  W := FRectWidth;
  H := FRectHeight;
  if X < 0 then X := 0;
  if Y < 0 then Y := 0;
  if W < 1 then W := 1;
  if H < 1 then H := 1;
  if X + W > Src.cols then W := Src.cols - X;
  if Y + H > Src.rows then H := Src.rows - Y;
  Result := TCVRect.Create(X, Y, W, H);
end;

function TcvGrabCutOperation.EnsureColorImage(const Src: TCVMat): TCVMat;
begin
  if Src.channels > 1 then
    Result := Src.clone
  else
  begin
    Result := TCVMat.Create_0(0, 0, CV_8UC3);
    cvtColor(Src.Handle, Result.Handle, COLOR_GRAY2BGR, 0, 0);
  end;
end;

function TcvGrabCutOperation.GetDisplayName: string;
begin
  Result := Format('GrabCut (%dx%d)', [FRectWidth, FRectHeight]);
end;

procedure TcvGrabCutOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Work, Mask, BgdModel, FgdModel, FgMask, OutImg: TCVMat;
  Rect: TCVRect;
  I, J: Integer;
  Mv: Byte;
begin
  Work := EnsureColorImage(Src);
  Mask := TCVMat.Create_2(Work.rows, Work.cols, CV_8UC1, TCVScalar.Create(0));
  BgdModel := TCVMat.Create_2(1, 65, CV_64FC1, TCVScalar.Create(0));
  FgdModel := TCVMat.Create_2(1, 65, CV_64FC1, TCVScalar.Create(0));
  Rect := EffectiveRect(Work);
  grabCut(Work.Handle, Mask.Handle, Rect, BgdModel.Handle, FgdModel.Handle,
    FIterCount, GC_INIT_WITH_RECT);
  FgMask := TCVMat.Create_2(Work.rows, Work.cols, CV_8UC1, TCVScalar.Create(0));
  for I := 0 to Work.rows - 1 do
    for J := 0 to Work.cols - 1 do
    begin
      Mv := PByte(Mask.ptr(I, J))^;
      if (Mv = GC_FGD) or (Mv = GC_PR_FGD) then
        PByte(FgMask.ptr(I, J))^ := 255;
    end;
  case FOutput of
    gcoMask:
      Dst := FgMask.clone;
    gcoForeground:
      begin
        OutImg := TCVMat.Create_0(0, 0, CV_8UC3);
        Work.copyTo(OutImg.Handle);
        bitwise_and(OutImg.Handle, OutImg.Handle, OutImg.Handle, FgMask.Handle);
        Dst := OutImg;
      end;
  else
    begin
      OutImg := Work.clone;
      if FDrawOverlay then
        rectangle(OutImg.Handle, Rect, TCVScalar.Create(0, 255, 255), 2, LINE_8, 0);
      Dst := OutImg;
    end;
  end;
  Work.Release;
  BgdModel.Release;
  FgdModel.Release;
  Mask.Release;
  FgMask.Release;
end;

procedure TcvGrabCutOperation.SetDrawOverlay(const Value: Boolean);
begin
  if FDrawOverlay <> Value then begin FDrawOverlay := Value; Changed; end;
end;

procedure TcvGrabCutOperation.SetIterCount(const Value: Integer);
begin
  if FIterCount <> Value then begin FIterCount := Value; Changed; end;
end;

procedure TcvGrabCutOperation.SetOutput(const Value: TcvGrabCutOutput);
begin
  if FOutput <> Value then begin FOutput := Value; Changed; end;
end;

procedure TcvGrabCutOperation.SetRectHeight(const Value: Integer);
begin
  if FRectHeight <> Value then begin FRectHeight := Value; Changed; end;
end;

procedure TcvGrabCutOperation.SetRectWidth(const Value: Integer);
begin
  if FRectWidth <> Value then begin FRectWidth := Value; Changed; end;
end;

procedure TcvGrabCutOperation.SetRectX(const Value: Integer);
begin
  if FRectX <> Value then begin FRectX := Value; Changed; end;
end;

procedure TcvGrabCutOperation.SetRectY(const Value: Integer);
begin
  if FRectY <> Value then begin FRectY := Value; Changed; end;
end;

{ TcvWatershedOperation }

constructor TcvWatershedOperation.Create(AOwner: TcvPipelineStage);
begin
  inherited Create(AOwner);
  FFgRectX := 50;
  FFgRectY := 50;
  FFgRectWidth := 100;
  FFgRectHeight := 100;
  FOutput := wsoBoundaries;
  FDrawOverlay := True;
end;

procedure TcvWatershedOperation.Assign(Source: TPersistent);
begin
  if Source is TcvWatershedOperation then
  begin
    FFgRectX := TcvWatershedOperation(Source).FgRectX;
    FFgRectY := TcvWatershedOperation(Source).FgRectY;
    FFgRectWidth := TcvWatershedOperation(Source).FgRectWidth;
    FFgRectHeight := TcvWatershedOperation(Source).FgRectHeight;
    FOutput := TcvWatershedOperation(Source).Output;
    FDrawOverlay := TcvWatershedOperation(Source).DrawOverlay;
    Changed;
  end
  else
    inherited Assign(Source);
end;

function TcvWatershedOperation.EffectiveFgRect(const Src: TCVMat): TCVRect;
var
  X, Y, W, H: Integer;
begin
  X := FFgRectX;
  Y := FFgRectY;
  W := FFgRectWidth;
  H := FFgRectHeight;
  if X < 0 then X := 0;
  if Y < 0 then Y := 0;
  if W < 1 then W := 1;
  if H < 1 then H := 1;
  if X + W > Src.cols then W := Src.cols - X;
  if Y + H > Src.rows then H := Src.rows - Y;
  Result := TCVRect.Create(X, Y, W, H);
end;

function TcvWatershedOperation.EnsureColorImage(const Src: TCVMat): TCVMat;
begin
  if Src.channels > 1 then
    Result := Src.clone
  else
  begin
    Result := TCVMat.Create_0(0, 0, CV_8UC3);
    cvtColor(Src.Handle, Result.Handle, COLOR_GRAY2BGR, 0, 0);
  end;
end;

function TcvWatershedOperation.GetDisplayName: string;
begin
  Result := 'Watershed';
end;

procedure TcvWatershedOperation.Process(const Src: TCVMat; var Dst: TCVMat);
var
  Work3, Markers, Marker8, OutImg: TCVMat;
  FgRect, BorderRect: TCVRect;
  I, J: Integer;
  L: Integer;
  Sp: PByte;
begin
  Work3 := EnsureColorImage(Src);
  Markers := TCVMat.Create_2(Work3.rows, Work3.cols, CV_32SC1, TCVScalar.Create(0));
  BorderRect := TCVRect.Create(0, 0, Work3.cols, Work3.rows);
  rectangle(Markers.Handle, BorderRect, TCVScalar.Create(1), 1, LINE_8, 0);
  FgRect := EffectiveFgRect(Work3);
  rectangle(Markers.Handle, FgRect, TCVScalar.Create(2), FILLED, LINE_8, 0);
  watershed(Work3.Handle, Markers.Handle);
  case FOutput of
    wsoMarkers:
      begin
        Marker8 := TCVMat.Create_0(0, 0, CV_8UC1);
        Markers.convertTo(Marker8.Handle, CV_8U, 1.0, 128.0);
        OutImg := TCVMat.Create_0(0, 0, CV_8UC3);
        applyColorMap(Marker8.Handle, OutImg.Handle, COLORMAP_JET);
        Marker8.Release;
        Dst := OutImg;
      end;
  else
    begin
      if FDrawOverlay then
        OutImg := EnsureColorImage(Src)
      else
        OutImg := TCVMat.Create_2(Work3.rows, Work3.cols, CV_8UC3, TCVScalar.Create(0));
      for I := 0 to Markers.rows - 1 do
        for J := 0 to Markers.cols - 1 do
        begin
          L := PInteger(Markers.ptr(I, J))^;
          if L = -1 then
          begin
            Sp := PByte(OutImg.ptr(I, J));
            Sp^ := 0;
            PByte(Sp + 1)^ := 0;
            PByte(Sp + 2)^ := 255;
          end;
        end;
      Dst := OutImg;
    end;
  end;
  Work3.Release;
  Markers.Release;
end;

procedure TcvWatershedOperation.SetDrawOverlay(const Value: Boolean);
begin
  if FDrawOverlay <> Value then begin FDrawOverlay := Value; Changed; end;
end;

procedure TcvWatershedOperation.SetFgRectHeight(const Value: Integer);
begin
  if FFgRectHeight <> Value then begin FFgRectHeight := Value; Changed; end;
end;

procedure TcvWatershedOperation.SetFgRectWidth(const Value: Integer);
begin
  if FFgRectWidth <> Value then begin FFgRectWidth := Value; Changed; end;
end;

procedure TcvWatershedOperation.SetFgRectX(const Value: Integer);
begin
  if FFgRectX <> Value then begin FFgRectX := Value; Changed; end;
end;

procedure TcvWatershedOperation.SetFgRectY(const Value: Integer);
begin
  if FFgRectY <> Value then begin FFgRectY := Value; Changed; end;
end;

procedure TcvWatershedOperation.SetOutput(const Value: TcvWatershedOutput);
begin
  if FOutput <> Value then begin FOutput := Value; Changed; end;
end;

initialization
  RegisterClass(TcvPyrUpOperation);
  RegisterClass(TcvLaplacianOperation);
  RegisterClass(TcvScharrOperation);
  RegisterClass(TcvDenoiseOperation);
  RegisterClass(TcvDistanceTransformOperation);
  RegisterClass(TcvCropOperation);
  RegisterClass(TcvNormalizeOperation);
  RegisterClass(TcvSharpenOperation);
  RegisterClass(TcvBitwiseOperation);
  RegisterClass(TcvRotateOperation);
  RegisterClass(TcvWarpPolarOperation);
  RegisterClass(TcvFilter2DOperation);
  RegisterClass(TcvCornerHarrisOperation);
  RegisterClass(TcvTemporalBlendOperation);
  RegisterClass(TcvMatchTemplateOperation);
  RegisterClass(TcvContoursOperation);
  RegisterClass(TcvChannelExtractOperation);
  RegisterClass(TcvFlipOperation);
  RegisterClass(TcvOrthoRotateOperation);
  RegisterClass(TcvGammaOperation);
  RegisterClass(TcvAddWeightedOperation);
  RegisterClass(TcvPyrMeanShiftOperation);
  RegisterClass(TcvSepFilter2DOperation);
  RegisterClass(TcvSqrBoxFilterOperation);
  RegisterClass(TcvSpatialGradientOperation);
  RegisterClass(TcvCornerMinEigenValOperation);
  RegisterClass(TcvIntegralOperation);
  RegisterClass(TcvAbsDiffOperation);
  RegisterClass(TcvAutoContrastOperation);
  RegisterClass(TcvMergeChannelsOperation);
  RegisterClass(TcvInpaintOperation);
  RegisterClass(TcvUndistortOperation);
  RegisterClass(TcvRemapOperation);
  RegisterClass(TcvCustomLUTOperation);
  RegisterClass(TcvHoughLinesPOperation);
  RegisterClass(TcvHoughCirclesOperation);
  RegisterClass(TcvConnectedComponentsOperation);
  RegisterClass(TcvBackgroundSubtractOperation);
  RegisterClass(TcvDebugTextOperation);
  RegisterClass(TcvPhaseCorrelateOperation);
  RegisterClass(TcvBlendLinearOperation);
  RegisterClass(TcvReferenceDiffOperation);
  RegisterClass(TcvOpticalFlowOperation);
  RegisterClass(TcvRunningAvgOperation);
  RegisterClass(TcvGrabCutOperation);
  RegisterClass(TcvWatershedOperation);

end.
