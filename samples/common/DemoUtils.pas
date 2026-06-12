unit DemoUtils;

interface

uses
  System.SysUtils,
  Winapi.Windows,
  OpenCV5.Core,
  OpenCV5.Types,
  OpenCV5.Videoio;

procedure DemoOutLn(const S: string = '');

function DemoCmdValue(const Name, Default: string): string;

function DemoParseBackend(const Name: string): Integer;

function DemoOpenCamera(const Index: Integer; const PreferredBackend: Integer): TCVVideoCapture;

function DemoFourcc(const C1, C2, C3, C4: AnsiChar): Integer;

implementation

procedure DemoOutLn(const S: string);
var
  Line: string;
  Written: DWORD;
  Handle: THandle;
  Utf8: TBytes;
begin
  if S = '' then
    Line := sLineBreak
  else
    Line := S + sLineBreak;
  Handle := GetStdHandle(STD_OUTPUT_HANDLE);
  if (Handle <> INVALID_HANDLE_VALUE) and ((GetFileType(Handle) and $FF) = FILE_TYPE_CHAR) then
  begin
    if Length(Line) > 0 then
      WriteConsoleW(Handle, PWideChar(Line), Length(Line), Written, nil);
  end
  else
  begin
    Utf8 := TEncoding.UTF8.GetBytes(Line);
    if Length(Utf8) > 0 then
      WriteFile(Handle, Utf8[0], Length(Utf8), Written, nil);
  end;
end;

function DemoCmdValue(const Name, Default: string): string;
var
  I: Integer;
  Arg, Prefix, Key: string;
begin
  Result := Default;
  Prefix := LowerCase(Name) + '=';
  for I := 1 to ParamCount do
  begin
    Arg := ParamStr(I);
    Key := Arg;
    if (Length(Key) > 2) and (Key[1] = '-') and (Key[2] = '-') then
      Delete(Key, 1, 2)
    else if (Length(Key) > 1) and CharInSet(Key[1], ['-', '/']) then
      Delete(Key, 1, 1);
    if SameText(Copy(Key, 1, Length(Prefix)), Prefix) then
      Exit(Copy(Key, Length(Prefix) + 1, MaxInt));
  end;
end;

function DemoParseBackend(const Name: string): Integer;
begin
  if SameText(Name, 'dshow') then
    Result := CAP_DSHOW
  else if SameText(Name, 'msmf') then
    Result := CAP_MSMF
  else if SameText(Name, 'any') then
    Result := CAP_ANY
  else
    Result := -1;
end;

function DemoOpenCamera(const Index: Integer; const PreferredBackend: Integer): TCVVideoCapture;
const
  FALLBACK: array[0..2] of Integer = (CAP_DSHOW, CAP_MSMF, CAP_ANY);
var
  I, Backend, Start: Integer;
  BackendName: string;
begin
  if PreferredBackend >= 0 then
  begin
    Result := TCVVideoCapture.Create_2(Index, PreferredBackend);
    if Result.isOpened then
    begin
      BackendName := string(Result.getBackendName);
      DemoOutLn(Format('Camera %d opened (backend id=%d, name=%s)', [Index, PreferredBackend, BackendName]));
      Exit;
    end;
    Result.Release;
  end;

  Start := 0;
  if PreferredBackend = CAP_DSHOW then
    Start := 0
  else if PreferredBackend = CAP_MSMF then
    Start := 1
  else if PreferredBackend = CAP_ANY then
    Start := 2;

  for I := Start to High(FALLBACK) do
  begin
    Backend := FALLBACK[I];
    Result := TCVVideoCapture.Create_2(Index, Backend);
    if Result.isOpened then
    begin
      BackendName := string(Result.getBackendName);
      DemoOutLn(Format('Camera %d opened (backend id=%d, name=%s)', [Index, Backend, BackendName]));
      Exit;
    end;
    Result.Release;
  end;

  raise Exception.CreateFmt('Cannot open camera index %d. Try --camera=N or --backend=dshow|msmf', [Index]);
end;

function DemoFourcc(const C1, C2, C3, C4: AnsiChar): Integer;
begin
  Result := Integer(Byte(C1)) or (Integer(Byte(C2)) shl 8) or
    (Integer(Byte(C3)) shl 16) or (Integer(Byte(C4)) shl 24);
end;

end.
