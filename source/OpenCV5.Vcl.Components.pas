unit OpenCV5.Vcl.Components;

{$IFNDEF WIN64}
  {$IFNDEF PACKAGE}
    {$MESSAGE ERROR 'OpenCV 5.0 components are only supported in Win64 applications.'}
  {$ENDIF}
{$ENDIF}

interface

uses
  System.Classes, System.SysUtils, System.Types, Vcl.Controls, Vcl.Graphics,
  OpenCV5.Core, OpenCV5.Vcl, OpenCV5.Components.Base;

type
  TcvViewScaleMode = (smOriginal, smStretch, smFit, smCenter);

  [ComponentPlatformsAttribute(pidWin64)]
  TcvViewVcl = class(TCustomControl, ICVDataReceiver)
  private
    FBitmap: TBitmap;
    FScaleMode: TcvViewScaleMode;
    FConvertToRgb: Boolean;
    FEmptyText: string;
    FCVSourceComponent: TCVDataSource;
    function GetSource: TCVDataSource;
    procedure SetSourceComponent(const Value: TCVDataSource);
    procedure SetScaleMode(const Value: TcvViewScaleMode);
    procedure SetConvertToRgb(const Value: Boolean);
    procedure SetEmptyText(const Value: string);
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure SetSource(const Value: TObject);
    procedure TakeMat(const AMat: TCVMat);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function ComponentPlatforms: Integer;
    procedure ShowMat(const AMat: TCVMat);
    procedure Clear;
  published
    property Source: TCVDataSource read GetSource write SetSourceComponent;
    property Align;
    property Anchors;
    property Constraints;
    property DoubleBuffered default True;
    property Enabled;
    property ParentShowHint;
    property ShowHint;
    property Visible;
    property ScaleMode: TcvViewScaleMode read FScaleMode write SetScaleMode default smFit;
    property ConvertToRgb: Boolean read FConvertToRgb write SetConvertToRgb default False;
    property EmptyText: string read FEmptyText write SetEmptyText;
    
    // Events
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;

implementation

{ TcvViewVcl }

class function TcvViewVcl.ComponentPlatforms: Integer;
begin
  Result := $0002 or $0800; // pidWin64 ($0002) + pidWin64x ($0800)
end;

constructor TcvViewVcl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBitmap := TBitmap.Create;
  FScaleMode := smFit;
  FConvertToRgb := False;
  FEmptyText := 'No Signal';
  DoubleBuffered := True;
  Width := 320;
  Height := 240;
end;

destructor TcvViewVcl.Destroy;
begin
  SetSourceComponent(nil);
  FBitmap.Free;
  inherited Destroy;
end;

procedure TcvViewVcl.Clear;
begin
  FBitmap.SetSize(0, 0);
  Invalidate;
end;

procedure TcvViewVcl.ShowMat(const AMat: TCVMat);
begin
  if AMat.empty then
  begin
    Clear;
    Exit;
  end;
  
  BitmapFromMat(AMat, FBitmap, FConvertToRgb);
  Invalidate;
end;

procedure TcvViewVcl.SetScaleMode(const Value: TcvViewScaleMode);
begin
  if FScaleMode <> Value then
  begin
    FScaleMode := Value;
    Invalidate;
  end;
end;

procedure TcvViewVcl.SetConvertToRgb(const Value: Boolean);
begin
  if FConvertToRgb <> Value then
  begin
    FConvertToRgb := Value;
    Invalidate;
  end;
end;

procedure TcvViewVcl.SetEmptyText(const Value: string);
begin
  if FEmptyText <> Value then
  begin
    FEmptyText := Value;
    Invalidate;
  end;
end;

procedure TcvViewVcl.Resize;
begin
  inherited Resize;
  Invalidate;
end;

function TcvViewVcl.GetSource: TCVDataSource;
begin
  Result := FCVSourceComponent;
end;

procedure TcvViewVcl.SetSourceComponent(const Value: TCVDataSource);
begin
  if FCVSourceComponent <> Value then
  begin
    if Assigned(FCVSourceComponent) and (not (csDesigning in ComponentState)) then
      ICVDataSource(FCVSourceComponent).RemoveReceiver(Self);
    FCVSourceComponent := Value;
    if Assigned(FCVSourceComponent) and (not (csDesigning in ComponentState)) then
      ICVDataSource(FCVSourceComponent).AddReceiver(Self);
  end;
end;

procedure TcvViewVcl.SetSource(const Value: TObject);
begin
  if Value <> Self then
    SetSourceComponent(Value as TCVDataSource);
end;

procedure TcvViewVcl.TakeMat(const AMat: TCVMat);
begin
  if (ComponentState * [csDestroying, csDesigning]) = [] then
    ShowMat(AMat);
end;

procedure TcvViewVcl.Paint;
var
  DestRect: TRect;
  ControlRatio, ImageRatio: Double;
  NewW, NewH: Integer;
begin
  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);

  if (FBitmap.Width = 0) or (FBitmap.Height = 0) then
  begin
    if FEmptyText <> '' then
    begin
      Canvas.Font.Color := Font.Color;
      Canvas.Font.Name := Font.Name;
      Canvas.Font.Size := Font.Size;
      Canvas.TextOut(
        (ClientWidth - Canvas.TextWidth(FEmptyText)) div 2,
        (ClientHeight - Canvas.TextHeight(FEmptyText)) div 2,
        FEmptyText
      );
    end;
    Exit;
  end;

  case FScaleMode of
    smOriginal:
      DestRect := Rect(0, 0, FBitmap.Width, FBitmap.Height);
    
    smStretch:
      DestRect := ClientRect;
    
    smFit:
      begin
        ControlRatio := ClientWidth / ClientHeight;
        ImageRatio := FBitmap.Width / FBitmap.Height;
        if ImageRatio > ControlRatio then
        begin
          NewW := ClientWidth;
          NewH := Round(ClientWidth / ImageRatio);
        end
        else
        begin
          NewH := ClientHeight;
          NewW := Round(ClientHeight * ImageRatio);
        end;
        DestRect := Rect(
          (ClientWidth - NewW) div 2,
          (ClientHeight - NewH) div 2,
          (ClientWidth - NewW) div 2 + NewW,
          (ClientHeight - NewH) div 2 + NewH
        );
      end;
      
    smCenter:
      DestRect := Rect(
        (ClientWidth - FBitmap.Width) div 2,
        (ClientHeight - FBitmap.Height) div 2,
        (ClientWidth - FBitmap.Width) div 2 + FBitmap.Width,
        (ClientHeight - FBitmap.Height) div 2 + FBitmap.Height
      );
  end;

  Canvas.StretchDraw(DestRect, FBitmap);
end;

end.
