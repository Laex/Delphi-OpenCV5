unit OpenCV5.Videoio;

interface

uses
  OpenCV5.Core;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

type
  TCVVideoCaptureKind = (vcDefault, vcFromFile, vcFromIndex);

  TCVVideoCapture = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FKind: TCVVideoCaptureKind;
    FFilename: AnsiString;
    FIndex: Integer;
    FApiPreference: Integer;
    procedure ReleaseHandle;
    procedure RecreateOwned;
  public
    class operator Initialize(out Dest: TCVVideoCapture);
    class operator Finalize(var Dest: TCVVideoCapture);
    class operator Assign(var Dest: TCVVideoCapture; const [ref] Src: TCVVideoCapture);
    class function Create_0: TCVVideoCapture; static;
    class function Create_1(const filename: PAnsiChar; const apiPreference: Integer): TCVVideoCapture; static;
    class function Create_2(const index: Integer; const apiPreference: Integer): TCVVideoCapture; static;
    class function Create_3: TCVVideoCapture; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVVideoCapture; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function open(const filename: PAnsiChar; const apiPreference: Integer): Boolean; overload;
    function open(const index: Integer; const apiPreference: Integer): Boolean; overload;
    function isOpened(): Boolean;
    procedure releaseCap();
    function grab(): Boolean;
    function retrieve(const image: Pointer; const flag: Integer): Boolean;
    function read(const image: Pointer): Boolean; overload;
    function read(var image: TCVMat): Boolean; overload;
    function setProp(const propId: Integer; const value: Double): Boolean;
    function getProp(const propId: Integer): Double;
    function getBackendName(): PAnsiChar;
  end;

  TCVVideoWriterKind = (vwDefault, vwOpen1, vwOpen2);

  TCVVideoWriter = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FKind: TCVVideoWriterKind;
    FFilename: AnsiString;
    FFourcc: Integer;
    FFps: Double;
    FFrameSize: TCVSize;
    FIsColor: Boolean;
    FApiPreference: Integer;
    procedure ReleaseHandle;
    procedure RecreateOwned;
  public
    class operator Initialize(out Dest: TCVVideoWriter);
    class operator Finalize(var Dest: TCVVideoWriter);
    class operator Assign(var Dest: TCVVideoWriter; const [ref] Src: TCVVideoWriter);
    class function Create_0: TCVVideoWriter; static;
    class function Create_1(const filename: PAnsiChar; const fourcc: Integer; const fps: Double;
      const frameSize: TCVSize; const isColor: Boolean): TCVVideoWriter; static;
    class function Create_2(const filename: PAnsiChar; const apiPreference: Integer; const fourcc: Integer;
      const fps: Double; const frameSize: TCVSize; const isColor: Boolean): TCVVideoWriter; static;
    class function Create_3: TCVVideoWriter; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVVideoWriter; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function open(const filename: PAnsiChar; const fourcc: Integer; const fps: Double;
      const frameSize: TCVSize; const isColor: Boolean): Boolean; overload;
    function open(const filename: PAnsiChar; const apiPreference: Integer; const fourcc: Integer;
      const fps: Double; const frameSize: TCVSize; const isColor: Boolean): Boolean; overload;
    function isOpened(): Boolean;
    procedure releaseCap();
    function write(const image: Pointer): Boolean;
    function setProp(const propId: Integer; const value: Double): Boolean;
    function getProp(const propId: Integer): Double;
    function fourcc(const c1: AnsiChar; const c2: AnsiChar; const c3: AnsiChar; const c4: AnsiChar): Integer;
    function getBackendName(): PAnsiChar;
  end;

implementation

uses
  OpenCV5.Types;

// ==========================================
// Flat C API Imports
// ==========================================

