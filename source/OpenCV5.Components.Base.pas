unit OpenCV5.Components.Base;

{$IFNDEF WIN64}
  {$IFNDEF PACKAGE}
    {$MESSAGE ERROR 'OpenCV 5.0 components are only supported in Win64 applications.'}
  {$ENDIF}
{$ENDIF}

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, OpenCV5.Core;

type
  ICVDataReceiver = interface;

  ICVDataSource = interface
    ['{03150528-1FB4-4677-9194-D63E38D0B67E}']
    procedure AddReceiver(const CVReceiver: ICVDataReceiver);
    procedure RemoveReceiver(const CVReceiver: ICVDataReceiver);
    function getEnabled: Boolean;
    procedure setEnabled(const Value: Boolean);
    function getObjectName: string;
    property Enabled: Boolean read getEnabled write setEnabled;
  end;

  ICVDataReceiver = interface
    ['{7EBE0282-0731-45EB-8A1D-1097C2CBC680}']
    procedure TakeMat(const AMat: TCVMat);
    procedure SetSource(const Value: TObject);
  end;

  TCVReceiverList = TThreadList<ICVDataReceiver>;
  TOnCVNotify = procedure(Sender: TObject; const AMat: TCVMat) of object;
  TOnCVNotifyVar = procedure(Sender: TObject; var AMat: TCVMat) of object;

  TCVDataSource = class(TComponent, ICVDataSource)
  protected
    FEnabled: Boolean;
    FCVReceivers: TCVReceiverList;
    FOnBeforeNotifyReceiver: TOnCVNotifyVar;
    FOnCVNotify: TOnCVNotifyVar;
    procedure NotifyReceiver(const AMat: TCVMat); virtual;
    function getEnabled: Boolean; virtual;
    procedure setEnabled(const Value: Boolean); virtual;
    function getObjectName: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddReceiver(const CVReceiver: ICVDataReceiver); virtual;
    procedure RemoveReceiver(const CVReceiver: ICVDataReceiver); virtual;
    class function ComponentPlatforms: Integer;
  published
    property Enabled: Boolean read getEnabled write setEnabled default False;
    property OnBeforeNotifyReceiver: TOnCVNotifyVar read FOnBeforeNotifyReceiver write FOnBeforeNotifyReceiver;
    property OnCVNotify: TOnCVNotifyVar read FOnCVNotify write FOnCVNotify;
  end;

  TCVDataReceiver = class(TComponent, ICVDataReceiver)
  private
    FCVSourceComponent: TCVDataSource;
    function GetSource: TCVDataSource;
    procedure SetSourceComponent(const Value: TCVDataSource);
  protected
    procedure SetSource(const Value: TObject); virtual;
    procedure SubscribeSource(const Value: TCVDataSource); virtual;
    procedure UnsubscribeSource; virtual;
  public
    procedure TakeMat(const AMat: TCVMat); virtual; abstract;
    destructor Destroy; override;
    function isSourceEnabled: Boolean; virtual;
    class function ComponentPlatforms: Integer;
  published
    property Source: TCVDataSource read GetSource write SetSourceComponent;
  end;

  TCVDataProxy = class(TCVDataSource, ICVDataReceiver)
  private
    FUpstreamSource: TCVDataSource;
    function GetSource: TCVDataSource;
    procedure SetSourceComponent(const Value: TCVDataSource);
  protected
    procedure SetSource(const Value: TObject); virtual;
    procedure SubscribeSource(const Value: TCVDataSource); virtual;
    procedure UnsubscribeSource; virtual;
  public
    procedure TakeMat(const AMat: TCVMat); virtual; abstract;
    destructor Destroy; override;
    class function ComponentPlatforms: Integer;
  published
    property Source: TCVDataSource read GetSource write SetSourceComponent;
  end;
implementation

{ TCVDataSource }

constructor TCVDataSource.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := False;
  FCVReceivers := TCVReceiverList.Create;
end;

destructor TCVDataSource.Destroy;
begin
  FCVReceivers.Free;
  inherited Destroy;
end;

function TCVDataSource.getEnabled: Boolean;
begin
  Result := FEnabled;
end;

procedure TCVDataSource.setEnabled(const Value: Boolean);
begin
  FEnabled := Value;
end;

procedure TCVDataSource.AddReceiver(const CVReceiver: ICVDataReceiver);
begin
  FCVReceivers.Add(CVReceiver);
end;

