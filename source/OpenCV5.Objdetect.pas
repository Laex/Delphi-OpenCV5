unit OpenCV5.Objdetect;

interface

uses
  System.Classes,
  System.SysUtils,
  OpenCV5.Core,
  OpenCV5.Types;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

  CALIB_CB_ADAPTIVE_THRESH = 1;
  CALIB_CB_NORMALIZE_IMAGE = 2;
  CALIB_CB_FILTER_QUADS = 4;
  CALIB_CB_FAST_CHECK = 8;
  CALIB_CB_EXHAUSTIVE = 16;
  CALIB_CB_ACCURACY = 32;
  CALIB_CB_LARGER = 64;
  CALIB_CB_MARKER = 128;
  CALIB_CB_PLAIN = 256;

  CALIB_CB_SYMMETRIC_GRID = 1;
  CALIB_CB_ASYMMETRIC_GRID = 2;
  CALIB_CB_CLUSTERING = 4;

  DICT_4X4_50 = 0;
  DICT_4X4_100 = 1;
  DICT_4X4_250 = 2;
  DICT_4X4_1000 = 3;
  DICT_5X5_50 = 4;
  DICT_5X5_100 = 5;
  DICT_5X5_250 = 6;
  DICT_5X5_1000 = 7;
  DICT_6X6_50 = 8;
  DICT_6X6_100 = 9;
  DICT_6X6_250 = 10;
  DICT_6X6_1000 = 11;
  DICT_7X7_50 = 12;
  DICT_7X7_100 = 13;
  DICT_7X7_250 = 14;
  DICT_7X7_1000 = 15;
  DICT_ARUCO_ORIGINAL = 16;
  DICT_APRILTAG_16h5 = 17;
  DICT_APRILTAG_25h9 = 18;
  DICT_APRILTAG_36h10 = 19;
  DICT_APRILTAG_36h11 = 20;
  DICT_ARUCO_MIP_36h12 = 21;

  QR_CORRECT_LEVEL_L = 0;
  QR_CORRECT_LEVEL_M = 1;
  QR_CORRECT_LEVEL_Q = 2;
  QR_CORRECT_LEVEL_H = 3;

  QR_MODE_AUTO = -1;
  QR_MODE_NUMERIC = 1;
  QR_MODE_ALPHANUMERIC = 2;
  QR_MODE_BYTE = 4;

  QR_ECI_SHIFT_JIS = 20;
  QR_ECI_UTF8 = 26;

  FACE_DETECT_FIELDS = 15;

  FACE_IDX_X = 0;
  FACE_IDX_Y = 1;
  FACE_IDX_W = 2;
  FACE_IDX_H = 3;
  FACE_IDX_SCORE = 14;

  FACE_MODEL_ZOO_URL = 'https://github.com/opencv/opencv_zoo/tree/main/models/face_detection_yunet';
  FACE_MODEL_DEFAULT = 'models\face_detection_yunet_2026may.onnx';
  FACE_MODEL_YUNET_2026 = 'models\face_detection_yunet_2026may.onnx';
  FACE_MODEL_YUNET_2023 = 'models\face_detection_yunet_2023mar.onnx';
  FACE_MODEL_YUNET_2023_INT8 = 'models\face_detection_yunet_2023mar_int8.onnx';
  FACE_MODEL_YUNET_2023_INT8BQ = 'models\face_detection_yunet_2023mar_int8bq.onnx';

  FR_COSINE = 0;
  FR_NORM_L2 = 1;
  FACE_REC_MODEL_ZOO_URL = 'https://github.com/opencv/opencv_zoo/tree/main/models/face_recognition_sface';
  FACE_REC_MODEL_DEFAULT = 'models\face_recognition_sface_2021dec.onnx';
  FACE_REC_MATCH_THRESHOLD = 0.363;

