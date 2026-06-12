unit OpenCV5.Components.Mux;



{$IFNDEF WIN64}

  {$IFNDEF PACKAGE}

    {$MESSAGE ERROR 'OpenCV 5.0 components are only supported in Win64 applications.'}

  {$ENDIF}

{$ENDIF}



interface



uses

  System.Classes, System.SysUtils, OpenCV5.Core, OpenCV5.Components.Base;



type

  TcvMuxMode = (

    mmFallback,

    mmStrict

  );



  TcvMuxSelectEvent = procedure(Sender: TObject; const FrameA, FrameB: TCVMat;

    var SelectedInput: Integer) of object;



  TcvMultiplexer = class(TCVDataSource)

  private

    FSourceA: TCVDataSource;

    FSourceB: TCVDataSource;

    FReceiverA: ICVDataReceiver;

    FReceiverB: ICVDataReceiver;

    FFrameA: TCVMat;

    FFrameB: TCVMat;

    FHasA: Boolean;

    FHasB: Boolean;

    FMode: TcvMuxMode;

    FOnSelectInput: TcvMuxSelectEvent;

    procedure SetSourceA(const Value: TCVDataSource);

    procedure SetSourceB(const Value: TCVDataSource);

    procedure SetMode(const Value: TcvMuxMode);

    procedure SubscribeSource(const OldSource, NewSource: TCVDataSource;

      const Receiver: ICVDataReceiver);

    procedure UnsubscribeSource(const Source: TCVDataSource; const Receiver: ICVDataReceiver);

    function ResolveOutput(const Selected: Integer; out OutMat: TCVMat): Boolean;

    procedure TryForward(const InputIndex: Integer);

  public

    constructor Create(AOwner: TComponent); override;

    destructor Destroy; override;

    procedure ProcessInput(const InputIndex: Integer; const AMat: TCVMat);

    class function ComponentPlatforms: Integer;

  published

    property SourceA: TCVDataSource read FSourceA write SetSourceA;

    property SourceB: TCVDataSource read FSourceB write SetSourceB;

    property Mode: TcvMuxMode read FMode write SetMode default mmFallback;

    property OnSelectInput: TcvMuxSelectEvent read FOnSelectInput write FOnSelectInput;

  end;



implementation



type

  TcvMuxInputReceiver = class(TInterfacedObject, ICVDataReceiver)

  private

    FMux: TcvMultiplexer;

    FInputIndex: Integer;

  public

    constructor Create(AMux: TcvMultiplexer; AInputIndex: Integer);

    procedure TakeMat(const AMat: TCVMat);

    procedure SetSource(const Value: TObject);

  end;



{ TcvMuxInputReceiver }



constructor TcvMuxInputReceiver.Create(AMux: TcvMultiplexer; AInputIndex: Integer);

begin

  inherited Create;

  FMux := AMux;

  FInputIndex := AInputIndex;

end;



procedure TcvMuxInputReceiver.TakeMat(const AMat: TCVMat);

begin

  FMux.ProcessInput(FInputIndex, AMat);

end;



procedure TcvMuxInputReceiver.SetSource(const Value: TObject);

begin

  // MUX wiring is via SourceA / SourceB on the multiplexer component

end;



{ TcvMultiplexer }



constructor TcvMultiplexer.Create(AOwner: TComponent);

begin

  inherited Create(AOwner);

  FEnabled := True;

  FMode := mmFallback;

  FHasA := False;

  FHasB := False;

  FReceiverA := TcvMuxInputReceiver.Create(Self, 0);

  FReceiverB := TcvMuxInputReceiver.Create(Self, 1);

end;



destructor TcvMultiplexer.Destroy;

begin

  UnsubscribeSource(FSourceA, FReceiverA);

  UnsubscribeSource(FSourceB, FReceiverB);

  FReceiverA := nil;

  FReceiverB := nil;

  inherited Destroy;

end;



class function TcvMultiplexer.ComponentPlatforms: Integer;

begin

  Result := $0002 or $0800; // pidWin64 ($0002) + pidWin64x ($0800)

end;



procedure TcvMultiplexer.SetMode(const Value: TcvMuxMode);

begin

  FMode := Value;

end;



procedure TcvMultiplexer.UnsubscribeSource(const Source: TCVDataSource;

  const Receiver: ICVDataReceiver);

begin

  if Assigned(Source) and Assigned(Receiver) and (not (csDesigning in ComponentState)) then

    ICVDataSource(Source).RemoveReceiver(Receiver);

end;



procedure TcvMultiplexer.SubscribeSource(const OldSource, NewSource: TCVDataSource;

  const Receiver: ICVDataReceiver);

begin

  UnsubscribeSource(OldSource, Receiver);

  if Assigned(NewSource) and Assigned(Receiver) and (not (csDesigning in ComponentState)) then

    ICVDataSource(NewSource).AddReceiver(Receiver);

end;



procedure TcvMultiplexer.SetSourceA(const Value: TCVDataSource);

var

  NewSource: TCVDataSource;

begin

  NewSource := Value;

  if NewSource = Self then

    NewSource := nil;

  if FSourceA <> NewSource then

  begin

    SubscribeSource(FSourceA, NewSource, FReceiverA);

    FSourceA := NewSource;

  end;

end;



procedure TcvMultiplexer.SetSourceB(const Value: TCVDataSource);

var

  NewSource: TCVDataSource;

begin

  NewSource := Value;

  if NewSource = Self then

    NewSource := nil;

  if FSourceB <> NewSource then

  begin

    SubscribeSource(FSourceB, NewSource, FReceiverB);

    FSourceB := NewSource;

  end;

end;



function TcvMultiplexer.ResolveOutput(const Selected: Integer; out OutMat: TCVMat): Boolean;

begin

  Result := False;

  case FMode of

    mmFallback:

      if Selected = 0 then

      begin

        if FHasA then

          OutMat := FFrameA

        else if FHasB then

          OutMat := FFrameB

        else

          Exit;

      end

      else

      begin

        if FHasB then

          OutMat := FFrameB

        else if FHasA then

          OutMat := FFrameA

        else

          Exit;

      end;

    mmStrict:

      if Selected = 0 then

      begin

        if not FHasA then

          Exit;

        OutMat := FFrameA;

      end

      else

      begin

        if not FHasB then

          Exit;

        OutMat := FFrameB;

      end;

  else

    Exit;

  end;

  Result := True;

end;



procedure TcvMultiplexer.TryForward(const InputIndex: Integer);

var

  Selected: Integer;

  OutMat: TCVMat;

begin

  if InputIndex = 1 then

  begin

    if FMode <> mmFallback then

      Exit;

    if FHasA then

      Exit;

    if not FHasB then

      Exit;

  end;



  Selected := 0;

  if Assigned(FOnSelectInput) then

    FOnSelectInput(Self, FFrameA, FFrameB, Selected);



  if ResolveOutput(Selected, OutMat) then

    NotifyReceiver(OutMat);

end;



procedure TcvMultiplexer.ProcessInput(const InputIndex: Integer; const AMat: TCVMat);

begin

  if (ComponentState * [csDestroying, csDesigning]) <> [] then

    Exit;



  if InputIndex = 0 then

  begin

    FFrameA := AMat.clone;

    FHasA := not FFrameA.empty;

  end

  else

  begin

    FFrameB := AMat.clone;

    FHasB := not FFrameB.empty;

  end;



  if not Enabled then

    Exit;



  if InputIndex = 0 then

    TryForward(0)

  else

    TryForward(1);

end;



end.

