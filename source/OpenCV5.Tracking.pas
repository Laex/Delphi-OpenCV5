unit OpenCV5.Tracking;



interface



uses

  OpenCV5.Core,

  OpenCV5.Types;



const

  OpenCVLib = 'opencv_delphi_wrapper.dll';



type

  TCVKalmanFilter = record

  private

    FHandle: Pointer;

    FOwnsHandle: Boolean;

    FDynamParams: Integer;

    FMeasureParams: Integer;

    FControlParams: Integer;

    FType: Integer;

    procedure ReleaseHandle;

  public

    class operator Initialize(out Dest: TCVKalmanFilter);

    class operator Finalize(var Dest: TCVKalmanFilter);

    class operator Assign(var Dest: TCVKalmanFilter; const [ref] Src: TCVKalmanFilter);

    class function Create(const dynamParams, measureParams: Integer;

      const controlParams: Integer = 0; const matType: Integer = CV_32F): TCVKalmanFilter; static;

    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVKalmanFilter; static;

    procedure Release;

    property Handle: Pointer read FHandle;

    function predict(const control: Pointer): TCVMat;

    function correct(const measurement: Pointer): TCVMat;

    function getState: TCVMat;

  end;



procedure camShift(const probImage: Pointer; var windowRect: TCVRect;

  const criteria: TCVTermCriteria; out rotated: TCVRotatedRect);



function meanShift(const probImage: Pointer; var windowRect: TCVRect;

  const criteria: TCVTermCriteria): Integer;

type
  TCVTrackerMIL = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    procedure ReleaseHandle;
  public
    class operator Initialize(out Dest: TCVTrackerMIL);
    class operator Finalize(var Dest: TCVTrackerMIL);
    class function Create: TCVTrackerMIL; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure init(const image: Pointer; const bbox: TCVRect);
    function update(const image: Pointer; out bbox: TCVRect): Boolean;
  end;

  TCVTrackerNano = record
  private
    FHandle: Pointer;
    FOwnsHandle: Boolean;
    procedure ReleaseHandle;
  public
    class operator Initialize(out Dest: TCVTrackerNano);
    class operator Finalize(var Dest: TCVTrackerNano);
    class function Create: TCVTrackerNano; static;
    procedure Release;
    property Handle: Pointer read FHandle;
    procedure init(const image: Pointer; const bbox: TCVRect);
    function update(const image: Pointer; out bbox: TCVRect): Boolean;
  end;

implementation



procedure Tracking_CamShift(probImage: Pointer; windowRect: PInteger; criteria: Pointer;

  centerX, centerY, width, height, angle: PSingle); stdcall; external OpenCVLib delayed;

function Tracking_meanShift(probImage: Pointer; windowRect: PInteger; criteria: Pointer): Integer; stdcall; external OpenCVLib delayed;



function Tracking_Kalman_Create(dynamParams, measureParams, controlParams, matType: Integer): Pointer; stdcall; external OpenCVLib delayed;

procedure Tracking_Kalman_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;

function Tracking_Kalman_predict(self, control: Pointer): Pointer; stdcall; external OpenCVLib delayed;

function Tracking_Kalman_correct(self, measurement: Pointer): Pointer; stdcall; external OpenCVLib delayed;

function Tracking_Kalman_get_state(self: Pointer): Pointer; stdcall; external OpenCVLib delayed;

function Tracking_TrackerMIL_Create: Pointer; stdcall; external OpenCVLib delayed;
procedure Tracking_TrackerMIL_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Tracking_TrackerMIL_init(self, image: Pointer; x, y, w, h: Integer); stdcall; external OpenCVLib delayed;
function Tracking_TrackerMIL_update(self, image: Pointer; x, y, w, h: PInteger): Boolean; stdcall; external OpenCVLib delayed;
function Tracking_TrackerNano_Create: Pointer; stdcall; external OpenCVLib delayed;
procedure Tracking_TrackerNano_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;
procedure Tracking_TrackerNano_init(self, image: Pointer; x, y, w, h: Integer); stdcall; external OpenCVLib delayed;
function Tracking_TrackerNano_update(self, image: Pointer; x, y, w, h: PInteger): Boolean; stdcall; external OpenCVLib delayed;

procedure camShift(const probImage: Pointer; var windowRect: TCVRect;

  const criteria: TCVTermCriteria; out rotated: TCVRotatedRect);

var

  R: array[0..3] of Integer;

  CX, CY, W, H, A: Single;

begin

  R[0] := windowRect.X;

  R[1] := windowRect.Y;

  R[2] := windowRect.Width;

  R[3] := windowRect.Height;

  Tracking_CamShift(probImage, @R[0], @criteria, @CX, @CY, @W, @H, @A);

  windowRect := TCVRect.Create(R[0], R[1], R[2], R[3]);

  rotated.Center := TCVPoint2f.Create(CX, CY);

  rotated.Size := TCVSize2f.Create(W, H);

  rotated.Angle := A;

end;



function meanShift(const probImage: Pointer; var windowRect: TCVRect;

  const criteria: TCVTermCriteria): Integer;

var

  R: array[0..3] of Integer;

begin

  R[0] := windowRect.X;

  R[1] := windowRect.Y;

  R[2] := windowRect.Width;

  R[3] := windowRect.Height;

  Result := Tracking_meanShift(probImage, @R[0], @criteria);

  windowRect := TCVRect.Create(R[0], R[1], R[2], R[3]);

end;



{ TCVKalmanFilter }



