unit Utit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, OpenCV5.Vcl.Components,
  OpenCV5.Components.Base, OpenCV5.Components.VideoSource,
  OpenCV5.Components.Pipeline, OpenCV5.Components.Mux, OpenCV5.Core;

type
  TForm2 = class(TForm)
    cvcmr1: TcvCamera;
    cvwvcl1: TcvViewVcl;
    btn1: TButton;
    chkUseInputB: TCheckBox;
    chkStrictMode: TCheckBox;
    cvpln1: TcvPipeline;
    procedure btn1Click(Sender: TObject);
    procedure cvmux1SelectInput(Sender: TObject; const FrameA, FrameB: TCVMat;
      var SelectedInput: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.btn1Click(Sender: TObject);
begin
  cvcmr1.Enabled := not cvcmr1.Enabled;
end;

procedure TForm2.cvmux1SelectInput(Sender: TObject; const FrameA, FrameB: TCVMat;
  var SelectedInput: Integer);
begin
  if chkUseInputB.Checked then
    SelectedInput := 1
  else
    SelectedInput := 0;
end;

end.
