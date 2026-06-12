unit OpenCV5.Persistence;

interface

uses
  OpenCV5.Core;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

  FS_READ = 0;
  FS_WRITE = 1;

type
  TCVFileStorage = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FFilename: AnsiString;
    FFlags: Integer;
    procedure ReleaseHandle;
    procedure CreateOwned;
  public
    class operator Initialize(out Dest: TCVFileStorage);
    class operator Finalize(var Dest: TCVFileStorage);
    class operator Assign(var Dest: TCVFileStorage; const [ref] Src: TCVFileStorage);
    class function Open(const filename: PAnsiChar; const flags: Integer): TCVFileStorage; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVFileStorage; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function isOpened: Boolean;
    procedure writeMat(const name: PAnsiChar; const mat: Pointer);
    function readMat(const name: PAnsiChar; const mat: Pointer): Boolean;
    procedure writeInt(const name: PAnsiChar; const value: Integer);
    procedure writeDouble(const name: PAnsiChar; const value: Double);
    procedure writeString(const name: PAnsiChar; const value: PAnsiChar);
    function readInt(const name: PAnsiChar; out value: Integer): Boolean;
    function readDouble(const name: PAnsiChar; out value: Double): Boolean;
    function readString(const name: PAnsiChar; out value: AnsiString): Boolean;
  end;

implementation

function Persistence_create(filename: PAnsiChar; flags: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Persistence_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function Persistence_isOpened(self: Pointer): Boolean; stdcall; external OpenCVLib delayed;
procedure Persistence_writeMat(self: Pointer; name: PAnsiChar; val: Pointer); stdcall; external OpenCVLib delayed;
function Persistence_readMat(self: Pointer; name: PAnsiChar; val: Pointer): Boolean; stdcall; external OpenCVLib delayed;
procedure Persistence_writeInt(self: Pointer; name: PAnsiChar; val: Integer); stdcall; external OpenCVLib delayed;
procedure Persistence_writeDouble(self: Pointer; name: PAnsiChar; val: Double); stdcall; external OpenCVLib delayed;
procedure Persistence_writeString(self: Pointer; name, val: PAnsiChar); stdcall; external OpenCVLib delayed;
function Persistence_readInt(self: Pointer; name: PAnsiChar; val: PInteger): Boolean; stdcall; external OpenCVLib delayed;
function Persistence_readDouble(self: Pointer; name: PAnsiChar; val: PDouble): Boolean; stdcall; external OpenCVLib delayed;
function Persistence_readString(self: Pointer; name: PAnsiChar; buffer: PAnsiChar; bufferSize: Integer): Boolean; stdcall; external OpenCVLib delayed;

{ TCVFileStorage }

procedure TCVFileStorage.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Persistence_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVFileStorage.CreateOwned;
begin
  ReleaseHandle;
  FHandle := Persistence_create(PAnsiChar(FFilename), FFlags);
  FOwnsHandle := True;
end;

class operator TCVFileStorage.Initialize(out Dest: TCVFileStorage);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FFilename := '';
  Dest.FFlags := FS_WRITE;
end;

class operator TCVFileStorage.Finalize(var Dest: TCVFileStorage);
begin
  Dest.ReleaseHandle;
end;

class operator TCVFileStorage.Assign(var Dest: TCVFileStorage; const [ref] Src: TCVFileStorage);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FFilename := Src.FFilename;
  Dest.FFlags := Src.FFlags;
  if Src.FOwnsHandle then
    Dest.CreateOwned
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVFileStorage.Open(const filename: PAnsiChar; const flags: Integer): TCVFileStorage;
begin
  if filename <> nil then
    Result.FFilename := filename
  else
    Result.FFilename := '';
  Result.FFlags := flags;
  Result.FHandle := Persistence_create(PAnsiChar(Result.FFilename), flags);
  Result.FOwnsHandle := True;
end;

class function TCVFileStorage.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVFileStorage;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FFilename := '';
  Result.FFlags := FS_READ;
end;

procedure TCVFileStorage.Release;
begin
  ReleaseHandle;
end;

function TCVFileStorage.isOpened: Boolean;
begin
  if FHandle = nil then
    Exit(False);
  Result := Persistence_isOpened(FHandle);
end;

procedure TCVFileStorage.writeMat(const name: PAnsiChar; const mat: Pointer);
begin
  if FHandle <> nil then
    Persistence_writeMat(FHandle, name, mat);
end;

function TCVFileStorage.readMat(const name: PAnsiChar; const mat: Pointer): Boolean;
begin
  if FHandle = nil then
    Exit(False);
  Result := Persistence_readMat(FHandle, name, mat);
end;

procedure TCVFileStorage.writeInt(const name: PAnsiChar; const value: Integer);
begin
  if FHandle <> nil then
    Persistence_writeInt(FHandle, name, value);
end;

procedure TCVFileStorage.writeDouble(const name: PAnsiChar; const value: Double);
begin
  if FHandle <> nil then
    Persistence_writeDouble(FHandle, name, value);
end;

procedure TCVFileStorage.writeString(const name: PAnsiChar; const value: PAnsiChar);
begin
  if FHandle <> nil then
    Persistence_writeString(FHandle, name, value);
end;

function TCVFileStorage.readInt(const name: PAnsiChar; out value: Integer): Boolean;
begin
  if FHandle = nil then
    Exit(False);
  Result := Persistence_readInt(FHandle, name, @value);
end;

function TCVFileStorage.readDouble(const name: PAnsiChar; out value: Double): Boolean;
begin
  if FHandle = nil then
    Exit(False);
  Result := Persistence_readDouble(FHandle, name, @value);
end;

function TCVFileStorage.readString(const name: PAnsiChar; out value: AnsiString): Boolean;
const
  MAX_STR = 4096;
var
  Buffer: array[0..MAX_STR - 1] of AnsiChar;
begin
  value := '';
  if FHandle = nil then
    Exit(False);
  FillChar(Buffer, SizeOf(Buffer), 0);
  Result := Persistence_readString(FHandle, name, @Buffer[0], MAX_STR);
  if Result then
    value := Buffer;
end;

end.
