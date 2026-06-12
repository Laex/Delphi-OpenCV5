unit OpenCV5.Components.VideoSource;

{$IFNDEF WIN64}
  {$IFNDEF PACKAGE}
    {$MESSAGE ERROR 'OpenCV 5.0 components are only supported in Win64 applications.'}
  {$ENDIF}
{$ENDIF}

interface

uses
  System.Classes, System.SysUtils, System.Diagnostics,
  OpenCV5.Core, OpenCV5.Types, OpenCV5.Videoio, OpenCV5.Components.Base;

type
  TcvFrameEvent = procedure(Sender: TObject; const Frame: TCVMat) of object;
  TcvProcessFrameEvent = procedure(Sender: TObject; const InFrame: TCVMat; var OutFrame: TCVMat) of object;
  TcvErrorEvent = procedure(Sender: TObject; const Msg: string) of object;

  TcvCustomVideoSource = class(TCVDataSource)
  private
    FActive: Boolean;
    FFPS: Integer;
    FOnFrame: TcvFrameEvent;
    FOnProcessFrame: TcvProcessFrameEvent;
    FOnError: TcvErrorEvent;
    FThread: TThread;
  protected
    function getEnabled: Boolean; override;
    procedure setEnabled(const Value: Boolean); override;
    procedure DoFrame(const Frame: TCVMat); virtual;
    procedure DoProcessFrame(const InFrame: TCVMat; var OutFrame: TCVMat); virtual;
    procedure DoError(const Msg: string); virtual;
    procedure StartCapture; virtual;
    procedure StopCapture; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property FPS: Integer read FFPS write FFPS default 30;
    property OnFrame: TcvFrameEvent read FOnFrame write FOnFrame;
    property OnProcessFrame: TcvProcessFrameEvent read FOnProcessFrame write FOnProcessFrame;
    property OnError: TcvErrorEvent read FOnError write FOnError;
  end;

  TcvCaptureThread = class(TThread)
  private
    FSource: TcvCustomVideoSource;
    FCurrentFrame: TCVMat;
    FErrorMsg: string;
    procedure SyncFrame;
    procedure SyncError;
  protected
    procedure Execute; override;
  public
    constructor Create(ASource: TcvCustomVideoSource);
  end;

  TcvCamera = class(TcvCustomVideoSource)
  private
    FCameraIndex: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FBackend: Integer;
  protected
    procedure StartCapture; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Enabled;
    property CameraIndex: Integer read FCameraIndex write FCameraIndex default 0;
    property Width: Integer read FWidth write FWidth default 640;
    property Height: Integer read FHeight write FHeight default 480;
    property FPS;
    property Backend: Integer read FBackend write FBackend default CAP_ANY;
    property OnFrame;
    property OnProcessFrame;
    property OnError;
  end;

  TcvVideoFile = class(TcvCustomVideoSource)
  private
    FFileName: string;
    FLoop: Boolean;
  protected
    procedure StartCapture; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Enabled;
    property FileName: string read FFileName write FFileName;
    property Loop: Boolean read FLoop write FLoop default True;
    property FPS;
    property OnFrame;
    property OnProcessFrame;
    property OnError;
  end;

implementation

{ TcvCustomVideoSource }

constructor TcvCustomVideoSource.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FActive := False;
  FFPS := 30;
  FThread := nil;
end;

destructor TcvCustomVideoSource.Destroy;
begin
  setEnabled(False);
  inherited Destroy;
end;

function TcvCustomVideoSource.getEnabled: Boolean;
begin
  Result := FActive;
end;

