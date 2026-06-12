unit OpenCV5.Stereo;

interface

uses
  OpenCV5.Core,
  OpenCV5.Types;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

  STEREO_ZERO_DISPARITY = $00400;

procedure stereoRectify(const cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2: Pointer;
  const imageSize: TCVSize; const R, T, R1, R2, P1, P2, Q: Pointer;
  const flags: Integer = STEREO_ZERO_DISPARITY; const alpha: Double = -1;
  const newImageSize: Pointer = nil; const validPixROI1: Pointer = nil;
  const validPixROI2: Pointer = nil);

procedure reprojectImageTo3D(const disparity, image3d, Q: Pointer;
  const handleMissingValues: Boolean = False; const ddepth: Integer = -1);

type
  TCVStereoMatcher = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    procedure ReleaseHandle;
  public
    class operator Initialize(out Dest: TCVStereoMatcher);
    class operator Finalize(var Dest: TCVStereoMatcher);
    class function CreateSGBM(const minDisparity, numDisparities, blockSize: Integer): TCVStereoMatcher; static;
    class function CreateBM(const numDisparities, blockSize: Integer): TCVStereoMatcher; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure compute(const left, right, disparity: Pointer);
  end;

implementation

procedure Stereo_stereoRectify(cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2: Pointer;
  imageSize: Pointer; R, T, R1, R2, P1, P2, Q: Pointer;
  flags: Integer; alpha: Double; newImageSize: Pointer;
  validPixROI1, validPixROI2: Pointer); stdcall; external OpenCVLib delayed;

procedure Stereo_reprojectImageTo3D(disparity, image3d, Q: Pointer;
  handleMissingValues: Boolean; ddepth: Integer); stdcall; external OpenCVLib delayed;

function Stereo_SGBM_Create(minDisparity, numDisparities, blockSize: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Stereo_BM_Create(numDisparities, blockSize: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Stereo_Matcher_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Stereo_Matcher_compute(self, left, right, disparity: Pointer); stdcall; external OpenCVLib delayed;

procedure stereoRectify(const cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2: Pointer;
  const imageSize: TCVSize; const R, T, R1, R2, P1, P2, Q: Pointer;
  const flags: Integer; const alpha: Double;
  const newImageSize, validPixROI1, validPixROI2: Pointer);
begin
  Stereo_stereoRectify(cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2,
    @imageSize, R, T, R1, R2, P1, P2, Q, flags, alpha, newImageSize,
    validPixROI1, validPixROI2);
end;

procedure reprojectImageTo3D(const disparity, image3d, Q: Pointer;
  const handleMissingValues: Boolean; const ddepth: Integer);
begin
  Stereo_reprojectImageTo3D(disparity, image3d, Q, handleMissingValues, ddepth);
end;

{ TCVStereoMatcher }

procedure TCVStereoMatcher.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Stereo_Matcher_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

class operator TCVStereoMatcher.Initialize(out Dest: TCVStereoMatcher);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
end;

class operator TCVStereoMatcher.Finalize(var Dest: TCVStereoMatcher);
begin
  Dest.ReleaseHandle;
end;

class function TCVStereoMatcher.CreateSGBM(const minDisparity, numDisparities,
  blockSize: Integer): TCVStereoMatcher;
begin
  Result.FHandle := Stereo_SGBM_Create(minDisparity, numDisparities, blockSize);
  Result.FOwnsHandle := True;
end;

class function TCVStereoMatcher.CreateBM(const numDisparities, blockSize: Integer): TCVStereoMatcher;
begin
  Result.FHandle := Stereo_BM_Create(numDisparities, blockSize);
  Result.FOwnsHandle := True;
end;

procedure TCVStereoMatcher.Release;
begin
  ReleaseHandle;
end;

procedure TCVStereoMatcher.compute(const left, right, disparity: Pointer);
begin
  if FHandle <> nil then
    Stereo_Matcher_compute(FHandle, left, right, disparity);
end;

end.
