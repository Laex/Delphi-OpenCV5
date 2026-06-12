unit OpenCV5.Arith;

interface

uses
  OpenCV5.Core,
  OpenCV5.Types;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

procedure addMat(const src1, src2, dst: Pointer; const mask: Pointer = nil; const dtype: Integer = -1);
procedure subtractMat(const src1, src2, dst: Pointer; const mask: Pointer = nil; const dtype: Integer = -1);
procedure absdiff(const src1, src2, dst: Pointer);
procedure inRange(const src: Pointer; const lowerb, upperb: TCVScalar; const dst: Pointer);
procedure bitwise_and(const src1, src2, dst: Pointer; const mask: Pointer = nil);
procedure bitwise_or(const src1, src2, dst: Pointer; const mask: Pointer = nil);
procedure bitwise_xor(const src1, src2, dst: Pointer; const mask: Pointer = nil);
procedure bitwise_not(const src, dst: Pointer; const mask: Pointer = nil);

procedure minMaxLoc(const src: Pointer; out minVal, maxVal: Double;
  out minLoc, maxLoc: TCVPoint; const mask: Pointer = nil);

function countNonZero(const src: Pointer; const mask: Pointer = nil): Integer;

function splitMat(const src: Pointer; const channels: array of Pointer): Integer;

procedure mergeMats(const channels: array of Pointer; const dst: Pointer);
procedure multiplyMat(const src1, src2, dst: Pointer; const scale: Double = 1.0; const dtype: Integer = -1);
procedure divideMat(const src1, src2, dst: Pointer; const scale: Double = 1.0; const dtype: Integer = -1);
procedure meanStdDev(const src: Pointer; out meanVal, stdVal: TCVScalar; const mask: Pointer = nil);
procedure addWeighted(const src1, src2, dst: Pointer; const alpha, beta, gamma: Double);

implementation