function VideoCapture_Ctor_0(): Pointer; stdcall; external OpenCVLib delayed;
function VideoCapture_Ctor_1(filename: PAnsiChar; apiPreference: Integer): Pointer; stdcall; external OpenCVLib delayed;
function VideoCapture_Ctor_2(index: Integer; apiPreference: Integer): Pointer; stdcall; external OpenCVLib delayed;
function VideoCapture_Ctor_3(): Pointer; stdcall; external OpenCVLib delayed;
procedure VideoCapture_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function VideoCapture_open_0(self: Pointer; filename: PAnsiChar; apiPreference: Integer): Boolean; stdcall; external OpenCVLib delayed;
function VideoCapture_open_1(self: Pointer; index: Integer; apiPreference: Integer): Boolean; stdcall; external OpenCVLib delayed;
function VideoCapture_isOpened(self: Pointer): Boolean; stdcall; external OpenCVLib delayed;
procedure VideoCapture_release(self: Pointer); stdcall; external OpenCVLib delayed;
function VideoCapture_grab(self: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function VideoCapture_retrieve(self: Pointer; image: Pointer; flag: Integer): Boolean; stdcall; external OpenCVLib delayed;
function VideoCapture_read(self: Pointer; image: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function VideoCapture_set(self: Pointer; propId: Integer; value: Double): Boolean; stdcall; external OpenCVLib delayed;
function VideoCapture_get(self: Pointer; propId: Integer): Double; stdcall; external OpenCVLib delayed;
function VideoCapture_getBackendName(self: Pointer): PAnsiChar; stdcall; external OpenCVLib delayed;

function VideoWriter_Ctor_0(): Pointer; stdcall; external OpenCVLib delayed;
function VideoWriter_Ctor_1(filename: PAnsiChar; fourcc: Integer; fps: Double; frameSize: Pointer; isColor: Boolean): Pointer; stdcall; external OpenCVLib delayed;
function VideoWriter_Ctor_2(filename: PAnsiChar; apiPreference: Integer; fourcc: Integer; fps: Double; frameSize: Pointer; isColor: Boolean): Pointer; stdcall; external OpenCVLib delayed;
function VideoWriter_Ctor_3(): Pointer; stdcall; external OpenCVLib delayed;
procedure VideoWriter_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function VideoWriter_open_0(self: Pointer; filename: PAnsiChar; fourcc: Integer; fps: Double; frameSize: Pointer; isColor: Boolean): Boolean; stdcall; external OpenCVLib delayed;
function VideoWriter_open_1(self: Pointer; filename: PAnsiChar; apiPreference: Integer; fourcc: Integer; fps: Double; frameSize: Pointer; isColor: Boolean): Boolean; stdcall; external OpenCVLib delayed;
function VideoWriter_isOpened(self: Pointer): Boolean; stdcall; external OpenCVLib delayed;
procedure VideoWriter_release(self: Pointer); stdcall; external OpenCVLib delayed;
function VideoWriter_write(self: Pointer; image: Pointer): Boolean; stdcall; external OpenCVLib delayed;
function VideoWriter_set(self: Pointer; propId: Integer; value: Double): Boolean; stdcall; external OpenCVLib delayed;
function VideoWriter_get(self: Pointer; propId: Integer): Double; stdcall; external OpenCVLib delayed;
function VideoWriter_fourcc(self: Pointer; c1: AnsiChar; c2: AnsiChar; c3: AnsiChar; c4: AnsiChar): Integer; stdcall; external OpenCVLib delayed;
function VideoWriter_getBackendName(self: Pointer): PAnsiChar; stdcall; external OpenCVLib delayed;

// ==========================================
// TCVVideoCapture Implementation
// ==========================================

procedure TCVVideoCapture.ReleaseHandle;
begin
  if FOwnsHandle and Assigned(FHandle) then
    VideoCapture_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVVideoCapture.RecreateOwned;
begin
  ReleaseHandle;
  case FKind of
    vcDefault:
      FHandle := VideoCapture_Ctor_0();
    vcFromFile:
      FHandle := VideoCapture_Ctor_1(PAnsiChar(FFilename), FApiPreference);
    vcFromIndex:
      FHandle := VideoCapture_Ctor_2(FIndex, FApiPreference);
  end;
  FOwnsHandle := True;
end;

class operator TCVVideoCapture.Initialize(out Dest: TCVVideoCapture);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FKind := vcDefault;
  Dest.FFilename := '';
  Dest.FIndex := 0;
  Dest.FApiPreference := 0;
end;

class operator TCVVideoCapture.Finalize(var Dest: TCVVideoCapture);
begin
  Dest.ReleaseHandle;
end;

class operator TCVVideoCapture.Assign(var Dest: TCVVideoCapture; const [ref] Src: TCVVideoCapture);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FKind := Src.FKind;
  Dest.FFilename := Src.FFilename;
  Dest.FIndex := Src.FIndex;
  Dest.FApiPreference := Src.FApiPreference;
  if Src.FOwnsHandle and Assigned(Src.FHandle) then
    Dest.RecreateOwned
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVVideoCapture.Create_0: TCVVideoCapture;
begin
  Result.FKind := vcDefault;
  Result.FFilename := '';
  Result.FIndex := 0;
  Result.FApiPreference := 0;
  Result.FHandle := VideoCapture_Ctor_0();
  Result.FOwnsHandle := True;
end;

class function TCVVideoCapture.Create_1(const filename: PAnsiChar; const apiPreference: Integer): TCVVideoCapture;
begin
  Result.FKind := vcFromFile;
  Result.FFilename := filename;
  Result.FIndex := 0;
  Result.FApiPreference := apiPreference;
  Result.FHandle := VideoCapture_Ctor_1(filename, apiPreference);
  Result.FOwnsHandle := True;
end;

class function TCVVideoCapture.Create_2(const index: Integer; const apiPreference: Integer): TCVVideoCapture;
begin
  Result.FKind := vcFromIndex;
  Result.FFilename := '';
  Result.FIndex := index;
  Result.FApiPreference := apiPreference;
  Result.FHandle := VideoCapture_Ctor_2(index, apiPreference);
  Result.FOwnsHandle := True;
end;

class function TCVVideoCapture.Create_3: TCVVideoCapture;
begin
  Result.FKind := vcDefault;
  Result.FFilename := '';
  Result.FIndex := 0;
  Result.FApiPreference := 0;
  Result.FHandle := VideoCapture_Ctor_3();
  Result.FOwnsHandle := True;
end;

class function TCVVideoCapture.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVVideoCapture;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FKind := vcDefault;
  Result.FFilename := '';
  Result.FIndex := 0;
  Result.FApiPreference := 0;
end;

procedure TCVVideoCapture.Release;
begin
  ReleaseHandle;
end;

function TCVVideoCapture.open(const filename: PAnsiChar; const apiPreference: Integer): Boolean;
begin
  Result := VideoCapture_open_0(FHandle, filename, apiPreference);
end;

function TCVVideoCapture.open(const index: Integer; const apiPreference: Integer): Boolean;
begin
  Result := VideoCapture_open_1(FHandle, index, apiPreference);
end;

function TCVVideoCapture.isOpened(): Boolean;
begin
  Result := VideoCapture_isOpened(FHandle);
end;

procedure TCVVideoCapture.releaseCap();
begin
  VideoCapture_release(FHandle);
end;

function TCVVideoCapture.grab(): Boolean;
begin
  Result := VideoCapture_grab(FHandle);
end;

function TCVVideoCapture.retrieve(const image: Pointer; const flag: Integer): Boolean;
begin
  Result := VideoCapture_retrieve(FHandle, image, flag);
end;

function TCVVideoCapture.read(const image: Pointer): Boolean;
begin
  Result := VideoCapture_read(FHandle, image);
end;

function TCVVideoCapture.read(var image: TCVMat): Boolean;
begin
  if image.Handle = nil then
    image := TCVMat.Create_0(0, 0, CV_8UC3);
  Result := VideoCapture_read(FHandle, image.Handle);
end;

function TCVVideoCapture.setProp(const propId: Integer; const value: Double): Boolean;
begin
  Result := VideoCapture_set(FHandle, propId, value);
end;

function TCVVideoCapture.getProp(const propId: Integer): Double;
begin
  Result := VideoCapture_get(FHandle, propId);
end;

function TCVVideoCapture.getBackendName(): PAnsiChar;
begin
  Result := VideoCapture_getBackendName(FHandle);
end;

// ==========================================
// TCVVideoWriter Implementation
// ==========================================

procedure TCVVideoWriter.ReleaseHandle;
begin
  if FOwnsHandle and Assigned(FHandle) then
    VideoWriter_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVVideoWriter.RecreateOwned;
begin
  ReleaseHandle;
  case FKind of
    vwDefault:
      FHandle := VideoWriter_Ctor_0();
    vwOpen1:
      FHandle := VideoWriter_Ctor_1(PAnsiChar(FFilename), FFourcc, FFps, @FFrameSize, FIsColor);
    vwOpen2:
      FHandle := VideoWriter_Ctor_2(PAnsiChar(FFilename), FApiPreference, FFourcc, FFps, @FFrameSize, FIsColor);
  end;
  FOwnsHandle := True;
end;

class operator TCVVideoWriter.Initialize(out Dest: TCVVideoWriter);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FKind := vwDefault;
  Dest.FFilename := '';
  Dest.FFourcc := 0;
  Dest.FFps := 0;
  Dest.FFrameSize := TCVSize.Create(0, 0);
  Dest.FIsColor := False;
  Dest.FApiPreference := 0;
end;

class operator TCVVideoWriter.Finalize(var Dest: TCVVideoWriter);
begin
  Dest.ReleaseHandle;
end;

class operator TCVVideoWriter.Assign(var Dest: TCVVideoWriter; const [ref] Src: TCVVideoWriter);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FKind := Src.FKind;
  Dest.FFilename := Src.FFilename;
  Dest.FFourcc := Src.FFourcc;
  Dest.FFps := Src.FFps;
  Dest.FFrameSize := Src.FFrameSize;
  Dest.FIsColor := Src.FIsColor;
  Dest.FApiPreference := Src.FApiPreference;
  if Src.FOwnsHandle and Assigned(Src.FHandle) then
    Dest.RecreateOwned
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVVideoWriter.Create_0: TCVVideoWriter;
begin
  Result.FKind := vwDefault;
  Result.FFilename := '';
  Result.FFourcc := 0;
  Result.FFps := 0;
  Result.FFrameSize := TCVSize.Create(0, 0);
  Result.FIsColor := False;
  Result.FApiPreference := 0;
  Result.FHandle := VideoWriter_Ctor_0();
  Result.FOwnsHandle := True;
end;

class function TCVVideoWriter.Create_1(const filename: PAnsiChar; const fourcc: Integer; const fps: Double;
  const frameSize: TCVSize; const isColor: Boolean): TCVVideoWriter;
begin
  Result.FKind := vwOpen1;
  Result.FFilename := filename;
  Result.FFourcc := fourcc;
  Result.FFps := fps;
  Result.FFrameSize := frameSize;
  Result.FIsColor := isColor;
  Result.FApiPreference := 0;
  Result.FHandle := VideoWriter_Ctor_1(filename, fourcc, fps, @frameSize, isColor);
  Result.FOwnsHandle := True;
end;

class function TCVVideoWriter.Create_2(const filename: PAnsiChar; const apiPreference: Integer; const fourcc: Integer;
  const fps: Double; const frameSize: TCVSize; const isColor: Boolean): TCVVideoWriter;
begin
  Result.FKind := vwOpen2;
  Result.FFilename := filename;
  Result.FFourcc := fourcc;
  Result.FFps := fps;
  Result.FFrameSize := frameSize;
  Result.FIsColor := isColor;
  Result.FApiPreference := apiPreference;
  Result.FHandle := VideoWriter_Ctor_2(filename, apiPreference, fourcc, fps, @frameSize, isColor);
  Result.FOwnsHandle := True;
end;

class function TCVVideoWriter.Create_3: TCVVideoWriter;
begin
  Result.FKind := vwDefault;
  Result.FFilename := '';
  Result.FFourcc := 0;
  Result.FFps := 0;
  Result.FFrameSize := TCVSize.Create(0, 0);
  Result.FIsColor := False;
  Result.FApiPreference := 0;
  Result.FHandle := VideoWriter_Ctor_3();
  Result.FOwnsHandle := True;
end;

class function TCVVideoWriter.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVVideoWriter;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FKind := vwDefault;
  Result.FFilename := '';
  Result.FFourcc := 0;
  Result.FFps := 0;
  Result.FFrameSize := TCVSize.Create(0, 0);
  Result.FIsColor := False;
  Result.FApiPreference := 0;
end;

procedure TCVVideoWriter.Release;
begin
  ReleaseHandle;
end;

function TCVVideoWriter.open(const filename: PAnsiChar; const fourcc: Integer; const fps: Double;
  const frameSize: TCVSize; const isColor: Boolean): Boolean;
begin
  Result := VideoWriter_open_0(FHandle, filename, fourcc, fps, @frameSize, isColor);
end;

function TCVVideoWriter.open(const filename: PAnsiChar; const apiPreference: Integer; const fourcc: Integer;
  const fps: Double; const frameSize: TCVSize; const isColor: Boolean): Boolean;
begin
  Result := VideoWriter_open_1(FHandle, filename, apiPreference, fourcc, fps, @frameSize, isColor);
end;

function TCVVideoWriter.isOpened(): Boolean;
begin
  Result := VideoWriter_isOpened(FHandle);
end;

procedure TCVVideoWriter.releaseCap();
begin
  VideoWriter_release(FHandle);
end;

function TCVVideoWriter.write(const image: Pointer): Boolean;
begin
  Result := VideoWriter_write(FHandle, image);
end;

function TCVVideoWriter.setProp(const propId: Integer; const value: Double): Boolean;
begin
  Result := VideoWriter_set(FHandle, propId, value);
end;

function TCVVideoWriter.getProp(const propId: Integer): Double;
begin
  Result := VideoWriter_get(FHandle, propId);
end;

function TCVVideoWriter.fourcc(const c1: AnsiChar; const c2: AnsiChar; const c3: AnsiChar; const c4: AnsiChar): Integer;
begin
  Result := VideoWriter_fourcc(FHandle, c1, c2, c3, c4);
end;

function TCVVideoWriter.getBackendName(): PAnsiChar;
begin
  Result := VideoWriter_getBackendName(FHandle);
end;

end.
