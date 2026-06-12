unit OpenCV5.Calib3d;

interface

uses
  OpenCV5.Core,
  OpenCV5.Types;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

  CALIB_USE_INTRINSIC_GUESS = $00001;
  CALIB_FIX_ASPECT_RATIO = $00002;
  CALIB_FIX_PRINCIPAL_POINT = $00004;
  CALIB_ZERO_TANGENT_DIST = $00008;
  CALIB_FIX_FOCAL_LENGTH = $00010;
  CALIB_FIX_K1 = $00020;
  CALIB_FIX_K2 = $00040;
  CALIB_FIX_K3 = $00080;
  CALIB_FIX_K4 = $00800;
  CALIB_FIX_K5 = $01000;
  CALIB_FIX_K6 = $02000;

  SOLVEPNP_ITERATIVE = 0;
  SOLVEPNP_EPNP = 1;
  SOLVEPNP_P3P = 2;
  SOLVEPNP_AP3P = 3;
  SOLVEPNP_IPPE = 4;
  SOLVEPNP_IPPE_SQUARE = 5;
  SOLVEPNP_SQPNP = 6;

  FM_7POINT = 1;
  FM_RANSAC = 8;

function BuildChessboardObjectPoints(const PatternSize: TCVSize; const SquareSize: Single): TCVMat;

function calibrateCamera(const objectPointsViews, imagePointsViews: Pointer;
  const viewCount: Integer; const imageSize: TCVSize;
  const cameraMatrix, distCoeffs, rvecsOut, tvecsOut: Pointer;
  const flags: Integer; const criteria: TCVTermCriteria): Double;

function initCameraMatrix2D(const objectPointsViews, imagePointsViews: Pointer;
  const viewCount: Integer; const imageSize: TCVSize; const aspectRatio: Double = 1.0): TCVMat;

procedure projectPoints(const objectPoints, rvec, tvec, cameraMatrix, distCoeffs,
  imagePoints: Pointer);

function solvePnP(const objectPoints, imagePoints, cameraMatrix, distCoeffs,
  rvec, tvec: Pointer; const useExtrinsicGuess: Boolean = False;
  const flags: Integer = SOLVEPNP_ITERATIVE): Boolean;

procedure undistortPoints(const distorted, undistorted, cameraMatrix, distCoeffs: Pointer;
  const R: Pointer = nil; const P: Pointer = nil);

function findHomography(const srcPoints, dstPoints: Pointer; const method: Integer;
  const ransacReprojThreshold: Double; const mask: Pointer = nil): TCVMat;

procedure Rodrigues(const src, dst: Pointer; const jacobian: Pointer = nil);

function solvePnPRansac(const objectPoints, imagePoints, cameraMatrix, distCoeffs,
  rvec, tvec: Pointer; const useExtrinsicGuess: Boolean = False;
  const iterationsCount: Integer = 100; const reprojectionError: Single = 8.0;
  const confidence: Double = 0.99; const inliers: Pointer = nil;
  const flags: Integer = SOLVEPNP_ITERATIVE): Boolean;

function stereoCalibrate(const objectPoints, imagePoints1, imagePoints2: Pointer;
  const cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2: Pointer;
  const imageSize: TCVSize; const R, T, E, F: Pointer;
  const flags: Integer; const criteria: TCVTermCriteria): Double;

function recoverPose(const points1, points2, cameraMatrix1, distCoeffs1,
  cameraMatrix2, distCoeffs2, E, R, T: Pointer;
  const method: Integer = RANSAC; const prob: Double = 0.999;
  const threshold: Double = 1.0; const mask: Pointer = nil): Integer;

procedure triangulatePoints(const projMatr1, projMatr2, projPoints1, projPoints2,
  points4D: Pointer);

function estimateAffine2D(const fromPoints, toPoints: Pointer; const inliers: Pointer = nil;
  const method: Integer = RANSAC; const ransacReprojThreshold: Double = 3.0;
  const maxIters: Integer = 2000; const confidence: Double = 0.99;
  const refineIters: Integer = 10): TCVMat;

function estimateAffinePartial2D(const fromPoints, toPoints: Pointer; const inliers: Pointer = nil;
  const method: Integer = RANSAC; const ransacReprojThreshold: Double = 3.0;
  const maxIters: Integer = 2000; const confidence: Double = 0.99;
  const refineIters: Integer = 10): TCVMat;

function findFundamentalMat(const points1, points2: Pointer; const method: Integer = FM_RANSAC;
  const ransacReprojThreshold: Double = 3.0; const confidence: Double = 0.99;
  const mask: Pointer = nil): TCVMat;

function findEssentialMat(const points1, points2, cameraMatrix: Pointer;
  const method: Integer = RANSAC; const prob: Double = 0.999;
  const threshold: Double = 1.0; const mask: Pointer = nil): TCVMat;

procedure decomposeEssentialMat(const E, R1, R2, t: Pointer);

implementation

