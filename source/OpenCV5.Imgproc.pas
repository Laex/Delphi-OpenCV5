unit OpenCV5.Imgproc;

interface

uses
  OpenCV5.Core;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

  MORPH_ERODE = 0;
  MORPH_DILATE = 1;
  MORPH_OPEN = 2;
  MORPH_CLOSE = 3;
  MORPH_GRADIENT = 4;
  MORPH_TOPHAT = 5;
  MORPH_BLACKHAT = 6;
  MORPH_HITMISS = 7;
  MORPH_RECT = 0;
  MORPH_CROSS = 1;
  MORPH_ELLIPSE = 2;
  MORPH_DIAMOND = 3;
  INTER_NEAREST = 0;
  INTER_LINEAR = 1;
  INTER_CUBIC = 2;
  INTER_AREA = 3;
  INTER_LANCZOS4 = 4;
  INTER_LINEAR_EXACT = 5;
  INTER_NEAREST_EXACT = 6;
  INTER_MAX = 7;
  WARP_FILL_OUTLIERS = 8;
  WARP_INVERSE_MAP = 16;
  WARP_RELATIVE_MAP = 32;
  WARP_POLAR_LINEAR = 0;
  WARP_POLAR_LOG = 256;
  DIST_MASK_3 = 3;
  DIST_MASK_5 = 5;
  DIST_MASK_PRECISE = 0;
  THRESH_BINARY = 0;
  THRESH_BINARY_INV = 1;
  THRESH_TRUNC = 2;
  THRESH_TOZERO = 3;
  THRESH_TOZERO_INV = 4;
  THRESH_MASK = 7;
  THRESH_OTSU = 8;
  THRESH_TRIANGLE = 16;
  THRESH_DRYRUN = 128;
  ADAPTIVE_THRESH_MEAN_C = 0;
  ADAPTIVE_THRESH_GAUSSIAN_C = 1;
  GC_BGD = 0;
  GC_FGD = 1;
  GC_PR_BGD = 2;
  GC_PR_FGD = 3;
  GC_INIT_WITH_RECT = 0;
  GC_INIT_WITH_MASK = 1;
  GC_EVAL = 2;
  GC_EVAL_FREEZE_MODEL = 3;
  DIST_LABEL_CCOMP = 0;
  DIST_LABEL_PIXEL = 1;
  CC_STAT_LEFT = 0;
  CC_STAT_TOP = 1;
  CC_STAT_WIDTH = 2;
  CC_STAT_HEIGHT = 3;
  CC_STAT_AREA = 4;
  CCL_DEFAULT = -1;
  CCL_WU = 0;
  CCL_GRANA = 1;
  CCL_BOLELLI = 2;
  CCL_SAUF = 3;
  CCL_BBDT = 4;
  CCL_SPAGHETTI = 5;
  RETR_EXTERNAL = 0;
  RETR_LIST = 1;
  RETR_CCOMP = 2;
  RETR_TREE = 3;
  RETR_FLOODFILL = 4;
  CHAIN_CODE = 0;
  CHAIN_APPROX_NONE = 1;
  CHAIN_APPROX_SIMPLE = 2;
  CHAIN_APPROX_TC89_L1 = 3;
  CHAIN_APPROX_TC89_KCOS = 4;
  LINK_RUNS = 5;
  CONTOURS_MATCH_I1 = 1;
  CONTOURS_MATCH_I2 = 2;
  CONTOURS_MATCH_I3 = 3;
  HOUGH_STANDARD = 0;
  HOUGH_PROBABILISTIC = 1;
  HOUGH_MULTI_SCALE = 2;
  HOUGH_GRADIENT = 3;
  HOUGH_GRADIENT_ALT = 4;
  HISTCMP_CORREL = 0;
  HISTCMP_CHISQR = 1;
  HISTCMP_INTERSECT = 2;
  HISTCMP_BHATTACHARYYA = 3;
  HISTCMP_CHISQR_ALT = 4;
  HISTCMP_KL_DIV = 5;
  LSD_REFINE_NONE = 0;
  LSD_REFINE_STD = 1;
  LSD_REFINE_ADV = 2;
  COLOR_BGR2BGRA = 0;
  COLOR_BGRA2BGR = 1;
  COLOR_BGR2RGBA = 2;
  COLOR_RGBA2BGR = 3;
  COLOR_BGR2RGB = 4;
  COLOR_BGRA2RGBA = 5;
  COLOR_BGR2GRAY = 6;
  COLOR_RGB2GRAY = 7;
  COLOR_GRAY2BGR = 8;
  COLOR_GRAY2BGRA = 9;
  COLOR_BGRA2GRAY = 10;
  COLOR_RGBA2GRAY = 11;
  COLOR_BGR2BGR565 = 12;
  COLOR_RGB2BGR565 = 13;
  COLOR_BGR5652BGR = 14;
  COLOR_BGR5652RGB = 15;
  COLOR_BGRA2BGR565 = 16;
  COLOR_RGBA2BGR565 = 17;
  COLOR_BGR5652BGRA = 18;
  COLOR_BGR5652RGBA = 19;
  COLOR_GRAY2BGR565 = 20;
  COLOR_BGR5652GRAY = 21;
  COLOR_BGR2BGR555 = 22;
  COLOR_RGB2BGR555 = 23;
  COLOR_BGR5552BGR = 24;
  COLOR_BGR5552RGB = 25;
  COLOR_BGRA2BGR555 = 26;
  COLOR_RGBA2BGR555 = 27;
  COLOR_BGR5552BGRA = 28;
  COLOR_BGR5552RGBA = 29;
  COLOR_GRAY2BGR555 = 30;
  COLOR_BGR5552GRAY = 31;
  COLOR_BGR2XYZ = 32;
  COLOR_RGB2XYZ = 33;
  COLOR_XYZ2BGR = 34;
  COLOR_XYZ2RGB = 35;
  COLOR_BGR2YCrCb = 36;
  COLOR_RGB2YCrCb = 37;
  COLOR_YCrCb2BGR = 38;
  COLOR_YCrCb2RGB = 39;
  COLOR_BGR2HSV = 40;
  COLOR_RGB2HSV = 41;
  COLOR_BGR2Lab = 44;
  COLOR_RGB2Lab = 45;
  COLOR_BGR2Luv = 50;
  COLOR_RGB2Luv = 51;
  COLOR_BGR2HLS = 52;
  COLOR_RGB2HLS = 53;
  COLOR_HSV2BGR = 54;
  COLOR_HSV2RGB = 55;
  COLOR_Lab2BGR = 56;
  COLOR_Lab2RGB = 57;
  COLOR_Luv2BGR = 58;
  COLOR_Luv2RGB = 59;
  COLOR_HLS2BGR = 60;
  COLOR_HLS2RGB = 61;
  COLOR_BGR2HSV_FULL = 66;
  COLOR_RGB2HSV_FULL = 67;
  COLOR_BGR2HLS_FULL = 68;
  COLOR_RGB2HLS_FULL = 69;
  COLOR_HSV2BGR_FULL = 70;
  COLOR_HSV2RGB_FULL = 71;
  COLOR_HLS2BGR_FULL = 72;
  COLOR_HLS2RGB_FULL = 73;
  COLOR_LBGR2Lab = 74;
  COLOR_LRGB2Lab = 75;
  COLOR_LBGR2Luv = 76;
  COLOR_LRGB2Luv = 77;
  COLOR_Lab2LBGR = 78;
  COLOR_Lab2LRGB = 79;
  COLOR_Luv2LBGR = 80;
  COLOR_Luv2LRGB = 81;
  COLOR_BGR2YUV = 82;
  COLOR_RGB2YUV = 83;
  COLOR_YUV2BGR = 84;
  COLOR_YUV2RGB = 85;
  COLOR_YUV2RGB_NV12 = 90;
  COLOR_YUV2BGR_NV12 = 91;
  COLOR_YUV2RGB_NV21 = 92;
  COLOR_YUV2BGR_NV21 = 93;
  COLOR_YUV2RGBA_NV12 = 94;
  COLOR_YUV2BGRA_NV12 = 95;
  COLOR_YUV2RGBA_NV21 = 96;
  COLOR_YUV2BGRA_NV21 = 97;
  COLOR_YUV2RGB_YV12 = 98;
  COLOR_YUV2BGR_YV12 = 99;
  COLOR_YUV2RGB_IYUV = 100;
  COLOR_YUV2BGR_IYUV = 101;
  COLOR_YUV2RGBA_YV12 = 102;
  COLOR_YUV2BGRA_YV12 = 103;
  COLOR_YUV2RGBA_IYUV = 104;
  COLOR_YUV2BGRA_IYUV = 105;
  COLOR_YUV2GRAY_420 = 106;
  COLOR_YUV2RGB_UYVY = 107;
  COLOR_YUV2BGR_UYVY = 108;
  COLOR_YUV2RGBA_UYVY = 111;
  COLOR_YUV2BGRA_UYVY = 112;
  COLOR_YUV2RGB_YUY2 = 115;
  COLOR_YUV2BGR_YUY2 = 116;
  COLOR_YUV2RGB_YVYU = 117;
  COLOR_YUV2BGR_YVYU = 118;
  COLOR_YUV2RGBA_YUY2 = 119;
  COLOR_YUV2BGRA_YUY2 = 120;
  COLOR_YUV2RGBA_YVYU = 121;
  COLOR_YUV2BGRA_YVYU = 122;
  COLOR_YUV2GRAY_UYVY = 123;
  COLOR_YUV2GRAY_YUY2 = 124;
  COLOR_RGBA2mRGBA = 125;
  COLOR_mRGBA2RGBA = 126;
  COLOR_RGB2YUV_I420 = 127;
  COLOR_BGR2YUV_I420 = 128;
  COLOR_RGBA2YUV_I420 = 129;
  COLOR_BGRA2YUV_I420 = 130;
  COLOR_RGB2YUV_YV12 = 131;
  COLOR_BGR2YUV_YV12 = 132;
  COLOR_RGBA2YUV_YV12 = 133;
  COLOR_BGRA2YUV_YV12 = 134;
  COLOR_BayerBG2BGR = 46;
  COLOR_BayerGB2BGR = 47;
  COLOR_BayerRG2BGR = 48;
  COLOR_BayerGR2BGR = 49;
  COLOR_BayerBG2GRAY = 86;
  COLOR_BayerGB2GRAY = 87;
  COLOR_BayerRG2GRAY = 88;
  COLOR_BayerGR2GRAY = 89;
  COLOR_BayerBG2BGR_VNG = 62;
  COLOR_BayerGB2BGR_VNG = 63;
  COLOR_BayerRG2BGR_VNG = 64;
  COLOR_BayerGR2BGR_VNG = 65;
  COLOR_BayerBG2BGR_EA = 135;
  COLOR_BayerGB2BGR_EA = 136;
  COLOR_BayerRG2BGR_EA = 137;
  COLOR_BayerGR2BGR_EA = 138;
  COLOR_BayerBG2BGRA = 139;
  COLOR_BayerGB2BGRA = 140;
  COLOR_BayerRG2BGRA = 141;
  COLOR_BayerGR2BGRA = 142;
  COLOR_RGB2YUV_UYVY = 143;
  COLOR_BGR2YUV_UYVY = 144;
  COLOR_RGBA2YUV_UYVY = 145;
  COLOR_BGRA2YUV_UYVY = 146;
  COLOR_RGB2YUV_YUY2 = 147;
  COLOR_BGR2YUV_YUY2 = 148;
  COLOR_RGB2YUV_YVYU = 149;
  COLOR_BGR2YUV_YVYU = 150;
  COLOR_RGBA2YUV_YUY2 = 151;
  COLOR_BGRA2YUV_YUY2 = 152;
  COLOR_RGBA2YUV_YVYU = 153;
  COLOR_BGRA2YUV_YVYU = 154;
  COLOR_COLORCVT_MAX = 155;
  FILLED = -1;
  LINE_4 = 4;
  LINE_8 = 8;
  LINE_AA = 16;
  FONT_HERSHEY_SIMPLEX = 0;
  FONT_HERSHEY_PLAIN = 1;
  FONT_HERSHEY_DUPLEX = 2;
  FONT_HERSHEY_COMPLEX = 3;
  FONT_HERSHEY_TRIPLEX = 4;
  FONT_HERSHEY_COMPLEX_SMALL = 5;
  FONT_HERSHEY_SCRIPT_SIMPLEX = 6;
  FONT_HERSHEY_SCRIPT_COMPLEX = 7;
  FONT_ITALIC = 16;
  MARKER_CROSS = 0;
  MARKER_TILTED_CROSS = 1;
  MARKER_STAR = 2;
  MARKER_DIAMOND = 3;
  MARKER_SQUARE = 4;
  MARKER_TRIANGLE_UP = 5;
  MARKER_TRIANGLE_DOWN = 6;
  PROJ_SPHERICAL_ORTHO = 0;
  PROJ_SPHERICAL_EQRECT = 1;
  TM_SQDIFF = 0;
  TM_SQDIFF_NORMED = 1;
  TM_CCORR = 2;
  TM_CCORR_NORMED = 3;
  TM_CCOEFF = 4;
  TM_CCOEFF_NORMED = 5;
  FLIP_VERTICAL = 0;
  FLIP_HORIZONTAL = 1;
  FLIP_BOTH = -1;
  ROTATE_90_CLOCKWISE = 0;
  ROTATE_180 = 1;
  ROTATE_90_COUNTERCLOCKWISE = 2;
  COLORMAP_AUTUMN = 0;
  COLORMAP_BONE = 1;
  COLORMAP_JET = 2;
  COLORMAP_WINTER = 3;
  COLORMAP_RAINBOW = 4;
  COLORMAP_OCEAN = 5;
  COLORMAP_SUMMER = 6;
  COLORMAP_SPRING = 7;
  COLORMAP_COOL = 8;
  COLORMAP_HSV = 9;
  COLORMAP_PINK = 10;
  COLORMAP_HOT = 11;
  COLORMAP_PARULA = 12;
  COLORMAP_MAGMA = 13;
  COLORMAP_INFERNO = 14;
  COLORMAP_PLASMA = 15;
  COLORMAP_VIRIDIS = 16;
  COLORMAP_CIVIDIS = 17;
  COLORMAP_TWILIGHT = 18;
  COLORMAP_TWILIGHT_SHIFTED = 19;
  COLORMAP_TURBO = 20;
  COLORMAP_DEEPGREEN = 21;
  PUT_TEXT_ALIGN_LEFT = 0;
  PUT_TEXT_ALIGN_CENTER = 1;
  PUT_TEXT_ALIGN_RIGHT = 2;
  PUT_TEXT_ALIGN_MASK = 3;
  PUT_TEXT_ORIGIN_TL = 0;
  PUT_TEXT_ORIGIN_BL = 32;
  PUT_TEXT_WRAP = 128;
  INTERSECT_NONE = 0;
  INTERSECT_PARTIAL = 1;
  INTERSECT_FULL = 2;
  DIST_USER = -1;
  DIST_L1 = 1;
  DIST_L2 = 2;
  DIST_C = 3;
  DIST_L12 = 4;
  DIST_FAIR = 5;
  DIST_WELSCH = 6;
  DIST_HUBER = 7;
  ALGO_HINT_DEFAULT = 0;

