unit OpenCV5.Photo;

interface

uses
  OpenCV5.Core;

const
  OpenCVLib = 'opencv_delphi_wrapper.dll';

  INPAINT_NS = 0;
  INPAINT_TELEA = 1;

  NORMAL_CLONE = 1;
  MIXED_CLONE = 2;

procedure inpaint(const src, inpaintMask, dst: Pointer;
  const inpaintRadius: Double; const flags: Integer = INPAINT_NS);

procedure fastNlMeansDenoising(const src, dst: Pointer;
  const h: Single = 3.0; const templateWindowSize: Integer = 7;
  const searchWindowSize: Integer = 21);

procedure fastNlMeansDenoisingColored(const src, dst: Pointer;
  const h: Single = 3.0; const hColor: Single = 3.0;
  const templateWindowSize: Integer = 7; const searchWindowSize: Integer = 21);

procedure seamlessClone(const src, dst, mask: Pointer; const p: TCVPoint;
  const blend: Pointer; const flags: Integer = NORMAL_CLONE);

implementation

procedure Photo_inpaint(src, inpaintMask, dst: Pointer;
  inpaintRadius: Double; flags: Integer); stdcall; external OpenCVLib delayed;

procedure Photo_fastNlMeansDenoising(src, dst: Pointer;
  h: Single; templateWindowSize, searchWindowSize: Integer); stdcall; external OpenCVLib delayed;

procedure Photo_fastNlMeansDenoisingColored(src, dst: Pointer;
  h, hColor: Single; templateWindowSize, searchWindowSize: Integer); stdcall; external OpenCVLib delayed;

procedure Photo_seamlessClone(src, dst, mask, p, blend: Pointer; flags: Integer); stdcall; external OpenCVLib delayed;

procedure inpaint(const src, inpaintMask, dst: Pointer;
  const inpaintRadius: Double; const flags: Integer);
begin
  Photo_inpaint(src, inpaintMask, dst, inpaintRadius, flags);
end;

procedure fastNlMeansDenoising(const src, dst: Pointer;
  const h: Single; const templateWindowSize, searchWindowSize: Integer);
begin
  Photo_fastNlMeansDenoising(src, dst, h, templateWindowSize, searchWindowSize);
end;

procedure fastNlMeansDenoisingColored(const src, dst: Pointer;
  const h, hColor: Single; const templateWindowSize, searchWindowSize: Integer);
begin
  Photo_fastNlMeansDenoisingColored(src, dst, h, hColor, templateWindowSize, searchWindowSize);
end;

procedure seamlessClone(const src, dst, mask: Pointer; const p: TCVPoint;
  const blend: Pointer; const flags: Integer);
begin
  Photo_seamlessClone(src, dst, mask, @p, blend, flags);
end;

end.
