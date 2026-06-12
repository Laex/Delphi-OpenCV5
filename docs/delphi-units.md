# Delphi units

[← Documentation](README.md) · [Structure](project-structure.md) · [Cookbook](cookbook.md)

| Unit | OpenCV module | Description |
|------|---------------|-------------|
| `OpenCV5.Types.pas` | — | CV, CAP, IMREAD, DNN, COLOR, optical flow constants |
| `OpenCV5.Core.pas` | core | `TCVMat`, points, sizes, scalars |
| `OpenCV5.Arith.pas` | core | `add`, `subtract`, `absdiff`, `inRange`, `bitwise_*`, `minMaxLoc`, `countNonZero`, **`splitMat`** (`splitMat8u` for `CV_8U`), `merge`, `multiply`/`divide`, `meanStdDev` |
| `OpenCV5.Imgproc.pas` | imgproc | filters, geometry, histograms, CLAHE |
| `OpenCV5.Imgcodecs.pas` | imgcodecs | `imread` / `imwrite`, `imencode` / `imdecode` |
| `OpenCV5.Highgui.pas` | highgui | `imshow`, `waitKey`, `selectROI`, `setMouseCallback`, `createTrackbar` |
| `OpenCV5.Videoio.pas` | videoio | `TCVVideoCapture`, `TCVVideoWriter` |
| `OpenCV5.Video.pas` | video | optical flow, `TCVMOG2`, `TCVKNN` |
| `OpenCV5.Objdetect.pas` | objdetect | QR, ArUco, Charuco, **FaceDetectorYN**, **FaceRecognizerSF** |
| `OpenCV5.Calib3d.pas` | calib3d | `calibrateCamera`, `solvePnP`, `undistort`, `findHomography`, … |
| `OpenCV5.Stereo.pas` | stereo | `TCVStereoMatcher` (SGBM/BM), `stereoRectify`, `reprojectImageTo3D` |
| `OpenCV5.Ptcloud.pas` | io | `loadPointCloud`, `savePointCloud` (PLY/PCD) |
| `OpenCV5.Features2d.pas` | features | ORB, SIFT, GFTT, MSER, FAST, matchers, `drawMatches` |
| `OpenCV5.Dnn.pas` | dnn | high-level models + `readNet`, `blobFromImage(s)`, `NMSBoxes`, `softNMSBoxes` |
| `OpenCV5.Photo.pas` | photo | `inpaint`, `fastNlMeansDenoising*`, `seamlessClone` |
| `OpenCV5.Stitching.pas` | stitching | `TCVStitcher` |
| `OpenCV5.Persistence.pas` | persistence | `TCVFileStorage` (YAML/XML) |
| `OpenCV5.Ml.pas` | ml | `TCVKNearest`, `TCVSVM`, `TCVPCA` |
| `OpenCV5.Tracking.pas` | tracking | CamShift, Kalman, `TCVTrackerMIL`, `TCVTrackerNano` |
| `OpenCV5.System.pas` | core | `getOpenCVVersion`, `getLastOpenCVError` |
| `OpenCV5.Helpers.pas` | — | `findContoursEx`, `ParseDetections`, … |
| `OpenCV5.Vcl.pas` / `OpenCV5.Fmx.pas` | — | `TBitmap` ↔ `TCVMat` bridge |
| `OpenCV5.Components.*` | — | camera, pipeline, face detect, view — [Components](components.md) |
| `OpenCV5.Utils.pas` | — | `PathToUTF8`, `imreadPath`, `imwritePath` |

## OpenCV5.Types

Use instead of local constants in demos:

```delphi
uses OpenCV5.Types;

Frame := TCVMat.Create_0(0, 0, CV_8UC3);
Cap.setProp(CAP_PROP_FRAME_WIDTH, 640);
Img := imread('test.png', IMREAD_COLOR);
```

See [Cookbook](cookbook.md) · [DNN](cookbook.md#dnn-high-level-models)
