unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  OpenCV5.Fmx.Components, OpenCV5.Components.Base,
  OpenCV5.Components.VideoSource, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    cvcmr1: TcvCamera;
    cvwfmx1: TcvViewFmx;
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btn1Click(Sender: TObject);
begin
  cvcmr1.Enabled:=not cvcmr1.Enabled;
end;

end.
