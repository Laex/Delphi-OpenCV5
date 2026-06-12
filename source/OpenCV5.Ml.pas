unit OpenCV5.Ml;



interface



uses

  OpenCV5.Core,

  OpenCV5.Types;



const

  OpenCVLib = 'opencv_delphi_wrapper.dll';



type

  TCVKNearest = record

  private

    FHandle: Pointer;

    FOwnsHandle: Boolean;

    procedure ReleaseHandle;

  public

    class operator Initialize(out Dest: TCVKNearest);

    class operator Finalize(var Dest: TCVKNearest);

    class operator Assign(var Dest: TCVKNearest; const [ref] Src: TCVKNearest);

    class function Create: TCVKNearest; static;

    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVKNearest; static;

    procedure Release;

    property Handle: Pointer read FHandle;

    function train(const samples, responses: Pointer; const layout: Integer = ML_ROW_SAMPLE): Boolean;

    function findNearest(const samples, results, neighborResponses, dist: Pointer;

      const k: Integer): Single;

  end;



  TCVSVM = record

  private

    FHandle: Pointer;

    FOwnsHandle: Boolean;

    FSvmType: Integer;

    FKernelType: Integer;

    procedure ReleaseHandle;

  public

    class operator Initialize(out Dest: TCVSVM);

    class operator Finalize(var Dest: TCVSVM);

    class operator Assign(var Dest: TCVSVM; const [ref] Src: TCVSVM);

    class function Create(const svmType: Integer = SVM_C_SVC;

      const kernelType: Integer = SVM_LINEAR): TCVSVM; static;

    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVSVM; static;

    procedure Release;

    property Handle: Pointer read FHandle;

    function train(const samples, responses: Pointer; const layout: Integer = ML_ROW_SAMPLE): Boolean;

    function predict(const samples: Pointer; const results: Pointer): Single;

  end;



  TCVPCA = record

  private

    FHandle: Pointer;

    FOwnsHandle: Boolean;

    procedure ReleaseHandle;

  public

    class operator Initialize(out Dest: TCVPCA);

    class operator Finalize(var Dest: TCVPCA);

    class operator Assign(var Dest: TCVPCA; const [ref] Src: TCVPCA);

    class function Create(const data: Pointer; const maxComponents: Integer;

      const flags: Integer = PCA_DATA_AS_ROW): TCVPCA; static;

    class function FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean = True): TCVPCA; static;

    procedure Release;

    property Handle: Pointer read FHandle;

    function project(const vec: Pointer): TCVMat;

    function getComponents: Integer;

  end;



implementation



function Ml_KNN_Create: Pointer; stdcall; external OpenCVLib delayed;

procedure Ml_KNN_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;

function Ml_KNN_train(self, samples, responses: Pointer; layout: Integer): Boolean; stdcall; external OpenCVLib delayed;

function Ml_KNN_findNearest(self, samples: Pointer; k: Integer; results, neighborResponses, dist: Pointer): Single; stdcall; external OpenCVLib delayed;



function Ml_SVM_Create(svmType, kernelType: Integer): Pointer; stdcall; external OpenCVLib delayed;

procedure Ml_SVM_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;

function Ml_SVM_train(self, samples, responses: Pointer; layout: Integer): Boolean; stdcall; external OpenCVLib delayed;

function Ml_SVM_predict(self, samples, results: Pointer): Single; stdcall; external OpenCVLib delayed;



function Ml_PCA_Create(data: Pointer; maxComponents, flags: Integer): Pointer; stdcall; external OpenCVLib delayed;

procedure Ml_PCA_Destroy(self: Pointer); stdcall; external OpenCVLib delayed;

function Ml_PCA_project(self, vec: Pointer): Pointer; stdcall; external OpenCVLib delayed;

function Ml_PCA_getComponents(self: Pointer): Integer; stdcall; external OpenCVLib delayed;



{ TCVKNearest }



procedure TCVKNearest.ReleaseHandle;

begin

  if FOwnsHandle and (FHandle <> nil) then

    Ml_KNN_Destroy(FHandle);

  FHandle := nil;

  FOwnsHandle := False;

end;



class operator TCVKNearest.Initialize(out Dest: TCVKNearest);

begin

  Dest.FHandle := nil;

  Dest.FOwnsHandle := False;

end;



class operator TCVKNearest.Finalize(var Dest: TCVKNearest);

begin

  Dest.ReleaseHandle;

end;



class operator TCVKNearest.Assign(var Dest: TCVKNearest; const [ref] Src: TCVKNearest);

begin

  if @Dest = @Src then Exit;

  Dest.ReleaseHandle;

  if Src.FOwnsHandle then

    Dest := TCVKNearest.Create

  else

  begin

    Dest.FHandle := Src.FHandle;

    Dest.FOwnsHandle := False;

  end;

end;



class function TCVKNearest.Create: TCVKNearest;

