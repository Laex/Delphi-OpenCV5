unit OpenCV5.Types;

interface

const
  { Mat depth / type constants (opencv2/core/hal/interface.h) }
  CV_8U = 0;
  CV_8S = 1;
  CV_16U = 2;
  CV_16S = 3;
  CV_32S = 4;
  CV_32F = 5;
  CV_64F = 6;

  CV_8UC1 = 0;
  CV_8UC3 = 64;
  CV_8UC4 = 96;
  CV_16SC1 = 3;
  CV_32SC1 = 4;
  CV_32FC1 = 5;
  CV_32FC2 = 37;
  CV_32FC3 = 69;
  CV_64FC1 = 6;

  { TermCriteria }
  TERM_CRITERIA_COUNT = 1;
  TERM_CRITERIA_EPS = 2;
  TERM_CRITERIA_MAX_ITER = TERM_CRITERIA_COUNT;

  { imread flags (opencv2/imgcodecs.hpp) }
  IMREAD_UNCHANGED = -1;
  IMREAD_GRAYSCALE = 0;
  IMREAD_COLOR = 1;
  IMREAD_ANYDEPTH = 2;
  IMREAD_ANYCOLOR = 4;

  { VideoCapture backends and properties (opencv2/videoio.hpp) }
  CAP_ANY = 0;
  CAP_DSHOW = 700;
  CAP_MSMF = 1400;

  CAP_PROP_FRAME_WIDTH = 3;
  CAP_PROP_FRAME_HEIGHT = 4;
  CAP_PROP_FPS = 5;
  CAP_PROP_FOURCC = 6;
  CAP_PROP_FRAME_COUNT = 7;
  CAP_PROP_POS_FRAMES = 1;

  { Highgui window flags }
  WINDOW_NORMAL = 0;
  WINDOW_AUTOSIZE = 1;

  { DNN backend / target (opencv2/dnn/dnn.hpp) }
  DNN_BACKEND_DEFAULT = 0;
  DNN_BACKEND_INFERENCE_ENGINE = 2;
  DNN_BACKEND_OPENCV = 3;
  DNN_BACKEND_CUDA = 5;

  DNN_TARGET_CPU = 0;
  DNN_TARGET_OPENCL = 1;
  DNN_TARGET_CUDA = 4;

  { Common color conversions used in demos }
  COLOR_BGR2GRAY = 6;
  COLOR_GRAY2BGR = 8;
  COLOR_BGR2RGB = 4;
  COLOR_BGR2HSV = 40;
  COLOR_BGR2Lab = 44;

  BORDER_DEFAULT = 4;

  { Optical flow flags (opencv2/video/tracking.hpp) }
  OPTFLOW_USE_INITIAL_FLOW = 4;
  OPTFLOW_LK_GET_MIN_EIGENVALS = 8;

  { Descriptor matcher norms }
  NORM_L1 = 2;
  NORM_L2 = 4;
  NORM_HAMMING = 6;
  NORM_HAMMING2 = 7;

  BORDER_CONSTANT = 0;
  BORDER_REPLICATE = 1;

  { ML sample layout (opencv2/ml.hpp) }
  ML_ROW_SAMPLE = 0;
  ML_COL_SAMPLE = 1;

  { SVM types }
  SVM_C_SVC = 100;
  SVM_LINEAR = 0;
  SVM_POLY = 1;
  SVM_RBF = 2;

  { PCA flags }
  PCA_DATA_AS_ROW = 0;
  PCA_DATA_AS_COL = 1;

  { findHomography / estimateAffine methods }
  LMEDS = 4;
  RANSAC = 8;
  HOMOGRAPHY_LMEDS = LMEDS;
  HOMOGRAPHY_RANSAC = RANSAC;

  { Flann index params }
  FLANN_INDEX_LINEAR = 0;
  FLANN_INDEX_KDTREE = 1;

  FAST_TYPE_5_8 = 0;
  FAST_TYPE_7_12 = 1;
  FAST_TYPE_9_16 = 2;

implementation

end.