type
  TCVCLAHE = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FClipLimit: Double;
    FTilesGridSize: TCVSize;
    procedure ReleaseHandle;
    procedure CreateOwned(const clipLimit: Double; const tileGridSize: TCVSize);
  public
    class operator Initialize(out Dest: TCVCLAHE);
    class operator Finalize(var Dest: TCVCLAHE);
    class operator Assign(var Dest: TCVCLAHE; const [ref] Src: TCVCLAHE);
    class function Create(const clipLimit: Double; const tileGridSize: TCVSize): TCVCLAHE; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVCLAHE; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure apply(const src: Pointer; const dst: Pointer);
    procedure setClipLimit(const clipLimit: Double);
    function getClipLimit(): Double;
    procedure setTilesGridSize(const tileGridSize: TCVSize);
    function getTilesGridSize(): TCVSize;
    procedure setBitShift(const bitShift: Integer);
    function getBitShift(): Integer;
    procedure collectGarbage();
  end;

procedure undistortImage(const distorted: Pointer; const undistorted: Pointer; const K: Pointer; const D: Pointer; const Knew: Pointer; const new_size: TCVSize);
function getGaussianKernel(const ksize: Integer; const sigma: Double; const ktype: Integer): TCVMat;
procedure getDerivKernels(const kx: Pointer; const ky: Pointer; const dx: Integer; const dy: Integer; const ksize: Integer; const normalize: Boolean; const ktype: Integer);
function getGaborKernel(const ksize: TCVSize; const sigma: Double; const theta: Double; const lambd: Double; const gamma: Double; const psi: Double; const ktype: Integer): TCVMat;
function getStructuringElement(const shape: Integer; const ksize: TCVSize; const anchor: TCVPoint): TCVMat;
procedure medianBlur(const src: Pointer; const dst: Pointer; const ksize: Integer);
procedure GaussianBlur(const src: Pointer; const dst: Pointer; const ksize: TCVSize; const sigmaX: Double; const sigmaY: Double; const borderType: Integer; const hint: Integer);
procedure bilateralFilter(const src: Pointer; const dst: Pointer; const d: Integer; const sigmaColor: Double; const sigmaSpace: Double; const borderType: Integer);
procedure boxFilter(const src: Pointer; const dst: Pointer; const ddepth: Integer; const ksize: TCVSize; const anchor: TCVPoint; const normalize: Boolean; const borderType: Integer);
procedure sqrBoxFilter(const src: Pointer; const dst: Pointer; const ddepth: Integer; const ksize: TCVSize; const anchor: TCVPoint; const normalize: Boolean; const borderType: Integer);
procedure blur(const src: Pointer; const dst: Pointer; const ksize: TCVSize; const anchor: TCVPoint; const borderType: Integer);
procedure stackBlur(const src: Pointer; const dst: Pointer; const ksize: TCVSize);
procedure flip(const src: Pointer; const dst: Pointer; const flipCode: Integer);
procedure rotate(const src: Pointer; const dst: Pointer; const rotateCode: Integer);
procedure LUT(const src: Pointer; const lut: Pointer; const dst: Pointer);
procedure buildGammaLUT(const lut: Pointer; const gamma: Double);
procedure filter2D(const src: Pointer; const dst: Pointer; const ddepth: Integer; const kernel: Pointer; const anchor: TCVPoint; const delta: Double; const borderType: Integer);
procedure sepFilter2D(const src: Pointer; const dst: Pointer; const ddepth: Integer; const kernelX: Pointer; const kernelY: Pointer; const anchor: TCVPoint; const delta: Double; const borderType: Integer);
procedure Sobel(const src: Pointer; const dst: Pointer; const ddepth: Integer; const dx: Integer; const dy: Integer; const ksize: Integer; const scale: Double; const delta: Double; const borderType: Integer);
procedure spatialGradient(const src: Pointer; const dx: Pointer; const dy: Pointer; const ksize: Integer; const borderType: Integer);
procedure Scharr(const src: Pointer; const dst: Pointer; const ddepth: Integer; const dx: Integer; const dy: Integer; const scale: Double; const delta: Double; const borderType: Integer);
procedure Laplacian(const src: Pointer; const dst: Pointer; const ddepth: Integer; const ksize: Integer; const scale: Double; const delta: Double; const borderType: Integer);
procedure Canny(const image: Pointer; const edges: Pointer; const threshold1: Double; const threshold2: Double; const apertureSize: Integer; const L2gradient: Boolean); overload;
procedure Canny(const dx: Pointer; const dy: Pointer; const edges: Pointer; const threshold1: Double; const threshold2: Double; const L2gradient: Boolean); overload;
procedure cornerMinEigenVal(const src: Pointer; const dst: Pointer; const blockSize: Integer; const ksize: Integer; const borderType: Integer);
procedure cornerHarris(const src: Pointer; const dst: Pointer; const blockSize: Integer; const ksize: Integer; const k: Double; const borderType: Integer);
procedure cornerEigenValsAndVecs(const src: Pointer; const dst: Pointer; const blockSize: Integer; const ksize: Integer; const borderType: Integer);
procedure preCornerDetect(const src: Pointer; const dst: Pointer; const ksize: Integer; const borderType: Integer);
procedure cornerSubPix(const image: Pointer; const corners: Pointer; const winSize: TCVSize; const zeroZone: TCVSize; const criteria: TCVTermCriteria);
procedure HoughLines(const image: Pointer; const lines: Pointer; const rho: Double; const theta: Double; const threshold: Integer; const srn: Double; const stn: Double; const min_theta: Double; const max_theta: Double; const use_edgeval: Boolean);
procedure HoughLinesP(const image: Pointer; const lines: Pointer; const rho: Double; const theta: Double; const threshold: Integer; const minLineLength: Double; const maxLineGap: Double);
procedure HoughLinesPointSet(const point: Pointer; const lines: Pointer; const lines_max: Integer; const threshold: Integer; const min_rho: Double; const max_rho: Double; const rho_step: Double; const min_theta: Double; const max_theta: Double; const theta_step: Double);
procedure HoughCircles(const image: Pointer; const circles: Pointer; const method: Integer; const dp: Double; const minDist: Double; const param1: Double; const param2: Double; const minRadius: Integer; const maxRadius: Integer);
procedure erode(const src: Pointer; const dst: Pointer; const kernel: Pointer; const anchor: TCVPoint; const iterations: Integer; const borderType: Integer; const borderValue: TCVScalar);
procedure dilate(const src: Pointer; const dst: Pointer; const kernel: Pointer; const anchor: TCVPoint; const iterations: Integer; const borderType: Integer; const borderValue: TCVScalar);
procedure morphologyEx(const src: Pointer; const dst: Pointer; const op: Integer; const kernel: Pointer; const anchor: TCVPoint; const iterations: Integer; const borderType: Integer; const borderValue: TCVScalar);
procedure resize(const src: Pointer; const dst: Pointer; const dsize: TCVSize; const fx: Double; const fy: Double; const interpolation: Integer);
procedure warpAffine(const src: Pointer; const dst: Pointer; const M: Pointer; const dsize: TCVSize; const flags: Integer; const borderMode: Integer; const borderValue: TCVScalar; const hint: Integer);
procedure warpPerspective(const src: Pointer; const dst: Pointer; const M: Pointer; const dsize: TCVSize; const flags: Integer; const borderMode: Integer; const borderValue: TCVScalar; const hint: Integer);
procedure remap(const src: Pointer; const dst: Pointer; const map1: Pointer; const map2: Pointer; const interpolation: Integer; const borderMode: Integer; const borderValue: TCVScalar; const hint: Integer);
procedure convertMaps(const map1: Pointer; const map2: Pointer; const dstmap1: Pointer; const dstmap2: Pointer; const dstmap1type: Integer; const nninterpolation: Boolean);
procedure undistort(const src: Pointer; const dst: Pointer; const cameraMatrix: Pointer; const distCoeffs: Pointer; const newCameraMatrix: Pointer);
procedure initUndistortRectifyMap(const cameraMatrix: Pointer; const distCoeffs: Pointer; const R: Pointer; const newCameraMatrix: Pointer; const size: TCVSize; const m1type: Integer; const map1: Pointer; const map2: Pointer);
procedure initInverseRectificationMap(const cameraMatrix: Pointer; const distCoeffs: Pointer; const R: Pointer; const newCameraMatrix: Pointer; const size: TCVSize; const m1type: Integer; const map1: Pointer; const map2: Pointer);
procedure getRectSubPix(const image: Pointer; const patchSize: TCVSize; const center: TCVPoint2f; const patch: Pointer; const patchType: Integer);
procedure warpPolar(const src: Pointer; const dst: Pointer; const dsize: TCVSize; const center: TCVPoint2f; const maxRadius: Double; const flags: Integer);
procedure integral(const src: Pointer; const sum: Pointer; const sdepth: Integer);
procedure accumulate(const src: Pointer; const dst: Pointer; const mask: Pointer);
procedure accumulateSquare(const src: Pointer; const dst: Pointer; const mask: Pointer);
procedure accumulateProduct(const src1: Pointer; const src2: Pointer; const dst: Pointer; const mask: Pointer);
procedure accumulateWeighted(const src: Pointer; const dst: Pointer; const alpha: Double; const mask: Pointer);
function phaseCorrelate(const src1: Pointer; const src2: Pointer; const window: Pointer; out response: Double): TCVPoint2d;
function phaseCorrelateIterative(const src1: Pointer; const src2: Pointer; const L2size: Integer; const maxIters: Integer): TCVPoint2d;
procedure createHanningWindow(const dst: Pointer; const winSize: TCVSize; const dataType: Integer);
function threshold(const src: Pointer; const dst: Pointer; const thresh: Double; const maxval: Double; const dataType: Integer): Double;
function thresholdWithMask(const src: Pointer; const dst: Pointer; const mask: Pointer; const thresh: Double; const maxval: Double; const dataType: Integer): Double;
procedure adaptiveThreshold(const src: Pointer; const dst: Pointer; const maxValue: Double; const adaptiveMethod: Integer; const thresholdType: Integer; const blockSize: Integer; const C: Double);
procedure pyrDown(const src: Pointer; const dst: Pointer; const dstsize: TCVSize; const borderType: Integer);
procedure pyrUp(const src: Pointer; const dst: Pointer; const dstsize: TCVSize; const borderType: Integer);
procedure buildPyramid(const src: Pointer; const dst: Pointer; const maxlevel: Integer; const borderType: Integer);
function compareHist(const H1: Pointer; const H2: Pointer; const method: Integer): Double;
procedure equalizeHist(const src: Pointer; const dst: Pointer);
function EMD(const signature1: Pointer; const signature2: Pointer; const distType: Integer; const cost: Pointer; const lowerBound: Single; const flow: Pointer): Single;
procedure watershed(const image: Pointer; const markers: Pointer);
procedure pyrMeanShiftFiltering(const src: Pointer; const dst: Pointer; const sp: Double; const sr: Double; const maxLevel: Integer; const termcrit: TCVTermCriteria);
procedure grabCut(const img: Pointer; const mask: Pointer; const rect: TCVRect; const bgdModel: Pointer; const fgdModel: Pointer; const iterCount: Integer; const mode: Integer);
procedure distanceTransform(const src: Pointer; const dst: Pointer; const distanceType: Integer; const maskSize: Integer; const dstType: Integer);
function floodFill(const image: Pointer; const mask: Pointer; const seedPoint: TCVPoint; const newVal: TCVScalar; const rect: PCVRect; const loDiff: TCVScalar; const upDiff: TCVScalar; const flags: Integer): Integer; overload;
function floodFill(const image: Pointer; const seedPoint: TCVPoint; const newVal: TCVScalar; const rect: PCVRect; const loDiff: TCVScalar; const upDiff: TCVScalar; const flags: Integer): Integer; overload;
procedure blendLinear(const src1: Pointer; const src2: Pointer; const weights1: Pointer; const weights2: Pointer; const dst: Pointer);
procedure cvtColor(const src: Pointer; const dst: Pointer; const code: Integer; const dstCn: Integer; const hint: Integer);
procedure cvtColorTwoPlane(const src1: Pointer; const src2: Pointer; const dst: Pointer; const code: Integer; const hint: Integer);
procedure demosaicing(const src: Pointer; const dst: Pointer; const code: Integer; const dstCn: Integer);
procedure matchTemplate(const image: Pointer; const templ: Pointer; const result: Pointer; const method: Integer; const mask: Pointer);
function connectedComponents(const image: Pointer; const labels: Pointer; const connectivity: Integer; const ltype: Integer): Integer;
function connectedComponentsWithStats(const image: Pointer; const labels: Pointer; const stats: Pointer; const centroids: Pointer; const connectivity: Integer; const ltype: Integer): Integer;
procedure findContours(const image: Pointer; const contours: Pointer; const hierarchy: Pointer; const mode: Integer; const method: Integer; const offset: TCVPoint); overload;
procedure findContours(const image: Pointer; const contours: Pointer; const mode: Integer; const method: Integer; const offset: TCVPoint); overload;
procedure findContoursLinkRuns(const image: Pointer; const contours: Pointer; const hierarchy: Pointer); overload;
procedure findContoursLinkRuns(const image: Pointer; const contours: Pointer); overload;
procedure applyColorMap(const src: Pointer; const dst: Pointer; const colormap: Integer); overload;
procedure applyColorMap(const src: Pointer; const dst: Pointer; const userColor: Pointer); overload;
procedure line(const img: Pointer; const pt1: TCVPoint; const pt2: TCVPoint; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const shift: Integer);
procedure arrowedLine(const img: Pointer; const pt1: TCVPoint; const pt2: TCVPoint; const color: TCVScalar; const thickness: Integer; const line_type: Integer; const shift: Integer; const tipLength: Double);
procedure drawFrameAxes(const image: Pointer; const cameraMatrix: Pointer; const distCoeffs: Pointer; const rvec: Pointer; const tvec: Pointer; const length: Single; const thickness: Integer);
procedure rectangle(const img: Pointer; const pt1: TCVPoint; const pt2: TCVPoint; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const shift: Integer); overload;
procedure rectangle(const img: Pointer; const rec: TCVRect; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const shift: Integer); overload;
procedure circle(const img: Pointer; const center: TCVPoint; const radius: Integer; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const shift: Integer);
procedure ellipse(const img: Pointer; const center: TCVPoint; const axes: TCVSize; const angle: Double; const startAngle: Double; const endAngle: Double; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const shift: Integer); overload;
procedure ellipse(const img: Pointer; const box: TCVRotatedRect; const color: TCVScalar; const thickness: Integer; const lineType: Integer); overload;
procedure drawMarker(const img: Pointer; const position: TCVPoint; const color: TCVScalar; const markerType: Integer; const markerSize: Integer; const thickness: Integer; const line_type: Integer);
procedure fillConvexPoly(const img: Pointer; const points: Pointer; const color: TCVScalar; const lineType: Integer; const shift: Integer); overload;
procedure fillConvexPoly(const img: Pointer; const pts: PCVPoint; const npts: Integer; const color: TCVScalar; const lineType: Integer; const shift: Integer); overload;
procedure fillPoly(const img: Pointer; const pts: Pointer; const color: TCVScalar; const lineType: Integer; const shift: Integer; const offset: TCVPoint); overload;
procedure fillPoly(const img: Pointer; const pts: PCVPoint; const npts: Integer; const ncontours: Integer; const color: TCVScalar; const lineType: Integer; const shift: Integer; const offset: TCVPoint); overload;
procedure polylines(const img: Pointer; const pts: Pointer; const isClosed: Boolean; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const shift: Integer); overload;
procedure polylines(const img: Pointer; const pts: PCVPoint; const npts: Integer; const ncontours: Integer; const isClosed: Boolean; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const shift: Integer); overload;
procedure drawContours(const image: Pointer; const contours: Pointer; const contourIdx: Integer; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const hierarchy: Pointer; const maxLevel: Integer; const offset: TCVPoint);
function clipLine(const imgSize: TCVSize; const pt1: PCVPoint; const pt2: PCVPoint): Boolean; overload;
function clipLine(const imgSize: TCVSize2l; const pt1: PCVPoint2l; const pt2: PCVPoint2l): Boolean; overload;
function clipLine(const imgRect: TCVRect; const pt1: PCVPoint; const pt2: PCVPoint): Boolean; overload;
procedure putText(const img: Pointer; const text: PAnsiChar; const org: TCVPoint; const fontFace: Integer; const fontScale: Double; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const bottomLeftOrigin: Boolean); overload;
function getTextSize(const text: PAnsiChar; const fontFace: Integer; const fontScale: Double; const thickness: Integer; const baseLine: Integer): TCVSize; overload;
function getFontScaleFromHeight(const fontFace: Integer; const pixelHeight: Integer; const thickness: Integer): Double;
function putText(const img: Pointer; const text: PAnsiChar; const org: TCVPoint; const color: TCVScalar; const fface: Integer; const size: Integer; const weight: Integer; const flags: Integer; const wrap: Pointer): TCVPoint; overload;
function getTextSize(const imgsize: TCVSize; const text: PAnsiChar; const org: TCVPoint; const fface: Integer; const size: Integer; const weight: Integer; const flags: Integer; const wrap: Pointer): TCVRect; overload;
procedure approxPolyDP(const curve: Pointer; const approxCurve: Pointer; const epsilon: Double; const closed: Boolean);
procedure approxPolyN(const curve: Pointer; const approxCurve: Pointer; const nsides: Integer; const epsilon_percentage: Single; const ensure_convex: Boolean);
function minAreaRect(const points: Pointer): TCVRotatedRect;
procedure boxPoints(const box: TCVRotatedRect; const points: Pointer);
procedure minEnclosingCircle(const points: Pointer; const center: PCVPoint2f; const radius: Single);
function minEnclosingTriangle(const points: Pointer; const triangle: Pointer): Double;
function minEnclosingConvexPolygon(const points: Pointer; const polygon: Pointer; const k: Integer): Double;
function moments(const aArray: Pointer; const binaryImage: Boolean): TCVMoments;
procedure HuMoments(const m: TCVMoments; const hu: Pointer);
function matchShapes(const contour1: Pointer; const contour2: Pointer; const method: Integer; const parameter: Double): Double;
procedure convexHull(const points: Pointer; const hull: Pointer; const clockwise: Boolean; const returnPoints: Boolean);
procedure convexityDefects(const contour: Pointer; const convexhull: Pointer; const convexityDefects: Pointer);
function isContourConvex(const contour: Pointer): Boolean;
function intersectConvexConvex(const p1: Pointer; const p2: Pointer; const p12: Pointer; const handleNested: Boolean): Single;
function fitEllipse(const points: Pointer): TCVRotatedRect;
function fitEllipseAMS(const points: Pointer): TCVRotatedRect;
function fitEllipseDirect(const points: Pointer): TCVRotatedRect;
procedure getClosestEllipsePoints(const ellipse_params: TCVRotatedRect; const points: Pointer; const closest_pts: Pointer);
procedure fitLine(const points: Pointer; const line: Pointer; const distType: Integer; const param: Double; const reps: Double; const aeps: Double);
function pointPolygonTest(const contour: Pointer; const pt: TCVPoint2f; const measureDist: Boolean): Double;
function rotatedRectangleIntersection(const rect1: TCVRotatedRect; const rect2: TCVRotatedRect; const intersectingRegion: Pointer): Integer;
function arcLength(const curve: Pointer; const closed: Boolean): Double;
function contourArea(const contour: Pointer; const oriented: Boolean): Double;
function boundingRect(const aArray: Pointer): TCVRect;
function getRotationMatrix2D(const center: TCVPoint2f; const angle: Double; const scale: Double): TCVMat;
function getAffineTransform(const src: PCVPoint2f; const dst: PCVPoint2f): TCVMat; overload;
procedure invertAffineTransform(const M: Pointer; const iM: Pointer);
function getPerspectiveTransform(const src: Pointer; const dst: Pointer; const solveMethod: Integer): TCVMat; overload;
function getPerspectiveTransform(const src: PCVPoint2f; const dst: PCVPoint2f; const solveMethod: Integer): TCVMat; overload;
function getAffineTransform(const src: Pointer; const dst: Pointer): TCVMat; overload;

