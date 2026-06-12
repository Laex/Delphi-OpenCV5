unit OpenCV5.Ptcloud;

interface

uses
  OpenCV5.Core,
  OpenCV5.Types;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

function loadPointCloud(const filename: PAnsiChar; out vertices: TCVMat): Boolean; overload;
function loadPointCloud(const filename: PAnsiChar; out vertices: TCVMat;
  normals, rgb: Pointer): Boolean; overload;

procedure savePointCloud(const filename: PAnsiChar; const vertices: Pointer); overload;
procedure savePointCloud(const filename: PAnsiChar; const vertices: Pointer;
  normals, rgb: Pointer); overload;

implementation

function Ptcloud_loadPointCloud(filename: PAnsiChar; vertices, normals, rgb: Pointer): Boolean; stdcall; external OpenCVLib delayed;
procedure Ptcloud_savePointCloud(filename: PAnsiChar; vertices, normals, rgb: Pointer); stdcall; external OpenCVLib delayed;

function loadPointCloud(const filename: PAnsiChar; out vertices: TCVMat): Boolean;
begin
  Result := loadPointCloud(filename, vertices, nil, nil);
end;

function loadPointCloud(const filename: PAnsiChar; out vertices: TCVMat;
  normals, rgb: Pointer): Boolean;
begin
  vertices := TCVMat.Create_0(0, 0, CV_32F);
  Result := Ptcloud_loadPointCloud(filename, vertices.Handle, normals, rgb);
end;

procedure savePointCloud(const filename: PAnsiChar; const vertices: Pointer);
begin
  savePointCloud(filename, vertices, nil, nil);
end;

procedure savePointCloud(const filename: PAnsiChar; const vertices: Pointer;
  normals, rgb: Pointer);
begin
  Ptcloud_savePointCloud(filename, vertices, normals, rgb);
end;

end.
