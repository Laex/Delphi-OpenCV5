unit OpenCV5.Fmx.Components;

{$IFNDEF WIN64}
  {$IFNDEF PACKAGE}
    {$MESSAGE ERROR 'OpenCV 5.0 components are only supported in Win64 applications.'}
  {$ENDIF}
{$ENDIF}

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes,
  FMX.Controls, FMX.Graphics, FMX.Types,
  OpenCV5.Core, OpenCV5.Fmx, OpenCV5.Components.Base;

type
  TcvViewScaleMode = (smOriginal, smStretch, smFit, smCenter);

  [ComponentPlatformsAttribute(pidWin64)]
  TcvViewFmx = class(TControl, ICVDataReceiver)
  private
    FBitmap: TBitmap;
    FScaleMode: TcvViewScaleMode;
    FConvertToRgb: Boolean;
    FEmptyText: string;
    FBackgroundColor: TAlphaColor;
    FFontColor: TAlphaColor;
    FCVSourceComponent: TCVDataSource;
    function GetSource: TCVDataSource;
    procedure SetSourceComponent(const Value: TCVDataSource);
    procedure SetScaleMode(const Value: TcvViewScaleMode);
    procedure SetConvertToRgb(const Value: Boolean);
    procedure SetEmptyText(const Value: string);
    procedure SetBackgroundColor(const Value: TAlphaColor);
    procedure SetFontColor(const Value: TAlphaColor);
  protected
    procedure Paint; override;
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
    property ClipChildren;
    property ClipParent;
    property Cursor;
    property DragMode;
    property EnableDragHighlight;
    property Enabled;
    property Height;
    property HitTest;
    property Locked;
    property Margins;
    property Opacity;
    property Padding;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    property TouchTargetExpansion;
    property Visible;
    property Width;
    
    // Custom properties
    property ScaleMode: TcvViewScaleMode read FScaleMode write SetScaleMode default smFit;
    property ConvertToRgb: Boolean read FConvertToRgb write SetConvertToRgb default False;
    property EmptyText: string read FEmptyText write SetEmptyText;
    property BackgroundColor: TAlphaColor read FBackgroundColor write SetBackgroundColor;
    property FontColor: TAlphaColor read FFontColor write SetFontColor;
    
    // Events
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;

implementation

{ TcvViewFmx }

class function TcvViewFmx.ComponentPlatforms: Integer;
begin
  Result := $0002 or $0800; // pidWin64 ($0002) + pidWin64x ($0800)
end;

constructor TcvViewFmx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBitmap := TBitmap.Create;
  FScaleMode := smFit;
  FConvertToRgb := False;
  FEmptyText := 'No Signal';
  FBackgroundColor := TAlphaColorRec.Black;
  FFontColor := TAlphaColorRec.White;
  Width := 320;
  Height := 240;
end;

destructor TcvViewFmx.Destroy;
begin
  SetSourceComponent(nil);
  FBitmap.Free;
  inherited Destroy;
end;

procedure TcvViewFmx.Clear;
begin
  FBitmap.SetSize(0, 0);
  Repaint;
end;

procedure TcvViewFmx.ShowMat(const AMat: TCVMat);
begin
  if AMat.empty then
  begin
    Clear;
    Exit;
  end;

  FmxBitmapFromMat(AMat, FBitmap, FConvertToRgb);
  Repaint;
end;

procedure TcvViewFmx.SetScaleMode(const Value: TcvViewScaleMode);
begin
  if FScaleMode <> Value then
  begin
    FScaleMode := Value;
    Repaint;
  end;
end;

procedure TcvViewFmx.SetConvertToRgb(const Value: Boolean);
begin
  if FConvertToRgb <> Value then
  begin
    FConvertToRgb := Value;
    Repaint;
  end;
end;

procedure TcvViewFmx.SetEmptyText(const Value: string);
begin
  if FEmptyText <> Value then
  begin
    FEmptyText := Value;
    Repaint;
  end;
end;

procedure TcvViewFmx.SetBackgroundColor(const Value: TAlphaColor);
begin
  if FBackgroundColor <> Value then
  begin
    FBackgroundColor := Value;
    Repaint;
  end;
end;

procedure TcvViewFmx.SetFontColor(const Value: TAlphaColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    Repaint;
  end;
end;

function TcvViewFmx.GetSource: TCVDataSource;
begin
  Result := FCVSourceComponent;
end;

procedure TcvViewFmx.SetSourceComponent(const Value: TCVDataSource);
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

procedure TcvViewFmx.SetSource(const Value: TObject);
begin
  if Value <> Self then
    SetSourceComponent(Value as TCVDataSource);
end;

procedure TcvViewFmx.TakeMat(const AMat: TCVMat);
begin
  if (ComponentState * [csDestroying, csDesigning]) = [] then
    ShowMat(AMat);
end;

procedure TcvViewFmx.Paint;
var
  SrcRect, DestRect: TRectF;
  ControlRatio, ImageRatio: Double;
  NewW, NewH: Single;
begin
  Canvas.Fill.Color := FBackgroundColor;
  Canvas.Fill.Kind := TBrushKind.Solid;
  Canvas.FillRect(LocalRect, 0, 0, AllCorners, AbsoluteOpacity);

  if (FBitmap = nil) or FBitmap.IsEmpty then
  begin
    if FEmptyText <> '' then
    begin
      Canvas.Fill.Color := FFontColor;
      Canvas.FillText(LocalRect, FEmptyText, False, AbsoluteOpacity, [], TTextAlign.Center, TTextAlign.Center);
    end;
    Exit;
  end;

  SrcRect := TRectF.Create(0, 0, FBitmap.Width, FBitmap.Height);
  
  case FScaleMode of
    smOriginal:
      DestRect := TRectF.Create(0, 0, FBitmap.Width, FBitmap.Height);
    
    smStretch:
      DestRect := LocalRect;
    
    smFit:
      begin
        ControlRatio := Width / Height;
        ImageRatio := FBitmap.Width / FBitmap.Height;
        if ImageRatio > ControlRatio then
        begin
          NewW := Width;
          NewH := Width / ImageRatio;
        end
        else
        begin
          NewH := Height;
          NewW := Height * ImageRatio;
        end;
        DestRect := TRectF.Create(
          (Width - NewW) / 2,
          (Height - NewH) / 2,
          (Width - NewW) / 2 + NewW,
          (Height - NewH) / 2 + NewH
        );
      end;
      
    smCenter:
      DestRect := TRectF.Create(
        (Width - FBitmap.Width) / 2,
        (Height - FBitmap.Height) / 2,
        (Width - FBitmap.Width) / 2 + FBitmap.Width,
        (Height - FBitmap.Height) / 2 + FBitmap.Height
      );
  end;

  Canvas.DrawBitmap(FBitmap, SrcRect, DestRect, AbsoluteOpacity, True);
end;

end.