procedure TCVDataSource.RemoveReceiver(const CVReceiver: ICVDataReceiver);
begin
  FCVReceivers.Remove(CVReceiver);
end;

function TCVDataSource.getObjectName: string;
begin
  Result := Name;
end;

procedure TCVDataSource.NotifyReceiver(const AMat: TCVMat);
var
  R: ICVDataReceiver;
  LockList: TList<ICVDataReceiver>;
  M: TCVMat;
begin
  LockList := FCVReceivers.LockList;
  try
    if LockList.Count = 0 then
      Exit;

    if LockList.Count = 1 then
    begin
      M := AMat;
      if Assigned(FOnBeforeNotifyReceiver) then
        FOnBeforeNotifyReceiver(Self, M);
      LockList[0].TakeMat(M);
      if Assigned(FOnCVNotify) then
        FOnCVNotify(Self, M);
    end
    else
    begin
      M := AMat.clone;
      if Assigned(FOnBeforeNotifyReceiver) then
        FOnBeforeNotifyReceiver(Self, M);
      for R in LockList do
        R.TakeMat(M);
      if Assigned(FOnCVNotify) then
        FOnCVNotify(Self, M);
    end;
  finally
    FCVReceivers.UnlockList;
  end;
end;

class function TCVDataSource.ComponentPlatforms: Integer;
begin
  Result := $0002 or $0800; // pidWin64 ($0002) + pidWin64x ($0800)
end;

{ TCVDataReceiver }

destructor TCVDataReceiver.Destroy;
begin
  UnsubscribeSource;
  inherited Destroy;
end;

function TCVDataReceiver.GetSource: TCVDataSource;
begin
  Result := FCVSourceComponent;
end;

function TCVDataReceiver.isSourceEnabled: Boolean;
begin
  Result := Assigned(FCVSourceComponent) and FCVSourceComponent.Enabled;
end;

procedure TCVDataReceiver.SubscribeSource(const Value: TCVDataSource);
begin
  if (Value <> nil) and (not (csDesigning in ComponentState)) then
    ICVDataSource(Value).AddReceiver(Self);
end;

procedure TCVDataReceiver.UnsubscribeSource;
begin
  if Assigned(FCVSourceComponent) and (not (csDesigning in ComponentState)) then
    ICVDataSource(FCVSourceComponent).RemoveReceiver(Self);
end;

procedure TCVDataReceiver.SetSourceComponent(const Value: TCVDataSource);
begin
  if FCVSourceComponent <> Value then
  begin
    UnsubscribeSource;
    FCVSourceComponent := Value;
    SubscribeSource(Value);
  end;
end;

procedure TCVDataReceiver.SetSource(const Value: TObject);
begin
  if Value <> Self then
    SetSourceComponent(Value as TCVDataSource);
end;

class function TCVDataReceiver.ComponentPlatforms: Integer;
begin
  Result := $0002 or $0800; // pidWin64 ($0002) + pidWin64x ($0800)
end;

{ TCVDataProxy }

destructor TCVDataProxy.Destroy;
begin
  UnsubscribeSource;
  inherited Destroy;
end;

function TCVDataProxy.GetSource: TCVDataSource;
begin
  Result := FUpstreamSource;
end;

procedure TCVDataProxy.SubscribeSource(const Value: TCVDataSource);
begin
  if (Value <> nil) and (not (csDesigning in ComponentState)) then
    ICVDataSource(Value).AddReceiver(Self);
end;

procedure TCVDataProxy.UnsubscribeSource;
begin
  if Assigned(FUpstreamSource) and (not (csDesigning in ComponentState)) then
    ICVDataSource(FUpstreamSource).RemoveReceiver(Self);
end;

procedure TCVDataProxy.SetSourceComponent(const Value: TCVDataSource);
var
  NewSource: TCVDataSource;
begin
  NewSource := Value;
  if NewSource = Self then
    NewSource := nil;
  if FUpstreamSource <> NewSource then
  begin
    UnsubscribeSource;
    FUpstreamSource := NewSource;
    SubscribeSource(NewSource);
  end;
end;

procedure TCVDataProxy.SetSource(const Value: TObject);
begin
  if Value <> Self then
    SetSourceComponent(Value as TCVDataSource);
end;

class function TCVDataProxy.ComponentPlatforms: Integer;
begin
  Result := $0002 or $0800; // pidWin64 ($0002) + pidWin64x ($0800)
end;

end.
