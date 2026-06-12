unit OpenCV5.Core;

interface

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

type
  TCVPoint = packed record
    X, Y: Integer;
    class function Create(const AX, AY: Integer): TCVPoint; static;
  end;
  PCVPoint = ^TCVPoint;

  TCVPoint2f = packed record
    X, Y: Single;
    class function Create(const AX, AY: Single): TCVPoint2f; static;
  end;
  PCVPoint2f = ^TCVPoint2f;

  TCVPoint2d = packed record
    X, Y: Double;
    class function Create(const AX, AY: Double): TCVPoint2d; static;
  end;
  PCVPoint2d = ^TCVPoint2d;

  TCVPoint2l = packed record
    X, Y: Int64;
    class function Create(const AX, AY: Int64): TCVPoint2l; static;
  end;
  PCVPoint2l = ^TCVPoint2l;

  TCVSize = packed record
    Width, Height: Integer;
    class function Create(const AWidth, AHeight: Integer): TCVSize; static;
  end;

  TCVSize2f = packed record
    Width, Height: Single;
    class function Create(const AWidth, AHeight: Single): TCVSize2f; static;
  end;

  TCVSize2l = packed record
    Width, Height: Int64;
    class function Create(const AWidth, AHeight: Int64): TCVSize2l; static;
  end;
  PCVSize2l = ^TCVSize2l;

  TCVRect = packed record
    X, Y, Width, Height: Integer;
    class function Create(const AX, AY, AWidth, AHeight: Integer): TCVRect; static;
  end;
  PCVRect = ^TCVRect;

  TCVRotatedRect = packed record
    Center: TCVPoint2f;
    Size: TCVSize2f;
    Angle: Single;
    class function Create(const ACenter: TCVPoint2f; const ASize: TCVSize2f; const AAngle: Single): TCVRotatedRect; static;
  end;
  PCVRotatedRect = ^TCVRotatedRect;

  TCVTermCriteria = packed record
    TermType: Integer;
    MaxCount: Integer;
    Epsilon: Double;
    class function Create(const ATermType, AMaxCount: Integer; const AEpsilon: Double): TCVTermCriteria; static;
  end;
  PCVTermCriteria = ^TCVTermCriteria;

  TCVScalar = packed record
    V0, V1, V2, V3: Double;
    class function Create(const AV0: Double; const AV1: Double = 0; const AV2: Double = 0; const AV3: Double = 0): TCVScalar; static;
  end;

  TCVMoments = packed record
    m00, m10, m01, m20, m11, m02: Double;
    m30, m21, m12, m03: Double;
    mu20, mu11, mu02, mu30, mu21, mu12, mu03: Double;
    nu20, nu11, nu02, nu30, nu21, nu12, nu03: Double;
  end;
  PCVMoments = ^TCVMoments;


  TCVMat = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    procedure ReleaseHandle;
    function Get_rows: Integer;
    procedure Set_rows(const Value: Integer);
    function Get_cols: Integer;
    procedure Set_cols(const Value: Integer);
  public
    class operator Initialize(out Dest: TCVMat);
    class operator Finalize(var Dest: TCVMat);
    class operator Assign(var Dest: TCVMat; const [ref] Src: TCVMat);
    class function Create_0(const rows: Integer; const cols: Integer; const dataType: Integer): TCVMat; static;
    class function Create_1(const size: TCVSize; const dataType: Integer): TCVMat; static;
    class function Create_2(const rows: Integer; const cols: Integer; const dataType: Integer; const s: TCVScalar): TCVMat; static;
    class function Create_3(const size: TCVSize; const dataType: Integer; const s: TCVScalar): TCVMat; static;
    class function Create_4(const ndims: Integer; const sizes: Pointer; const dataType: Integer): TCVMat; static;
    class function Create_5(const ndims: Integer; const sizes: Pointer; const dataType: Integer; const s: TCVScalar): TCVMat; static;
    class function Create_6(const m: TCVMat): TCVMat; static;
    class function Create_7(const m: TCVMat; const rowRange: Pointer; const colRange: Pointer): TCVMat; static;
    class function Create_8(const m: TCVMat; const roi: TCVRect): TCVMat; static;
    class function Create_9(const m: TCVMat; const ranges: Pointer): TCVMat; static;
    class function FromHandle(const AHandle: Pointer): TCVMat; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function row(const y: Integer): TCVMat;
    function col(const x: Integer): TCVMat;
    function rowRange(const startrow: Integer; const endrow: Integer): TCVMat; overload;
    function rowRange(const r: Pointer): TCVMat; overload;
    function colRange(const startcol: Integer; const endcol: Integer): TCVMat; overload;
    function colRange(const r: Pointer): TCVMat; overload;
    function diag(const d: Integer): TCVMat; overload;
    function diag(const d: TCVMat): TCVMat; overload;
    function clone(): TCVMat;
    procedure copyTo(const m: Pointer); overload;
    procedure copyTo(const m: Pointer; const mask: Pointer); overload;
    procedure copyAt(const m: Pointer); overload;
    procedure copyAt(const m: Pointer; const mask: Pointer); overload;
    procedure convertTo(const m: Pointer; const rtype: Integer; const alpha: Double; const beta: Double);
    procedure assignTo(const m: TCVMat; const dataType: Integer);
    function setTo(const value: Pointer; const mask: Pointer): TCVMat;
    function setZero(): TCVMat;
    function reshape(const cn: Integer; const rows: Integer): TCVMat; overload;
    function reshape(const cn: Integer; const newndims: Integer; const newsz: Pointer): TCVMat; overload;
    function reinterpret(const dataType: Integer): TCVMat;
    function cross(const m: Pointer): TCVMat;
    function dot(const m: Pointer): Double;
    procedure create(const rows: Integer; const cols: Integer; const dataType: Integer); overload;
    procedure create(const size: TCVSize; const dataType: Integer); overload;
    procedure create(const ndims: Integer; const sizes: Pointer; const dataType: Integer); overload;
    procedure createSameSize(const arr: Pointer; const dataType: Integer);
    procedure fit(const rows: Integer; const cols: Integer; const dataType: Integer); overload;
    procedure fit(const size: TCVSize; const dataType: Integer); overload;
    procedure fit(const ndims: Integer; const sizes: Pointer; const dataType: Integer); overload;
    procedure fitSameSize(const arr: Pointer; const dataType: Integer);
    procedure addref();
    procedure releaseRef();
    procedure deallocate();
    procedure copySize(const m: TCVMat);
    procedure push_back_(const elem: Pointer);
    procedure push_back(const m: TCVMat);
    procedure locateROI(const wholeSize: TCVSize; const ofs: TCVPoint);
    function adjustROI(const dtop: Integer; const dbottom: Integer; const dleft: Integer; const dright: Integer): TCVMat;
    function isContinuous(): Boolean;
    function isSubmatrix(): Boolean;
    function dataType(): Integer;
    function depth(): Integer;
    function channels(): Integer;
    function empty(): Boolean;
    function checkVector(const elemChannels: Integer; const depth: Integer; const requireContinuous: Boolean): Integer;
    function ptr(const i0: Integer): Pointer; overload;
    function ptr(const row: Integer; const col: Integer): Pointer; overload;
    function ptr(const i0: Integer; const i1: Integer; const i2: Integer): Pointer; overload;
    function ptr(const idx: Pointer): Pointer; overload;
    procedure updateContinuityFlag();
    property rows: Integer read Get_rows write Set_rows;
    property cols: Integer read Get_cols write Set_cols;
  end;