function Calib3d_calibrateCamera(objectPointsViews, imagePointsViews: Pointer; viewCount: Integer;
  imageSize: Pointer; cameraMatrix, distCoeffs, rvecsOut, tvecsOut: Pointer;
  flags: Integer; criteria: Pointer): Double; stdcall; external OpenCVLib delayed;

function Calib3d_initCameraMatrix2D(objectPointsViews, imagePointsViews: Pointer; viewCount: Integer;
  imageSize: Pointer; aspectRatio: Double): Pointer; stdcall; external OpenCVLib delayed;

procedure Calib3d_projectPoints(objectPoints, rvec, tvec, cameraMatrix, distCoeffs,
  imagePoints: Pointer); stdcall; external OpenCVLib delayed;

function Calib3d_solvePnP(objectPoints, imagePoints, cameraMatrix, distCoeffs,
  rvec, tvec: Pointer; useExtrinsicGuess: Boolean; flags: Integer): Boolean; stdcall; external OpenCVLib delayed;

procedure Calib3d_undistortPoints(distorted, undistorted, cameraMatrix, distCoeffs,
  R, P: Pointer); stdcall; external OpenCVLib delayed;

function Calib3d_findHomography(srcPoints, dstPoints: Pointer; method: Integer;
  ransacReprojThreshold: Double; mask: Pointer): Pointer; stdcall; external OpenCVLib delayed;

procedure Calib3d_Rodrigues(src, dst, jacobian: Pointer); stdcall; external OpenCVLib delayed;

function Calib3d_solvePnPRansac(objectPoints, imagePoints, cameraMatrix, distCoeffs,
  rvec, tvec: Pointer; useExtrinsicGuess: Boolean; iterationsCount: Integer;
  reprojectionError: Single; confidence: Double; inliers: Pointer; flags: Integer): Boolean; stdcall; external OpenCVLib delayed;

function Calib3d_stereoCalibrate(objectPoints, imagePoints1, imagePoints2: Pointer;
  cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2: Pointer;
  imageSize: Pointer; R, T, E, F: Pointer; flags: Integer; criteria: Pointer): Double; stdcall; external OpenCVLib delayed;

function Calib3d_recoverPose(points1, points2, cameraMatrix1, distCoeffs1,
  cameraMatrix2, distCoeffs2, E, R, T: Pointer;
  method: Integer; prob, threshold: Double; mask: Pointer): Integer; stdcall; external OpenCVLib delayed;

procedure Calib3d_triangulatePoints(projMatr1, projMatr2, projPoints1, projPoints2,
  points4D: Pointer); stdcall; external OpenCVLib delayed;

function Calib3d_estimateAffine2D(fromPoints, toPoints, inliers: Pointer;
  method: Integer; ransacReprojThreshold: Double; maxIters: Integer;
  confidence: Double; refineIters: Integer): Pointer; stdcall; external OpenCVLib delayed;

function Calib3d_estimateAffinePartial2D(fromPoints, toPoints, inliers: Pointer;
  method: Integer; ransacReprojThreshold: Double; maxIters: Integer;
  confidence: Double; refineIters: Integer): Pointer; stdcall; external OpenCVLib delayed;

function Calib3d_findFundamentalMat(points1, points2: Pointer; method: Integer;
  ransacReprojThreshold, confidence: Double; mask: Pointer): Pointer; stdcall; external OpenCVLib delayed;

function Calib3d_findEssentialMat(points1, points2, cameraMatrix: Pointer;
  method: Integer; prob, threshold: Double; mask: Pointer): Pointer; stdcall; external OpenCVLib delayed;

procedure Calib3d_decomposeEssentialMat(E, R1, R2, t: Pointer); stdcall; external OpenCVLib delayed;

function BuildChessboardObjectPoints(const PatternSize: TCVSize; const SquareSize: Single): TCVMat;
var
  I, J, Idx: Integer;
  P: PSingle;
begin
  Result := TCVMat.Create_0(PatternSize.Width * PatternSize.Height, 1, CV_32FC3);
  Idx := 0;
  for J := 0 to PatternSize.Height - 1 do
    for I := 0 to PatternSize.Width - 1 do
    begin
      P := PSingle(Result.ptr(Idx, 0));
      P^ := I * SquareSize;
      Inc(P);
      P^ := J * SquareSize;
      Inc(P);
      P^ := 0;
      Inc(Idx);
    end;
end;

function calibrateCamera(const objectPointsViews, imagePointsViews: Pointer;
  const viewCount: Integer; const imageSize: TCVSize;
  const cameraMatrix, distCoeffs, rvecsOut, tvecsOut: Pointer;
  const flags: Integer; const criteria: TCVTermCriteria): Double;
begin
  Result := Calib3d_calibrateCamera(objectPointsViews, imagePointsViews, viewCount,
    @imageSize, cameraMatrix, distCoeffs, rvecsOut, tvecsOut, flags, @criteria);
end;

function initCameraMatrix2D(const objectPointsViews, imagePointsViews: Pointer;
  const viewCount: Integer; const imageSize: TCVSize; const aspectRatio: Double): TCVMat;