procedure calcHistSimple(const image: Pointer; const hist: Pointer; const channel: Integer; const mask: Pointer; const histSize: PInteger; const ranges: PSingle; const dims: Integer; const accumulate: Boolean);
procedure calcHist(const images: PPointer; const nimages: Integer; const channels: PInteger; const channelsCount: Integer; const mask: Pointer; const hist: Pointer; const histSize: PInteger; const histSizeCount: Integer; const ranges: PSingle; const rangesCount: Integer; const accumulate: Boolean);
procedure calcBackProjectSimple(const image: Pointer; const hist: Pointer; const backProject: Pointer; const ranges: PSingle; const rangesCount: Integer; const scale: Double);
procedure calcBackProject(const images: PPointer; const nimages: Integer; const channels: PInteger; const channelsCount: Integer; const hist: Pointer; const backProject: Pointer; const ranges: PSingle; const rangesCount: Integer; const scale: Double);
function createCLAHE(const clipLimit: Double; const tileGridSize: TCVSize): TCVCLAHE;
function ellipse2Poly(const center: TCVPoint; const axes: TCVSize; const angle: Integer; const arcStart: Integer; const arcEnd: Integer; const delta: Integer; pts: PCVPoint; const maxPts: Integer): Integer;

implementation

// ==========================================
// Flat C API Imports
// ==========================================