begin

  Result.FHandle := Ml_KNN_Create;

  Result.FOwnsHandle := True;

end;



class function TCVKNearest.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVKNearest;

begin

  Result.FHandle := AHandle;

  Result.FOwnsHandle := AOwnsHandle;

end;



procedure TCVKNearest.Release;

begin

  ReleaseHandle;

end;



function TCVKNearest.train(const samples, responses: Pointer; const layout: Integer): Boolean;

begin

  Result := Ml_KNN_train(FHandle, samples, responses, layout);

end;



function TCVKNearest.findNearest(const samples, results, neighborResponses, dist: Pointer;

  const k: Integer): Single;

begin

  Result := Ml_KNN_findNearest(FHandle, samples, k, results, neighborResponses, dist);

end;



{ TCVSVM }



procedure TCVSVM.ReleaseHandle;

begin

  if FOwnsHandle and (FHandle <> nil) then

    Ml_SVM_Destroy(FHandle);

  FHandle := nil;

  FOwnsHandle := False;

end;



class operator TCVSVM.Initialize(out Dest: TCVSVM);

begin

  Dest.FHandle := nil;

  Dest.FOwnsHandle := False;

  Dest.FSvmType := SVM_C_SVC;

  Dest.FKernelType := SVM_LINEAR;

end;



class operator TCVSVM.Finalize(var Dest: TCVSVM);

begin

  Dest.ReleaseHandle;

end;



class operator TCVSVM.Assign(var Dest: TCVSVM; const [ref] Src: TCVSVM);

begin

  if @Dest = @Src then Exit;

  Dest.ReleaseHandle;

  Dest.FSvmType := Src.FSvmType;

  Dest.FKernelType := Src.FKernelType;

  if Src.FOwnsHandle then

    Dest := TCVSVM.Create(Src.FSvmType, Src.FKernelType)

  else

  begin

    Dest.FHandle := Src.FHandle;

    Dest.FOwnsHandle := False;

  end;

end;



class function TCVSVM.Create(const svmType, kernelType: Integer): TCVSVM;

begin

  Result.FSvmType := svmType;

  Result.FKernelType := kernelType;

  Result.FHandle := Ml_SVM_Create(svmType, kernelType);

  Result.FOwnsHandle := True;

end;



class function TCVSVM.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVSVM;

begin

  Result.FHandle := AHandle;

  Result.FOwnsHandle := AOwnsHandle;

  Result.FSvmType := SVM_C_SVC;

  Result.FKernelType := SVM_LINEAR;

end;



procedure TCVSVM.Release;

begin

  ReleaseHandle;

end;



function TCVSVM.train(const samples, responses: Pointer; const layout: Integer): Boolean;

begin

  Result := Ml_SVM_train(FHandle, samples, responses, layout);

end;



function TCVSVM.predict(const samples: Pointer; const results: Pointer): Single;

begin

  Result := Ml_SVM_predict(FHandle, samples, results);

end;



{ TCVPCA }



procedure TCVPCA.ReleaseHandle;

begin

  if FOwnsHandle and (FHandle <> nil) then

    Ml_PCA_Destroy(FHandle);

  FHandle := nil;

  FOwnsHandle := False;

end;



class operator TCVPCA.Initialize(out Dest: TCVPCA);

begin

  Dest.FHandle := nil;

  Dest.FOwnsHandle := False;

end;



class operator TCVPCA.Finalize(var Dest: TCVPCA);

begin

  Dest.ReleaseHandle;

end;



class operator TCVPCA.Assign(var Dest: TCVPCA; const [ref] Src: TCVPCA);

begin

  if @Dest = @Src then Exit;

  Dest.ReleaseHandle;

  if Src.FOwnsHandle and (Src.FHandle <> nil) then

  begin

    Dest.FHandle := Src.FHandle;

    Dest.FOwnsHandle := False;

  end

  else

  begin

    Dest.FHandle := Src.FHandle;

    Dest.FOwnsHandle := False;

  end;

end;



class function TCVPCA.Create(const data: Pointer; const maxComponents: Integer;

  const flags: Integer): TCVPCA;

begin

  Result.FHandle := Ml_PCA_Create(data, maxComponents, flags);

  Result.FOwnsHandle := True;

end;



class function TCVPCA.FromHandle(const AHandle: Pointer; const AOwnsHandle: Boolean): TCVPCA;

begin

  Result.FHandle := AHandle;

  Result.FOwnsHandle := AOwnsHandle;

end;



procedure TCVPCA.Release;

begin

  ReleaseHandle;

end;



function TCVPCA.project(const vec: Pointer): TCVMat;

begin

  Result := TCVMat.FromHandle(Ml_PCA_project(FHandle, vec));

end;



function TCVPCA.getComponents: Integer;

begin

  Result := Ml_PCA_getComponents(FHandle);

end;



end.

