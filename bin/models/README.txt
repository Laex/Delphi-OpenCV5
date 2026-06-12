OpenCV Zoo and third-party models for OpenCV 5.0 Delphi demos
================================================================

Download all models (recommended):

  cd "OpenCV 5.0"
  .\download_models.ps1

Re-download: .\download_models.ps1 -Force

Files in bin\models\
---------------------

Face detection (YuNet)
  face_detection_yunet_2026may.onnx   - OpenCV 5 webcam (dynamic input)
  face_detection_yunet_2023mar.onnx   - photos, fixed input

Face recognition (SFace)
  face_recognition_sface_2021dec.onnx - DemoWebcamFaceId5

DNN demos
  image_classification_mobilenetv2_2022apr.onnx
  classification.onnx                 - alias for DemoDnnClassify5
  object_detection_yolox_2022nov.onnx
  detection_yolox.onnx                  - alias for TCVDetectionModel
  human_segmentation_pphumanseg_2023mar.onnx
  text_detection_en_ppocrv3_2023may.onnx
  text_detection_ppocr.onnx              - alias for DemoDnnPpocr5

Text (EAST, .pb not ONNX)
  frozen_east_text_detection.pb         - TextDetectionModel_EAST

TrackerNano (copies also in bin\models\)
  nanotrack_backbone_sim.onnx
  nanotrack_head_sim.onnx

Files in bin\ (OpenCV TrackerNano defaults)
  backbone.onnx
  neckhead.onnx

Sample images in bin\
  test.png              - general demos (squirrel photo)
  text_sample.png       - synthetic text for DemoDnnPpocr5 / PPOCR tests

Sources
-------
https://github.com/opencv/opencv_zoo (Git LFS via media.githubusercontent.com)
https://github.com/HonglinChu/SiamTrackers (NanoTrack v2)
https://www.dropbox.com/s/r2ingd0l3zt8hxs/frozen_east_text_detection.tar.gz (EAST)

Usage from bin\
----------------
  DemoWebcamFace5.exe
  DemoWebcamFaceId5.exe --enroll=photo.jpg --name=Alice
  DemoDnnClassify5.exe --model=models\classification.onnx --image=test.png
  DemoDnnPpocr5.exe --image=text_sample.png
  DemoDnn5.exe --model=models\face_detection_yunet_2026may.onnx --image=test.png
  TestOpenCV5.exe --model=models\face_detection_yunet_2026may.onnx