procedure TCVKalmanFilter.ReleaseHandle;

begin

  if FOwnsHandle and (FHandle <> nil) then

    Tracking_Kalman_Destroy(FHandle);

  FHandle := nil;

  FOwnsHandle := False;

end;



class operator TCVKalmanFilter.Initialize(out Dest: TCVKalmanFilter);

begin

  Dest.FHandle := nil;

  Dest.FOwnsHandle := False;

  Dest.FDynamParams := 0;

  Dest.FMeasureParams := 0;

  Dest.FControlParams := 0;

  Dest.FType := CV_32F;

end;



class operator TCVKalmanFilter.Finalize(var Dest: TCVKalmanFilter);

begin

  Dest.ReleaseHandle;

end;



class operator TCVKalmanFilter.Assign(var Dest: TCVKalmanFilter; const [ref] Src: TCVKalmanFilter);

begin

  if @Dest = @Src then Exit;

  Dest.ReleaseHandle;

  Dest.FDynamParams := Src.FDynamParams;

  Dest.FMeasureParams := Src.FMeasureParams;

  Dest.FControlParams := Src.FControlParams;

  Dest.FType := Src.FType;

  if Src.FOwnsHandle then

    Dest := TCVKalmanFilter.Create(Src.FDynamParams, Src.FMeasureParams, Src.FControlParams, Src.FType)

  else

  begin

    Dest.FHandle := Src.FHandle;

    Dest.FOwnsHandle := False;

  end;

end;



class function TCVKalmanFilter.Create(const dynamParams, measureParams, controlParams,

  matType: Integer): TCVKalmanFilter;

begin

  Result.FDynamParams := dynamParams;

  Result.FMeasureParams := measureParams;

  Result.FControlParams := controlParams;

  Result.FType := matType;

  Result.FHandle := Tracking_Kalman_Create(dynamParams, measureParams, controlParams, matType);

  Result.FOwnsHandle := True;

end;



class function TCVKalmanFilter.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVKalmanFilter;

begin

  Result.FHandle := AHandle;

  Result.FOwnsHandle := AOwnsHandle;

end;



procedure TCVKalmanFilter.Release;

begin

  ReleaseHandle;

end;



function TCVKalmanFilter.predict(const control: Pointer): TCVMat;

begin

  Result := TCVMat.FromHandle(Tracking_Kalman_predict(FHandle, control));

end;



function TCVKalmanFilter.correct(const measurement: Pointer): TCVMat;

begin

  Result := TCVMat.FromHandle(Tracking_Kalman_correct(FHandle, measurement));

end;



function TCVKalmanFilter.getState: TCVMat;

begin

  Result := TCVMat.FromHandle(Tracking_Kalman_get_state(FHandle));

end;

{ TCVTrackerMIL }

procedure TCVTrackerMIL.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Tracking_TrackerMIL_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

class operator TCVTrackerMIL.Initialize(out Dest: TCVTrackerMIL);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
end;

class operator TCVTrackerMIL.Finalize(var Dest: TCVTrackerMIL);
begin
  Dest.ReleaseHandle;
end;

class function TCVTrackerMIL.Create: TCVTrackerMIL;
begin
  Result.FHandle := Tracking_TrackerMIL_Create;
  Result.FOwnsHandle := True;
end;

procedure TCVTrackerMIL.Release;
begin
  ReleaseHandle;
end;

procedure TCVTrackerMIL.init(const image: Pointer; const bbox: TCVRect);
begin
  if FHandle <> nil then
    Tracking_TrackerMIL_init(FHandle, image, bbox.X, bbox.Y, bbox.Width, bbox.Height);
end;

function TCVTrackerMIL.update(const image: Pointer; out bbox: TCVRect): Boolean;
var
  X, Y, W, H: Integer;
begin
  if FHandle = nil then
    Exit(False);
  Result := Tracking_TrackerMIL_update(FHandle, image, @X, @Y, @W, @H);
  bbox := TCVRect.Create(X, Y, W, H);
end;

{ TCVTrackerNano }

procedure TCVTrackerNano.ReleaseHandle;
begin
  if FOwnsHandle and (FHandle <> nil) then
    Tracking_TrackerNano_Destroy(FHandle);
  FHandle := nil;
  FOwnsHandle := False;
end;

class operator TCVTrackerNano.Initialize(out Dest: TCVTrackerNano);
begin
  Dest.FHandle := nil;
  Dest.FOwnsHandle := False;
end;

class operator TCVTrackerNano.Finalize(var Dest: TCVTrackerNano);
begin
  Dest.ReleaseHandle;
end;

class function TCVTrackerNano.Create: TCVTrackerNano;
begin
  Result.FHandle := Tracking_TrackerNano_Create;
  Result.FOwnsHandle := True;
end;

procedure TCVTrackerNano.Release;
begin
  ReleaseHandle;
end;

procedure TCVTrackerNano.init(const image: Pointer; const bbox: TCVRect);
begin
  if FHandle <> nil then
    Tracking_TrackerNano_init(FHandle, image, bbox.X, bbox.Y, bbox.Width, bbox.Height);
end;

function TCVTrackerNano.update(const image: Pointer; out bbox: TCVRect): Boolean;
var
  X, Y, W, H: Integer;
begin
  if FHandle = nil then
    Exit(False);
  Result := Tracking_TrackerNano_update(FHandle, image, @X, @Y, @W, @H);
  bbox := TCVRect.Create(X, Y, W, H);
end;

end.