implementation

{ TCVPoint }
class function TCVPoint.Create(const AX, AY: Integer): TCVPoint;
begin
  Result.X := AX;
  Result.Y := AY;
end;

{ TCVSize }
class function TCVSize.Create(const AWidth, AHeight: Integer): TCVSize;
begin
  Result.Width := AWidth;
  Result.Height := AHeight;
end;

{ TCVRect }
class function TCVRect.Create(const AX, AY, AWidth, AHeight: Integer): TCVRect;
begin
  Result.X := AX;
  Result.Y := AY;
  Result.Width := AWidth;
  Result.Height := AHeight;
end;

{ TCVScalar }
class function TCVScalar.Create(const AV0: Double; const AV1: Double; const AV2: Double; const AV3: Double): TCVScalar;
begin
  Result.V0 := AV0;
  Result.V1 := AV1;
  Result.V2 := AV2;
  Result.V3 := AV3;
end;

{ TCVPoint2f }
class function TCVPoint2f.Create(const AX, AY: Single): TCVPoint2f;
begin
  Result.X := AX;
  Result.Y := AY;
end;

{ TCVPoint2d }
class function TCVPoint2d.Create(const AX, AY: Double): TCVPoint2d;
begin
  Result.X := AX;
  Result.Y := AY;
end;

