unit OpenCV5.Fmx.Register;

interface

uses
  System.Classes;

procedure Register;

implementation

{$R OpenCV5FmxIcons.res}

uses
  OpenCV5.Fmx.Components;

procedure Register;
begin
  RegisterComponents('OpenCV 5 FMX', [
    TcvViewFmx
  ]);
end;

end.
