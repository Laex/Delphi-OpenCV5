program DemoTrack5;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  OpenCV5.Core in '..\..\source\OpenCV5.Core.pas',
  OpenCV5.Types in '..\..\source\OpenCV5.Types.pas',
  OpenCV5.Tracking in '..\..\source\OpenCV5.Tracking.pas',
  DemoUtils in '..\common\DemoUtils.pas';

procedure RunDemo;
var
  Prob, Measurement, State: TCVMat;
  Window: TCVRect;
  Rotated: TCVRotatedRect;
  Criteria: TCVTermCriteria;
  Kalman: TCVKalmanFilter;
  I, J, ShiftCount: Integer;
begin
  DemoOutLn('OpenCV 5.0 Tracking Demo (CamShift, meanShift, KalmanFilter)');
  DemoOutLn('');

  Prob := TCVMat.Create_2(120, 160, CV_8UC1, TCVScalar.Create(0));
  for I := 30 to 90 do
    for J := 40 to 100 do
      PByte(Prob.ptr(I, J))^ := 255;

  Window := TCVRect.Create(35, 45, 60, 50);
  Criteria := TCVTermCriteria.Create(TERM_CRITERIA_EPS or TERM_CRITERIA_COUNT, 10, 1.0);

  camShift(Prob.Handle, Window, Criteria, Rotated);
  DemoOutLn(Format('CamShift window: (%d,%d,%d,%d) angle=%.1f',
    [Window.X, Window.Y, Window.Width, Window.Height, Rotated.Angle]));

  Window := TCVRect.Create(35, 45, 60, 50);
  ShiftCount := meanShift(Prob.Handle, Window, Criteria);
  DemoOutLn(Format('meanShift iterations: %d, window: (%d,%d,%d,%d)',
    [ShiftCount, Window.X, Window.Y, Window.Width, Window.Height]));

  Kalman := TCVKalmanFilter.Create(2, 1, 0, CV_32F);
  Measurement := TCVMat.Create_0(1, 1, CV_32F);
  PSingle(Measurement.ptr(0, 0))^ := 10;
  Kalman.predict(nil);
  State := Kalman.correct(Measurement.Handle);
  DemoOutLn(Format('Kalman state after measure 10: %.2f',
    [PSingle(State.ptr(0, 0))^]));
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
