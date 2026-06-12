unit OpenCV5.Highgui;

interface

uses
  OpenCV5.Core;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

procedure namedWindow(const winname: PAnsiChar; const flags: Integer);
procedure destroyWindow(const winname: PAnsiChar);
procedure destroyAllWindows();
function waitKey(const delay: Integer): Integer;
function pollKey(): Integer;
procedure imshow(const winname: PAnsiChar; const mat: Pointer);

function selectROI(const winname: PAnsiChar; const img: Pointer;
  const showCrosshair: Boolean = True; const fromCenter: Boolean = False): TCVRect; overload;
function selectROI(const img: Pointer;
  const showCrosshair: Boolean = True; const fromCenter: Boolean = False): TCVRect; overload;

type
  TCVMouseCallback = procedure(Event, X, Y, Flags: Integer; UserData: Pointer); cdecl;
  TCVTrackbarCallback = procedure(Pos: Integer; UserData: Pointer); cdecl;

procedure setMouseCallback(const winname: PAnsiChar; const onMouse: TCVMouseCallback;
  const userdata: Pointer = nil);
function createTrackbar(const trackbarname, winname: PAnsiChar; var value: Integer;
  const count: Integer; const onChange: TCVTrackbarCallback = nil;
  const userdata: Pointer = nil): Integer;

implementation

// ==========================================
// Flat C API Imports
// ==========================================

procedure Highgui_namedWindow(winname: PAnsiChar; flags: Integer); stdcall; external OpenCVLib delayed;
procedure Highgui_destroyWindow(winname: PAnsiChar); stdcall; external OpenCVLib delayed;
procedure Highgui_destroyAllWindows(); stdcall; external OpenCVLib delayed;
function Highgui_waitKey(delay: Integer): Integer; stdcall; external OpenCVLib delayed;
function Highgui_pollKey(): Integer; stdcall; external OpenCVLib delayed;
procedure Highgui_imshow(winname: PAnsiChar; mat: Pointer); stdcall; external OpenCVLib delayed;
procedure Highgui_selectROI(winname: PAnsiChar; img: Pointer; showCrosshair, fromCenter: Boolean;
  outX, outY, outW, outH: PInteger); stdcall; external OpenCVLib delayed;
procedure Highgui_setMouseCallback(winname: PAnsiChar; onMouse: TCVMouseCallback;
  userdata: Pointer); stdcall; external OpenCVLib delayed;
function Highgui_createTrackbar(trackbarname, winname: PAnsiChar; value: PInteger; count: Integer;
  onChange: TCVTrackbarCallback; userdata: Pointer): Integer; stdcall; external OpenCVLib delayed;

procedure namedWindow(const winname: PAnsiChar; const flags: Integer);
begin
  Highgui_namedWindow(winname, flags);
end;

procedure destroyWindow(const winname: PAnsiChar);
begin
  Highgui_destroyWindow(winname);
end;

procedure destroyAllWindows();
begin
  Highgui_destroyAllWindows();
end;

function waitKey(const delay: Integer): Integer;
begin
  Result := Highgui_waitKey(delay);
end;

function pollKey(): Integer;
begin
  Result := Highgui_pollKey();
end;

procedure imshow(const winname: PAnsiChar; const mat: Pointer);
begin
  Highgui_imshow(winname, mat);
end;

function selectROI(const winname: PAnsiChar; const img: Pointer;
  const showCrosshair, fromCenter: Boolean): TCVRect;
var
  X, Y, W, H: Integer;
begin
  Highgui_selectROI(winname, img, showCrosshair, fromCenter, @X, @Y, @W, @H);
  Result := TCVRect.Create(X, Y, W, H);
end;

function selectROI(const img: Pointer; const showCrosshair, fromCenter: Boolean): TCVRect;
begin
  Result := selectROI(nil, img, showCrosshair, fromCenter);
end;

procedure setMouseCallback(const winname: PAnsiChar; const onMouse: TCVMouseCallback;
  const userdata: Pointer);
begin
  Highgui_setMouseCallback(winname, onMouse, userdata);
end;

function createTrackbar(const trackbarname, winname: PAnsiChar; var value: Integer;
  const count: Integer; const onChange: TCVTrackbarCallback; const userdata: Pointer): Integer;
begin
  Result := Highgui_createTrackbar(trackbarname, winname, @value, count, onChange, userdata);
end;

end.