procedure CLAHE_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure CLAHE_apply(self: Pointer; src: Pointer; dst: Pointer); stdcall; external OpenCVLib delayed;
procedure CLAHE_setClipLimit(self: Pointer; clipLimit: Double); stdcall; external OpenCVLib delayed;
function CLAHE_getClipLimit(self: Pointer): Double; stdcall; external OpenCVLib delayed;
procedure CLAHE_setTilesGridSize(self: Pointer; tileGridSize: Pointer); stdcall; external OpenCVLib delayed;
function CLAHE_getTilesGridSize(self: Pointer): TCVSize; stdcall; external OpenCVLib delayed;
procedure CLAHE_setBitShift(self: Pointer; bitShift: Integer); stdcall; external OpenCVLib delayed;
function CLAHE_getBitShift(self: Pointer): Integer; stdcall; external OpenCVLib delayed;
procedure CLAHE_collectGarbage(self: Pointer); stdcall; external OpenCVLib delayed;
function Imgproc_createCLAHE(clipLimit: Double; tileCols, tileRows: Integer): Pointer; stdcall; external OpenCVLib delayed;

procedure Imgproc_undistortImage(distorted: Pointer; undistorted: Pointer; K: Pointer; D: Pointer; Knew: Pointer; new_size: Pointer); stdcall; external OpenCVLib delayed;
function Imgproc_getGaussianKernel(ksize: Integer; sigma: Double; ktype: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Imgproc_getDerivKernels(kx: Pointer; ky: Pointer; dx: Integer; dy: Integer; ksize: Integer; normalize: Boolean; ktype: Integer); stdcall; external OpenCVLib delayed;
function Imgproc_getGaborKernel(ksize: Pointer; sigma: Double; theta: Double; lambd: Double; gamma: Double; psi: Double; ktype: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Imgproc_getStructuringElement(shape: Integer; ksize: Pointer; anchor: Pointer): Pointer; stdcall; external OpenCVLib delayed;
procedure Imgproc_medianBlur(src: Pointer; dst: Pointer; ksize: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_GaussianBlur(src: Pointer; dst: Pointer; ksize: Pointer; sigmaX: Double; sigmaY: Double; borderType: Integer; hint: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_bilateralFilter(src: Pointer; dst: Pointer; d: Integer; sigmaColor: Double; sigmaSpace: Double; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_boxFilter(src: Pointer; dst: Pointer; ddepth: Integer; ksize: Pointer; anchor: Pointer; normalize: Boolean; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_sqrBoxFilter(src: Pointer; dst: Pointer; ddepth: Integer; ksize: Pointer; anchor: Pointer; normalize: Boolean; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_blur(src: Pointer; dst: Pointer; ksize: Pointer; anchor: Pointer; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_stackBlur(src: Pointer; dst: Pointer; ksize: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_filter2D(src: Pointer; dst: Pointer; ddepth: Integer; kernel: Pointer; anchor: Pointer; delta: Double; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_sepFilter2D(src: Pointer; dst: Pointer; ddepth: Integer; kernelX: Pointer; kernelY: Pointer; anchor: Pointer; delta: Double; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_Sobel(src: Pointer; dst: Pointer; ddepth: Integer; dx: Integer; dy: Integer; ksize: Integer; scale: Double; delta: Double; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_spatialGradient(src: Pointer; dx: Pointer; dy: Pointer; ksize: Integer; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_Scharr(src: Pointer; dst: Pointer; ddepth: Integer; dx: Integer; dy: Integer; scale: Double; delta: Double; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_Laplacian(src: Pointer; dst: Pointer; ddepth: Integer; ksize: Integer; scale: Double; delta: Double; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_Canny_0(image: Pointer; edges: Pointer; threshold1: Double; threshold2: Double; apertureSize: Integer; L2gradient: Boolean); stdcall; external OpenCVLib delayed;
procedure Imgproc_Canny_1(dx: Pointer; dy: Pointer; edges: Pointer; threshold1: Double; threshold2: Double; L2gradient: Boolean); stdcall; external OpenCVLib delayed;
procedure Imgproc_cornerMinEigenVal(src: Pointer; dst: Pointer; blockSize: Integer; ksize: Integer; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_cornerHarris(src: Pointer; dst: Pointer; blockSize: Integer; ksize: Integer; k: Double; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_cornerEigenValsAndVecs(src: Pointer; dst: Pointer; blockSize: Integer; ksize: Integer; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_preCornerDetect(src: Pointer; dst: Pointer; ksize: Integer; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_cornerSubPix(image: Pointer; corners: Pointer; winSize: Pointer; zeroZone: Pointer; criteria: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_HoughLines(image: Pointer; lines: Pointer; rho: Double; theta: Double; threshold: Integer; srn: Double; stn: Double; min_theta: Double; max_theta: Double; use_edgeval: Boolean); stdcall; external OpenCVLib delayed;
procedure Imgproc_HoughLinesP(image: Pointer; lines: Pointer; rho: Double; theta: Double; threshold: Integer; minLineLength: Double; maxLineGap: Double); stdcall; external OpenCVLib delayed;
procedure Imgproc_HoughLinesPointSet(point: Pointer; lines: Pointer; lines_max: Integer; threshold: Integer; min_rho: Double; max_rho: Double; rho_step: Double; min_theta: Double; max_theta: Double; theta_step: Double); stdcall; external OpenCVLib delayed;
procedure Imgproc_HoughCircles(image: Pointer; circles: Pointer; method: Integer; dp: Double; minDist: Double; param1: Double; param2: Double; minRadius: Integer; maxRadius: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_erode(src: Pointer; dst: Pointer; kernel: Pointer; anchor: Pointer; iterations: Integer; borderType: Integer; borderValue: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_dilate(src: Pointer; dst: Pointer; kernel: Pointer; anchor: Pointer; iterations: Integer; borderType: Integer; borderValue: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_morphologyEx(src: Pointer; dst: Pointer; op: Integer; kernel: Pointer; anchor: Pointer; iterations: Integer; borderType: Integer; borderValue: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_resize(src: Pointer; dst: Pointer; dsize: Pointer; fx: Double; fy: Double; interpolation: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_warpAffine(src: Pointer; dst: Pointer; M: Pointer; dsize: Pointer; flags: Integer; borderMode: Integer; borderValue: Pointer; hint: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_warpPerspective(src: Pointer; dst: Pointer; M: Pointer; dsize: Pointer; flags: Integer; borderMode: Integer; borderValue: Pointer; hint: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_remap(src: Pointer; dst: Pointer; map1: Pointer; map2: Pointer; interpolation: Integer; borderMode: Integer; borderValue: Pointer; hint: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_convertMaps(map1: Pointer; map2: Pointer; dstmap1: Pointer; dstmap2: Pointer; dstmap1type: Integer; nninterpolation: Boolean); stdcall; external OpenCVLib delayed;
procedure Imgproc_undistort(src: Pointer; dst: Pointer; cameraMatrix: Pointer; distCoeffs: Pointer; newCameraMatrix: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_initUndistortRectifyMap(cameraMatrix: Pointer; distCoeffs: Pointer; R: Pointer; newCameraMatrix: Pointer; size: Pointer; m1type: Integer; map1: Pointer; map2: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_initInverseRectificationMap(cameraMatrix: Pointer; distCoeffs: Pointer; R: Pointer; newCameraMatrix: Pointer; size: Pointer; m1type: Integer; map1: Pointer; map2: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_getRectSubPix(image: Pointer; patchSize: Pointer; center: Pointer; patch: Pointer; patchType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_warpPolar(src: Pointer; dst: Pointer; dsize: Pointer; center: Pointer; maxRadius: Double; flags: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_integral(src: Pointer; sum: Pointer; sdepth: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_accumulate(src: Pointer; dst: Pointer; mask: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_accumulateSquare(src: Pointer; dst: Pointer; mask: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_accumulateProduct(src1: Pointer; src2: Pointer; dst: Pointer; mask: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_accumulateWeighted(src: Pointer; dst: Pointer; alpha: Double; mask: Pointer); stdcall; external OpenCVLib delayed;
function Imgproc_phaseCorrelate(src1: Pointer; src2: Pointer; window: Pointer; response: PDouble): TCVPoint2d; stdcall; external OpenCVLib delayed;
function Imgproc_phaseCorrelateIterative(src1: Pointer; src2: Pointer; L2size: Integer; maxIters: Integer): TCVPoint2d; stdcall; external OpenCVLib delayed;
procedure Imgproc_createHanningWindow(dst: Pointer; winSize: Pointer; dataType: Integer); stdcall; external OpenCVLib delayed;
function Imgproc_threshold(src: Pointer; dst: Pointer; thresh: Double; maxval: Double; dataType: Integer): Double; stdcall; external OpenCVLib delayed;
function Imgproc_thresholdWithMask(src: Pointer; dst: Pointer; mask: Pointer; thresh: Double; maxval: Double; dataType: Integer): Double; stdcall; external OpenCVLib delayed;
procedure Imgproc_adaptiveThreshold(src: Pointer; dst: Pointer; maxValue: Double; adaptiveMethod: Integer; thresholdType: Integer; blockSize: Integer; C: Double); stdcall; external OpenCVLib delayed;
procedure Imgproc_pyrDown(src: Pointer; dst: Pointer; dstsize: Pointer; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_pyrUp(src: Pointer; dst: Pointer; dstsize: Pointer; borderType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_buildPyramid(src: Pointer; dst: Pointer; maxlevel: Integer; borderType: Integer); stdcall; external OpenCVLib delayed;
function Imgproc_compareHist(H1: Pointer; H2: Pointer; method: Integer): Double; stdcall; external OpenCVLib delayed;
procedure Imgproc_equalizeHist(src: Pointer; dst: Pointer); stdcall; external OpenCVLib delayed;
function Imgproc_EMD(signature1: Pointer; signature2: Pointer; distType: Integer; cost: Pointer; lowerBound: Single; flow: Pointer): Single; stdcall; external OpenCVLib delayed;
procedure Imgproc_watershed(image: Pointer; markers: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_pyrMeanShiftFiltering(src: Pointer; dst: Pointer; sp: Double; sr: Double; maxLevel: Integer; termcrit: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_grabCut(img: Pointer; mask: Pointer; rect: Pointer; bgdModel: Pointer; fgdModel: Pointer; iterCount: Integer; mode: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_distanceTransform(src: Pointer; dst: Pointer; distanceType: Integer; maskSize: Integer; dstType: Integer); stdcall; external OpenCVLib delayed;
function Imgproc_floodFill_0(image: Pointer; mask: Pointer; seedPoint: Pointer; newVal: Pointer; rect: Pointer; loDiff: Pointer; upDiff: Pointer; flags: Integer): Integer; stdcall; external OpenCVLib delayed;
function Imgproc_floodFill_1(image: Pointer; seedPoint: Pointer; newVal: Pointer; rect: Pointer; loDiff: Pointer; upDiff: Pointer; flags: Integer): Integer; stdcall; external OpenCVLib delayed;
procedure Imgproc_blendLinear(src1: Pointer; src2: Pointer; weights1: Pointer; weights2: Pointer; dst: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_cvtColor(src: Pointer; dst: Pointer; code: Integer; dstCn: Integer; hint: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_cvtColorTwoPlane(src1: Pointer; src2: Pointer; dst: Pointer; code: Integer; hint: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_demosaicing(src: Pointer; dst: Pointer; code: Integer; dstCn: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_matchTemplate(image: Pointer; templ: Pointer; result: Pointer; method: Integer; mask: Pointer); stdcall; external OpenCVLib delayed;
function Imgproc_connectedComponents(image: Pointer; labels: Pointer; connectivity: Integer; ltype: Integer): Integer; stdcall; external OpenCVLib delayed;
function Imgproc_connectedComponentsWithStats(image: Pointer; labels: Pointer; stats: Pointer; centroids: Pointer; connectivity: Integer; ltype: Integer): Integer; stdcall; external OpenCVLib delayed;
procedure Imgproc_findContours_0(image: Pointer; contours: Pointer; hierarchy: Pointer; mode: Integer; method: Integer; offset: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_findContours_1(image: Pointer; contours: Pointer; mode: Integer; method: Integer; offset: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_findContoursLinkRuns_0(image: Pointer; contours: Pointer; hierarchy: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_findContoursLinkRuns_1(image: Pointer; contours: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_applyColorMap_0(src: Pointer; dst: Pointer; colormap: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_applyColorMap_1(src: Pointer; dst: Pointer; userColor: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_line(img: Pointer; pt1: Pointer; pt2: Pointer; color: Pointer; thickness: Integer; lineType: Integer; shift: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_arrowedLine(img: Pointer; pt1: Pointer; pt2: Pointer; color: Pointer; thickness: Integer; line_type: Integer; shift: Integer; tipLength: Double); stdcall; external OpenCVLib delayed;
procedure Imgproc_drawFrameAxes(image: Pointer; cameraMatrix: Pointer; distCoeffs: Pointer; rvec: Pointer; tvec: Pointer; length: Single; thickness: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_rectangle_0(img: Pointer; pt1: Pointer; pt2: Pointer; color: Pointer; thickness: Integer; lineType: Integer; shift: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_rectangle_1(img: Pointer; rec: Pointer; color: Pointer; thickness: Integer; lineType: Integer; shift: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_circle(img: Pointer; center: Pointer; radius: Integer; color: Pointer; thickness: Integer; lineType: Integer; shift: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_ellipse_0(img: Pointer; center: Pointer; axes: Pointer; angle: Double; startAngle: Double; endAngle: Double; color: Pointer; thickness: Integer; lineType: Integer; shift: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_ellipse_1(img: Pointer; box: Pointer; color: Pointer; thickness: Integer; lineType: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_drawMarker(img: Pointer; position: Pointer; color: Pointer; markerType: Integer; markerSize: Integer; thickness: Integer; line_type: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_fillConvexPoly_0(img: Pointer; points: Pointer; color: Pointer; lineType: Integer; shift: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_fillConvexPoly_1(img: Pointer; pts: Pointer; npts: Integer; color: Pointer; lineType: Integer; shift: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_fillPoly_0(img: Pointer; pts: Pointer; color: Pointer; lineType: Integer; shift: Integer; offset: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_fillPoly_1(img: Pointer; pts: Pointer; npts: Integer; ncontours: Integer; color: Pointer; lineType: Integer; shift: Integer; offset: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_polylines_0(img: Pointer; pts: Pointer; isClosed: Boolean; color: Pointer; thickness: Integer; lineType: Integer; shift: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_polylines_1(img: Pointer; pts: Pointer; npts: Integer; ncontours: Integer; isClosed: Boolean; color: Pointer; thickness: Integer; lineType: Integer; shift: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_drawContours(image: Pointer; contours: Pointer; contourIdx: Integer; color: Pointer; thickness: Integer; lineType: Integer; hierarchy: Pointer; maxLevel: Integer; offset: Pointer); stdcall; external OpenCVLib delayed;
function Imgproc_clipLine_0(imgSize: Pointer; pt1: Pointer; pt2: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function Imgproc_clipLine_1(imgSize: Pointer; pt1: Pointer; pt2: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function Imgproc_clipLine_2(imgRect: Pointer; pt1: Pointer; pt2: Pointer): Boolean; stdcall; external OpenCVLib delayed;
procedure Imgproc_putText_0(img: Pointer; text: PAnsiChar; org: Pointer; fontFace: Integer; fontScale: Double; color: Pointer; thickness: Integer; lineType: Integer; bottomLeftOrigin: Boolean); stdcall; external OpenCVLib delayed;
function Imgproc_getTextSize_0(text: PAnsiChar; fontFace: Integer; fontScale: Double; thickness: Integer; baseLine: Integer): TCVSize; stdcall; external OpenCVLib delayed;
function Imgproc_getFontScaleFromHeight(fontFace: Integer; pixelHeight: Integer; thickness: Integer): Double; stdcall; external OpenCVLib delayed;
function Imgproc_putText_1(img: Pointer; text: PAnsiChar; org: Pointer; color: Pointer; fface: Integer; size: Integer; weight: Integer; flags: Integer; wrap: Pointer): TCVPoint; stdcall; external OpenCVLib delayed;
function Imgproc_getTextSize_1(imgsize: Pointer; text: PAnsiChar; org: Pointer; fface: Integer; size: Integer; weight: Integer; flags: Integer; wrap: Pointer): TCVRect; stdcall; external OpenCVLib delayed;
procedure Imgproc_approxPolyDP(curve: Pointer; approxCurve: Pointer; epsilon: Double; closed: Boolean); stdcall; external OpenCVLib delayed;
procedure Imgproc_approxPolyN(curve: Pointer; approxCurve: Pointer; nsides: Integer; epsilon_percentage: Single; ensure_convex: Boolean); stdcall; external OpenCVLib delayed;
function Imgproc_minAreaRect(points: Pointer): TCVRotatedRect; stdcall; external OpenCVLib delayed;
procedure Imgproc_boxPoints(box: Pointer; points: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_minEnclosingCircle(points: Pointer; center: Pointer; radius: Single); stdcall; external OpenCVLib delayed;
function Imgproc_minEnclosingTriangle(points: Pointer; triangle: Pointer): Double; stdcall; external OpenCVLib delayed;
function Imgproc_minEnclosingConvexPolygon(points: Pointer; polygon: Pointer; k: Integer): Double; stdcall; external OpenCVLib delayed;
function Imgproc_moments(aArray: Pointer; binaryImage: Boolean): TCVMoments; stdcall; external OpenCVLib delayed;
procedure Imgproc_HuMoments(m: Pointer; hu: Pointer); stdcall; external OpenCVLib delayed;
function Imgproc_matchShapes(contour1: Pointer; contour2: Pointer; method: Integer; parameter: Double): Double; stdcall; external OpenCVLib delayed;
procedure Imgproc_convexHull(points: Pointer; hull: Pointer; clockwise: Boolean; returnPoints: Boolean); stdcall; external OpenCVLib delayed;
procedure Imgproc_convexityDefects(contour: Pointer; convexhull: Pointer; convexityDefects: Pointer); stdcall; external OpenCVLib delayed;
function Imgproc_isContourConvex(contour: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function Imgproc_intersectConvexConvex(p1: Pointer; p2: Pointer; p12: Pointer; handleNested: Boolean): Single; stdcall; external OpenCVLib delayed;
function Imgproc_fitEllipse(points: Pointer): TCVRotatedRect; stdcall; external OpenCVLib delayed;
function Imgproc_fitEllipseAMS(points: Pointer): TCVRotatedRect; stdcall; external OpenCVLib delayed;
function Imgproc_fitEllipseDirect(points: Pointer): TCVRotatedRect; stdcall; external OpenCVLib delayed;
procedure Imgproc_getClosestEllipsePoints(ellipse_params: Pointer; points: Pointer; closest_pts: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_fitLine(points: Pointer; line: Pointer; distType: Integer; param: Double; reps: Double; aeps: Double); stdcall; external OpenCVLib delayed;
function Imgproc_pointPolygonTest(contour: Pointer; pt: Pointer; measureDist: Boolean): Double; stdcall; external OpenCVLib delayed;
function Imgproc_rotatedRectangleIntersection(rect1: Pointer; rect2: Pointer; intersectingRegion: Pointer): Integer; stdcall; external OpenCVLib delayed;
function Imgproc_arcLength(curve: Pointer; closed: Boolean): Double; stdcall; external OpenCVLib delayed;
function Imgproc_contourArea(contour: Pointer; oriented: Boolean): Double; stdcall; external OpenCVLib delayed;
function Imgproc_boundingRect(aArray: Pointer): TCVRect; stdcall; external OpenCVLib delayed;
function Imgproc_getRotationMatrix2D(center: Pointer; angle: Double; scale: Double): Pointer; stdcall; external OpenCVLib delayed;
function Imgproc_getAffineTransform_0(src: Pointer; dst: Pointer): Pointer; stdcall; external OpenCVLib delayed;
procedure Imgproc_invertAffineTransform(M: Pointer; iM: Pointer); stdcall; external OpenCVLib delayed;
function Imgproc_getPerspectiveTransform_0(src: Pointer; dst: Pointer; solveMethod: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Imgproc_getPerspectiveTransform_1(src: Pointer; dst: Pointer; solveMethod: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Imgproc_getAffineTransform_1(src: Pointer; dst: Pointer): Pointer; stdcall; external OpenCVLib delayed;

// ==========================================
// TCVCLAHE Implementation
// ==========================================

procedure TCVCLAHE.ReleaseHandle;
begin
  if FOwnsHandle and Assigned(FHandle) then
    CLAHE_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVCLAHE.CreateOwned(const clipLimit: Double; const tileGridSize: TCVSize);
begin
  ReleaseHandle;
  FClipLimit := clipLimit;
  FTilesGridSize := tileGridSize;
  FHandle := Imgproc_createCLAHE(clipLimit, tileGridSize.Width, tileGridSize.Height);
  FOwnsHandle := True;
end;

class operator TCVCLAHE.Initialize(out Dest: TCVCLAHE);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FClipLimit := 0;
  Dest.FTilesGridSize := TCVSize.Create(0, 0);
end;

class operator TCVCLAHE.Finalize(var Dest: TCVCLAHE);
begin
  Dest.ReleaseHandle;
end;

class operator TCVCLAHE.Assign(var Dest: TCVCLAHE; const [ref] Src: TCVCLAHE);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FClipLimit := Src.FClipLimit;
  Dest.FTilesGridSize := Src.FTilesGridSize;
  if Src.FOwnsHandle and Assigned(Src.FHandle) then
    Dest.CreateOwned(Src.FClipLimit, Src.FTilesGridSize)
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVCLAHE.Create(const clipLimit: Double; const tileGridSize: TCVSize): TCVCLAHE;
begin
  Result.FClipLimit := clipLimit;
  Result.FTilesGridSize := tileGridSize;
  Result.FHandle := Imgproc_createCLAHE(clipLimit, tileGridSize.Width, tileGridSize.Height);
  Result.FOwnsHandle := True;
end;

class function TCVCLAHE.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVCLAHE;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FClipLimit := 0;
  Result.FTilesGridSize := TCVSize.Create(0, 0);
end;

procedure TCVCLAHE.Release;
begin
  ReleaseHandle;
end;

procedure TCVCLAHE.apply(const src: Pointer; const dst: Pointer);
begin
  CLAHE_apply(FHandle, src, dst);
end;

procedure TCVCLAHE.setClipLimit(const clipLimit: Double);
begin
  CLAHE_setClipLimit(FHandle, clipLimit);
end;

function TCVCLAHE.getClipLimit(): Double;
begin
  Result := CLAHE_getClipLimit(FHandle);
end;

procedure TCVCLAHE.setTilesGridSize(const tileGridSize: TCVSize);
begin
  CLAHE_setTilesGridSize(FHandle, @tileGridSize);
end;

function TCVCLAHE.getTilesGridSize(): TCVSize;
begin
  Result := CLAHE_getTilesGridSize(FHandle);
end;

procedure TCVCLAHE.setBitShift(const bitShift: Integer);
begin
  CLAHE_setBitShift(FHandle, bitShift);
end;

function TCVCLAHE.getBitShift(): Integer;
begin
  Result := CLAHE_getBitShift(FHandle);
end;

procedure TCVCLAHE.collectGarbage();
begin
  CLAHE_collectGarbage(FHandle);
end;


procedure undistortImage(const distorted: Pointer; const undistorted: Pointer; const K: Pointer; const D: Pointer; const Knew: Pointer; const new_size: TCVSize);
begin
  Imgproc_undistortImage(distorted, undistorted, K, D, Knew, @new_size);
end;

function getGaussianKernel(const ksize: Integer; const sigma: Double; const ktype: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Imgproc_getGaussianKernel(ksize, sigma, ktype));
end;

procedure getDerivKernels(const kx: Pointer; const ky: Pointer; const dx: Integer; const dy: Integer; const ksize: Integer; const normalize: Boolean; const ktype: Integer);
begin
  Imgproc_getDerivKernels(kx, ky, dx, dy, ksize, normalize, ktype);
end;

function getGaborKernel(const ksize: TCVSize; const sigma: Double; const theta: Double; const lambd: Double; const gamma: Double; const psi: Double; const ktype: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Imgproc_getGaborKernel(@ksize, sigma, theta, lambd, gamma, psi, ktype));
end;

function getStructuringElement(const shape: Integer; const ksize: TCVSize; const anchor: TCVPoint): TCVMat;
begin
  Result := TCVMat.FromHandle(Imgproc_getStructuringElement(shape, @ksize, @anchor));
end;

procedure medianBlur(const src: Pointer; const dst: Pointer; const ksize: Integer);
begin
  Imgproc_medianBlur(src, dst, ksize);
end;

procedure GaussianBlur(const src: Pointer; const dst: Pointer; const ksize: TCVSize; const sigmaX: Double; const sigmaY: Double; const borderType: Integer; const hint: Integer);
begin
  Imgproc_GaussianBlur(src, dst, @ksize, sigmaX, sigmaY, borderType, hint);
end;

procedure bilateralFilter(const src: Pointer; const dst: Pointer; const d: Integer; const sigmaColor: Double; const sigmaSpace: Double; const borderType: Integer);
begin
  Imgproc_bilateralFilter(src, dst, d, sigmaColor, sigmaSpace, borderType);
end;

procedure boxFilter(const src: Pointer; const dst: Pointer; const ddepth: Integer; const ksize: TCVSize; const anchor: TCVPoint; const normalize: Boolean; const borderType: Integer);
begin
  Imgproc_boxFilter(src, dst, ddepth, @ksize, @anchor, normalize, borderType);
end;

procedure sqrBoxFilter(const src: Pointer; const dst: Pointer; const ddepth: Integer; const ksize: TCVSize; const anchor: TCVPoint; const normalize: Boolean; const borderType: Integer);
begin
  Imgproc_sqrBoxFilter(src, dst, ddepth, @ksize, @anchor, normalize, borderType);
end;

procedure blur(const src: Pointer; const dst: Pointer; const ksize: TCVSize; const anchor: TCVPoint; const borderType: Integer);
begin
  Imgproc_blur(src, dst, @ksize, @anchor, borderType);
end;

procedure stackBlur(const src: Pointer; const dst: Pointer; const ksize: TCVSize);
begin
  Imgproc_stackBlur(src, dst, @ksize);
end;

procedure filter2D(const src: Pointer; const dst: Pointer; const ddepth: Integer; const kernel: Pointer; const anchor: TCVPoint; const delta: Double; const borderType: Integer);
begin
  Imgproc_filter2D(src, dst, ddepth, kernel, @anchor, delta, borderType);
end;

procedure sepFilter2D(const src: Pointer; const dst: Pointer; const ddepth: Integer; const kernelX: Pointer; const kernelY: Pointer; const anchor: TCVPoint; const delta: Double; const borderType: Integer);
begin
  Imgproc_sepFilter2D(src, dst, ddepth, kernelX, kernelY, @anchor, delta, borderType);
end;

procedure Sobel(const src: Pointer; const dst: Pointer; const ddepth: Integer; const dx: Integer; const dy: Integer; const ksize: Integer; const scale: Double; const delta: Double; const borderType: Integer);
begin
  Imgproc_Sobel(src, dst, ddepth, dx, dy, ksize, scale, delta, borderType);
end;

procedure spatialGradient(const src: Pointer; const dx: Pointer; const dy: Pointer; const ksize: Integer; const borderType: Integer);
begin
  Imgproc_spatialGradient(src, dx, dy, ksize, borderType);
end;

procedure Scharr(const src: Pointer; const dst: Pointer; const ddepth: Integer; const dx: Integer; const dy: Integer; const scale: Double; const delta: Double; const borderType: Integer);
begin
  Imgproc_Scharr(src, dst, ddepth, dx, dy, scale, delta, borderType);
end;

procedure Laplacian(const src: Pointer; const dst: Pointer; const ddepth: Integer; const ksize: Integer; const scale: Double; const delta: Double; const borderType: Integer);
begin
  Imgproc_Laplacian(src, dst, ddepth, ksize, scale, delta, borderType);
end;

procedure Canny(const image: Pointer; const edges: Pointer; const threshold1: Double; const threshold2: Double; const apertureSize: Integer; const L2gradient: Boolean);
begin
  Imgproc_Canny_0(image, edges, threshold1, threshold2, apertureSize, L2gradient);
end;

procedure Canny(const dx: Pointer; const dy: Pointer; const edges: Pointer; const threshold1: Double; const threshold2: Double; const L2gradient: Boolean);
begin
  Imgproc_Canny_1(dx, dy, edges, threshold1, threshold2, L2gradient);
end;

procedure cornerMinEigenVal(const src: Pointer; const dst: Pointer; const blockSize: Integer; const ksize: Integer; const borderType: Integer);
begin
  Imgproc_cornerMinEigenVal(src, dst, blockSize, ksize, borderType);
end;

procedure cornerHarris(const src: Pointer; const dst: Pointer; const blockSize: Integer; const ksize: Integer; const k: Double; const borderType: Integer);
begin
  Imgproc_cornerHarris(src, dst, blockSize, ksize, k, borderType);
end;

procedure cornerEigenValsAndVecs(const src: Pointer; const dst: Pointer; const blockSize: Integer; const ksize: Integer; const borderType: Integer);
begin
  Imgproc_cornerEigenValsAndVecs(src, dst, blockSize, ksize, borderType);
end;

procedure preCornerDetect(const src: Pointer; const dst: Pointer; const ksize: Integer; const borderType: Integer);
begin
  Imgproc_preCornerDetect(src, dst, ksize, borderType);
end;

procedure cornerSubPix(const image: Pointer; const corners: Pointer; const winSize: TCVSize; const zeroZone: TCVSize; const criteria: TCVTermCriteria);
begin
  Imgproc_cornerSubPix(image, corners, @winSize, @zeroZone, @criteria);
end;

procedure HoughLines(const image: Pointer; const lines: Pointer; const rho: Double; const theta: Double; const threshold: Integer; const srn: Double; const stn: Double; const min_theta: Double; const max_theta: Double; const use_edgeval: Boolean);
begin
  Imgproc_HoughLines(image, lines, rho, theta, threshold, srn, stn, min_theta, max_theta, use_edgeval);
end;

procedure HoughLinesP(const image: Pointer; const lines: Pointer; const rho: Double; const theta: Double; const threshold: Integer; const minLineLength: Double; const maxLineGap: Double);
begin
  Imgproc_HoughLinesP(image, lines, rho, theta, threshold, minLineLength, maxLineGap);
end;

procedure HoughLinesPointSet(const point: Pointer; const lines: Pointer; const lines_max: Integer; const threshold: Integer; const min_rho: Double; const max_rho: Double; const rho_step: Double; const min_theta: Double; const max_theta: Double; const theta_step: Double);
begin
  Imgproc_HoughLinesPointSet(point, lines, lines_max, threshold, min_rho, max_rho, rho_step, min_theta, max_theta, theta_step);
end;

procedure HoughCircles(const image: Pointer; const circles: Pointer; const method: Integer; const dp: Double; const minDist: Double; const param1: Double; const param2: Double; const minRadius: Integer; const maxRadius: Integer);
begin
  Imgproc_HoughCircles(image, circles, method, dp, minDist, param1, param2, minRadius, maxRadius);
end;

procedure erode(const src: Pointer; const dst: Pointer; const kernel: Pointer; const anchor: TCVPoint; const iterations: Integer; const borderType: Integer; const borderValue: TCVScalar);
begin
  Imgproc_erode(src, dst, kernel, @anchor, iterations, borderType, @borderValue);
end;

procedure dilate(const src: Pointer; const dst: Pointer; const kernel: Pointer; const anchor: TCVPoint; const iterations: Integer; const borderType: Integer; const borderValue: TCVScalar);
begin
  Imgproc_dilate(src, dst, kernel, @anchor, iterations, borderType, @borderValue);
end;

procedure morphologyEx(const src: Pointer; const dst: Pointer; const op: Integer; const kernel: Pointer; const anchor: TCVPoint; const iterations: Integer; const borderType: Integer; const borderValue: TCVScalar);
begin
  Imgproc_morphologyEx(src, dst, op, kernel, @anchor, iterations, borderType, @borderValue);
end;

procedure resize(const src: Pointer; const dst: Pointer; const dsize: TCVSize; const fx: Double; const fy: Double; const interpolation: Integer);
begin
  Imgproc_resize(src, dst, @dsize, fx, fy, interpolation);
end;

procedure warpAffine(const src: Pointer; const dst: Pointer; const M: Pointer; const dsize: TCVSize; const flags: Integer; const borderMode: Integer; const borderValue: TCVScalar; const hint: Integer);
begin
  Imgproc_warpAffine(src, dst, M, @dsize, flags, borderMode, @borderValue, hint);
end;

procedure warpPerspective(const src: Pointer; const dst: Pointer; const M: Pointer; const dsize: TCVSize; const flags: Integer; const borderMode: Integer; const borderValue: TCVScalar; const hint: Integer);
begin
  Imgproc_warpPerspective(src, dst, M, @dsize, flags, borderMode, @borderValue, hint);
end;

procedure remap(const src: Pointer; const dst: Pointer; const map1: Pointer; const map2: Pointer; const interpolation: Integer; const borderMode: Integer; const borderValue: TCVScalar; const hint: Integer);
begin
  Imgproc_remap(src, dst, map1, map2, interpolation, borderMode, @borderValue, hint);
end;

procedure convertMaps(const map1: Pointer; const map2: Pointer; const dstmap1: Pointer; const dstmap2: Pointer; const dstmap1type: Integer; const nninterpolation: Boolean);
begin
  Imgproc_convertMaps(map1, map2, dstmap1, dstmap2, dstmap1type, nninterpolation);
end;

procedure undistort(const src: Pointer; const dst: Pointer; const cameraMatrix: Pointer; const distCoeffs: Pointer; const newCameraMatrix: Pointer);
begin
  Imgproc_undistort(src, dst, cameraMatrix, distCoeffs, newCameraMatrix);
end;

procedure initUndistortRectifyMap(const cameraMatrix: Pointer; const distCoeffs: Pointer; const R: Pointer; const newCameraMatrix: Pointer; const size: TCVSize; const m1type: Integer; const map1: Pointer; const map2: Pointer);
begin
  Imgproc_initUndistortRectifyMap(cameraMatrix, distCoeffs, R, newCameraMatrix, @size, m1type, map1, map2);
end;

procedure initInverseRectificationMap(const cameraMatrix: Pointer; const distCoeffs: Pointer; const R: Pointer; const newCameraMatrix: Pointer; const size: TCVSize; const m1type: Integer; const map1: Pointer; const map2: Pointer);
begin
  Imgproc_initInverseRectificationMap(cameraMatrix, distCoeffs, R, newCameraMatrix, @size, m1type, map1, map2);
end;

procedure getRectSubPix(const image: Pointer; const patchSize: TCVSize; const center: TCVPoint2f; const patch: Pointer; const patchType: Integer);
begin
  Imgproc_getRectSubPix(image, @patchSize, @center, patch, patchType);
end;

procedure warpPolar(const src: Pointer; const dst: Pointer; const dsize: TCVSize; const center: TCVPoint2f; const maxRadius: Double; const flags: Integer);
begin
  Imgproc_warpPolar(src, dst, @dsize, @center, maxRadius, flags);
end;

procedure integral(const src: Pointer; const sum: Pointer; const sdepth: Integer);
begin
  Imgproc_integral(src, sum, sdepth);
end;

procedure accumulate(const src: Pointer; const dst: Pointer; const mask: Pointer);
begin
  Imgproc_accumulate(src, dst, mask);
end;

procedure accumulateSquare(const src: Pointer; const dst: Pointer; const mask: Pointer);
begin
  Imgproc_accumulateSquare(src, dst, mask);
end;

procedure accumulateProduct(const src1: Pointer; const src2: Pointer; const dst: Pointer; const mask: Pointer);
begin
  Imgproc_accumulateProduct(src1, src2, dst, mask);
end;

procedure accumulateWeighted(const src: Pointer; const dst: Pointer; const alpha: Double; const mask: Pointer);
begin
  Imgproc_accumulateWeighted(src, dst, alpha, mask);
end;

function phaseCorrelate(const src1: Pointer; const src2: Pointer; const window: Pointer; out response: Double): TCVPoint2d;
var
  Resp: Double;
begin
  Resp := 0.0;
  Result := Imgproc_phaseCorrelate(src1, src2, window, @Resp);
  response := Resp;
end;

function phaseCorrelateIterative(const src1: Pointer; const src2: Pointer; const L2size: Integer; const maxIters: Integer): TCVPoint2d;
begin
  Result := Imgproc_phaseCorrelateIterative(src1, src2, L2size, maxIters);
end;

procedure createHanningWindow(const dst: Pointer; const winSize: TCVSize; const dataType: Integer);
begin
  Imgproc_createHanningWindow(dst, @winSize, dataType);
end;

function threshold(const src: Pointer; const dst: Pointer; const thresh: Double; const maxval: Double; const dataType: Integer): Double;
begin
  Result := Imgproc_threshold(src, dst, thresh, maxval, dataType);
end;

function thresholdWithMask(const src: Pointer; const dst: Pointer; const mask: Pointer; const thresh: Double; const maxval: Double; const dataType: Integer): Double;
begin
  Result := Imgproc_thresholdWithMask(src, dst, mask, thresh, maxval, dataType);
end;

procedure adaptiveThreshold(const src: Pointer; const dst: Pointer; const maxValue: Double; const adaptiveMethod: Integer; const thresholdType: Integer; const blockSize: Integer; const C: Double);
begin
  Imgproc_adaptiveThreshold(src, dst, maxValue, adaptiveMethod, thresholdType, blockSize, C);
end;

procedure pyrDown(const src: Pointer; const dst: Pointer; const dstsize: TCVSize; const borderType: Integer);
begin
  Imgproc_pyrDown(src, dst, @dstsize, borderType);
end;

procedure pyrUp(const src: Pointer; const dst: Pointer; const dstsize: TCVSize; const borderType: Integer);
begin
  Imgproc_pyrUp(src, dst, @dstsize, borderType);
end;

procedure buildPyramid(const src: Pointer; const dst: Pointer; const maxlevel: Integer; const borderType: Integer);
begin
  Imgproc_buildPyramid(src, dst, maxlevel, borderType);
end;

function compareHist(const H1: Pointer; const H2: Pointer; const method: Integer): Double;
begin
  Result := Imgproc_compareHist(H1, H2, method);
end;

procedure equalizeHist(const src: Pointer; const dst: Pointer);
begin
  Imgproc_equalizeHist(src, dst);
end;

function EMD(const signature1: Pointer; const signature2: Pointer; const distType: Integer; const cost: Pointer; const lowerBound: Single; const flow: Pointer): Single;
begin
  Result := Imgproc_EMD(signature1, signature2, distType, cost, lowerBound, flow);
end;

procedure watershed(const image: Pointer; const markers: Pointer);
begin
  Imgproc_watershed(image, markers);
end;

procedure pyrMeanShiftFiltering(const src: Pointer; const dst: Pointer; const sp: Double; const sr: Double; const maxLevel: Integer; const termcrit: TCVTermCriteria);
begin
  Imgproc_pyrMeanShiftFiltering(src, dst, sp, sr, maxLevel, @termcrit);
end;

procedure grabCut(const img: Pointer; const mask: Pointer; const rect: TCVRect; const bgdModel: Pointer; const fgdModel: Pointer; const iterCount: Integer; const mode: Integer);
begin
  Imgproc_grabCut(img, mask, @rect, bgdModel, fgdModel, iterCount, mode);
end;

procedure distanceTransform(const src: Pointer; const dst: Pointer; const distanceType: Integer; const maskSize: Integer; const dstType: Integer);
begin
  Imgproc_distanceTransform(src, dst, distanceType, maskSize, dstType);
end;

function floodFill(const image: Pointer; const mask: Pointer; const seedPoint: TCVPoint; const newVal: TCVScalar; const rect: PCVRect; const loDiff: TCVScalar; const upDiff: TCVScalar; const flags: Integer): Integer;
begin
  Result := Imgproc_floodFill_0(image, mask, @seedPoint, @newVal, rect, @loDiff, @upDiff, flags);
end;

function floodFill(const image: Pointer; const seedPoint: TCVPoint; const newVal: TCVScalar; const rect: PCVRect; const loDiff: TCVScalar; const upDiff: TCVScalar; const flags: Integer): Integer;
begin
  Result := Imgproc_floodFill_1(image, @seedPoint, @newVal, rect, @loDiff, @upDiff, flags);
end;

procedure blendLinear(const src1: Pointer; const src2: Pointer; const weights1: Pointer; const weights2: Pointer; const dst: Pointer);
begin
  Imgproc_blendLinear(src1, src2, weights1, weights2, dst);
end;

procedure cvtColor(const src: Pointer; const dst: Pointer; const code: Integer; const dstCn: Integer; const hint: Integer);
begin
  Imgproc_cvtColor(src, dst, code, dstCn, hint);
end;

procedure cvtColorTwoPlane(const src1: Pointer; const src2: Pointer; const dst: Pointer; const code: Integer; const hint: Integer);
begin
  Imgproc_cvtColorTwoPlane(src1, src2, dst, code, hint);
end;

procedure demosaicing(const src: Pointer; const dst: Pointer; const code: Integer; const dstCn: Integer);
begin
  Imgproc_demosaicing(src, dst, code, dstCn);
end;

procedure matchTemplate(const image: Pointer; const templ: Pointer; const result: Pointer; const method: Integer; const mask: Pointer);
begin
  Imgproc_matchTemplate(image, templ, result, method, mask);
end;

function connectedComponents(const image: Pointer; const labels: Pointer; const connectivity: Integer; const ltype: Integer): Integer;
begin
  Result := Imgproc_connectedComponents(image, labels, connectivity, ltype);
end;

function connectedComponentsWithStats(const image: Pointer; const labels: Pointer; const stats: Pointer; const centroids: Pointer; const connectivity: Integer; const ltype: Integer): Integer;
begin
  Result := Imgproc_connectedComponentsWithStats(image, labels, stats, centroids, connectivity, ltype);
end;

procedure findContours(const image: Pointer; const contours: Pointer; const hierarchy: Pointer; const mode: Integer; const method: Integer; const offset: TCVPoint);
begin
  Imgproc_findContours_0(image, contours, hierarchy, mode, method, @offset);
end;

procedure findContours(const image: Pointer; const contours: Pointer; const mode: Integer; const method: Integer; const offset: TCVPoint);
begin
  Imgproc_findContours_1(image, contours, mode, method, @offset);
end;

procedure findContoursLinkRuns(const image: Pointer; const contours: Pointer; const hierarchy: Pointer);
begin
  Imgproc_findContoursLinkRuns_0(image, contours, hierarchy);
end;

procedure findContoursLinkRuns(const image: Pointer; const contours: Pointer);
begin
  Imgproc_findContoursLinkRuns_1(image, contours);
end;

procedure applyColorMap(const src: Pointer; const dst: Pointer; const colormap: Integer);
begin
  Imgproc_applyColorMap_0(src, dst, colormap);
end;

procedure applyColorMap(const src: Pointer; const dst: Pointer; const userColor: Pointer);
begin
  Imgproc_applyColorMap_1(src, dst, userColor);
end;

procedure line(const img: Pointer; const pt1: TCVPoint; const pt2: TCVPoint; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const shift: Integer);
begin
  Imgproc_line(img, @pt1, @pt2, @color, thickness, lineType, shift);
end;

procedure arrowedLine(const img: Pointer; const pt1: TCVPoint; const pt2: TCVPoint; const color: TCVScalar; const thickness: Integer; const line_type: Integer; const shift: Integer; const tipLength: Double);
begin
  Imgproc_arrowedLine(img, @pt1, @pt2, @color, thickness, line_type, shift, tipLength);
end;

procedure drawFrameAxes(const image: Pointer; const cameraMatrix: Pointer; const distCoeffs: Pointer; const rvec: Pointer; const tvec: Pointer; const length: Single; const thickness: Integer);
begin
  Imgproc_drawFrameAxes(image, cameraMatrix, distCoeffs, rvec, tvec, length, thickness);
end;

procedure rectangle(const img: Pointer; const pt1: TCVPoint; const pt2: TCVPoint; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const shift: Integer);
begin
  Imgproc_rectangle_0(img, @pt1, @pt2, @color, thickness, lineType, shift);
end;

procedure rectangle(const img: Pointer; const rec: TCVRect; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const shift: Integer);
begin
  Imgproc_rectangle_1(img, @rec, @color, thickness, lineType, shift);
end;

procedure circle(const img: Pointer; const center: TCVPoint; const radius: Integer; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const shift: Integer);
begin
  Imgproc_circle(img, @center, radius, @color, thickness, lineType, shift);
end;

procedure ellipse(const img: Pointer; const center: TCVPoint; const axes: TCVSize; const angle: Double; const startAngle: Double; const endAngle: Double; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const shift: Integer);
begin
  Imgproc_ellipse_0(img, @center, @axes, angle, startAngle, endAngle, @color, thickness, lineType, shift);
end;

procedure ellipse(const img: Pointer; const box: TCVRotatedRect; const color: TCVScalar; const thickness: Integer; const lineType: Integer);
begin
  Imgproc_ellipse_1(img, @box, @color, thickness, lineType);
end;

procedure drawMarker(const img: Pointer; const position: TCVPoint; const color: TCVScalar; const markerType: Integer; const markerSize: Integer; const thickness: Integer; const line_type: Integer);
begin
  Imgproc_drawMarker(img, @position, @color, markerType, markerSize, thickness, line_type);
end;

procedure fillConvexPoly(const img: Pointer; const points: Pointer; const color: TCVScalar; const lineType: Integer; const shift: Integer);
begin
  Imgproc_fillConvexPoly_0(img, points, @color, lineType, shift);
end;

procedure fillConvexPoly(const img: Pointer; const pts: PCVPoint; const npts: Integer; const color: TCVScalar; const lineType: Integer; const shift: Integer);
begin
  Imgproc_fillConvexPoly_1(img, pts, npts, @color, lineType, shift);
end;

procedure fillPoly(const img: Pointer; const pts: Pointer; const color: TCVScalar; const lineType: Integer; const shift: Integer; const offset: TCVPoint);
begin
  Imgproc_fillPoly_0(img, pts, @color, lineType, shift, @offset);
end;

procedure fillPoly(const img: Pointer; const pts: PCVPoint; const npts: Integer; const ncontours: Integer; const color: TCVScalar; const lineType: Integer; const shift: Integer; const offset: TCVPoint);
begin
  Imgproc_fillPoly_1(img, pts, npts, ncontours, @color, lineType, shift, @offset);
end;

procedure polylines(const img: Pointer; const pts: Pointer; const isClosed: Boolean; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const shift: Integer);
begin
  Imgproc_polylines_0(img, pts, isClosed, @color, thickness, lineType, shift);
end;

procedure polylines(const img: Pointer; const pts: PCVPoint; const npts: Integer; const ncontours: Integer; const isClosed: Boolean; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const shift: Integer);
begin
  Imgproc_polylines_1(img, pts, npts, ncontours, isClosed, @color, thickness, lineType, shift);
end;

procedure drawContours(const image: Pointer; const contours: Pointer; const contourIdx: Integer; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const hierarchy: Pointer; const maxLevel: Integer; const offset: TCVPoint);
begin
  Imgproc_drawContours(image, contours, contourIdx, @color, thickness, lineType, hierarchy, maxLevel, @offset);
end;

function clipLine(const imgSize: TCVSize; const pt1: PCVPoint; const pt2: PCVPoint): Boolean;
begin
  Result := Imgproc_clipLine_0(@imgSize, pt1, pt2);
end;

function clipLine(const imgSize: TCVSize2l; const pt1: PCVPoint2l; const pt2: PCVPoint2l): Boolean;
begin
  Result := Imgproc_clipLine_1(@imgSize, pt1, pt2);
end;

function clipLine(const imgRect: TCVRect; const pt1: PCVPoint; const pt2: PCVPoint): Boolean;
begin
  Result := Imgproc_clipLine_2(@imgRect, pt1, pt2);
end;

procedure putText(const img: Pointer; const text: PAnsiChar; const org: TCVPoint; const fontFace: Integer; const fontScale: Double; const color: TCVScalar; const thickness: Integer; const lineType: Integer; const bottomLeftOrigin: Boolean);
begin
  Imgproc_putText_0(img, text, @org, fontFace, fontScale, @color, thickness, lineType, bottomLeftOrigin);
end;

function getTextSize(const text: PAnsiChar; const fontFace: Integer; const fontScale: Double; const thickness: Integer; const baseLine: Integer): TCVSize;
begin
  Result := Imgproc_getTextSize_0(text, fontFace, fontScale, thickness, baseLine);
end;

function getFontScaleFromHeight(const fontFace: Integer; const pixelHeight: Integer; const thickness: Integer): Double;
begin
  Result := Imgproc_getFontScaleFromHeight(fontFace, pixelHeight, thickness);
end;

function putText(const img: Pointer; const text: PAnsiChar; const org: TCVPoint; const color: TCVScalar; const fface: Integer; const size: Integer; const weight: Integer; const flags: Integer; const wrap: Pointer): TCVPoint;
begin
  Result := Imgproc_putText_1(img, text, @org, @color, fface, size, weight, flags, wrap);
end;

function getTextSize(const imgsize: TCVSize; const text: PAnsiChar; const org: TCVPoint; const fface: Integer; const size: Integer; const weight: Integer; const flags: Integer; const wrap: Pointer): TCVRect;
begin
  Result := Imgproc_getTextSize_1(@imgsize, text, @org, fface, size, weight, flags, wrap);
end;

procedure approxPolyDP(const curve: Pointer; const approxCurve: Pointer; const epsilon: Double; const closed: Boolean);
begin
  Imgproc_approxPolyDP(curve, approxCurve, epsilon, closed);
end;

procedure approxPolyN(const curve: Pointer; const approxCurve: Pointer; const nsides: Integer; const epsilon_percentage: Single; const ensure_convex: Boolean);
begin
  Imgproc_approxPolyN(curve, approxCurve, nsides, epsilon_percentage, ensure_convex);
end;

function minAreaRect(const points: Pointer): TCVRotatedRect;
begin
  Result := Imgproc_minAreaRect(points);
end;

procedure boxPoints(const box: TCVRotatedRect; const points: Pointer);
begin
  Imgproc_boxPoints(@box, points);
end;

procedure minEnclosingCircle(const points: Pointer; const center: PCVPoint2f; const radius: Single);
begin
  Imgproc_minEnclosingCircle(points, center, radius);
end;

function minEnclosingTriangle(const points: Pointer; const triangle: Pointer): Double;
begin
  Result := Imgproc_minEnclosingTriangle(points, triangle);
end;

function minEnclosingConvexPolygon(const points: Pointer; const polygon: Pointer; const k: Integer): Double;
begin
  Result := Imgproc_minEnclosingConvexPolygon(points, polygon, k);
end;

function moments(const aArray: Pointer; const binaryImage: Boolean): TCVMoments;
begin
  Result := Imgproc_moments(aArray, binaryImage);
end;

procedure HuMoments(const m: TCVMoments; const hu: Pointer);
begin
  Imgproc_HuMoments(@m, hu);
end;

function matchShapes(const contour1: Pointer; const contour2: Pointer; const method: Integer; const parameter: Double): Double;
begin
  Result := Imgproc_matchShapes(contour1, contour2, method, parameter);
end;

procedure convexHull(const points: Pointer; const hull: Pointer; const clockwise: Boolean; const returnPoints: Boolean);
begin
  Imgproc_convexHull(points, hull, clockwise, returnPoints);
end;

procedure convexityDefects(const contour: Pointer; const convexhull: Pointer; const convexityDefects: Pointer);
begin
  Imgproc_convexityDefects(contour, convexhull, convexityDefects);
end;

function isContourConvex(const contour: Pointer): Boolean;
begin
  Result := Imgproc_isContourConvex(contour);
end;

function intersectConvexConvex(const p1: Pointer; const p2: Pointer; const p12: Pointer; const handleNested: Boolean): Single;
begin
  Result := Imgproc_intersectConvexConvex(p1, p2, p12, handleNested);
end;

function fitEllipse(const points: Pointer): TCVRotatedRect;
begin
  Result := Imgproc_fitEllipse(points);
end;

function fitEllipseAMS(const points: Pointer): TCVRotatedRect;
begin
  Result := Imgproc_fitEllipseAMS(points);
end;

function fitEllipseDirect(const points: Pointer): TCVRotatedRect;
begin
  Result := Imgproc_fitEllipseDirect(points);
end;

procedure getClosestEllipsePoints(const ellipse_params: TCVRotatedRect; const points: Pointer; const closest_pts: Pointer);
begin
  Imgproc_getClosestEllipsePoints(@ellipse_params, points, closest_pts);
end;

procedure fitLine(const points: Pointer; const line: Pointer; const distType: Integer; const param: Double; const reps: Double; const aeps: Double);
begin
  Imgproc_fitLine(points, line, distType, param, reps, aeps);
end;

function pointPolygonTest(const contour: Pointer; const pt: TCVPoint2f; const measureDist: Boolean): Double;
begin
  Result := Imgproc_pointPolygonTest(contour, @pt, measureDist);
end;

function rotatedRectangleIntersection(const rect1: TCVRotatedRect; const rect2: TCVRotatedRect; const intersectingRegion: Pointer): Integer;
begin
  Result := Imgproc_rotatedRectangleIntersection(@rect1, @rect2, intersectingRegion);
end;

function arcLength(const curve: Pointer; const closed: Boolean): Double;
begin
  Result := Imgproc_arcLength(curve, closed);
end;

function contourArea(const contour: Pointer; const oriented: Boolean): Double;
begin
  Result := Imgproc_contourArea(contour, oriented);
end;

function boundingRect(const aArray: Pointer): TCVRect;
begin
  Result := Imgproc_boundingRect(aArray);
end;

function getRotationMatrix2D(const center: TCVPoint2f; const angle: Double; const scale: Double): TCVMat;
begin
  Result := TCVMat.FromHandle(Imgproc_getRotationMatrix2D(@center, angle, scale));
end;

function getAffineTransform(const src: PCVPoint2f; const dst: PCVPoint2f): TCVMat;
begin
  Result := TCVMat.FromHandle(Imgproc_getAffineTransform_0(src, dst));
end;

procedure invertAffineTransform(const M: Pointer; const iM: Pointer);
begin
  Imgproc_invertAffineTransform(M, iM);
end;

function getPerspectiveTransform(const src: Pointer; const dst: Pointer; const solveMethod: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Imgproc_getPerspectiveTransform_0(src, dst, solveMethod));
end;

function getPerspectiveTransform(const src: PCVPoint2f; const dst: PCVPoint2f; const solveMethod: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Imgproc_getPerspectiveTransform_1(src, dst, solveMethod));
end;

function getAffineTransform(const src: Pointer; const dst: Pointer): TCVMat;
begin
  Result := TCVMat.FromHandle(Imgproc_getAffineTransform_1(src, dst));
end;

procedure Imgproc_calcHistSimple(image: Pointer; hist: Pointer; channel: Integer; mask: Pointer; histSize: PInteger; ranges: PSingle; dims: Integer; accumulate: Boolean); stdcall; external OpenCVLib delayed;
procedure Imgproc_calcHist(images: PPointer; nimages: Integer; channels: PInteger; channelsCount: Integer; mask: Pointer; hist: Pointer; histSize: PInteger; histSizeCount: Integer; ranges: PSingle; rangesCount: Integer; accumulate: Boolean); stdcall; external OpenCVLib delayed;
procedure Imgproc_calcBackProjectSimple(image: Pointer; hist: Pointer; backProject: Pointer; ranges: PSingle; rangesCount: Integer; scale: Double); stdcall; external OpenCVLib delayed;
procedure Imgproc_calcBackProject(images: PPointer; nimages: Integer; channels: PInteger; channelsCount: Integer; hist: Pointer; backProject: Pointer; ranges: PSingle; rangesCount: Integer; scale: Double); stdcall; external OpenCVLib delayed;
function Imgproc_ellipse2Poly(center: Pointer; axes: Pointer; angle, arcStart, arcEnd, delta: Integer; pts: Pointer; maxPts: Integer): Integer; stdcall; external OpenCVLib delayed;
procedure Imgproc_flip(src, dst: Pointer; flipCode: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_rotate(src, dst: Pointer; rotateCode: Integer); stdcall; external OpenCVLib delayed;
procedure Imgproc_LUT(src, lut, dst: Pointer); stdcall; external OpenCVLib delayed;
procedure Imgproc_buildGammaLUT(lut: Pointer; gamma: Double); stdcall; external OpenCVLib delayed;

procedure calcHistSimple(const image: Pointer; const hist: Pointer; const channel: Integer; const mask: Pointer; const histSize: PInteger; const ranges: PSingle; const dims: Integer; const accumulate: Boolean);
begin
  Imgproc_calcHistSimple(image, hist, channel, mask, histSize, ranges, dims, accumulate);
end;

procedure calcHist(const images: PPointer; const nimages: Integer; const channels: PInteger; const channelsCount: Integer; const mask: Pointer; const hist: Pointer; const histSize: PInteger; const histSizeCount: Integer; const ranges: PSingle; const rangesCount: Integer; const accumulate: Boolean);
begin
  Imgproc_calcHist(images, nimages, channels, channelsCount, mask, hist, histSize, histSizeCount, ranges, rangesCount, accumulate);
end;

procedure calcBackProjectSimple(const image: Pointer; const hist: Pointer; const backProject: Pointer; const ranges: PSingle; const rangesCount: Integer; const scale: Double);
begin
  Imgproc_calcBackProjectSimple(image, hist, backProject, ranges, rangesCount, scale);
end;

procedure calcBackProject(const images: PPointer; const nimages: Integer; const channels: PInteger; const channelsCount: Integer; const hist: Pointer; const backProject: Pointer; const ranges: PSingle; const rangesCount: Integer; const scale: Double);
begin
  Imgproc_calcBackProject(images, nimages, channels, channelsCount, hist, backProject, ranges, rangesCount, scale);
end;

function createCLAHE(const clipLimit: Double; const tileGridSize: TCVSize): TCVCLAHE;
begin
  Result := TCVCLAHE.Create(clipLimit, tileGridSize);
end;

function ellipse2Poly(const center: TCVPoint; const axes: TCVSize; const angle: Integer; const arcStart: Integer; const arcEnd: Integer; const delta: Integer; pts: PCVPoint; const maxPts: Integer): Integer;
begin
  Result := Imgproc_ellipse2Poly(@center, @axes, angle, arcStart, arcEnd, delta, pts, maxPts);
end;

procedure flip(const src: Pointer; const dst: Pointer; const flipCode: Integer);
begin
  Imgproc_flip(src, dst, flipCode);
end;

procedure rotate(const src: Pointer; const dst: Pointer; const rotateCode: Integer);
begin
  Imgproc_rotate(src, dst, rotateCode);
end;

procedure LUT(const src: Pointer; const lut: Pointer; const dst: Pointer);
begin
  Imgproc_LUT(src, lut, dst);
end;

procedure buildGammaLUT(const lut: Pointer; const gamma: Double);
begin
  Imgproc_buildGammaLUT(lut, gamma);
end;

end.