function Core_split(src, dst0, dst1, dst2, dst3: Pointer; maxDst: Integer): Integer; stdcall; external OpenCVLib delayed;
function Mat_get_rows(self: Pointer): Integer; stdcall; external OpenCVLib delayed;
function Mat_get_cols(self: Pointer): Integer; stdcall; external OpenCVLib delayed;
function Mat_depth(self: Pointer): Integer; stdcall; external OpenCVLib delayed;
function Mat_channels(self: Pointer): Integer; stdcall; external OpenCVLib delayed;
function Mat_ptr_1(self: Pointer; row, col: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Core_merge(src0, src1, src2, src3: Pointer; nsrc: Integer; dst: Pointer); stdcall; external OpenCVLib delayed;
procedure Core_multiply(src1, src2, dst: Pointer; scale: Double; dtype: Integer); stdcall; external OpenCVLib delayed;
procedure Core_divide(src1, src2, dst: Pointer; scale: Double; dtype: Integer); stdcall; external OpenCVLib delayed;
procedure Core_meanStdDev(src, mask, mean, stddev: Pointer); stdcall; external OpenCVLib delayed;

procedure Core_add(src1, src2, dst, mask: Pointer; dtype: Integer); stdcall; external OpenCVLib delayed;
procedure Core_subtract(src1, src2, dst, mask: Pointer; dtype: Integer); stdcall; external OpenCVLib delayed;
procedure Core_absdiff(src1, src2, dst: Pointer); stdcall; external OpenCVLib delayed;
procedure Core_inRange(src: Pointer; lowerb, upperb: Pointer; dst: Pointer); stdcall; external OpenCVLib delayed;
procedure Core_bitwise_and(src1, src2, dst, mask: Pointer); stdcall; external OpenCVLib delayed;
procedure Core_bitwise_or(src1, src2, dst, mask: Pointer); stdcall; external OpenCVLib delayed;
procedure Core_bitwise_xor(src1, src2, dst, mask: Pointer); stdcall; external OpenCVLib delayed;
procedure Core_bitwise_not(src, dst, mask: Pointer); stdcall; external OpenCVLib delayed;
procedure Core_minMaxLoc(src, mask: Pointer; minVal, maxVal: Pointer;
  minX, minY, maxX, maxY: Pointer); stdcall; external OpenCVLib delayed;
function Core_countNonZero(src, mask: Pointer): Integer; stdcall; external OpenCVLib delayed;
procedure Core_addWeighted(src1: Pointer; alpha: Double; src2: Pointer; beta: Double; gamma: Double; dst: Pointer); stdcall; external OpenCVLib delayed;

procedure addMat(const src1, src2, dst: Pointer; const mask: Pointer; const dtype: Integer);
begin
  Core_add(src1, src2, dst, mask, dtype);
end;

procedure subtractMat(const src1, src2, dst: Pointer; const mask: Pointer; const dtype: Integer);
begin
  Core_subtract(src1, src2, dst, mask, dtype);
end;

procedure absdiff(const src1, src2, dst: Pointer);
begin
  Core_absdiff(src1, src2, dst);
end;

procedure inRange(const src: Pointer; const lowerb, upperb: TCVScalar; const dst: Pointer);
var
  Lo, Hi: TCVScalar;
begin
  Lo := lowerb;
  Hi := upperb;
  Core_inRange(src, @Lo, @Hi, dst);
end;

procedure bitwise_and(const src1, src2, dst: Pointer; const mask: Pointer);
begin
  Core_bitwise_and(src1, src2, dst, mask);
end;

procedure bitwise_or(const src1, src2, dst: Pointer; const mask: Pointer);
begin
  Core_bitwise_or(src1, src2, dst, mask);
end;

procedure bitwise_xor(const src1, src2, dst: Pointer; const mask: Pointer);
begin
  Core_bitwise_xor(src1, src2, dst, mask);
end;

procedure bitwise_not(const src, dst: Pointer; const mask: Pointer);
begin
  Core_bitwise_not(src, dst, mask);
end;

procedure minMaxLoc(const src: Pointer; out minVal, maxVal: Double;
  out minLoc, maxLoc: TCVPoint; const mask: Pointer);
var
  MinX, MinY, MaxX, MaxY: Integer;
begin
  Core_minMaxLoc(src, mask, @minVal, @maxVal, @MinX, @MinY, @MaxX, @MaxY);
  minLoc := TCVPoint.Create(MinX, MinY);
  maxLoc := TCVPoint.Create(MaxX, MaxY);
end;

function countNonZero(const src: Pointer; const mask: Pointer): Integer;
begin
  Result := Core_countNonZero(src, mask);
end;

function splitMat8u(const src: Pointer; const channels: array of Pointer): Integer;
var
  ChCount, Row, Col, Ci, Rows, Cols: Integer;
  Sp, Dp: PByte;
begin
  ChCount := Mat_channels(src);
  Result := ChCount;
  if (src = nil) or (ChCount <= 0) or (Length(channels) < ChCount) then
    Exit(0);
  Rows := Mat_get_rows(src);
  Cols := Mat_get_cols(src);
  for Ci := 0 to ChCount - 1 do
    if (Mat_get_rows(channels[Ci]) <> Rows) or (Mat_get_cols(channels[Ci]) <> Cols) or
       (Mat_channels(channels[Ci]) <> 1) then
      Exit(0);
  for Ci := 0 to ChCount - 1 do
    for Row := 0 to Rows - 1 do
      for Col := 0 to Cols - 1 do
      begin
        Sp := Mat_ptr_1(src, Row, Col);
        Dp := Mat_ptr_1(channels[Ci], Row, Col);
        Dp^ := PByte(Sp)[Ci];
      end;
end;

function splitMat(const src: Pointer; const channels: array of Pointer): Integer;
begin
  if (src <> nil) and (Mat_depth(src) = CV_8U) and (Mat_channels(src) in [1..4]) and
     (Length(channels) >= Mat_channels(src)) then
    Result := splitMat8u(src, channels)
  else
    Result := 0;
end;

procedure mergeMats(const channels: array of Pointer; const dst: Pointer);
var
  S0, S1, S2, S3: Pointer;
begin
  S0 := nil; S1 := nil; S2 := nil; S3 := nil;
  if Length(channels) > 0 then S0 := channels[0];
  if Length(channels) > 1 then S1 := channels[1];
  if Length(channels) > 2 then S2 := channels[2];
  if Length(channels) > 3 then S3 := channels[3];
  Core_merge(S0, S1, S2, S3, Length(channels), dst);
end;

procedure multiplyMat(const src1, src2, dst: Pointer; const scale: Double; const dtype: Integer);
begin
  Core_multiply(src1, src2, dst, scale, dtype);
end;

procedure divideMat(const src1, src2, dst: Pointer; const scale: Double; const dtype: Integer);
begin
  Core_divide(src1, src2, dst, scale, dtype);
end;

procedure meanStdDev(const src: Pointer; out meanVal, stdVal: TCVScalar; const mask: Pointer);
var
  MeanMat, StdMat: TCVMat;
begin
  MeanMat := TCVMat.Create_0(0, 0, CV_64F);
  StdMat := TCVMat.Create_0(0, 0, CV_64F);
  Core_meanStdDev(src, mask, MeanMat.Handle, StdMat.Handle);
  meanVal := TCVScalar.Create(0);
  stdVal := TCVScalar.Create(0);
  if MeanMat.cols >= 1 then meanVal.V0 := PDouble(MeanMat.ptr(0, 0))^;
  if MeanMat.cols >= 2 then meanVal.V1 := PDouble(MeanMat.ptr(0, 1))^;
  if MeanMat.cols >= 3 then meanVal.V2 := PDouble(MeanMat.ptr(0, 2))^;
  if MeanMat.cols >= 4 then meanVal.V3 := PDouble(MeanMat.ptr(0, 3))^;
  if StdMat.cols >= 1 then stdVal.V0 := PDouble(StdMat.ptr(0, 0))^;
  if StdMat.cols >= 2 then stdVal.V1 := PDouble(StdMat.ptr(0, 1))^;
  if StdMat.cols >= 3 then stdVal.V2 := PDouble(StdMat.ptr(0, 2))^;
  if StdMat.cols >= 4 then stdVal.V3 := PDouble(StdMat.ptr(0, 3))^;
end;

procedure addWeighted(const src1, src2, dst: Pointer; const alpha, beta, gamma: Double);
begin
  Core_addWeighted(src1, alpha, src2, beta, gamma, dst);
end;

end.
