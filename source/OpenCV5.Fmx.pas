unit OpenCV5.Fmx;

interface

uses
  System.SysUtils,
  FMX.Graphics,
  OpenCV5.Core,
  OpenCV5.Types,
  OpenCV5.Imgproc;

function MatFromFmxBitmap(const Bitmap: TBitmap): TCVMat;
procedure FmxBitmapFromMat(const Mat: TCVMat; const Bitmap: TBitmap; const ConvertToRgb: Boolean = True);

implementation

function MatFromFmxBitmap(const Bitmap: TBitmap): TCVMat;
var
  Map: TBitmapData;
  Y, RowBytes, BytesPerPixel: Integer;
  Src, Dst: PByte;
begin
  if (Bitmap = nil) or Bitmap.IsEmpty then
    raise Exception.Create('MatFromFmxBitmap: empty bitmap');

  if not Bitmap.Map(TMapAccess.Read, Map) then
    raise Exception.Create('MatFromFmxBitmap: Map failed');

  try
    if Bitmap.Width <= 0 then
      raise Exception.Create('MatFromFmxBitmap: invalid width');
    BytesPerPixel := Map.Pitch div Bitmap.Width;
    if BytesPerPixel >= 4 then
    begin
      Result := TCVMat.Create_0(Bitmap.Height, Bitmap.Width, CV_8UC4);
      RowBytes := Bitmap.Width * 4;
    end
    else if BytesPerPixel >= 3 then
    begin
      Result := TCVMat.Create_0(Bitmap.Height, Bitmap.Width, CV_8UC3);
      RowBytes := Bitmap.Width * 3;
    end
    else
      raise Exception.Create('MatFromFmxBitmap: unsupported bitmap layout');

    for Y := 0 to Bitmap.Height - 1 do
    begin
      Src := PByte(NativeUInt(Map.Data) + NativeUInt(Y * Map.Pitch));
      Dst := PByte(Result.ptr(Y, 0));
      Move(Src^, Dst^, RowBytes);
    end;
  finally
    Bitmap.Unmap(Map);
  end;
end;

procedure FmxBitmapFromMat(const Mat: TCVMat; const Bitmap: TBitmap; const ConvertToRgb: Boolean);
var
  SrcMat, Temp: TCVMat;
  Map: TBitmapData;
  Y, RowBytes: Integer;
  Src, Dst: PByte;
begin
  if Mat.empty then
    raise Exception.Create('FmxBitmapFromMat: empty mat');

  SrcMat := Mat;
  if ConvertToRgb and (Mat.channels = 3) then
  begin
    Temp := TCVMat.Create_0(Mat.rows, Mat.cols, CV_8UC3);
    cvtColor(Mat.Handle, Temp.Handle, COLOR_BGR2RGB, 0, 0);
    SrcMat := Temp;
  end
  else if ConvertToRgb and (Mat.channels = 4) then
  begin
    Temp := TCVMat.Create_0(Mat.rows, Mat.cols, CV_8UC4);
    cvtColor(Mat.Handle, Temp.Handle, COLOR_BGRA2RGBA, 0, 0);
    SrcMat := Temp;
  end;

  if SrcMat.channels = 1 then
  begin
    Temp := TCVMat.Create_0(SrcMat.rows, SrcMat.cols, CV_8UC4);
    cvtColor(SrcMat.Handle, Temp.Handle, COLOR_GRAY2BGR, 0, 0);
    cvtColor(Temp.Handle, Temp.Handle, COLOR_BGR2BGRA, 0, 0);
    SrcMat := Temp;
  end
  else if SrcMat.channels = 3 then
  begin
    Temp := TCVMat.Create_0(SrcMat.rows, SrcMat.cols, CV_8UC4);
    cvtColor(SrcMat.Handle, Temp.Handle, COLOR_BGR2BGRA, 0, 0);
    SrcMat := Temp;
  end
  else if SrcMat.channels <> 4 then
    raise Exception.Create('FmxBitmapFromMat: unsupported channel count');

  Bitmap.SetSize(SrcMat.cols, SrcMat.rows);
  if not Bitmap.Map(TMapAccess.Write, Map) then
    raise Exception.Create('FmxBitmapFromMat: Map failed');

  try
    RowBytes := SrcMat.cols * SrcMat.channels;
    for Y := 0 to SrcMat.rows - 1 do
    begin
      Src := PByte(SrcMat.ptr(Y, 0));
      Dst := PByte(NativeUInt(Map.Data) + NativeUInt(Y * Map.Pitch));
      Move(Src^, Dst^, RowBytes);
    end;
  finally
    Bitmap.Unmap(Map);
  end;
end;

end.
