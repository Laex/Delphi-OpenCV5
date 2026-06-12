unit OpenCV5.Stitching;

interface

uses
  OpenCV5.Core;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

  STITCHER_PANORAMA = 0;
  STITCHER_SCANS = 1;

  STITCHER_OK = 0;
  STITCHER_ERR_NEED_MORE_IMGS = 1;
  STITCHER_ERR_HOMOGRAPHY_EST_FAIL = 2;
  STITCHER_ERR_CAMERA_PARAMS_ADJUST_FAIL = 3;

type
  TCVStitcher = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    FMode: Integer;
    procedure ReleaseHandle;
    procedure CreateOwned;
  public
    class operator Initialize(out Dest: TCVStitcher);
    class operator Finalize(var Dest: TCVStitcher);
    class operator Assign(var Dest: TCVStitcher; const [ref] Src: TCVStitcher);
    class function Create(const mode: Integer = STITCHER_PANORAMA): TCVStitcher; static;
    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVStitcher; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    function stitch(const images: array of TCVMat; const pano: Pointer): Integer;
  end;

implementation

function Stitching_create(mode: Integer): Pointer; stdcall; external OpenCVLib delayed;
procedure Stitching_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
function Stitching_stitch(self: Pointer; images: Pointer; count: Integer; pano: Pointer): Integer; stdcall; external OpenCVLib delayed;

{ TCVStitcher }

procedure TCVStitcher.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Stitching_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

procedure TCVStitcher.CreateOwned;
begin
  ReleaseHandle;
  FHandle := Stitching_create(FMode);
  FOwnsHandle := True;
end;

class operator TCVStitcher.Initialize(out Dest: TCVStitcher);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
  Dest.FMode := STITCHER_PANORAMA;
end;

class operator TCVStitcher.Finalize(var Dest: TCVStitcher);
begin
  Dest.ReleaseHandle;
end;

class operator TCVStitcher.Assign(var Dest: TCVStitcher; const [ref] Src: TCVStitcher);
begin
  if @Dest = @Src then
    Exit;
  Dest.ReleaseHandle;
  Dest.FMode := Src.FMode;
  if Src.FOwnsHandle then
    Dest.CreateOwned
  else
  begin
    Dest.FHandle := Src.FHandle;
    Dest.FOwnsHandle := False;
  end;
end;

class function TCVStitcher.Create(const mode: Integer): TCVStitcher;
begin
  Result.FMode := mode;
  Result.FHandle := Stitching_create(mode);
  Result.FOwnsHandle := True;
end;

class function TCVStitcher.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVStitcher;
begin
  Result.FHandle := AHandle;
  Result.FOwnsHandle := AOwnsHandle;
  Result.FMode := STITCHER_PANORAMA;
end;

procedure TCVStitcher.Release;
begin
  ReleaseHandle;
end;

function TCVStitcher.stitch(const images: array of TCVMat; const pano: Pointer): Integer;
var
  Handles: array of Pointer;
  I: Integer;
begin
  SetLength(Handles, Length(images));
  for I := 0 to High(images) do
    Handles[I] := images[I].Handle;
  if Length(Handles) = 0 then
    Exit(STITCHER_ERR_NEED_MORE_IMGS);
  Result := Stitching_stitch(FHandle, @Handles[0], Length(Handles), pano);
end;

end.
