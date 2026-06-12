unit UMain;

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects,
  OpenCV5.Core, OpenCV5.Types, OpenCV5.Utils, OpenCV5.Fmx,
  FMX.Controls.Presentation, OpenCV5.Components.VideoSource;

type
  TFormMain = class(TForm)
    Image1: TImage;
    BtnLoad: TButton;
    OpenDialog1: TOpenDialog;
    procedure BtnLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FMat: TCVMat;
  public
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Caption := 'OpenCV 5 FMX Preview';
  BtnLoad.Text := 'Load image...';
  OpenDialog1.Filter := 'Images|*.png;*.jpg;*.jpeg;*.bmp|All|*.*';
end;

procedure TFormMain.BtnLoadClick(Sender: TObject);
begin
  if not OpenDialog1.Execute then
    Exit;
  FMat := imreadPath(OpenDialog1.FileName, IMREAD_COLOR);
  if FMat.empty then
  begin
    ShowMessage('Failed to read image');
    Exit;
  end;
  FmxBitmapFromMat(FMat, Image1.Bitmap);
end;

end.
