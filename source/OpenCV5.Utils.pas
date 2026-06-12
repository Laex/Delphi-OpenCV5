unit OpenCV5.Utils;

interface

uses
  System.SysUtils,
  OpenCV5.Core,
  OpenCV5.Types,
  OpenCV5.Imgcodecs;

function PathToUTF8(const Path: string): AnsiString;

function imreadPath(const Path: string; const Flags: Integer = IMREAD_COLOR): TCVMat;

function imwritePath(const Path: string; const img: Pointer): Boolean;

implementation

function PathToUTF8(const Path: string): AnsiString;
begin
  Result := AnsiString(UTF8String(Path));
end;

function imreadPath(const Path: string; const Flags: Integer): TCVMat;
begin
  Result := imread(PAnsiChar(PathToUTF8(Path)), Flags);
end;

function imwritePath(const Path: string; const img: Pointer): Boolean;
begin
  Result := imwrite(PAnsiChar(PathToUTF8(Path)), img);
end;

end.