type
  TCVQRCodeDetector = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    procedure ReleaseHandle;
  public
    class operator Initialize(out Dest: TCVQRCodeDetector);
    class operator Finalize(var Dest: TCVQRCodeDetector);
    class operator Assign(var Dest: TCVQRCodeDetector; const [ref] Src: TCVQRCodeDetector);
    class function Create: TCVQRCodeDetector; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVQRCodeDetector; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure setEpsX(const epsX: Double);
    procedure setEpsY(const epsY: Double);
    procedure setUseAlignmentMarkers(const useAlignmentMarkers: Boolean);
    function detect(const img: Pointer; const points: Pointer): Boolean;
    function detectMulti(const img: Pointer; const points: Pointer): Boolean;
    function decode(const img, points, straightQrcode: Pointer; out Text: string): Boolean;
    function decodeMulti(const img, points: Pointer; Texts: TStrings): Integer;
    function detectAndDecode(const img: Pointer; const points: Pointer; out Text: string): Boolean;
    function detectAndDecodeMulti(const img: Pointer; const points: Pointer; Texts: TStrings): Integer;
    function detectAndDecodeCurved(const img, points, straightQrcode: Pointer; out Text: string): Boolean;
    function getEncoding(const codeIdx: Integer = 0): Integer;
  end;

  TCVBarcodeDetector = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    procedure ReleaseHandle;
  public
    class operator Initialize(out Dest: TCVBarcodeDetector);
    class operator Finalize(var Dest: TCVBarcodeDetector);
    class operator Assign(var Dest: TCVBarcodeDetector; const [ref] Src: TCVBarcodeDetector);
    class function Create: TCVBarcodeDetector; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVBarcodeDetector; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function detect(const img: Pointer; const points: Pointer): Boolean;
    function decodeWithType(const img, points: Pointer; Texts, Types: TStrings): Boolean;
    function detectAndDecodeWithType(const img: Pointer; const points: Pointer;
      Texts, Types: TStrings): Boolean;
    function getDownsamplingThreshold: Double;
    procedure setDownsamplingThreshold(const thresh: Double);
    function getGradientThreshold: Double;
    procedure setGradientThreshold(const thresh: Double);
  end;

  TCVGridBoard = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FMarkersX: Integer;
    FMarkersY: Integer;
    FMarkerLength: Single;
    FMarkerSeparation: Single;
    FDictionaryId: Integer;
    procedure ReleaseHandle;
    procedure CreateOwned(const markersX, markersY: Integer; const markerLength, markerSeparation: Single;
      const dictionaryId: Integer);
  public
    class operator Initialize(out Dest: TCVGridBoard);
    class operator Finalize(var Dest: TCVGridBoard);
    class operator Assign(var Dest: TCVGridBoard; const [ref] Src: TCVGridBoard);
    class function Create(const markersX, markersY: Integer; const markerLength, markerSeparation: Single;
      const dictionaryId: Integer = DICT_4X4_50): TCVGridBoard; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVGridBoard; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure generateImage(const outWidth, outHeight, marginSize, borderBits: Integer; const img: Pointer);
  end;

  TCVArucoDetector = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FDictionaryId: Integer;
    procedure ReleaseHandle;
    procedure CreateOwned(const dictionaryId: Integer);
  public
    class operator Initialize(out Dest: TCVArucoDetector);
    class operator Finalize(var Dest: TCVArucoDetector);
    class operator Assign(var Dest: TCVArucoDetector; const [ref] Src: TCVArucoDetector);
    class function Create(const dictionaryId: Integer = DICT_4X4_50): TCVArucoDetector; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVArucoDetector; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function detectMarkers(const image, markerCorners, ids: Pointer;
      const rejectedImgPoints: Pointer = nil): Integer;
    procedure refineDetectedMarkers(const image, markerCorners, ids, rejectedImgPoints: Pointer;
      const board: TCVGridBoard; const cameraMatrix, distCoeffs: Pointer);
  end;

  TCVQRCodeEncoder = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FVersion: Integer;
    FCorrectionLevel: Integer;
    FMode: Integer;
    procedure ReleaseHandle;
    procedure CreateOwned(const version, correctionLevel, mode: Integer);
  public
    class operator Initialize(out Dest: TCVQRCodeEncoder);
    class operator Finalize(var Dest: TCVQRCodeEncoder);
    class operator Assign(var Dest: TCVQRCodeEncoder; const [ref] Src: TCVQRCodeEncoder);
    class function Create(const version: Integer = -1; const correctionLevel: Integer = QR_CORRECT_LEVEL_L;
      const mode: Integer = QR_MODE_AUTO): TCVQRCodeEncoder; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVQRCodeEncoder; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure encode(const text: string; const qrcode: Pointer);
  end;

  TCVCharucoBoard = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FSquaresX: Integer;
    FSquaresY: Integer;
    FSquareLength: Single;
    FMarkerLength: Single;
    FDictionaryId: Integer;
    procedure ReleaseHandle;
    procedure CreateOwned(const squaresX, squaresY: Integer; const squareLength, markerLength: Single;
      const dictionaryId: Integer);
  public
    class operator Initialize(out Dest: TCVCharucoBoard);
    class operator Finalize(var Dest: TCVCharucoBoard);
    class operator Assign(var Dest: TCVCharucoBoard; const [ref] Src: TCVCharucoBoard);
    class function Create(const squaresX, squaresY: Integer; const squareLength, markerLength: Single;
      const dictionaryId: Integer = DICT_4X4_50): TCVCharucoBoard; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVCharucoBoard; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure generateImage(const outWidth, outHeight, marginSize, borderBits: Integer; const img: Pointer);
  end;

  TCVCharucoDetector = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FBoardHandle: Pointer;
    procedure ReleaseHandle;
  public
    class operator Initialize(out Dest: TCVCharucoDetector);
    class operator Finalize(var Dest: TCVCharucoDetector);
    class operator Assign(var Dest: TCVCharucoDetector; const [ref] Src: TCVCharucoDetector);
    class function Create(const board: TCVCharucoBoard): TCVCharucoDetector; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVCharucoDetector; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure detectBoard(const image, charucoCorners, charucoIds, markerCorners, markerIds: Pointer);
  end;

  TCVFaceDetectorYN = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FModelPath: AnsiString;
    FConfigPath: AnsiString;
    FInputSize: TCVSize;
    FScoreThreshold: Single;
    FNmsThreshold: Single;
    FTopK: Integer;
    FBackendId: Integer;
    FTargetId: Integer;
    procedure ReleaseHandle;
    procedure CreateOwned;
  public
    class operator Initialize(out Dest: TCVFaceDetectorYN);
    class operator Finalize(var Dest: TCVFaceDetectorYN);
    class operator Assign(var Dest: TCVFaceDetectorYN; const [ref] Src: TCVFaceDetectorYN);
    class function Create(const modelPath: PAnsiChar; const configPath: PAnsiChar;
      const inputSize: TCVSize; const scoreThreshold: Single = 0.9; const nmsThreshold: Single = 0.3;
      const topK: Integer = 5000; const backendId: Integer = DNN_BACKEND_DEFAULT;
      const targetId: Integer = DNN_TARGET_CPU): TCVFaceDetectorYN; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVFaceDetectorYN; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure setInputSize(const inputSize: TCVSize);
    function getInputSize: TCVSize;
    procedure setScoreThreshold(const scoreThreshold: Single);
    function getScoreThreshold: Single;
    procedure setNMSThreshold(const nmsThreshold: Single);
    function getNMSThreshold: Single;
    procedure setTopK(const topK: Integer);
    function getTopK: Integer;
    function detect(const image: Pointer; const faces: Pointer): Integer;
  end;

  TCVFaceRecognizerSF = record
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
    class operator Initialize(out Dest: TCVFaceRecognizerSF);
    class operator Finalize(var Dest: TCVFaceRecognizerSF);
    class operator Assign(var Dest: TCVFaceRecognizerSF; const [ref] Src: TCVFaceRecognizerSF);
    class function Create(const modelPath, configPath: PAnsiChar;
      const backendId: Integer = DNN_BACKEND_DEFAULT;
      const targetId: Integer = DNN_TARGET_CPU): TCVFaceRecognizerSF; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVFaceRecognizerSF; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure alignCrop(const srcImg, faceBox, alignedImg: Pointer);
    procedure feature(const alignedImg, faceFeature: Pointer);
    function match(const feature1, feature2: Pointer; const disType: Integer = FR_COSINE): Double;
  end;

function findChessboardCorners(const image: Pointer; const patternSize: TCVSize; const corners: Pointer;
  const flags: Integer): Boolean;
function findChessboardCornersSB(const image: Pointer; const patternSize: TCVSize; const corners: Pointer;
  const flags: Integer; const meta: Pointer = nil): Boolean;
function checkChessboard(const img: Pointer; const size: TCVSize): Boolean;
procedure drawChessboardCorners(const image: Pointer; const patternSize: TCVSize; const corners: Pointer;
  const patternWasFound: Boolean);
function find4QuadCornerSubpix(const img, corners: Pointer; const regionSize: TCVSize): Boolean;
function estimateChessboardSharpness(const image: Pointer; const patternSize: TCVSize; const corners: Pointer;
  const riseDistance: Single; const vertical: Boolean; const sharpness: Pointer; out avgSharpness: TCVScalar): Boolean;
function findCirclesGrid(const image: Pointer; const patternSize: TCVSize; const centers: Pointer;
  const flags: Integer): Boolean;
function findCirclesGridEx(const image: Pointer; const patternSize: TCVSize; const centers: Pointer;
  const flags: Integer; const minArea, maxArea, minCircularity: Single): Boolean;

procedure generateArucoMarker(const dictionaryId: Integer; const markerId: Integer; const sidePixels: Integer;
  const outImage: Pointer); overload;
procedure generateArucoMarker(const dictionaryId, markerId, sidePixels, borderBits: Integer;
  const outImage: Pointer); overload;
procedure drawDetectedMarkers(const image, corners, ids: Pointer); overload;
procedure drawDetectedMarkers(const image, corners, ids: Pointer; const borderColor: TCVScalar); overload;
procedure drawDetectedCornersCharuco(const image, charucoCorners, charucoIds: Pointer); overload;
procedure drawDetectedCornersCharuco(const image, charucoCorners, charucoIds: Pointer;
  const cornerColor: TCVScalar); overload;
procedure encodeQRCode(const text: PAnsiChar; const qrcode: Pointer);

procedure drawDetectedFaces(const image: Pointer; const faces: TCVMat); overload;
procedure drawDetectedFaces(const image: Pointer; const faces: TCVMat;
  const boxColor, landmarkColor: TCVScalar); overload;

function ReadFaceFloat(const Faces: TCVMat; const Row, Col: Integer): Single;

function ResolveFaceDetectorModelPath(const OverridePath: string = ''): string;
function ResolveFaceRecognizerModelPath(const OverridePath: string = ''): string;
function FaceDetectorModelMissingHint: string;
function FaceRecognizerModelMissingHint: string;

procedure SplitNullSeparatedStrings(const Buffer: AnsiString; List: TStrings);

implementation

uses
  OpenCV5.Imgproc;

const
  MAX_DECODE_TEXT = 65536;

