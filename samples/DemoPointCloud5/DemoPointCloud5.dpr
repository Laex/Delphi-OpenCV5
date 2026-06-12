program DemoPointCloud5;



{$APPTYPE CONSOLE}



uses

  System.SysUtils,

  System.Math,

  System.Classes,

  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',

  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',

  OpenCV5.Ptcloud in '..\..\source\OpenCV5.Ptcloud.pas',

  OpenCV5.Utils in '..\..\source\OpenCV5.Utils.pas',

  DemoUtils in '..\common\DemoUtils.pas';



procedure WriteAsciiPly(const Path: string);

var

  SL: TStringList;

begin

  SL := TStringList.Create;

  try

    SL.Add('ply');

    SL.Add('format ascii 1.0');

    SL.Add('element vertex 4');

    SL.Add('property float x');

    SL.Add('property float y');

    SL.Add('property float z');

    SL.Add('end_header');

    SL.Add('0 0 0');

    SL.Add('1 0 0');

    SL.Add('0 1 0');

    SL.Add('0 0 1');

    SL.SaveToFile(Path, TEncoding.ASCII);

  finally

    SL.Free;

  end;

end;



procedure RunDemo;

var

  OutPath, SavedPath: string;

  Verts, Loaded: TCVMat;

  I: Integer;

begin

  OutPath := DemoCmdValue('out', 'pointcloud_test.ply');

  SavedPath := DemoCmdValue('saved', 'pointcloud_saved.ply');

  DemoOutLn('OpenCV 5.0 loadPointCloud / savePointCloud demo');

  DemoOutLn('Options: --out=pointcloud_test.ply [--saved=pointcloud_saved.ply]');

  DemoOutLn('');



  WriteAsciiPly(OutPath);

  DemoOutLn('Wrote ASCII PLY ' + OutPath);



  if not loadPointCloud(PAnsiChar(PathToUTF8(OutPath)), Loaded) then

    raise Exception.Create('loadPointCloud failed');



  DemoOutLn(Format('Loaded vertices: rows=%d cols=%d channels=%d',

    [Loaded.rows, Loaded.cols, Loaded.channels]));

  for I := 0 to Min(Loaded.rows, 4) - 1 do

    DemoOutLn(Format('  v[%d] = (%.2f, %.2f, %.2f)', [I,

      PSingle(Loaded.ptr(I, 0))^, PSingle(Loaded.ptr(I, 1))^, PSingle(Loaded.ptr(I, 2))^]));



  Verts := TCVMat.Create_0(4, 3, CV_32F);

  for I := 0 to 3 do

  begin

    PSingle(Verts.ptr(I, 0))^ := I * 0.5;

    PSingle(Verts.ptr(I, 1))^ := I * 0.25;

    PSingle(Verts.ptr(I, 2))^ := I * 0.1;

  end;

  savePointCloud(PAnsiChar(PathToUTF8(SavedPath)), Verts.Handle);

  DemoOutLn('savePointCloud -> ' + SavedPath);



  Loaded := TCVMat.Create_0(0, 0, CV_32F);

  if not loadPointCloud(PAnsiChar(PathToUTF8(SavedPath)), Loaded) then

    raise Exception.Create('reload after save failed');

  DemoOutLn(Format('Reloaded saved cloud: rows=%d cols=%d', [Loaded.rows, Loaded.cols]));

end;



begin

  try

    RunDemo;

  except

    on E: Exception do

    begin

      DemoOutLn('ERROR: ' + E.Message);

      ExitCode := 1;

    end;

  end;

end.

