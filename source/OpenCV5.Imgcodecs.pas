unit OpenCV5.Imgcodecs;

interface

uses
  System.SysUtils,
  OpenCV5.Core;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

function imread(const filename: PAnsiChar; const flags: Integer): TCVMat; overload;
procedure imread(const filename: PAnsiChar; const dst: Pointer; const flags: Integer); overload;

function imwrite(const filename: PAnsiChar; const img: Pointer): Boolean; overload;
function imwrite(const filename: PAnsiChar; const img: Pointer; const params: PInteger; const paramsCount: Integer): Boolean; overload;

function imencode(const ext: PAnsiChar; const img: Pointer; out bytes: TBytes): Boolean;
function imdecode(const buffer: TBytes; const flags: Integer): TCVMat; overload;
function imdecode(const buffer: Pointer; const bufferSize: Integer; const flags: Integer): TCVMat; overload;

implementation

// ==========================================
// Flat C API Imports
// ==========================================

function Imgcodecs_imread_0(filename: PAnsiChar; flags: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Imgcodecs_imread_1(filename: PAnsiChar; dst: Pointer; flags: Integer); stdcall; external OpenCVLib delayed;


function imread(const filename: PAnsiChar; const flags: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Imgcodecs_imread_0(filename, flags));
end;

procedure imread(const filename: PAnsiChar; const dst: Pointer; const flags: Integer);
begin
  Imgcodecs_imread_1(filename, dst, flags);
end;

function Imgcodecs_imwrite(filename: PAnsiChar; img: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function Imgcodecs_imwrite_1(filename: PAnsiChar; img: Pointer; params: PInteger; paramsCount: Integer): Boolean; stdcall; external OpenCVLib delayed;

function imwrite(const filename: PAnsiChar; const img: Pointer): Boolean;
begin
  Result := Imgcodecs_imwrite(filename, img);
end;

function imwrite(const filename: PAnsiChar; const img: Pointer; const params: PInteger; const paramsCount: Integer): Boolean;
begin
  Result := Imgcodecs_imwrite_1(filename, img, params, paramsCount);
end;

function Imgcodecs_imencode(ext: PAnsiChar; img: Pointer; buffer: PByte; bufferSize: Integer): Integer; stdcall; external OpenCVLib delayed;
function Imgcodecs_imdecode(buffer: PByte; bufferSize: Integer; flags: Integer): Pointer; stdcall; external OpenCVLib delayed;

function imencode(const ext: PAnsiChar; const img: Pointer; out bytes: TBytes): Boolean;
var
  Need, N: Integer;
begin
  Need := Imgcodecs_imencode(ext, img, nil, 0);
  if Need >= 0 then
  begin
    SetLength(bytes, 0);
    Exit(False);
  end;
  SetLength(bytes, -Need);
  N := Imgcodecs_imencode(ext, img, @bytes[0], Length(bytes));
  Result := N = Length(bytes);
  if not Result then
    SetLength(bytes, 0);
end;

function imdecode(const buffer: TBytes; const flags: Integer): TCVMat;
begin
  if Length(buffer) = 0 then
    Exit(TCVMat.FromHandle(nil));
  Result := imdecode(@buffer[0], Length(buffer), flags);
end;

function imdecode(const buffer: Pointer; const bufferSize: Integer; const flags: Integer): TCVMat;
begin
  Result := TCVMat.FromHandle(Imgcodecs_imdecode(PByte(buffer), bufferSize, flags));
end;

end.