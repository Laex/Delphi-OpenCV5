unit OpenCV5.Vcl;

interface

uses
  System.SysUtils,
  Vcl.Graphics,
  OpenCV5.Core,
  OpenCV5.Types,
  OpenCV5.Imgproc;

function MatFromBitmap(const Bitmap: TBitmap): TCVMat;
procedure BitmapFromMat(const Mat: TCVMat; const Bitmap: TBitmap; const ConvertToRgb: Boolean = True);

implementation

function MatFromBitmap(const Bitmap: TBitmap): TCVMat;
var
  Y, RowBytes: Integer;
  Src, Dst: PByte;
begin
  if (Bitmap = nil) or Bitmap.Empty then
    raise Exception.Create('MatFromBitmap: empty bitmap');

  case Bitmap.PixelFormat of
    pf24bit:
      begin
        Result := TCVMat.Create_0(Bitmap.Height, Bitmap.Width, CV_8UC3);
        RowBytes := Bitmap.Width * 3;
        for Y := 0 to Bitmap.Height - 1 do
        begin
          Src := PByte(Bitmap.ScanLine[Y]);
          Dst := PByte(Result.ptr(Y, 0));
          Move(Src^, Dst^, RowBytes);
        end;
      end;
    pf32bit:
      begin
        Result := TCVMat.Create_0(Bitmap.Height, Bitmap.Width, CV_8UC4);
        RowBytes := Bitmap.Width * 4;
        for Y := 0 to Bitmap.Height - 1 do
        begin
          Src := PByte(Bitmap.ScanLine[Y]);
          Dst := PByte(Result.ptr(Y, 0));
          Move(Src^, Dst^, RowBytes);
        end;
      end;
  else
    raise Exception.Create('MatFromBitmap: unsupported pixel format (use pf24bit or pf32bit)');
  end;
end;

procedure BitmapFromMat(const Mat: TCVMat; const Bitmap: TBitmap; const ConvertToRgb: Boolean);
var
  SrcMat, Temp: TCVMat;
  Y, RowBytes, CvType: Integer;
  Src, Dst: PByte;
begin
  if Mat.empty then
    raise Exception.Create('BitmapFromMat: empty mat');

  SrcMat := Mat;
  CvType := Mat.dataType;
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
    Bitmap.PixelFormat := pf24bit;
    Bitmap.SetSize(SrcMat.cols, SrcMat.rows);
    Temp := TCVMat.Create_0(SrcMat.rows, SrcMat.cols, CV_8UC3);
    cvtColor(SrcMat.Handle, Temp.Handle, COLOR_GRAY2BGR, 0, 0);
    SrcMat := Temp;
  end
  else if SrcMat.channels = 3 then
  begin
    Bitmap.PixelFormat := pf24bit;
    Bitmap.SetSize(SrcMat.cols, SrcMat.rows);
  end
  else if SrcMat.channels = 4 then
  begin
    Bitmap.PixelFormat := pf32bit;
    Bitmap.SetSize(SrcMat.cols, SrcMat.rows);
  end
  else
    raise Exception.Create('BitmapFromMat: unsupported channel count');

  RowBytes := SrcMat.cols * SrcMat.channels;
  for Y := 0 to SrcMat.rows - 1 do
  begin
    Src := PByte(SrcMat.ptr(Y, 0));
    Dst := PByte(Bitmap.ScanLine[Y]);
    Move(Src^, Dst^, RowBytes);
  end;
end;

end.