procedure TcvCustomVideoSource.setEnabled(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    if Value then
      StartCapture
    else
      StopCapture;
  end;
end;

procedure TcvCustomVideoSource.StartCapture;
begin
  if not(csDesigning in ComponentState) then
  begin
    FActive := True;
    FThread := TcvCaptureThread.Create(Self);
  end;
end;

procedure TcvCustomVideoSource.StopCapture;
begin
  FActive := False;
  if Assigned(FThread) then
  begin
    FThread.Terminate;
    FThread.WaitFor;
    FreeAndNil(FThread);
  end;
end;

procedure TcvCustomVideoSource.DoFrame(const Frame: TCVMat);
begin
  if Assigned(FOnFrame) then
    FOnFrame(Self, Frame);
  NotifyReceiver(Frame); // Рассылка подписчикам
end;

procedure TcvCustomVideoSource.DoProcessFrame(const InFrame: TCVMat; var OutFrame: TCVMat);
begin
  if Assigned(FOnProcessFrame) then
    FOnProcessFrame(Self, InFrame, OutFrame);
end;

procedure TcvCustomVideoSource.DoError(const Msg: string);
begin
  if Assigned(FOnError) then
    FOnError(Self, Msg);
end;

{ TcvCaptureThread }

constructor TcvCaptureThread.Create(ASource: TcvCustomVideoSource);
begin
  inherited Create(False); // Запуск сразу
  FSource := ASource;
  FreeOnTerminate := False;
end;

procedure TcvCaptureThread.SyncFrame;
begin
  if not Terminated then
    FSource.DoFrame(FCurrentFrame);
end;

procedure TcvCaptureThread.SyncError;
begin
  FSource.DoError(FErrorMsg);
end;

procedure TcvCaptureThread.Execute;
var
  Cap: TCVVideoCapture;
  Frame, ProcessedFrame: TCVMat;
  Success: Boolean;
  TargetDelay, Elapsed: Int64;
  Stopwatch: TStopwatch;
begin
  if FSource is TcvCamera then
  begin
    Cap := TCVVideoCapture.Create_2(TcvCamera(FSource).CameraIndex, TcvCamera(FSource).Backend);
    if TcvCamera(FSource).Width > 0 then
      Cap.setProp(CAP_PROP_FRAME_WIDTH, TcvCamera(FSource).Width);
    if TcvCamera(FSource).Height > 0 then
      Cap.setProp(CAP_PROP_FRAME_HEIGHT, TcvCamera(FSource).Height);
    if TcvCamera(FSource).FPS > 0 then
      Cap.setProp(CAP_PROP_FPS, TcvCamera(FSource).FPS);
  end
  else if FSource is TcvVideoFile then
  begin
    Cap := TCVVideoCapture.Create_1(PAnsiChar(AnsiString(TcvVideoFile(FSource).FileName)), 0);
  end
  else
  begin
    Cap := TCVVideoCapture.Create_0;
  end;

  if not Cap.isOpened then
  begin
    FErrorMsg := 'Cannot open video source';
    Synchronize(SyncError);
    Exit;
  end;

  TargetDelay := 1000 div FSource.FPS;

  while not Terminated do
  begin
    Stopwatch := TStopwatch.StartNew;

    Success := Cap.read(Frame);

    if not Success then
    begin
      if (FSource is TcvVideoFile) and TcvVideoFile(FSource).Loop then
      begin
        Cap.setProp(CAP_PROP_POS_FRAMES, 0);
        Continue;
      end;
      Break;
    end;

    if Frame.empty then
      Continue;

    ProcessedFrame := Frame;
    FSource.DoProcessFrame(Frame, ProcessedFrame);

    FCurrentFrame := ProcessedFrame;
    Synchronize(SyncFrame);

    Stopwatch.Stop;
    Elapsed := Stopwatch.ElapsedMilliseconds;
    if Elapsed < TargetDelay then
      Sleep(TargetDelay - Elapsed)
    else
      Sleep(1);
  end;

  Cap.releaseCap;
end;

{ TcvCamera }

constructor TcvCamera.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCameraIndex := 0;
  FWidth := 640;
  FHeight := 480;
  FBackend := CAP_ANY;
end;

procedure TcvCamera.StartCapture;
begin
  inherited StartCapture;
end;

{ TcvVideoFile }

constructor TcvVideoFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLoop := True;
end;

procedure TcvVideoFile.StartCapture;
begin
  if FFileName = '' then
    raise Exception.Create('Video file name not specified');
  inherited StartCapture;
end;

end.
