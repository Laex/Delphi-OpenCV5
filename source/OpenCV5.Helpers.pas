unit OpenCV5.Helpers;

interface

uses
  OpenCV5.Core,
  OpenCV5.Types;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

type
  TCVKeypoint = record
    Pt: TCVPoint2f;
    Size: Single;
    Angle: Single;
    Response: Single;
    Octave: Integer;
    ClassId: Integer;
  end;

  TCVDetection = record
    ClassId: Integer;
    Confidence: Single;
    Box: TCVRect;
  end;

  TCVMatVector = record
  private
    FHandle: Pointer;
    procedure ReleaseHandle;
  public
    class operator Initialize(out Dest: TCVMatVector);
    class operator Finalize(var Dest: TCVMatVector);
    class function Create: TCVMatVector; static;
    procedure Release;
    function Count: Integer;
    function At(const Index: Integer): TCVMat;
    procedure Clear;
    property Handle: Pointer read FHandle;
  end;

procedure findContoursEx(const image: Pointer; const contours: TCVMatVector;
  const hierarchy: Pointer; const mode, method: Integer; const offset: TCVPoint);

procedure drawContoursEx(const image: Pointer; const contours: TCVMatVector;
  const contourIdx: Integer; const color: TCVScalar; const thickness: Integer = 1);

function ParseKeypoints(const keypoints: TCVMat): TArray<TCVKeypoint>;
function ContourToPoints(const contour: TCVMat): TArray<TCVPoint>;
function ParseDetections(const classIds, confidences, boxes: TCVMat): TArray<TCVDetection>;

implementation

function MatVector_Create: Pointer; stdcall; external OpenCVLib delayed;
procedure MatVector_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function MatVector_size(self: Pointer): Integer; stdcall; external OpenCVLib delayed;
procedure MatVector_clear(self: Pointer); stdcall; external OpenCVLib delayed;
function MatVector_at(self: Pointer; index: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Helpers_findContours(image, contours, hierarchy: Pointer; mode, method, offsetX, offsetY: Integer); stdcall; external OpenCVLib delayed;
procedure Helpers_drawContours(image, contours: Pointer; contourIdx, b, g, r, thickness: Integer); stdcall; external OpenCVLib delayed;

{ TCVMatVector }

procedure TCVMatVector.ReleaseHandle;
begin
  if FHandle <> nil then
  begin
    MatVector_Destroy(FHandle);
    FHandle := nil;
  end;
end;

class operator TCVMatVector.Initialize(out Dest: TCVMatVector);
begin
  Dest.FHandle := nil;
end;

class operator TCVMatVector.Finalize(var Dest: TCVMatVector);
begin
  Dest.ReleaseHandle;
end;

class function TCVMatVector.Create: TCVMatVector;
begin
  Result.FHandle := MatVector_Create;
end;

procedure TCVMatVector.Release;
begin
  ReleaseHandle;
end;

function TCVMatVector.Count: Integer;
begin
  if FHandle = nil then
    Exit(0);
  Result := MatVector_size(FHandle);
end;

function TCVMatVector.At(const Index: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(MatVector_at(FHandle, Index));
end;

procedure TCVMatVector.Clear;
begin
  if FHandle <> nil then
    MatVector_clear(FHandle);
end;

procedure findContoursEx(const image: Pointer; const contours: TCVMatVector;
  const hierarchy: Pointer; const mode, method: Integer; const offset: TCVPoint);
begin
  Helpers_findContours(image, contours.Handle, hierarchy, mode, method, offset.X, offset.Y);
end;

procedure drawContoursEx(const image: Pointer; const contours: TCVMatVector;
  const contourIdx: Integer; const color: TCVScalar; const thickness: Integer);
begin
  Helpers_drawContours(image, contours.Handle, contourIdx,
    Trunc(color.V0), Trunc(color.V1), Trunc(color.V2), thickness);
end;

function ParseKeypoints(const keypoints: TCVMat): TArray<TCVKeypoint>;
type
  TRow = array[0..6] of Single;
  PRow = ^TRow;
var
  I: Integer;
  R: PRow;
begin
  SetLength(Result, keypoints.rows);
  for I := 0 to keypoints.rows - 1 do
  begin
    R := keypoints.ptr(I, 0);
    Result[I].Pt := TCVPoint2f.Create(R[0], R[1]);
    if keypoints.cols > 2 then Result[I].Size := R[2];
    if keypoints.cols > 3 then Result[I].Angle := R[3];
    if keypoints.cols > 4 then Result[I].Response := R[4];
    if keypoints.cols > 5 then Result[I].Octave := Trunc(R[5]);
    if keypoints.cols > 6 then Result[I].ClassId := Trunc(R[6]);
  end;
end;

function ContourToPoints(const contour: TCVMat): TArray<TCVPoint>;
type
  TRow = array[0..1] of Integer;
  PRow = ^TRow;
var
  I: Integer;
  R: PRow;
begin
  SetLength(Result, contour.rows);
  for I := 0 to contour.rows - 1 do
  begin
    R := contour.ptr(I, 0);
    Result[I] := TCVPoint.Create(R[0], R[1]);
  end;
end;

function ParseDetections(const classIds, confidences, boxes: TCVMat): TArray<TCVDetection>;
type
  TBoxRow = array[0..3] of Single;
  PBoxRow = ^TBoxRow;
var
  I, N: Integer;
  C: PInteger;
  F: PSingle;
  B: PBoxRow;
begin
  N := classIds.rows;
  if (confidences.rows > 0) and (confidences.rows < N) then
    N := confidences.rows;
  if (boxes.rows > 0) and (boxes.rows < N) then
    N := boxes.rows;
  SetLength(Result, N);
  for I := 0 to N - 1 do
  begin
    if classIds.rows > I then
    begin
      C := classIds.ptr(I, 0);
      Result[I].ClassId := C^;
    end;
    if confidences.rows > I then
    begin
      F := confidences.ptr(I, 0);
      Result[I].Confidence := F^;
    end;
    if boxes.rows > I then
    begin
      B := boxes.ptr(I, 0);
      Result[I].Box := TCVRect.Create(Trunc(B[0]), Trunc(B[1]), Trunc(B[2]), Trunc(B[3]));
    end;
  end;
end;

end.
