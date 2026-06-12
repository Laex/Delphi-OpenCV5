unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  OpenCV5.Core, OpenCV5.Types, OpenCV5.Utils, OpenCV5.Vcl;

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

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Caption := 'OpenCV 5 VCL Preview';
  BtnLoad.Caption := 'Load image...';
  OpenDialog1.Filter := 'Images|*.png;*.jpg;*.jpeg;*.bmp|All|*.*';
end;

procedure TFormMain.BtnLoadClick(Sender: TObject);
begin
  if not OpenDialog1.Execute then
    Exit;
  FMat := imreadPath(OpenDialog1.FileName, IMREAD_COLOR);
  if FMat.empty then
  begin
    MessageDlg('Failed to read image', mtError, [mbOK], 0);
    Exit;
  end;
  BitmapFromMat(FMat, Image1.Picture.Bitmap);
  Image1.Invalidate;
end;

end.
