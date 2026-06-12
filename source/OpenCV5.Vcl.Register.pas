unit OpenCV5.Vcl.Register;

interface

uses
  System.Classes;

procedure Register;

implementation

{$R OpenCV5VclIcons.res}

uses
  OpenCV5.Vcl.Components;

procedure Register;
begin
  RegisterComponents('OpenCV 5 VCL', [
    TcvViewVcl
  ]);
end;

end.