procedure SplitNullSeparatedStrings(const Buffer: AnsiString; List: TStrings);
var
  P, Start: PAnsiChar;
  S: string;
begin
  List.Clear;
  if Buffer = '' then
    Exit;
  Start := PAnsiChar(Buffer);
  P := Start;
  while P^ <> #0 do
  begin
    S := string(P);
    List.Add(S);
    Inc(P, Length(S) + 1);
    if P >= Start + Length(Buffer) then
      Break;
  end;
end;

function Objdetect_findChessboardCorners(image, patternSize, corners: Pointer; flags: Integer): Boolean; stdcall; external OpenCVLib delayed;
function Objdetect_findChessboardCornersSB(image, patternSize, corners: Pointer; flags: Integer; meta: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function Objdetect_checkChessboard(img, size: Pointer): Boolean; stdcall; external OpenCVLib delayed;
procedure Objdetect_drawChessboardCorners(image, patternSize, corners: Pointer; patternWasFound: Boolean); stdcall; external OpenCVLib delayed;
function Objdetect_find4QuadCornerSubpix(img, corners, regionSize: Pointer): Boolean; stdcall; external OpenCVLib delayed;
procedure Objdetect_estimateChessboardSharpness(image, patternSize, corners: Pointer; riseDistance: Single;
  vertical: Boolean; sharpness: Pointer; outScalar: PDouble); stdcall; external OpenCVLib delayed;
function Objdetect_findCirclesGrid(image, patternSize, centers: Pointer; flags: Integer): Boolean; stdcall; external OpenCVLib delayed;
function Objdetect_findCirclesGridEx(image, patternSize, centers: Pointer; flags: Integer;
  minArea, maxArea, minCircularity: Single): Boolean; stdcall; external OpenCVLib delayed;
procedure Objdetect_ArucoDetector_refineDetectedMarkers(self, image, board, markerCorners, ids,
  rejectedImgPoints, cameraMatrix, distCoeffs: Pointer); stdcall; external OpenCVLib delayed;

function Objdetect_QRCodeDetector_Create(): Pointer; stdcall; external OpenCVLib delayed;
procedure Objdetect_QRCodeDetector_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Objdetect_QRCodeDetector_setEpsX(self: Pointer; epsX: Double); stdcall; external OpenCVLib delayed;
procedure Objdetect_QRCodeDetector_setEpsY(self: Pointer; epsY: Double); stdcall; external OpenCVLib delayed;
procedure Objdetect_QRCodeDetector_setUseAlignmentMarkers(self: Pointer; useAlignmentMarkers: Boolean); stdcall; external OpenCVLib delayed;
function Objdetect_QRCodeDetector_detect(self, img, points: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function Objdetect_QRCodeDetector_detectMulti(self, img, points: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function Objdetect_QRCodeDetector_decode(self, img, points: Pointer; textBuffer: PAnsiChar; textBufferSize: Integer;
  straightQrcode: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function Objdetect_QRCodeDetector_decodeMulti(self, img, points: Pointer; textBuffer: PAnsiChar;
  textBufferSize: Integer): Integer; stdcall; external OpenCVLib delayed;
function Objdetect_QRCodeDetector_detectAndDecode(self, img, points: Pointer; textBuffer: PAnsiChar;
  textBufferSize: Integer): Boolean; stdcall; external OpenCVLib delayed;
function Objdetect_QRCodeDetector_detectAndDecodeMulti(self, img, points: Pointer; textBuffer: PAnsiChar;
  textBufferSize: Integer): Integer; stdcall; external OpenCVLib delayed;
function Objdetect_QRCodeDetector_detectAndDecodeCurved(self, img, points: Pointer; textBuffer: PAnsiChar;
  textBufferSize: Integer; straightQrcode: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function Objdetect_QRCodeDetector_getEncoding(self: Pointer; codeIdx: Integer): Integer; stdcall; external OpenCVLib delayed;

function Objdetect_BarcodeDetector_Create(): Pointer; stdcall; external OpenCVLib delayed;
procedure Objdetect_BarcodeDetector_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function Objdetect_BarcodeDetector_detect(self, img, points: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function Objdetect_BarcodeDetector_decodeWithType(self, img, points: Pointer; textBuffer: PAnsiChar;
  textBufferSize: Integer; typeBuffer: PAnsiChar; typeBufferSize: Integer): Boolean; stdcall; external OpenCVLib delayed;
function Objdetect_BarcodeDetector_detectAndDecodeWithType(self, img: Pointer; textBuffer: PAnsiChar;
  textBufferSize: Integer; typeBuffer: PAnsiChar; typeBufferSize: Integer; points: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function Objdetect_BarcodeDetector_getDownsamplingThreshold(self: Pointer): Double; stdcall; external OpenCVLib delayed;
procedure Objdetect_BarcodeDetector_setDownsamplingThreshold(self: Pointer; thresh: Double); stdcall; external OpenCVLib delayed;
function Objdetect_BarcodeDetector_getGradientThreshold(self: Pointer): Double; stdcall; external OpenCVLib delayed;
procedure Objdetect_BarcodeDetector_setGradientThreshold(self: Pointer; thresh: Double); stdcall; external OpenCVLib delayed;

function Objdetect_ArucoDetector_Create(dictionaryId: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Objdetect_ArucoDetector_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function Objdetect_ArucoDetector_detectMarkers(self, image, markerCorners, ids: Pointer): Integer; stdcall; external OpenCVLib delayed;
function Objdetect_ArucoDetector_detectMarkersEx(self, image, markerCorners, ids, rejectedImgPoints: Pointer): Integer; stdcall; external OpenCVLib delayed;
procedure Objdetect_generateArucoMarker(dictionaryId, markerId, sidePixels: Integer; outImage: Pointer); stdcall; external OpenCVLib delayed;
procedure Objdetect_generateArucoMarkerEx(dictionaryId, markerId, sidePixels, borderBits: Integer; outImage: Pointer); stdcall; external OpenCVLib delayed;
procedure Objdetect_drawDetectedMarkers(image, corners, ids: Pointer; borderB, borderG, borderR: Double); stdcall; external OpenCVLib delayed;
procedure Objdetect_drawDetectedCornersCharuco(image, charucoCorners, charucoIds: Pointer;
  colorB, colorG, colorR: Double); stdcall; external OpenCVLib delayed;
procedure Objdetect_encodeQRCode(text: PAnsiChar; qrcode: Pointer); stdcall; external OpenCVLib delayed;

function Objdetect_QRCodeEncoder_Create(version, correctionLevel, mode: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Objdetect_QRCodeEncoder_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Objdetect_QRCodeEncoder_encode(self: Pointer; text: PAnsiChar; qrcode: Pointer); stdcall; external OpenCVLib delayed;

function Objdetect_GridBoard_Create(markersX, markersY: Integer; markerLength, markerSeparation: Single;
  dictionaryId: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Objdetect_GridBoard_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Objdetect_GridBoard_generateImage(self: Pointer; outWidth, outHeight, marginSize, borderBits: Integer;
  img: Pointer); stdcall; external OpenCVLib delayed;

function Objdetect_CharucoBoard_Create(squaresX, squaresY: Integer; squareLength, markerLength: Single;
  dictionaryId: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Objdetect_CharucoBoard_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Objdetect_CharucoBoard_generateImage(self: Pointer; outWidth, outHeight, marginSize, borderBits: Integer;
  img: Pointer); stdcall; external OpenCVLib delayed;

function Objdetect_CharucoDetector_Create(board: Pointer): Pointer; stdcall; external OpenCVLib delayed;
procedure Objdetect_CharucoDetector_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Objdetect_CharucoDetector_detectBoard(self, image, charucoCorners, charucoIds, markerCorners,
  markerIds: Pointer); stdcall; external OpenCVLib delayed;

function Objdetect_FaceDetectorYN_Create(model, config: PAnsiChar; inputSize: Pointer; scoreThreshold: Single;
  nmsThreshold: Single; topK, backendId, targetId: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Objdetect_FaceDetectorYN_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Objdetect_FaceDetectorYN_setInputSize(self: Pointer; inputSize: Pointer); stdcall; external OpenCVLib delayed;
function Objdetect_FaceDetectorYN_getInputSize(self: Pointer): TCVSize; stdcall; external OpenCVLib delayed;
procedure Objdetect_FaceDetectorYN_setScoreThreshold(self: Pointer; scoreThreshold: Single); stdcall; external OpenCVLib delayed;
function Objdetect_FaceDetectorYN_getScoreThreshold(self: Pointer): Single; stdcall; external OpenCVLib delayed;
procedure Objdetect_FaceDetectorYN_setNMSThreshold(self: Pointer; nmsThreshold: Single); stdcall; external OpenCVLib delayed;
function Objdetect_FaceDetectorYN_getNMSThreshold(self: Pointer): Single; stdcall; external OpenCVLib delayed;
procedure Objdetect_FaceDetectorYN_setTopK(self: Pointer; topK: Integer); stdcall; external OpenCVLib delayed;
function Objdetect_FaceDetectorYN_getTopK(self: Pointer): Integer; stdcall; external OpenCVLib delayed;
function Objdetect_FaceDetectorYN_detect(self, image, faces: Pointer): Integer; stdcall; external OpenCVLib delayed;

function Objdetect_FaceRecognizerSF_Create(model, config: PAnsiChar; backendId, targetId: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Objdetect_FaceRecognizerSF_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Objdetect_FaceRecognizerSF_alignCrop(self, srcImg, faceBox, alignedImg: Pointer); stdcall; external OpenCVLib delayed;
procedure Objdetect_FaceRecognizerSF_feature(self, alignedImg, faceFeature: Pointer); stdcall; external OpenCVLib delayed;
function Objdetect_FaceRecognizerSF_match(self, feature1, feature2: Pointer; disType: Integer): Double; stdcall; external OpenCVLib delayed;

function findChessboardCorners(const image: Pointer; const patternSize: TCVSize; const corners: Pointer;
  const flags: Integer): Boolean;
begin
  Result := Objdetect_findChessboardCorners(image, @patternSize, corners, flags);
end;

function findChessboardCornersSB(const image: Pointer; const patternSize: TCVSize; const corners: Pointer;
  const flags: Integer; const meta: Pointer): Boolean;
begin
  Result := Objdetect_findChessboardCornersSB(image, @patternSize, corners, flags, meta);
end;

function checkChessboard(const img: Pointer; const size: TCVSize): Boolean;
begin
  Result := Objdetect_checkChessboard(img, @size);
end;

procedure drawChessboardCorners(const image: Pointer; const patternSize: TCVSize; const corners: Pointer;
  const patternWasFound: Boolean);
begin
  Objdetect_drawChessboardCorners(image, @patternSize, corners, patternWasFound);
end;

function find4QuadCornerSubpix(const img, corners: Pointer; const regionSize: TCVSize): Boolean;
begin
  Result := Objdetect_find4QuadCornerSubpix(img, corners, @regionSize);
end;

function estimateChessboardSharpness(const image: Pointer; const patternSize: TCVSize; const corners: Pointer;
  const riseDistance: Single; const vertical: Boolean; const sharpness: Pointer; out avgSharpness: TCVScalar): Boolean;
var
  S: array[0..3] of Double;
begin
  Objdetect_estimateChessboardSharpness(image, @patternSize, corners, riseDistance, vertical, sharpness, @S[0]);
  avgSharpness := TCVScalar.Create(S[0], S[1], S[2], S[3]);
  Result := S[0] > 0;
end;

function findCirclesGrid(const image: Pointer; const patternSize: TCVSize; const centers: Pointer;
  const flags: Integer): Boolean;
begin
  Result := Objdetect_findCirclesGrid(image, @patternSize, centers, flags);
end;

function findCirclesGridEx(const image: Pointer; const patternSize: TCVSize; const centers: Pointer;
  const flags: Integer; const minArea, maxArea, minCircularity: Single): Boolean;
begin
  Result := Objdetect_findCirclesGridEx(image, @patternSize, centers, flags, minArea, maxArea, minCircularity);
end;

procedure generateArucoMarker(const dictionaryId: Integer; const markerId: Integer; const sidePixels: Integer;
  const outImage: Pointer);
begin
  Objdetect_generateArucoMarker(dictionaryId, markerId, sidePixels, outImage);
end;

procedure generateArucoMarker(const dictionaryId, markerId, sidePixels, borderBits: Integer;
  const outImage: Pointer);
begin
  Objdetect_generateArucoMarkerEx(dictionaryId, markerId, sidePixels, borderBits, outImage);
end;

procedure drawDetectedMarkers(const image, corners, ids: Pointer);
begin
  drawDetectedMarkers(image, corners, ids, TCVScalar.Create(0, 255, 0));
end;

procedure drawDetectedMarkers(const image, corners, ids: Pointer; const borderColor: TCVScalar);
begin
  Objdetect_drawDetectedMarkers(image, corners, ids, borderColor.V0, borderColor.V1, borderColor.V2);
end;

procedure drawDetectedCornersCharuco(const image, charucoCorners, charucoIds: Pointer);
begin
  drawDetectedCornersCharuco(image, charucoCorners, charucoIds, TCVScalar.Create(255, 0, 0));
end;

procedure drawDetectedCornersCharuco(const image, charucoCorners, charucoIds: Pointer;
  const cornerColor: TCVScalar);
begin
  Objdetect_drawDetectedCornersCharuco(image, charucoCorners, charucoIds, cornerColor.V0, cornerColor.V1, cornerColor.V2);
end;

procedure encodeQRCode(const text: PAnsiChar; const qrcode: Pointer);
begin
  Objdetect_encodeQRCode(text, qrcode);
end;

{ TCVQRCodeDetector }

procedure TCVQRCodeDetector.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Objdetect_QRCodeDetector_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

class operator TCVQRCodeDetector.Initialize(out Dest: TCVQRCodeDetector);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
end;

class operator TCVQRCodeDetector.Finalize(var Dest: TCVQRCodeDetector);
begin
  Dest.ReleaseHandle;
end;

class operator TCVQRCodeDetector.Assign(var Dest: TCVQRCodeDetector; const [ref] Src: TCVQRCodeDetector);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  if Src.FOwnsHandle and (Src.FHandle <> nil) then
  begin
    Dest.FHandle := Objdetect_QRCodeDetector_Create;
    Dest.FOwnsHandle := True;
  end
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVQRCodeDetector.Create: TCVQRCodeDetector;
begin
  Result.FHandle := Objdetect_QRCodeDetector_Create;
  Result.FOwnsHandle := True;
end;

class function TCVQRCodeDetector.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVQRCodeDetector;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
end;

procedure TCVQRCodeDetector.Release;
begin
  ReleaseHandle;
end;

procedure TCVQRCodeDetector.setEpsX(const epsX: Double);
begin
  Objdetect_QRCodeDetector_setEpsX(FHandle, epsX);
end;

procedure TCVQRCodeDetector.setEpsY(const epsY: Double);
begin
  Objdetect_QRCodeDetector_setEpsY(FHandle, epsY);
end;

procedure TCVQRCodeDetector.setUseAlignmentMarkers(const useAlignmentMarkers: Boolean);
begin
  Objdetect_QRCodeDetector_setUseAlignmentMarkers(FHandle, useAlignmentMarkers);
end;

function TCVQRCodeDetector.detect(const img: Pointer; const points: Pointer): Boolean;
begin
  Result := Objdetect_QRCodeDetector_detect(FHandle, img, points);
end;

function TCVQRCodeDetector.detectMulti(const img: Pointer; const points: Pointer): Boolean;
begin
  Result := Objdetect_QRCodeDetector_detectMulti(FHandle, img, points);
end;

function TCVQRCodeDetector.decode(const img, points, straightQrcode: Pointer; out Text: string): Boolean;
var
  Buf: array[0..MAX_DECODE_TEXT - 1] of AnsiChar;
begin
  Result := Objdetect_QRCodeDetector_decode(FHandle, img, points, @Buf[0], MAX_DECODE_TEXT, straightQrcode);
  Text := string(AnsiString(Buf));
end;

function TCVQRCodeDetector.decodeMulti(const img, points: Pointer; Texts: TStrings): Integer;
var
  Buf: array[0..MAX_DECODE_TEXT - 1] of AnsiChar;
begin
  Result := Objdetect_QRCodeDetector_decodeMulti(FHandle, img, points, @Buf[0], MAX_DECODE_TEXT);
  SplitNullSeparatedStrings(AnsiString(Buf), Texts);
end;

function TCVQRCodeDetector.detectAndDecode(const img: Pointer; const points: Pointer; out Text: string): Boolean;
var
  Buf: array[0..MAX_DECODE_TEXT - 1] of AnsiChar;
begin
  Result := Objdetect_QRCodeDetector_detectAndDecode(FHandle, img, points, @Buf[0], MAX_DECODE_TEXT);
  Text := string(AnsiString(Buf));
end;

function TCVQRCodeDetector.detectAndDecodeMulti(const img: Pointer; const points: Pointer; Texts: TStrings): Integer;
var
  Buf: array[0..MAX_DECODE_TEXT - 1] of AnsiChar;
begin
  Result := Objdetect_QRCodeDetector_detectAndDecodeMulti(FHandle, img, points, @Buf[0], MAX_DECODE_TEXT);
  SplitNullSeparatedStrings(AnsiString(Buf), Texts);
end;

function TCVQRCodeDetector.detectAndDecodeCurved(const img, points, straightQrcode: Pointer; out Text: string): Boolean;
var
  Buf: array[0..MAX_DECODE_TEXT - 1] of AnsiChar;
begin
  Result := Objdetect_QRCodeDetector_detectAndDecodeCurved(FHandle, img, points, @Buf[0], MAX_DECODE_TEXT, straightQrcode);
  Text := string(AnsiString(Buf));
end;

function TCVQRCodeDetector.getEncoding(const codeIdx: Integer): Integer;
begin
  Result := Objdetect_QRCodeDetector_getEncoding(FHandle, codeIdx);
end;

{ TCVBarcodeDetector }

procedure TCVBarcodeDetector.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Objdetect_BarcodeDetector_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

class operator TCVBarcodeDetector.Initialize(out Dest: TCVBarcodeDetector);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
end;

class operator TCVBarcodeDetector.Finalize(var Dest: TCVBarcodeDetector);
begin
  Dest.ReleaseHandle;
end;

class operator TCVBarcodeDetector.Assign(var Dest: TCVBarcodeDetector; const [ref] Src: TCVBarcodeDetector);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  if Src.FOwnsHandle and (Src.FHandle <> nil) then
  begin
    Dest.FHandle := Objdetect_BarcodeDetector_Create;
    Dest.FOwnsHandle := True;
  end
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVBarcodeDetector.Create: TCVBarcodeDetector;
begin
  Result.FHandle := Objdetect_BarcodeDetector_Create;
  Result.FOwnsHandle := True;
end;

class function TCVBarcodeDetector.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVBarcodeDetector;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
end;

procedure TCVBarcodeDetector.Release;
begin
  ReleaseHandle;
end;

function TCVBarcodeDetector.detect(const img: Pointer; const points: Pointer): Boolean;
begin
  Result := Objdetect_BarcodeDetector_detect(FHandle, img, points);
end;

function TCVBarcodeDetector.decodeWithType(const img, points: Pointer; Texts, Types: TStrings): Boolean;
var
  TextBuf, TypeBuf: array[0..MAX_DECODE_TEXT - 1] of AnsiChar;
begin
  Result := Objdetect_BarcodeDetector_decodeWithType(FHandle, img, points, @TextBuf[0], MAX_DECODE_TEXT,
    @TypeBuf[0], MAX_DECODE_TEXT);
  SplitNullSeparatedStrings(AnsiString(TextBuf), Texts);
  SplitNullSeparatedStrings(AnsiString(TypeBuf), Types);
end;

function TCVBarcodeDetector.detectAndDecodeWithType(const img: Pointer; const points: Pointer;
  Texts, Types: TStrings): Boolean;
var
  TextBuf, TypeBuf: array[0..MAX_DECODE_TEXT - 1] of AnsiChar;
begin
  Result := Objdetect_BarcodeDetector_detectAndDecodeWithType(FHandle, img, @TextBuf[0], MAX_DECODE_TEXT,
    @TypeBuf[0], MAX_DECODE_TEXT, points);
  SplitNullSeparatedStrings(AnsiString(TextBuf), Texts);
  SplitNullSeparatedStrings(AnsiString(TypeBuf), Types);
end;

function TCVBarcodeDetector.getDownsamplingThreshold: Double;
begin
  Result := Objdetect_BarcodeDetector_getDownsamplingThreshold(FHandle);
end;

procedure TCVBarcodeDetector.setDownsamplingThreshold(const thresh: Double);
begin
  Objdetect_BarcodeDetector_setDownsamplingThreshold(FHandle, thresh);
end;

function TCVBarcodeDetector.getGradientThreshold: Double;
begin
  Result := Objdetect_BarcodeDetector_getGradientThreshold(FHandle);
end;

procedure TCVBarcodeDetector.setGradientThreshold(const thresh: Double);
begin
  Objdetect_BarcodeDetector_setGradientThreshold(FHandle, thresh);
end;

{ TCVArucoDetector }

procedure TCVArucoDetector.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Objdetect_ArucoDetector_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVArucoDetector.CreateOwned(const dictionaryId: Integer);
begin
  ReleaseHandle;
  FDictionaryId := dictionaryId;
  FHandle := Objdetect_ArucoDetector_Create(dictionaryId);
  FOwnsHandle := True;
end;

class operator TCVArucoDetector.Initialize(out Dest: TCVArucoDetector);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FDictionaryId := DICT_4X4_50;
end;

class operator TCVArucoDetector.Finalize(var Dest: TCVArucoDetector);
begin
  Dest.ReleaseHandle;
end;

class operator TCVArucoDetector.Assign(var Dest: TCVArucoDetector; const [ref] Src: TCVArucoDetector);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FDictionaryId := Src.FDictionaryId;
  if Src.FOwnsHandle and (Src.FHandle <> nil) then
    Dest.CreateOwned(Src.FDictionaryId)
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVArucoDetector.Create(const dictionaryId: Integer): TCVArucoDetector;
begin
  Result.FDictionaryId := dictionaryId;
  Result.FHandle := Objdetect_ArucoDetector_Create(dictionaryId);
  Result.FOwnsHandle := True;
end;

class function TCVArucoDetector.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVArucoDetector;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FDictionaryId := DICT_4X4_50;
end;

procedure TCVArucoDetector.Release;
begin
  ReleaseHandle;
end;

function TCVArucoDetector.detectMarkers(const image, markerCorners, ids: Pointer;
  const rejectedImgPoints: Pointer): Integer;
begin
  if rejectedImgPoints <> nil then
    Result := Objdetect_ArucoDetector_detectMarkersEx(FHandle, image, markerCorners, ids, rejectedImgPoints)
  else
    Result := Objdetect_ArucoDetector_detectMarkers(FHandle, image, markerCorners, ids);
end;

procedure TCVArucoDetector.refineDetectedMarkers(const image, markerCorners, ids, rejectedImgPoints: Pointer;
  const board: TCVGridBoard; const cameraMatrix, distCoeffs: Pointer);
begin
  Objdetect_ArucoDetector_refineDetectedMarkers(FHandle, image, board.Handle, markerCorners, ids,
    rejectedImgPoints, cameraMatrix, distCoeffs);
end;

{ TCVQRCodeEncoder }

procedure TCVQRCodeEncoder.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Objdetect_QRCodeEncoder_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVQRCodeEncoder.CreateOwned(const version, correctionLevel, mode: Integer);
begin
  ReleaseHandle;
  FVersion := version;
  FCorrectionLevel := correctionLevel;
  FMode := mode;
  FHandle := Objdetect_QRCodeEncoder_Create(version, correctionLevel, mode);
  FOwnsHandle := True;
end;

class operator TCVQRCodeEncoder.Initialize(out Dest: TCVQRCodeEncoder);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FVersion := -1;
  Dest.FCorrectionLevel := QR_CORRECT_LEVEL_L;
  Dest.FMode := QR_MODE_AUTO;
end;

class operator TCVQRCodeEncoder.Finalize(var Dest: TCVQRCodeEncoder);
begin
  Dest.ReleaseHandle;
end;

class operator TCVQRCodeEncoder.Assign(var Dest: TCVQRCodeEncoder; const [ref] Src: TCVQRCodeEncoder);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FVersion := Src.FVersion;
  Dest.FCorrectionLevel := Src.FCorrectionLevel;
  Dest.FMode := Src.FMode;
  if Src.FOwnsHandle and (Src.FHandle <> nil) then
    Dest.CreateOwned(Src.FVersion, Src.FCorrectionLevel, Src.FMode)
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVQRCodeEncoder.Create(const version, correctionLevel, mode: Integer): TCVQRCodeEncoder;
begin
  Result.FVersion := version;
  Result.FCorrectionLevel := correctionLevel;
  Result.FMode := mode;
  Result.FHandle := Objdetect_QRCodeEncoder_Create(version, correctionLevel, mode);
  Result.FOwnsHandle := True;
end;

class function TCVQRCodeEncoder.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVQRCodeEncoder;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FVersion := -1;
  Result.FCorrectionLevel := QR_CORRECT_LEVEL_L;
  Result.FMode := QR_MODE_AUTO;
end;

procedure TCVQRCodeEncoder.Release;
begin
  ReleaseHandle;
end;

procedure TCVQRCodeEncoder.encode(const text: string; const qrcode: Pointer);
begin
  Objdetect_QRCodeEncoder_encode(FHandle, PAnsiChar(AnsiString(text)), qrcode);
end;

{ TCVGridBoard }

procedure TCVGridBoard.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Objdetect_GridBoard_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVGridBoard.CreateOwned(const markersX, markersY: Integer; const markerLength, markerSeparation: Single;
  const dictionaryId: Integer);
begin
  ReleaseHandle;
  FMarkersX := markersX;
  FMarkersY := markersY;
  FMarkerLength := markerLength;
  FMarkerSeparation := markerSeparation;
  FDictionaryId := dictionaryId;
  FHandle := Objdetect_GridBoard_Create(markersX, markersY, markerLength, markerSeparation, dictionaryId);
  FOwnsHandle := True;
end;

class operator TCVGridBoard.Initialize(out Dest: TCVGridBoard);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FMarkersX := 0;
  Dest.FMarkersY := 0;
  Dest.FMarkerLength := 0;
  Dest.FMarkerSeparation := 0;
  Dest.FDictionaryId := DICT_4X4_50;
end;

class operator TCVGridBoard.Finalize(var Dest: TCVGridBoard);
begin
  Dest.ReleaseHandle;
end;

class operator TCVGridBoard.Assign(var Dest: TCVGridBoard; const [ref] Src: TCVGridBoard);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FMarkersX := Src.FMarkersX;
  Dest.FMarkersY := Src.FMarkersY;
  Dest.FMarkerLength := Src.FMarkerLength;
  Dest.FMarkerSeparation := Src.FMarkerSeparation;
  Dest.FDictionaryId := Src.FDictionaryId;
  if Src.FOwnsHandle and (Src.FHandle <> nil) then
    Dest.CreateOwned(Src.FMarkersX, Src.FMarkersY, Src.FMarkerLength, Src.FMarkerSeparation, Src.FDictionaryId)
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVGridBoard.Create(const markersX, markersY: Integer; const markerLength, markerSeparation: Single;
  const dictionaryId: Integer): TCVGridBoard;
begin
  Result.FMarkersX := markersX;
  Result.FMarkersY := markersY;
  Result.FMarkerLength := markerLength;
  Result.FMarkerSeparation := markerSeparation;
  Result.FDictionaryId := dictionaryId;
  Result.FHandle := Objdetect_GridBoard_Create(markersX, markersY, markerLength, markerSeparation, dictionaryId);
  Result.FOwnsHandle := True;
end;

class function TCVGridBoard.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVGridBoard;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FMarkersX := 0;
  Result.FMarkersY := 0;
  Result.FMarkerLength := 0;
  Result.FMarkerSeparation := 0;
  Result.FDictionaryId := DICT_4X4_50;
end;

procedure TCVGridBoard.Release;
begin
  ReleaseHandle;
end;

procedure TCVGridBoard.generateImage(const outWidth, outHeight, marginSize, borderBits: Integer; const img: Pointer);
begin
  Objdetect_GridBoard_generateImage(FHandle, outWidth, outHeight, marginSize, borderBits, img);
end;

{ TCVCharucoBoard }

procedure TCVCharucoBoard.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Objdetect_CharucoBoard_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVCharucoBoard.CreateOwned(const squaresX, squaresY: Integer; const squareLength, markerLength: Single;
  const dictionaryId: Integer);
begin
  ReleaseHandle;
  FSquaresX := squaresX;
  FSquaresY := squaresY;
  FSquareLength := squareLength;
  FMarkerLength := markerLength;
  FDictionaryId := dictionaryId;
  FHandle := Objdetect_CharucoBoard_Create(squaresX, squaresY, squareLength, markerLength, dictionaryId);
  FOwnsHandle := True;
end;

class operator TCVCharucoBoard.Initialize(out Dest: TCVCharucoBoard);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FSquaresX := 0;
  Dest.FSquaresY := 0;
  Dest.FSquareLength := 0;
  Dest.FMarkerLength := 0;
  Dest.FDictionaryId := DICT_4X4_50;
end;

class operator TCVCharucoBoard.Finalize(var Dest: TCVCharucoBoard);
begin
  Dest.ReleaseHandle;
end;

class operator TCVCharucoBoard.Assign(var Dest: TCVCharucoBoard; const [ref] Src: TCVCharucoBoard);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FSquaresX := Src.FSquaresX;
  Dest.FSquaresY := Src.FSquaresY;
  Dest.FSquareLength := Src.FSquareLength;
  Dest.FMarkerLength := Src.FMarkerLength;
  Dest.FDictionaryId := Src.FDictionaryId;
  if Src.FOwnsHandle and (Src.FHandle <> nil) then
    Dest.CreateOwned(Src.FSquaresX, Src.FSquaresY, Src.FSquareLength, Src.FMarkerLength, Src.FDictionaryId)
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVCharucoBoard.Create(const squaresX, squaresY: Integer; const squareLength, markerLength: Single;
  const dictionaryId: Integer): TCVCharucoBoard;
begin
  Result.FSquaresX := squaresX;
  Result.FSquaresY := squaresY;
  Result.FSquareLength := squareLength;
  Result.FMarkerLength := markerLength;
  Result.FDictionaryId := dictionaryId;
  Result.FHandle := Objdetect_CharucoBoard_Create(squaresX, squaresY, squareLength, markerLength, dictionaryId);
  Result.FOwnsHandle := True;
end;

class function TCVCharucoBoard.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVCharucoBoard;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FSquaresX := 0;
  Result.FSquaresY := 0;
  Result.FSquareLength := 0;
  Result.FMarkerLength := 0;
  Result.FDictionaryId := DICT_4X4_50;
end;

procedure TCVCharucoBoard.Release;
begin
  ReleaseHandle;
end;

procedure TCVCharucoBoard.generateImage(const outWidth, outHeight, marginSize, borderBits: Integer; const img: Pointer);
begin
  Objdetect_CharucoBoard_generateImage(FHandle, outWidth, outHeight, marginSize, borderBits, img);
end;

{ TCVCharucoDetector }

procedure TCVCharucoDetector.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Objdetect_CharucoDetector_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

class operator TCVCharucoDetector.Initialize(out Dest: TCVCharucoDetector);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FBoardHandle := nil;
end;

class operator TCVCharucoDetector.Finalize(var Dest: TCVCharucoDetector);
begin
  Dest.ReleaseHandle;
end;

class operator TCVCharucoDetector.Assign(var Dest: TCVCharucoDetector; const [ref] Src: TCVCharucoDetector);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FBoardHandle := Src.FBoardHandle;
  if Src.FOwnsHandle and (Src.FHandle <> nil) and (Src.FBoardHandle <> nil) then
  begin
    Dest.FHandle := Objdetect_CharucoDetector_Create(Src.FBoardHandle);
    Dest.FOwnsHandle := True;
  end
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVCharucoDetector.Create(const board: TCVCharucoBoard): TCVCharucoDetector;
begin
  Result.FBoardHandle := board.Handle;
  if Result.FBoardHandle <> nil then
    Result.FHandle := Objdetect_CharucoDetector_Create(Result.FBoardHandle)
  else
    Result.FHandle := nil;
  Result.FOwnsHandle := True;
end;

class function TCVCharucoDetector.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVCharucoDetector;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FBoardHandle := nil;
end;

procedure TCVCharucoDetector.Release;
begin
  ReleaseHandle;
end;

procedure TCVCharucoDetector.detectBoard(const image, charucoCorners, charucoIds, markerCorners, markerIds: Pointer);
begin
  Objdetect_CharucoDetector_detectBoard(FHandle, image, charucoCorners, charucoIds, markerCorners, markerIds);
end;

{ TCVFaceDetectorYN }

procedure TCVFaceDetectorYN.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Objdetect_FaceDetectorYN_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVFaceDetectorYN.CreateOwned;
begin
  ReleaseHandle;
  FHandle := Objdetect_FaceDetectorYN_Create(PAnsiChar(FModelPath), PAnsiChar(FConfigPath), @FInputSize,
    FScoreThreshold, FNmsThreshold, FTopK, FBackendId, FTargetId);
  FOwnsHandle := True;
end;

class operator TCVFaceDetectorYN.Initialize(out Dest: TCVFaceDetectorYN);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FModelPath := '';
  Dest.FConfigPath := '';
  Dest.FInputSize := TCVSize.Create(0, 0);
  Dest.FScoreThreshold := 0.9;
  Dest.FNmsThreshold := 0.3;
  Dest.FTopK := 5000;
  Dest.FBackendId := DNN_BACKEND_DEFAULT;
  Dest.FTargetId := DNN_TARGET_CPU;
end;

class operator TCVFaceDetectorYN.Finalize(var Dest: TCVFaceDetectorYN);
begin
  Dest.ReleaseHandle;
end;

class operator TCVFaceDetectorYN.Assign(var Dest: TCVFaceDetectorYN; const [ref] Src: TCVFaceDetectorYN);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FModelPath := Src.FModelPath;
  Dest.FConfigPath := Src.FConfigPath;
  Dest.FInputSize := Src.FInputSize;
  Dest.FScoreThreshold := Src.FScoreThreshold;
  Dest.FNmsThreshold := Src.FNmsThreshold;
  Dest.FTopK := Src.FTopK;
  Dest.FBackendId := Src.FBackendId;
  Dest.FTargetId := Src.FTargetId;
  if Src.FOwnsHandle and (Src.FHandle <> nil) then
    Dest.CreateOwned
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVFaceDetectorYN.Create(const modelPath, configPath: PAnsiChar; const inputSize: TCVSize;
  const scoreThreshold, nmsThreshold: Single; const topK, backendId, targetId: Integer): TCVFaceDetectorYN;
begin
  if modelPath <> nil then
    Result.FModelPath := modelPath
  else
    Result.FModelPath := '';
  if configPath <> nil then
    Result.FConfigPath := configPath
  else
    Result.FConfigPath := '';
  Result.FInputSize := inputSize;
  Result.FScoreThreshold := scoreThreshold;
  Result.FNmsThreshold := nmsThreshold;
  Result.FTopK := topK;
  Result.FBackendId := backendId;
  Result.FTargetId := targetId;
  Result.FHandle := Objdetect_FaceDetectorYN_Create(PAnsiChar(Result.FModelPath), PAnsiChar(Result.FConfigPath),
    @inputSize, scoreThreshold, nmsThreshold, topK, backendId, targetId);
  Result.FOwnsHandle := True;
end;

class function TCVFaceDetectorYN.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVFaceDetectorYN;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FModelPath := '';
  Result.FConfigPath := '';
  Result.FInputSize := TCVSize.Create(0, 0);
  Result.FScoreThreshold := 0.9;
  Result.FNmsThreshold := 0.3;
  Result.FTopK := 5000;
  Result.FBackendId := DNN_BACKEND_DEFAULT;
  Result.FTargetId := DNN_TARGET_CPU;
end;

procedure TCVFaceDetectorYN.Release;
begin
  ReleaseHandle;
end;

procedure TCVFaceDetectorYN.setInputSize(const inputSize: TCVSize);
begin
  FInputSize := inputSize;
  Objdetect_FaceDetectorYN_setInputSize(FHandle, @inputSize);
end;

function TCVFaceDetectorYN.getInputSize: TCVSize;
begin
  Result := Objdetect_FaceDetectorYN_getInputSize(FHandle);
end;

procedure TCVFaceDetectorYN.setScoreThreshold(const scoreThreshold: Single);
begin
  FScoreThreshold := scoreThreshold;
  Objdetect_FaceDetectorYN_setScoreThreshold(FHandle, scoreThreshold);
end;

function TCVFaceDetectorYN.getScoreThreshold: Single;
begin
  Result := Objdetect_FaceDetectorYN_getScoreThreshold(FHandle);
end;

procedure TCVFaceDetectorYN.setNMSThreshold(const nmsThreshold: Single);
begin
  FNmsThreshold := nmsThreshold;
  Objdetect_FaceDetectorYN_setNMSThreshold(FHandle, nmsThreshold);
end;

function TCVFaceDetectorYN.getNMSThreshold: Single;
begin
  Result := Objdetect_FaceDetectorYN_getNMSThreshold(FHandle);
end;

procedure TCVFaceDetectorYN.setTopK(const topK: Integer);
begin
  FTopK := topK;
  Objdetect_FaceDetectorYN_setTopK(FHandle, topK);
end;

function TCVFaceDetectorYN.getTopK: Integer;
begin
  Result := Objdetect_FaceDetectorYN_getTopK(FHandle);
end;

function TCVFaceDetectorYN.detect(const image, faces: Pointer): Integer;
begin
  Result := Objdetect_FaceDetectorYN_detect(FHandle, image, faces);
end;

{ TCVFaceRecognizerSF }

procedure TCVFaceRecognizerSF.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Objdetect_FaceRecognizerSF_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVFaceRecognizerSF.CreateOwned;
begin
  ReleaseHandle;
  FHandle := Objdetect_FaceRecognizerSF_Create(PAnsiChar(FModelPath), PAnsiChar(FConfigPath),
    FBackendId, FTargetId);
  FOwnsHandle := True;
end;

class operator TCVFaceRecognizerSF.Initialize(out Dest: TCVFaceRecognizerSF);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FModelPath := '';
  Dest.FConfigPath := '';
  Dest.FBackendId := DNN_BACKEND_DEFAULT;
  Dest.FTargetId := DNN_TARGET_CPU;
end;

class operator TCVFaceRecognizerSF.Finalize(var Dest: TCVFaceRecognizerSF);
begin
  Dest.ReleaseHandle;
end;

class operator TCVFaceRecognizerSF.Assign(var Dest: TCVFaceRecognizerSF; const [ref] Src: TCVFaceRecognizerSF);
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

class function TCVFaceRecognizerSF.Create(const modelPath, configPath: PAnsiChar;
  const backendId, targetId: Integer): TCVFaceRecognizerSF;
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
  Result.FHandle := Objdetect_FaceRecognizerSF_Create(PAnsiChar(Result.FModelPath),
    PAnsiChar(Result.FConfigPath), backendId, targetId);
  Result.FOwnsHandle := True;
end;

class function TCVFaceRecognizerSF.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVFaceRecognizerSF;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FModelPath := '';
  Result.FConfigPath := '';
  Result.FBackendId := DNN_BACKEND_DEFAULT;
  Result.FTargetId := DNN_TARGET_CPU;
end;

procedure TCVFaceRecognizerSF.Release;
begin
  ReleaseHandle;
end;

procedure TCVFaceRecognizerSF.alignCrop(const srcImg, faceBox, alignedImg: Pointer);
begin
  Objdetect_FaceRecognizerSF_alignCrop(FHandle, srcImg, faceBox, alignedImg);
end;

procedure TCVFaceRecognizerSF.feature(const alignedImg, faceFeature: Pointer);
begin
  Objdetect_FaceRecognizerSF_feature(FHandle, alignedImg, faceFeature);
end;

function TCVFaceRecognizerSF.match(const feature1, feature2: Pointer; const disType: Integer): Double;
begin
  Result := Objdetect_FaceRecognizerSF_match(FHandle, feature1, feature2, disType);
end;

function ReadFaceFloat(const Faces: TCVMat; const Row, Col: Integer): Single;
begin
  Result := PSingle(Faces.ptr(Row, Col))^;
end;

procedure drawDetectedFaces(const image: Pointer; const faces: TCVMat);
begin
  drawDetectedFaces(image, faces, TCVScalar.Create(0, 255, 0), TCVScalar.Create(255, 0, 0));
end;

procedure drawDetectedFaces(const image: Pointer; const faces: TCVMat;
  const boxColor, landmarkColor: TCVScalar);
var
  I, L: Integer;
  X, Y, W, H: Integer;
  Pt: TCVPoint;
begin
  for I := 0 to faces.rows - 1 do
  begin
    X := Trunc(ReadFaceFloat(faces, I, FACE_IDX_X));
    Y := Trunc(ReadFaceFloat(faces, I, FACE_IDX_Y));
    W := Trunc(ReadFaceFloat(faces, I, FACE_IDX_W));
    H := Trunc(ReadFaceFloat(faces, I, FACE_IDX_H));
    rectangle(image, TCVPoint.Create(X, Y), TCVPoint.Create(X + W, Y + H), boxColor, 2, LINE_8, 0);
    for L := 0 to 4 do
    begin
      Pt.X := Trunc(ReadFaceFloat(faces, I, 4 + 2 * L));
      Pt.Y := Trunc(ReadFaceFloat(faces, I, 5 + 2 * L));
      circle(image, Pt, 2, landmarkColor, FILLED, LINE_8, 0);
    end;
  end;
end;

function ResolveFaceDetectorModelPath(const OverridePath: string): string;
const
  CANDIDATES: array[0..4] of string = (
    'models\face_detection_yunet_2026may.onnx',
    'models\face_detection_yunet_2023mar.onnx',
    'models\face_detection_yunet_2023mar_int8.onnx',
    'models\face_detection_yunet_2023mar_int8bq.onnx',
    'models\yunet-202303.onnx');
var
  I: Integer;
begin
  if (OverridePath <> '') and FileExists(OverridePath) then
    Exit(OverridePath);
  for I := Low(CANDIDATES) to High(CANDIDATES) do
    if FileExists(CANDIDATES[I]) then
      Exit(CANDIDATES[I]);
  if OverridePath <> '' then
    Result := OverridePath
  else
    Result := FACE_MODEL_DEFAULT;
end;

function FaceDetectorModelMissingHint: string;
begin
  Result :=
    'Download a YuNet ONNX model from ' + FACE_MODEL_ZOO_URL + sLineBreak +
    'Recommended for OpenCV 5.0 (webcam, any resolution):' + sLineBreak +
    '  ' + FACE_MODEL_YUNET_2026 + sLineBreak +
    'Fixed input shape (photos, OpenCV 4.x style DNN):' + sLineBreak +
    '  ' + FACE_MODEL_YUNET_2023 + sLineBreak +
    'Quantized variants:' + sLineBreak +
    '  ' + FACE_MODEL_YUNET_2023_INT8 + sLineBreak +
    '  ' + FACE_MODEL_YUNET_2023_INT8BQ;
end;

function ResolveFaceRecognizerModelPath(const OverridePath: string): string;
const
  CANDIDATES: array[0..1] of string = (
    'models\face_recognition_sface_2021dec.onnx',
    'models\face_recognition_sface_2021dec_int8.onnx');
var
  I: Integer;
begin
  if (OverridePath <> '') and FileExists(OverridePath) then
    Exit(OverridePath);
  for I := Low(CANDIDATES) to High(CANDIDATES) do
    if FileExists(CANDIDATES[I]) then
      Exit(CANDIDATES[I]);
  if OverridePath <> '' then
    Result := OverridePath
  else
    Result := FACE_REC_MODEL_DEFAULT;
end;

function FaceRecognizerModelMissingHint: string;
begin
  Result :=
    'Download SFace ONNX from ' + FACE_REC_MODEL_ZOO_URL + sLineBreak +
    'Recommended:' + sLineBreak +
    '  ' + FACE_REC_MODEL_DEFAULT;
end;

end.