begin
  Result := TCVMat.FromHandle(Calib3d_initCameraMatrix2D(objectPointsViews, imagePointsViews,
    viewCount, @imageSize, aspectRatio));
end;

procedure projectPoints(const objectPoints, rvec, tvec, cameraMatrix, distCoeffs,
  imagePoints: Pointer);
begin
  Calib3d_projectPoints(objectPoints, rvec, tvec, cameraMatrix, distCoeffs, imagePoints);
end;

function solvePnP(const objectPoints, imagePoints, cameraMatrix, distCoeffs,
  rvec, tvec: Pointer; const useExtrinsicGuess: Boolean; const flags: Integer): Boolean;
begin
  Result := Calib3d_solvePnP(objectPoints, imagePoints, cameraMatrix, distCoeffs,
    rvec, tvec, useExtrinsicGuess, flags);
end;

procedure undistortPoints(const distorted, undistorted, cameraMatrix, distCoeffs: Pointer;
  const R, P: Pointer);
begin
  Calib3d_undistortPoints(distorted, undistorted, cameraMatrix, distCoeffs, R, P);
end;

function findHomography(const srcPoints, dstPoints: Pointer; const method: Integer;
  const ransacReprojThreshold: Double; const mask: Pointer): TCVMat;
begin
  Result := TCVMat.FromHandle(Calib3d_findHomography(srcPoints, dstPoints, method,
    ransacReprojThreshold, mask));
end;

procedure Rodrigues(const src, dst: Pointer; const jacobian: Pointer);
begin
  Calib3d_Rodrigues(src, dst, jacobian);
end;

function solvePnPRansac(const objectPoints, imagePoints, cameraMatrix, distCoeffs,
  rvec, tvec: Pointer; const useExtrinsicGuess: Boolean; const iterationsCount: Integer;
  const reprojectionError: Single; const confidence: Double; const inliers: Pointer;
  const flags: Integer): Boolean;
begin
  Result := Calib3d_solvePnPRansac(objectPoints, imagePoints, cameraMatrix, distCoeffs,
    rvec, tvec, useExtrinsicGuess, iterationsCount, reprojectionError, confidence,
    inliers, flags);
end;

function stereoCalibrate(const objectPoints, imagePoints1, imagePoints2: Pointer;
  const cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2: Pointer;
  const imageSize: TCVSize; const R, T, E, F: Pointer;
  const flags: Integer; const criteria: TCVTermCriteria): Double;
begin
  Result := Calib3d_stereoCalibrate(objectPoints, imagePoints1, imagePoints2,
    cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2, @imageSize, R, T, E, F,
    flags, @criteria);
end;

function recoverPose(const points1, points2, cameraMatrix1, distCoeffs1,
  cameraMatrix2, distCoeffs2, E, R, T: Pointer;
  const method: Integer; const prob, threshold: Double; const mask: Pointer): Integer;
begin
  Result := Calib3d_recoverPose(points1, points2, cameraMatrix1, distCoeffs1,
    cameraMatrix2, distCoeffs2, E, R, T, method, prob, threshold, mask);
end;

procedure triangulatePoints(const projMatr1, projMatr2, projPoints1, projPoints2,
  points4D: Pointer);
begin
  Calib3d_triangulatePoints(projMatr1, projMatr2, projPoints1, projPoints2, points4D);
end;

function estimateAffine2D(const fromPoints, toPoints: Pointer; const inliers: Pointer;
  const method: Integer; const ransacReprojThreshold: Double;
  const maxIters: Integer; const confidence: Double; const refineIters: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Calib3d_estimateAffine2D(fromPoints, toPoints, inliers,
    method, ransacReprojThreshold, maxIters, confidence, refineIters));
end;

function estimateAffinePartial2D(const fromPoints, toPoints: Pointer; const inliers: Pointer;
  const method: Integer; const ransacReprojThreshold: Double;
  const maxIters: Integer; const confidence: Double; const refineIters: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Calib3d_estimateAffinePartial2D(fromPoints, toPoints, inliers,
    method, ransacReprojThreshold, maxIters, confidence, refineIters));
end;

function findFundamentalMat(const points1, points2: Pointer; const method: Integer;
  const ransacReprojThreshold, confidence: Double; const mask: Pointer): TCVMat;
begin
  Result := TCVMat.FromHandle(Calib3d_findFundamentalMat(points1, points2, method,
    ransacReprojThreshold, confidence, mask));
end;

function findEssentialMat(const points1, points2, cameraMatrix: Pointer;
  const method: Integer; const prob, threshold: Double; const mask: Pointer): TCVMat;
begin
  Result := TCVMat.FromHandle(Calib3d_findEssentialMat(points1, points2, cameraMatrix,
    method, prob, threshold, mask));
end;

procedure decomposeEssentialMat(const E, R1, R2, t: Pointer);
begin
  Calib3d_decomposeEssentialMat(E, R1, R2, t);
end;

end.
