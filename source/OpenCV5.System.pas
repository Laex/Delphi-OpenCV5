unit OpenCV5.System;

interface

uses
  System.SysUtils;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

procedure clearLastOpenCVError;
function getLastOpenCVError: string;
function getOpenCVVersion: string;
function getOpenCVBuildInformation: string;

implementation

procedure Core_clearLastError; stdcall; external OpenCVLib delayed;
procedure Core_getLastError(buffer: PAnsiChar; bufferSize: Integer); stdcall; external OpenCVLib delayed;
procedure Core_getVersionString(buffer: PAnsiChar; bufferSize: Integer); stdcall; external OpenCVLib delayed;
function Core_getBuildInformation: PAnsiChar; stdcall; external OpenCVLib delayed;

procedure clearLastOpenCVError;
begin
  Core_clearLastError;
end;

function getLastOpenCVError: string;
var
  Buf: array[0..4095] of AnsiChar;
begin
  Core_getLastError(@Buf[0], Length(Buf));
  Result := string(AnsiString(Buf));
end;

function getOpenCVVersion: string;
var
  Buf: array[0..63] of AnsiChar;
begin
  Core_getVersionString(@Buf[0], Length(Buf));
  Result := string(AnsiString(Buf));
end;

function getOpenCVBuildInformation: string;
var
  P: PAnsiChar;
begin
  P := Core_getBuildInformation;
  if P <> nil then
    Result := string(AnsiString(P))
  else
    Result := '';
end;

end.
