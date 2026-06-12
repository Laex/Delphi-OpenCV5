unit OpenCV5.Components.Editors;

interface

implementation

uses
  System.Classes, DesignIntf, DesignEditors,
  OpenCV5.Components.Base;

type
  TCVDataSourceProperty = class(TComponentProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TCVDataSource), nil, '', TCVDataSourceProperty);
end;

procedure TCVDataSourceProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Current, Comp: TComponent;
  Root: TComponent;
  Env: IDesigner;
begin
  Proc('');
  Current := GetComponent(0) as TComponent;
  Env := Designer;
  if Env = nil then
    Exit;
  Root := Env.Root;
  if Root = nil then
    Exit;
  for I := 0 to Root.ComponentCount - 1 do
  begin
    Comp := Root.Components[I];
    if (Comp is TCVDataSource) and (Comp <> Current) then
      Proc(Comp.Name);
  end;
end;

end.
