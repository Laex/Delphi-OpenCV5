program DemoVclPreview5;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FormMain};

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
