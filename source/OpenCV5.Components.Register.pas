unit OpenCV5.Components.Register;

interface

uses
  System.Classes;

procedure Register;

implementation

{$R OpenCV5Icons.res}

uses
  OpenCV5.Components.VideoSource,
  OpenCV5.Components.Processors,
  OpenCV5.Components.Pipeline,
  OpenCV5.Components.Mux;

procedure Register;
begin
  RegisterComponents('OpenCV 5', [
    TcvCamera,
    TcvVideoFile,
    TcvFaceDetector,
    TcvFaceRecognizer,
    TcvPipeline,
    TcvMultiplexer
  ]);
end;

end.