{ TCVPoint2l }
class function TCVPoint2l.Create(const AX, AY: Int64): TCVPoint2l;
begin
  Result.X := AX;
  Result.Y := AY;
end;

{ TCVSize2f }
class function TCVSize2f.Create(const AWidth, AHeight: Single): TCVSize2f;
begin
  Result.Width := AWidth;
  Result.Height := AHeight;
end;

{ TCVSize2l }
class function TCVSize2l.Create(const AWidth, AHeight: Int64): TCVSize2l;
begin
  Result.Width := AWidth;
  Result.Height := AHeight;
end;

{ TCVRotatedRect }
class function TCVRotatedRect.Create(const ACenter: TCVPoint2f; const ASize: TCVSize2f; const AAngle: Single): TCVRotatedRect;
begin
  Result.Center := ACenter;
  Result.Size := ASize;
  Result.Angle := AAngle;
end;

{ TCVTermCriteria }
class function TCVTermCriteria.Create(const ATermType, AMaxCount: Integer; const AEpsilon: Double): TCVTermCriteria;
begin
  Result.TermType := ATermType;
  Result.MaxCount := AMaxCount;
  Result.Epsilon := AEpsilon;
end;

// ==========================================
// Flat C API Imports
// ==========================================

function Mat_Ctor_0(rows: Integer; cols: Integer; dataType: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_Ctor_1(size: Pointer; dataType: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_Ctor_2(rows: Integer; cols: Integer; dataType: Integer; s: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_Ctor_3(size: Pointer; dataType: Integer; s: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_Ctor_4(ndims: Integer; sizes: Pointer; dataType: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_Ctor_5(ndims: Integer; sizes: Pointer; dataType: Integer; s: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_Ctor_6(m: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_Ctor_7(m: Pointer; rowRange: Pointer; colRange: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_Ctor_8(m: Pointer; roi: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_Ctor_9(m: Pointer; ranges: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_Ctor_10(): Pointer; stdcall; external OpenCVLib delayed;
procedure Mat_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function Mat_Copy(self: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_get_rows(self: Pointer): Integer; stdcall; external OpenCVLib delayed;
procedure Mat_set_rows(self: Pointer; val: Integer); stdcall; external OpenCVLib delayed;
function Mat_get_cols(self: Pointer): Integer; stdcall; external OpenCVLib delayed;
procedure Mat_set_cols(self: Pointer; val: Integer); stdcall; external OpenCVLib delayed;
function Mat_row(self: Pointer; y: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_col(self: Pointer; x: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_rowRange_0(self: Pointer; startrow: Integer; endrow: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_rowRange_1(self: Pointer; r: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_colRange_0(self: Pointer; startcol: Integer; endcol: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_colRange_1(self: Pointer; r: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_diag_0(self: Pointer; d: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_diag_1(self: Pointer; d: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_clone(self: Pointer): Pointer; stdcall; external OpenCVLib delayed;
procedure Mat_copyTo_0(self: Pointer; m: Pointer); stdcall; external OpenCVLib delayed;
procedure Mat_copyTo_1(self: Pointer; m: Pointer; mask: Pointer); stdcall; external OpenCVLib delayed;
procedure Mat_copyAt_0(self: Pointer; m: Pointer); stdcall; external OpenCVLib delayed;
procedure Mat_copyAt_1(self: Pointer; m: Pointer; mask: Pointer); stdcall; external OpenCVLib delayed;
procedure Mat_convertTo(self: Pointer; m: Pointer; rtype: Integer; alpha: Double; beta: Double); stdcall; external OpenCVLib delayed;
procedure Mat_assignTo(self: Pointer; m: Pointer; dataType: Integer); stdcall; external OpenCVLib delayed;
function Mat_setTo(self: Pointer; value: Pointer; mask: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_setZero(self: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_reshape_0(self: Pointer; cn: Integer; rows: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_reshape_1(self: Pointer; cn: Integer; newndims: Integer; newsz: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_reinterpret(self: Pointer; dataType: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_cross(self: Pointer; m: Pointer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_dot(self: Pointer; m: Pointer): Double; stdcall; external OpenCVLib delayed;
procedure Mat_create_0(self: Pointer; rows: Integer; cols: Integer; dataType: Integer); stdcall; external OpenCVLib delayed;
procedure Mat_create_1(self: Pointer; size: Pointer; dataType: Integer); stdcall; external OpenCVLib delayed;
procedure Mat_create_2(self: Pointer; ndims: Integer; sizes: Pointer; dataType: Integer); stdcall; external OpenCVLib delayed;
procedure Mat_createSameSize(self: Pointer; arr: Pointer; dataType: Integer); stdcall; external OpenCVLib delayed;
procedure Mat_fit_0(self: Pointer; rows: Integer; cols: Integer; dataType: Integer); stdcall; external OpenCVLib delayed;
procedure Mat_fit_1(self: Pointer; size: Pointer; dataType: Integer); stdcall; external OpenCVLib delayed;
procedure Mat_fit_2(self: Pointer; ndims: Integer; sizes: Pointer; dataType: Integer); stdcall; external OpenCVLib delayed;
procedure Mat_fitSameSize(self: Pointer; arr: Pointer; dataType: Integer); stdcall; external OpenCVLib delayed;
procedure Mat_addref(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Mat_release(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Mat_deallocate(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Mat_copySize(self: Pointer; m: Pointer); stdcall; external OpenCVLib delayed;
procedure Mat_push_back_(self: Pointer; elem: Pointer); stdcall; external OpenCVLib delayed;
procedure Mat_push_back(self: Pointer; m: Pointer); stdcall; external OpenCVLib delayed;
procedure Mat_locateROI(self: Pointer; wholeSize: Pointer; ofs: Pointer); stdcall; external OpenCVLib delayed;
function Mat_adjustROI(self: Pointer; dtop: Integer; dbottom: Integer; dleft: Integer; dright: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_isContinuous(self: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function Mat_isSubmatrix(self: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function Mat_type(self: Pointer): Integer; stdcall; external OpenCVLib delayed;
function Mat_depth(self: Pointer): Integer; stdcall; external OpenCVLib delayed;
function Mat_channels(self: Pointer): Integer; stdcall; external OpenCVLib delayed;
function Mat_empty(self: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function Mat_checkVector(self: Pointer; elemChannels: Integer; depth: Integer; requireContinuous: Boolean): Integer; stdcall; external OpenCVLib delayed;
function Mat_ptr_0(self: Pointer; i0: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_ptr_1(self: Pointer; row: Integer; col: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_ptr_2(self: Pointer; i0: Integer; i1: Integer; i2: Integer): Pointer; stdcall; external OpenCVLib delayed;
function Mat_ptr_3(self: Pointer; idx: Pointer): Pointer; stdcall; external OpenCVLib delayed;
procedure Mat_updateContinuityFlag(self: Pointer); stdcall; external OpenCVLib delayed;

// ==========================================
// TCVMat Implementation
// ==========================================

procedure TCVMat.ReleaseHandle;
begin
  if FOwnsHandle and Assigned(FHandle) then
    Mat_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

class operator TCVMat.Initialize(out Dest: TCVMat);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
end;

class operator TCVMat.Finalize(var Dest: TCVMat);
begin
  Dest.ReleaseHandle;
end;

class operator TCVMat.Assign(var Dest: TCVMat; const [ref] Src: TCVMat);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  if Src.FOwnsHandle and Assigned(Src.FHandle) then
  begin
    Dest.FHandle := Mat_Copy(Src.FHandle);
    Dest.FOwnsHandle := True;
  end
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVMat.Create_0(const rows: Integer; const cols: Integer; const dataType: Integer): TCVMat;
begin
  Result.FHandle := Mat_Ctor_0(rows, cols, dataType);
  Result.FOwnsHandle := True;
end;

class function TCVMat.Create_1(const size: TCVSize; const dataType: Integer): TCVMat;
begin
  Result.FHandle := Mat_Ctor_1(@size, dataType);
  Result.FOwnsHandle := True;
end;

class function TCVMat.Create_2(const rows: Integer; const cols: Integer; const dataType: Integer; const s: TCVScalar): TCVMat;
begin
  Result.FHandle := Mat_Ctor_2(rows, cols, dataType, @s);
  Result.FOwnsHandle := True;
end;

class function TCVMat.Create_3(const size: TCVSize; const dataType: Integer; const s: TCVScalar): TCVMat;
begin
  Result.FHandle := Mat_Ctor_3(@size, dataType, @s);
  Result.FOwnsHandle := True;
end;

class function TCVMat.Create_4(const ndims: Integer; const sizes: Pointer; const dataType: Integer): TCVMat;
begin
  Result.FHandle := Mat_Ctor_4(ndims, sizes, dataType);
  Result.FOwnsHandle := True;
end;

class function TCVMat.Create_5(const ndims: Integer; const sizes: Pointer; const dataType: Integer; const s: TCVScalar): TCVMat;
begin
  Result.FHandle := Mat_Ctor_5(ndims, sizes, dataType, @s);
  Result.FOwnsHandle := True;
end;

class function TCVMat.Create_6(const m: TCVMat): TCVMat;
begin
  Result.FHandle := Mat_Ctor_6(m.Handle);
  Result.FOwnsHandle := True;
end;

class function TCVMat.Create_7(const m: TCVMat; const rowRange: Pointer; const colRange: Pointer): TCVMat;
begin
  Result.FHandle := Mat_Ctor_7(m.Handle, rowRange, colRange);
  Result.FOwnsHandle := True;
end;

class function TCVMat.Create_8(const m: TCVMat; const roi: TCVRect): TCVMat;
begin
  Result.FHandle := Mat_Ctor_8(m.Handle, @roi);
  Result.FOwnsHandle := True;
end;

class function TCVMat.Create_9(const m: TCVMat; const ranges: Pointer): TCVMat;
begin
  Result.FHandle := Mat_Ctor_9(m.Handle, ranges);
  Result.FOwnsHandle := True;
end;

class function TCVMat.FromHandle(const AHandle: Pointer): TCVMat;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := True;
end;

procedure TCVMat.Release;
begin
  ReleaseHandle;
end;

function TCVMat.Get_rows: Integer;
begin
  Result := Mat_get_rows(FHandle);
end;

procedure TCVMat.Set_rows(const Value: Integer);
begin
  Mat_set_rows(FHandle, Value);
end;

function TCVMat.Get_cols: Integer;
begin
  Result := Mat_get_cols(FHandle);
end;

procedure TCVMat.Set_cols(const Value: Integer);
begin
  Mat_set_cols(FHandle, Value);
end;

function TCVMat.row(const y: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_row(FHandle, y));
end;

function TCVMat.col(const x: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_col(FHandle, x));
end;

function TCVMat.rowRange(const startrow: Integer; const endrow: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_rowRange_0(FHandle, startrow, endrow));
end;

function TCVMat.rowRange(const r: Pointer): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_rowRange_1(FHandle, r));
end;

function TCVMat.colRange(const startcol: Integer; const endcol: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_colRange_0(FHandle, startcol, endcol));
end;

function TCVMat.colRange(const r: Pointer): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_colRange_1(FHandle, r));
end;

function TCVMat.diag(const d: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_diag_0(FHandle, d));
end;

function TCVMat.diag(const d: TCVMat): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_diag_1(FHandle, d.Handle));
end;

function TCVMat.clone(): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_clone(FHandle));
end;

procedure TCVMat.copyTo(const m: Pointer);
begin
  Mat_copyTo_0(FHandle, m);
end;

procedure TCVMat.copyTo(const m: Pointer; const mask: Pointer);
begin
  Mat_copyTo_1(FHandle, m, mask);
end;

procedure TCVMat.copyAt(const m: Pointer);
begin
  Mat_copyAt_0(FHandle, m);
end;

procedure TCVMat.copyAt(const m: Pointer; const mask: Pointer);
begin
  Mat_copyAt_1(FHandle, m, mask);
end;

procedure TCVMat.convertTo(const m: Pointer; const rtype: Integer; const alpha: Double; const beta: Double);
begin
  Mat_convertTo(FHandle, m, rtype, alpha, beta);
end;

procedure TCVMat.assignTo(const m: TCVMat; const dataType: Integer);
begin
  Mat_assignTo(FHandle, m.Handle, dataType);
end;

function TCVMat.setTo(const value: Pointer; const mask: Pointer): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_setTo(FHandle, value, mask));
end;

function TCVMat.setZero(): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_setZero(FHandle));
end;

function TCVMat.reshape(const cn: Integer; const rows: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_reshape_0(FHandle, cn, rows));
end;

function TCVMat.reshape(const cn: Integer; const newndims: Integer; const newsz: Pointer): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_reshape_1(FHandle, cn, newndims, newsz));
end;

function TCVMat.reinterpret(const dataType: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_reinterpret(FHandle, dataType));
end;

function TCVMat.cross(const m: Pointer): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_cross(FHandle, m));
end;

function TCVMat.dot(const m: Pointer): Double;
begin
  Result := Mat_dot(FHandle, m);
end;

procedure TCVMat.create(const rows: Integer; const cols: Integer; const dataType: Integer);
begin
  Mat_create_0(FHandle, rows, cols, dataType);
end;

procedure TCVMat.create(const size: TCVSize; const dataType: Integer);
begin
  Mat_create_1(FHandle, @size, dataType);
end;

procedure TCVMat.create(const ndims: Integer; const sizes: Pointer; const dataType: Integer);
begin
  Mat_create_2(FHandle, ndims, sizes, dataType);
end;

procedure TCVMat.createSameSize(const arr: Pointer; const dataType: Integer);
begin
  Mat_createSameSize(FHandle, arr, dataType);
end;

procedure TCVMat.fit(const rows: Integer; const cols: Integer; const dataType: Integer);
begin
  Mat_fit_0(FHandle, rows, cols, dataType);
end;

procedure TCVMat.fit(const size: TCVSize; const dataType: Integer);
begin
  Mat_fit_1(FHandle, @size, dataType);
end;

procedure TCVMat.fit(const ndims: Integer; const sizes: Pointer; const dataType: Integer);
begin
  Mat_fit_2(FHandle, ndims, sizes, dataType);
end;

procedure TCVMat.fitSameSize(const arr: Pointer; const dataType: Integer);
begin
  Mat_fitSameSize(FHandle, arr, dataType);
end;

procedure TCVMat.addref();
begin
  Mat_addref(FHandle);
end;

procedure TCVMat.releaseRef();
begin
  Mat_release(FHandle);
end;

procedure TCVMat.deallocate();
begin
  Mat_deallocate(FHandle);
end;

procedure TCVMat.copySize(const m: TCVMat);
begin
  Mat_copySize(FHandle, m.Handle);
end;

procedure TCVMat.push_back_(const elem: Pointer);
begin
  Mat_push_back_(FHandle, elem);
end;

procedure TCVMat.push_back(const m: TCVMat);
begin
  Mat_push_back(FHandle, m.Handle);
end;

procedure TCVMat.locateROI(const wholeSize: TCVSize; const ofs: TCVPoint);
begin
  Mat_locateROI(FHandle, @wholeSize, @ofs);
end;

function TCVMat.adjustROI(const dtop: Integer; const dbottom: Integer; const dleft: Integer; const dright: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Mat_adjustROI(FHandle, dtop, dbottom, dleft, dright));
end;

function TCVMat.isContinuous(): Boolean;
begin
  Result := Mat_isContinuous(FHandle);
end;

function TCVMat.isSubmatrix(): Boolean;
begin
  Result := Mat_isSubmatrix(FHandle);
end;

function TCVMat.dataType(): Integer;
begin
  Result := Mat_type(FHandle);
end;

function TCVMat.depth(): Integer;
begin
  Result := Mat_depth(FHandle);
end;

function TCVMat.channels(): Integer;
begin
  Result := Mat_channels(FHandle);
end;

function TCVMat.empty(): Boolean;
begin
  if FHandle = nil then
    Exit(True);
  Result := Mat_empty(FHandle);
end;

function TCVMat.checkVector(const elemChannels: Integer; const depth: Integer; const requireContinuous: Boolean): Integer;
begin
  Result := Mat_checkVector(FHandle, elemChannels, depth, requireContinuous);
end;

function TCVMat.ptr(const i0: Integer): Pointer;
begin
  Result := Mat_ptr_0(FHandle, i0);
end;

function TCVMat.ptr(const row: Integer; const col: Integer): Pointer;
begin
  Result := Mat_ptr_1(FHandle, row, col);
end;

function TCVMat.ptr(const i0: Integer; const i1: Integer; const i2: Integer): Pointer;
begin
  Result := Mat_ptr_2(FHandle, i0, i1, i2);
end;

function TCVMat.ptr(const idx: Pointer): Pointer;
begin
  Result := Mat_ptr_3(FHandle, idx);
end;

procedure TCVMat.updateContinuityFlag();
begin
  Mat_updateContinuityFlag(FHandle);
end;

procedure Core_installSehTranslator; stdcall; external OpenCVLib delayed;

initialization
  try
    Core_installSehTranslator;
  except
    // Ignore DLL loading issues in design-time
  end;

end.