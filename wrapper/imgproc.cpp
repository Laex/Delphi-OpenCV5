#include <opencv2/opencv.hpp>
#include <opencv2/geometry/2d.hpp>
#include <cmath>
using namespace cv;
using namespace std;

extern "C" {

    struct CVPoint2f { float x, y; };
    struct CVPoint2d { double x, y; };
    struct CVPoint2l { int64_t x, y; };
    struct CVSize { int width, height; };
    struct CVSize2f { float width, height; };
    struct CVSize2l { int64_t width, height; };
    struct CVRect { int x, y, width, height; };
    struct CVRotatedRect { CVPoint2f center; CVSize2f size; float angle; };
    struct CVTermCriteria { int type; int maxCount; double epsilon; };
    struct CVMoments {
        double m00, m10, m01, m20, m11, m02, m30, m21, m12, m03;
        double mu20, mu11, mu02, mu30, mu21, mu12, mu03;
        double nu20, nu11, nu02, nu30, nu21, nu12, nu03;
    };

    // ==========================================
    // Class CLAHE
    // ==========================================
    static std::map<CLAHE*, Ptr<CLAHE>> g_clahe_instances;
    __declspec(dllexport) void __stdcall CLAHE_Destroy(CLAHE* self) {
        if (self) g_clahe_instances.erase(self);
    }
    __declspec(dllexport) void __stdcall CLAHE_apply(CLAHE* self, Mat* src, Mat* dst) {
        try {
            self->apply(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in CLAHE_apply: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in CLAHE_apply\n");
        }
    }
    __declspec(dllexport) void __stdcall CLAHE_setClipLimit(CLAHE* self, double clipLimit) {
        try {
            self->setClipLimit(clipLimit);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in CLAHE_setClipLimit: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in CLAHE_setClipLimit\n");
        }
    }
    __declspec(dllexport) double __stdcall CLAHE_getClipLimit(CLAHE* self) {
        try {
            return self->getClipLimit();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in CLAHE_getClipLimit: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in CLAHE_getClipLimit\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall CLAHE_setTilesGridSize(CLAHE* self, Size* tileGridSize) {
        try {
            self->setTilesGridSize(*tileGridSize);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in CLAHE_setTilesGridSize: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in CLAHE_setTilesGridSize\n");
        }
    }
    __declspec(dllexport) CVSize __stdcall CLAHE_getTilesGridSize(CLAHE* self) {
        try {
            Size result = self->getTilesGridSize();
            return {result.width, result.height};
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in CLAHE_getTilesGridSize: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in CLAHE_getTilesGridSize\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall CLAHE_setBitShift(CLAHE* self, int bitShift) {
        try {
            self->setBitShift(bitShift);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in CLAHE_setBitShift: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in CLAHE_setBitShift\n");
        }
    }
    __declspec(dllexport) int __stdcall CLAHE_getBitShift(CLAHE* self) {
        try {
            return self->getBitShift();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in CLAHE_getBitShift: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in CLAHE_getBitShift\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall CLAHE_collectGarbage(CLAHE* self) {
        try {
            self->collectGarbage();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in CLAHE_collectGarbage: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in CLAHE_collectGarbage\n");
        }
    }

    // ==========================================
    // Global Functions
    // ==========================================
    __declspec(dllexport) void __stdcall Imgproc_undistortImage(Mat* distorted, Mat* undistorted, Mat* K, Mat* D, Mat* Knew, Size* new_size) {
        try {
            ::cv::fisheye::undistortImage(distorted ? *distorted : (InputArray)cv::noArray(), undistorted ? *undistorted : (OutputArray)cv::noArray(), K ? *K : (InputArray)cv::noArray(), D ? *D : (InputArray)cv::noArray(), Knew ? *Knew : (InputArray)cv::noArray(), *new_size);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_undistortImage: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_undistortImage\n");
        }
    }
    __declspec(dllexport) Mat* __stdcall Imgproc_getGaussianKernel(int ksize, double sigma, int ktype) {
        try {
            return new Mat(::cv::getGaussianKernel(ksize, sigma, ktype));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_getGaussianKernel: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Imgproc_getGaussianKernel\n");
            return nullptr;
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_getDerivKernels(Mat* kx, Mat* ky, int dx, int dy, int ksize, bool normalize, int ktype) {
        try {
            ::cv::getDerivKernels(kx ? *kx : (OutputArray)cv::noArray(), ky ? *ky : (OutputArray)cv::noArray(), dx, dy, ksize, normalize, ktype);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_getDerivKernels: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_getDerivKernels\n");
        }
    }
    __declspec(dllexport) Mat* __stdcall Imgproc_getGaborKernel(Size* ksize, double sigma, double theta, double lambd, double gamma, double psi, int ktype) {
        try {
            return new Mat(::cv::getGaborKernel(*ksize, sigma, theta, lambd, gamma, psi, ktype));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_getGaborKernel: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Imgproc_getGaborKernel\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Imgproc_getStructuringElement(int shape, Size* ksize, Point* anchor) {
        try {
            return new Mat(::cv::getStructuringElement(shape, *ksize, *anchor));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_getStructuringElement: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Imgproc_getStructuringElement\n");
            return nullptr;
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_medianBlur(Mat* src, Mat* dst, int ksize) {
        try {
            ::cv::medianBlur(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), ksize);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_medianBlur: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_medianBlur\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_GaussianBlur(Mat* src, Mat* dst, Size* ksize, double sigmaX, double sigmaY, int borderType, int hint) {
        try {
            ::cv::GaussianBlur(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), *ksize, sigmaX, sigmaY, borderType, static_cast<AlgorithmHint>(hint));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_GaussianBlur: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_GaussianBlur\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_bilateralFilter(Mat* src, Mat* dst, int d, double sigmaColor, double sigmaSpace, int borderType) {
        try {
            ::cv::bilateralFilter(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), d, sigmaColor, sigmaSpace, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_bilateralFilter: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_bilateralFilter\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_boxFilter(Mat* src, Mat* dst, int ddepth, Size* ksize, Point* anchor, bool normalize, int borderType) {
        try {
            ::cv::boxFilter(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), ddepth, *ksize, *anchor, normalize, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_boxFilter: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_boxFilter\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_sqrBoxFilter(Mat* src, Mat* dst, int ddepth, Size* ksize, Point* anchor, bool normalize, int borderType) {
        try {
            ::cv::sqrBoxFilter(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), ddepth, *ksize, *anchor, normalize, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_sqrBoxFilter: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_sqrBoxFilter\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_blur(Mat* src, Mat* dst, Size* ksize, Point* anchor, int borderType) {
        try {
            ::cv::blur(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), *ksize, *anchor, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_blur: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_blur\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_stackBlur(Mat* src, Mat* dst, Size* ksize) {
        try {
            ::cv::stackBlur(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), *ksize);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_stackBlur: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_stackBlur\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_filter2D(Mat* src, Mat* dst, int ddepth, Mat* kernel, Point* anchor, double delta, int borderType) {
        try {
            ::cv::filter2D(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), ddepth, kernel ? *kernel : (InputArray)cv::noArray(), *anchor, delta, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_filter2D: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_filter2D\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_sepFilter2D(Mat* src, Mat* dst, int ddepth, Mat* kernelX, Mat* kernelY, Point* anchor, double delta, int borderType) {
        try {
            ::cv::sepFilter2D(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), ddepth, kernelX ? *kernelX : (InputArray)cv::noArray(), kernelY ? *kernelY : (InputArray)cv::noArray(), *anchor, delta, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_sepFilter2D: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_sepFilter2D\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_Sobel(Mat* src, Mat* dst, int ddepth, int dx, int dy, int ksize, double scale, double delta, int borderType) {
        try {
            ::cv::Sobel(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), ddepth, dx, dy, ksize, scale, delta, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_Sobel: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_Sobel\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_spatialGradient(Mat* src, Mat* dx, Mat* dy, int ksize, int borderType) {
        try {
            ::cv::spatialGradient(src ? *src : (InputArray)cv::noArray(), dx ? *dx : (OutputArray)cv::noArray(), dy ? *dy : (OutputArray)cv::noArray(), ksize, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_spatialGradient: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_spatialGradient\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_Scharr(Mat* src, Mat* dst, int ddepth, int dx, int dy, double scale, double delta, int borderType) {
        try {
            ::cv::Scharr(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), ddepth, dx, dy, scale, delta, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_Scharr: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_Scharr\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_Laplacian(Mat* src, Mat* dst, int ddepth, int ksize, double scale, double delta, int borderType) {
        try {
            ::cv::Laplacian(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), ddepth, ksize, scale, delta, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_Laplacian: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_Laplacian\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_Canny_0(Mat* image, Mat* edges, double threshold1, double threshold2, int apertureSize, bool L2gradient) {
        try {
            ::cv::Canny(image ? *image : (InputArray)cv::noArray(), edges ? *edges : (OutputArray)cv::noArray(), threshold1, threshold2, apertureSize, L2gradient);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_Canny_0: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_Canny_0\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_Canny_1(Mat* dx, Mat* dy, Mat* edges, double threshold1, double threshold2, bool L2gradient) {
        try {
            ::cv::Canny(dx ? *dx : (InputArray)cv::noArray(), dy ? *dy : (InputArray)cv::noArray(), edges ? *edges : (OutputArray)cv::noArray(), threshold1, threshold2, L2gradient);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_Canny_1: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_Canny_1\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_cornerMinEigenVal(Mat* src, Mat* dst, int blockSize, int ksize, int borderType) {
        try {
            ::cv::cornerMinEigenVal(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), blockSize, ksize, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_cornerMinEigenVal: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_cornerMinEigenVal\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_cornerHarris(Mat* src, Mat* dst, int blockSize, int ksize, double k, int borderType) {
        try {
            ::cv::cornerHarris(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), blockSize, ksize, k, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_cornerHarris: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_cornerHarris\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_cornerEigenValsAndVecs(Mat* src, Mat* dst, int blockSize, int ksize, int borderType) {
        try {
            ::cv::cornerEigenValsAndVecs(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), blockSize, ksize, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_cornerEigenValsAndVecs: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_cornerEigenValsAndVecs\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_preCornerDetect(Mat* src, Mat* dst, int ksize, int borderType) {
        try {
            ::cv::preCornerDetect(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), ksize, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_preCornerDetect: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_preCornerDetect\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_cornerSubPix(Mat* image, Mat* corners, Size* winSize, Size* zeroZone, TermCriteria* criteria) {
        try {
            ::cv::cornerSubPix(image ? *image : (InputArray)cv::noArray(), corners ? *corners : (InputOutputArray)cv::noArray(), *winSize, *zeroZone, *criteria);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_cornerSubPix: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_cornerSubPix\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_HoughLines(Mat* image, Mat* lines, double rho, double theta, int threshold, double srn, double stn, double min_theta, double max_theta, bool use_edgeval) {
        try {
            ::cv::HoughLines(image ? *image : (InputArray)cv::noArray(), lines ? *lines : (OutputArray)cv::noArray(), rho, theta, threshold, srn, stn, min_theta, max_theta, use_edgeval);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_HoughLines: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_HoughLines\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_HoughLinesP(Mat* image, Mat* lines, double rho, double theta, int threshold, double minLineLength, double maxLineGap) {
        try {
            ::cv::HoughLinesP(image ? *image : (InputArray)cv::noArray(), lines ? *lines : (OutputArray)cv::noArray(), rho, theta, threshold, minLineLength, maxLineGap);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_HoughLinesP: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_HoughLinesP\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_HoughLinesPointSet(Mat* point, Mat* lines, int lines_max, int threshold, double min_rho, double max_rho, double rho_step, double min_theta, double max_theta, double theta_step) {
        try {
            ::cv::HoughLinesPointSet(point ? *point : (InputArray)cv::noArray(), lines ? *lines : (OutputArray)cv::noArray(), lines_max, threshold, min_rho, max_rho, rho_step, min_theta, max_theta, theta_step);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_HoughLinesPointSet: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_HoughLinesPointSet\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_HoughCircles(Mat* image, Mat* circles, int method, double dp, double minDist, double param1, double param2, int minRadius, int maxRadius) {
        try {
            ::cv::HoughCircles(image ? *image : (InputArray)cv::noArray(), circles ? *circles : (OutputArray)cv::noArray(), method, dp, minDist, param1, param2, minRadius, maxRadius);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_HoughCircles: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_HoughCircles\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_erode(Mat* src, Mat* dst, Mat* kernel, Point* anchor, int iterations, int borderType, Scalar* borderValue) {
        try {
            ::cv::erode(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), kernel ? *kernel : (InputArray)cv::noArray(), *anchor, iterations, borderType, *borderValue);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_erode: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_erode\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_dilate(Mat* src, Mat* dst, Mat* kernel, Point* anchor, int iterations, int borderType, Scalar* borderValue) {
        try {
            ::cv::dilate(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), kernel ? *kernel : (InputArray)cv::noArray(), *anchor, iterations, borderType, *borderValue);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_dilate: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_dilate\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_morphologyEx(Mat* src, Mat* dst, int op, Mat* kernel, Point* anchor, int iterations, int borderType, Scalar* borderValue) {
        try {
            ::cv::morphologyEx(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), op, kernel ? *kernel : (InputArray)cv::noArray(), *anchor, iterations, borderType, *borderValue);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_morphologyEx: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_morphologyEx\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_resize(Mat* src, Mat* dst, Size* dsize, double fx, double fy, int interpolation) {
        try {
            ::cv::resize(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), *dsize, fx, fy, interpolation);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_resize: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_resize\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_warpAffine(Mat* src, Mat* dst, Mat* M, Size* dsize, int flags, int borderMode, Scalar* borderValue, int hint) {
        try {
            ::cv::warpAffine(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), M ? *M : (InputArray)cv::noArray(), *dsize, flags, borderMode, *borderValue, static_cast<AlgorithmHint>(hint));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_warpAffine: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_warpAffine\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_warpPerspective(Mat* src, Mat* dst, Mat* M, Size* dsize, int flags, int borderMode, Scalar* borderValue, int hint) {
        try {
            ::cv::warpPerspective(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), M ? *M : (InputArray)cv::noArray(), *dsize, flags, borderMode, *borderValue, static_cast<AlgorithmHint>(hint));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_warpPerspective: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_warpPerspective\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_remap(Mat* src, Mat* dst, Mat* map1, Mat* map2, int interpolation, int borderMode, Scalar* borderValue, int hint) {
        try {
            ::cv::remap(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), map1 ? *map1 : (InputArray)cv::noArray(), map2 ? *map2 : (InputArray)cv::noArray(), interpolation, borderMode, *borderValue, static_cast<AlgorithmHint>(hint));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_remap: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_remap\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_convertMaps(Mat* map1, Mat* map2, Mat* dstmap1, Mat* dstmap2, int dstmap1type, bool nninterpolation) {
        try {
            ::cv::convertMaps(map1 ? *map1 : (InputArray)cv::noArray(), map2 ? *map2 : (InputArray)cv::noArray(), dstmap1 ? *dstmap1 : (OutputArray)cv::noArray(), dstmap2 ? *dstmap2 : (OutputArray)cv::noArray(), dstmap1type, nninterpolation);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_convertMaps: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_convertMaps\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_undistort(Mat* src, Mat* dst, Mat* cameraMatrix, Mat* distCoeffs, Mat* newCameraMatrix) {
        try {
            ::cv::undistort(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), cameraMatrix ? *cameraMatrix : (InputArray)cv::noArray(), distCoeffs ? *distCoeffs : (InputArray)cv::noArray(), newCameraMatrix ? *newCameraMatrix : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_undistort: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_undistort\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_initUndistortRectifyMap(Mat* cameraMatrix, Mat* distCoeffs, Mat* R, Mat* newCameraMatrix, Size* size, int m1type, Mat* map1, Mat* map2) {
        try {
            ::cv::initUndistortRectifyMap(cameraMatrix ? *cameraMatrix : (InputArray)cv::noArray(), distCoeffs ? *distCoeffs : (InputArray)cv::noArray(), R ? *R : (InputArray)cv::noArray(), newCameraMatrix ? *newCameraMatrix : (InputArray)cv::noArray(), *size, m1type, map1 ? *map1 : (OutputArray)cv::noArray(), map2 ? *map2 : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_initUndistortRectifyMap: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_initUndistortRectifyMap\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_initInverseRectificationMap(Mat* cameraMatrix, Mat* distCoeffs, Mat* R, Mat* newCameraMatrix, Size* size, int m1type, Mat* map1, Mat* map2) {
        try {
            ::cv::initInverseRectificationMap(cameraMatrix ? *cameraMatrix : (InputArray)cv::noArray(), distCoeffs ? *distCoeffs : (InputArray)cv::noArray(), R ? *R : (InputArray)cv::noArray(), newCameraMatrix ? *newCameraMatrix : (InputArray)cv::noArray(), *size, m1type, map1 ? *map1 : (OutputArray)cv::noArray(), map2 ? *map2 : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_initInverseRectificationMap: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_initInverseRectificationMap\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_getRectSubPix(Mat* image, Size* patchSize, Point2f* center, Mat* patch, int patchType) {
        try {
            ::cv::getRectSubPix(image ? *image : (InputArray)cv::noArray(), *patchSize, *center, patch ? *patch : (OutputArray)cv::noArray(), patchType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_getRectSubPix: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_getRectSubPix\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_warpPolar(Mat* src, Mat* dst, Size* dsize, Point2f* center, double maxRadius, int flags) {
        try {
            ::cv::warpPolar(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), *dsize, *center, maxRadius, flags);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_warpPolar: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_warpPolar\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_integral(Mat* src, Mat* sum, int sdepth) {
        try {
            ::cv::integral(src ? *src : (InputArray)cv::noArray(), sum ? *sum : (OutputArray)cv::noArray(), sdepth);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_integral: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_integral\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_accumulate(Mat* src, Mat* dst, Mat* mask) {
        try {
            ::cv::accumulate(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (InputOutputArray)cv::noArray(), mask ? *mask : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_accumulate: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_accumulate\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_accumulateSquare(Mat* src, Mat* dst, Mat* mask) {
        try {
            ::cv::accumulateSquare(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (InputOutputArray)cv::noArray(), mask ? *mask : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_accumulateSquare: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_accumulateSquare\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_accumulateProduct(Mat* src1, Mat* src2, Mat* dst, Mat* mask) {
        try {
            ::cv::accumulateProduct(src1 ? *src1 : (InputArray)cv::noArray(), src2 ? *src2 : (InputArray)cv::noArray(), dst ? *dst : (InputOutputArray)cv::noArray(), mask ? *mask : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_accumulateProduct: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_accumulateProduct\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_accumulateWeighted(Mat* src, Mat* dst, double alpha, Mat* mask) {
        try {
            ::cv::accumulateWeighted(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (InputOutputArray)cv::noArray(), alpha, mask ? *mask : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_accumulateWeighted: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_accumulateWeighted\n");
        }
    }
    __declspec(dllexport) CVPoint2d __stdcall Imgproc_phaseCorrelate(Mat* src1, Mat* src2, Mat* window, CV_OUT double* response) {
        try {
            Point2d result = ::cv::phaseCorrelate(src1 ? *src1 : (InputArray)cv::noArray(), src2 ? *src2 : (InputArray)cv::noArray(), window ? *window : (InputArray)cv::noArray(), response);
            return {result.x, result.y};
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_phaseCorrelate: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_phaseCorrelate\n");
            return {};
        }
    }
    __declspec(dllexport) CVPoint2d __stdcall Imgproc_phaseCorrelateIterative(Mat* src1, Mat* src2, int L2size, int maxIters) {
        try {
            Point2d result = ::cv::phaseCorrelateIterative(src1 ? *src1 : (InputArray)cv::noArray(), src2 ? *src2 : (InputArray)cv::noArray(), L2size, maxIters);
            return {result.x, result.y};
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_phaseCorrelateIterative: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_phaseCorrelateIterative\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_createHanningWindow(Mat* dst, Size* winSize, int type) {
        try {
            ::cv::createHanningWindow(dst ? *dst : (OutputArray)cv::noArray(), *winSize, type);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_createHanningWindow: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_createHanningWindow\n");
        }
    }
    __declspec(dllexport) double __stdcall Imgproc_threshold(Mat* src, Mat* dst, double thresh, double maxval, int type) {
        try {
            return ::cv::threshold(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), thresh, maxval, type);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_threshold: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_threshold\n");
            return {};
        }
    }
    __declspec(dllexport) double __stdcall Imgproc_thresholdWithMask(Mat* src, Mat* dst, Mat* mask, double thresh, double maxval, int type) {
        try {
            return ::cv::thresholdWithMask(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (InputOutputArray)cv::noArray(), mask ? *mask : (InputArray)cv::noArray(), thresh, maxval, type);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_thresholdWithMask: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_thresholdWithMask\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_adaptiveThreshold(Mat* src, Mat* dst, double maxValue, int adaptiveMethod, int thresholdType, int blockSize, double C) {
        try {
            ::cv::adaptiveThreshold(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), maxValue, adaptiveMethod, thresholdType, blockSize, C);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_adaptiveThreshold: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_adaptiveThreshold\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_pyrDown(Mat* src, Mat* dst, Size* dstsize, int borderType) {
        try {
            ::cv::pyrDown(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), *dstsize, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_pyrDown: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_pyrDown\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_pyrUp(Mat* src, Mat* dst, Size* dstsize, int borderType) {
        try {
            ::cv::pyrUp(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), *dstsize, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_pyrUp: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_pyrUp\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_buildPyramid(Mat* src, OutputArrayOfArrays dst, int maxlevel, int borderType) {
        try {
            ::cv::buildPyramid(src ? *src : (InputArray)cv::noArray(), dst, maxlevel, borderType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_buildPyramid: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_buildPyramid\n");
        }
    }
    __declspec(dllexport) double __stdcall Imgproc_compareHist(Mat* H1, Mat* H2, int method) {
        try {
            return ::cv::compareHist(H1 ? *H1 : (InputArray)cv::noArray(), H2 ? *H2 : (InputArray)cv::noArray(), method);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_compareHist: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_compareHist\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_equalizeHist(Mat* src, Mat* dst) {
        try {
            ::cv::equalizeHist(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_equalizeHist: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_equalizeHist\n");
        }
    }
    __declspec(dllexport) float __stdcall Imgproc_EMD(Mat* signature1, Mat* signature2, int distType, Mat* cost, float* lowerBound, Mat* flow) {
        try {
            return ::cv::EMD(signature1 ? *signature1 : (InputArray)cv::noArray(), signature2 ? *signature2 : (InputArray)cv::noArray(), distType, cost ? *cost : (InputArray)cv::noArray(), lowerBound, flow ? *flow : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_EMD: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_EMD\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_watershed(Mat* image, Mat* markers) {
        try {
            ::cv::watershed(image ? *image : (InputArray)cv::noArray(), markers ? *markers : (InputOutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_watershed: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_watershed\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_pyrMeanShiftFiltering(Mat* src, Mat* dst, double sp, double sr, int maxLevel, TermCriteria* termcrit) {
        try {
            ::cv::pyrMeanShiftFiltering(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), sp, sr, maxLevel, *termcrit);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_pyrMeanShiftFiltering: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_pyrMeanShiftFiltering\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_grabCut(Mat* img, Mat* mask, Rect* rect, Mat* bgdModel, Mat* fgdModel, int iterCount, int mode) {
        try {
            ::cv::grabCut(img ? *img : (InputArray)cv::noArray(), mask ? *mask : (InputOutputArray)cv::noArray(), *rect, bgdModel ? *bgdModel : (InputOutputArray)cv::noArray(), fgdModel ? *fgdModel : (InputOutputArray)cv::noArray(), iterCount, mode);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_grabCut: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_grabCut\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_distanceTransform(Mat* src, Mat* dst, int distanceType, int maskSize, int dstType) {
        try {
            ::cv::distanceTransform(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), distanceType, maskSize, dstType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_distanceTransform: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_distanceTransform\n");
        }
    }
    __declspec(dllexport) int __stdcall Imgproc_floodFill_0(Mat* image, Mat* mask, Point* seedPoint, Scalar* newVal, Rect* rect, Scalar* loDiff, Scalar* upDiff, int flags) {
        try {
            return ::cv::floodFill(image ? *image : (InputOutputArray)cv::noArray(), mask ? *mask : (InputOutputArray)cv::noArray(), *seedPoint, *newVal, rect, *loDiff, *upDiff, flags);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_floodFill_0: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_floodFill_0\n");
            return {};
        }
    }
    __declspec(dllexport) int __stdcall Imgproc_floodFill_1(Mat* image, Point* seedPoint, Scalar* newVal, Rect* rect, Scalar* loDiff, Scalar* upDiff, int flags) {
        try {
            return ::cv::floodFill(image ? *image : (InputOutputArray)cv::noArray(), *seedPoint, *newVal, rect, *loDiff, *upDiff, flags);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_floodFill_1: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_floodFill_1\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_blendLinear(Mat* src1, Mat* src2, Mat* weights1, Mat* weights2, Mat* dst) {
        try {
            ::cv::blendLinear(src1 ? *src1 : (InputArray)cv::noArray(), src2 ? *src2 : (InputArray)cv::noArray(), weights1 ? *weights1 : (InputArray)cv::noArray(), weights2 ? *weights2 : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_blendLinear: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_blendLinear\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_cvtColor(Mat* src, Mat* dst, int code, int dstCn, int hint) {
        try {
            ::cv::cvtColor(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), code, dstCn, static_cast<AlgorithmHint>(hint));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_cvtColor: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_cvtColor\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_cvtColorTwoPlane(Mat* src1, Mat* src2, Mat* dst, int code, int hint) {
        try {
            ::cv::cvtColorTwoPlane(src1 ? *src1 : (InputArray)cv::noArray(), src2 ? *src2 : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), code, static_cast<AlgorithmHint>(hint));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_cvtColorTwoPlane: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_cvtColorTwoPlane\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_demosaicing(Mat* src, Mat* dst, int code, int dstCn) {
        try {
            ::cv::demosaicing(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), code, dstCn);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_demosaicing: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_demosaicing\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_matchTemplate(Mat* image, Mat* templ, Mat* result, int method, Mat* mask) {
        try {
            ::cv::matchTemplate(image ? *image : (InputArray)cv::noArray(), templ ? *templ : (InputArray)cv::noArray(), result ? *result : (OutputArray)cv::noArray(), method, mask ? *mask : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_matchTemplate: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_matchTemplate\n");
        }
    }
    __declspec(dllexport) int __stdcall Imgproc_connectedComponents(Mat* image, Mat* labels, int connectivity, int ltype) {
        try {
            return ::cv::connectedComponents(image ? *image : (InputArray)cv::noArray(), labels ? *labels : (OutputArray)cv::noArray(), connectivity, ltype);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_connectedComponents: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_connectedComponents\n");
            return {};
        }
    }
    __declspec(dllexport) int __stdcall Imgproc_connectedComponentsWithStats(Mat* image, Mat* labels, Mat* stats, Mat* centroids, int connectivity, int ltype) {
        try {
            return ::cv::connectedComponentsWithStats(image ? *image : (InputArray)cv::noArray(), labels ? *labels : (OutputArray)cv::noArray(), stats ? *stats : (OutputArray)cv::noArray(), centroids ? *centroids : (OutputArray)cv::noArray(), connectivity, ltype);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_connectedComponentsWithStats: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_connectedComponentsWithStats\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_findContours_0(Mat* image, OutputArrayOfArrays contours, Mat* hierarchy, int mode, int method, Point* offset) {
        try {
            ::cv::findContours(image ? *image : (InputArray)cv::noArray(), contours, hierarchy ? *hierarchy : (OutputArray)cv::noArray(), mode, method, *offset);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_findContours_0: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_findContours_0\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_findContours_1(Mat* image, OutputArrayOfArrays contours, int mode, int method, Point* offset) {
        try {
            ::cv::findContours(image ? *image : (InputArray)cv::noArray(), contours, mode, method, *offset);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_findContours_1: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_findContours_1\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_findContoursLinkRuns_0(Mat* image, OutputArrayOfArrays contours, Mat* hierarchy) {
        try {
            ::cv::findContoursLinkRuns(image ? *image : (InputArray)cv::noArray(), contours, hierarchy ? *hierarchy : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_findContoursLinkRuns_0: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_findContoursLinkRuns_0\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_findContoursLinkRuns_1(Mat* image, OutputArrayOfArrays contours) {
        try {
            ::cv::findContoursLinkRuns(image ? *image : (InputArray)cv::noArray(), contours);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_findContoursLinkRuns_1: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_findContoursLinkRuns_1\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_applyColorMap_0(Mat* src, Mat* dst, int colormap) {
        try {
            ::cv::applyColorMap(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), colormap);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_applyColorMap_0: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_applyColorMap_0\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_applyColorMap_1(Mat* src, Mat* dst, Mat* userColor) {
        try {
            ::cv::applyColorMap(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (OutputArray)cv::noArray(), userColor ? *userColor : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_applyColorMap_1: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_applyColorMap_1\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_line(Mat* img, Point* pt1, Point* pt2, Scalar* color, int thickness, int lineType, int shift) {
        try {
            ::cv::line(img ? *img : (InputOutputArray)cv::noArray(), *pt1, *pt2, *color, thickness, lineType, shift);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_line: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_line\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_arrowedLine(Mat* img, Point* pt1, Point* pt2, Scalar* color, int thickness, int line_type, int shift, double tipLength) {
        try {
            ::cv::arrowedLine(img ? *img : (InputOutputArray)cv::noArray(), *pt1, *pt2, *color, thickness, line_type, shift, tipLength);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_arrowedLine: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_arrowedLine\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_drawFrameAxes(Mat* image, Mat* cameraMatrix, Mat* distCoeffs, Mat* rvec, Mat* tvec, float length, int thickness) {
        try {
            ::cv::drawFrameAxes(image ? *image : (InputOutputArray)cv::noArray(), cameraMatrix ? *cameraMatrix : (InputArray)cv::noArray(), distCoeffs ? *distCoeffs : (InputArray)cv::noArray(), rvec ? *rvec : (InputArray)cv::noArray(), tvec ? *tvec : (InputArray)cv::noArray(), length, thickness);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_drawFrameAxes: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_drawFrameAxes\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_rectangle_0(Mat* img, Point* pt1, Point* pt2, Scalar* color, int thickness, int lineType, int shift) {
        try {
            ::cv::rectangle(img ? *img : (InputOutputArray)cv::noArray(), *pt1, *pt2, *color, thickness, lineType, shift);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_rectangle_0: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_rectangle_0\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_rectangle_1(Mat* img, Rect* rec, Scalar* color, int thickness, int lineType, int shift) {
        try {
            ::cv::rectangle(img ? *img : (InputOutputArray)cv::noArray(), *rec, *color, thickness, lineType, shift);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_rectangle_1: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_rectangle_1\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_circle(Mat* img, Point* center, int radius, Scalar* color, int thickness, int lineType, int shift) {
        try {
            ::cv::circle(img ? *img : (InputOutputArray)cv::noArray(), *center, radius, *color, thickness, lineType, shift);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_circle: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_circle\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_ellipse_0(Mat* img, Point* center, Size* axes, double angle, double startAngle, double endAngle, Scalar* color, int thickness, int lineType, int shift) {
        try {
            ::cv::ellipse(img ? *img : (InputOutputArray)cv::noArray(), *center, *axes, angle, startAngle, endAngle, *color, thickness, lineType, shift);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_ellipse_0: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_ellipse_0\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_ellipse_1(Mat* img, RotatedRect* box, Scalar* color, int thickness, int lineType) {
        try {
            ::cv::ellipse(img ? *img : (InputOutputArray)cv::noArray(), *box, *color, thickness, lineType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_ellipse_1: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_ellipse_1\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_drawMarker(Mat* img, Point* position, Scalar* color, int markerType, int markerSize, int thickness, int line_type) {
        try {
            ::cv::drawMarker(img ? *img : (InputOutputArray)cv::noArray(), *position, *color, markerType, markerSize, thickness, line_type);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_drawMarker: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_drawMarker\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_fillConvexPoly_0(Mat* img, Mat* points, Scalar* color, int lineType, int shift) {
        try {
            ::cv::fillConvexPoly(img ? *img : (InputOutputArray)cv::noArray(), points ? *points : (InputArray)cv::noArray(), *color, lineType, shift);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_fillConvexPoly_0: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_fillConvexPoly_0\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_fillConvexPoly_1(Mat* img, const Point* pts, int npts, Scalar* color, int lineType, int shift) {
        try {
            ::cv::fillConvexPoly(img ? *img : (InputOutputArray)cv::noArray(), pts, npts, *color, lineType, shift);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_fillConvexPoly_1: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_fillConvexPoly_1\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_fillPoly_0(Mat* img, InputArrayOfArrays pts, Scalar* color, int lineType, int shift, Point* offset) {
        try {
            ::cv::fillPoly(img ? *img : (InputOutputArray)cv::noArray(), pts, *color, lineType, shift, *offset);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_fillPoly_0: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_fillPoly_0\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_fillPoly_1(Mat* img, const Point** pts, const int* npts, int ncontours, Scalar* color, int lineType, int shift, Point* offset) {
        try {
            ::cv::fillPoly(img ? *img : (InputOutputArray)cv::noArray(), pts, npts, ncontours, *color, lineType, shift, *offset);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_fillPoly_1: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_fillPoly_1\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_polylines_0(Mat* img, InputArrayOfArrays pts, bool isClosed, Scalar* color, int thickness, int lineType, int shift) {
        try {
            ::cv::polylines(img ? *img : (InputOutputArray)cv::noArray(), pts, isClosed, *color, thickness, lineType, shift);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_polylines_0: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_polylines_0\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_polylines_1(Mat* img, const Point* const* pts, const int* npts, int ncontours, bool isClosed, Scalar* color, int thickness, int lineType, int shift) {
        try {
            ::cv::polylines(img ? *img : (InputOutputArray)cv::noArray(), pts, npts, ncontours, isClosed, *color, thickness, lineType, shift);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_polylines_1: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_polylines_1\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_drawContours(Mat* image, InputArrayOfArrays contours, int contourIdx, Scalar* color, int thickness, int lineType, Mat* hierarchy, int maxLevel, Point* offset) {
        try {
            ::cv::drawContours(image ? *image : (InputOutputArray)cv::noArray(), contours, contourIdx, *color, thickness, lineType, hierarchy ? *hierarchy : (InputArray)cv::noArray(), maxLevel, *offset);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_drawContours: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_drawContours\n");
        }
    }
    __declspec(dllexport) bool __stdcall Imgproc_clipLine_0(Size* imgSize, Point* pt1, Point* pt2) {
        try {
            return ::cv::clipLine(*imgSize, *pt1, *pt2);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_clipLine_0: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_clipLine_0\n");
            return {};
        }
    }
    __declspec(dllexport) bool __stdcall Imgproc_clipLine_1(Size2l* imgSize, Point2l* pt1, Point2l* pt2) {
        try {
            return ::cv::clipLine(*imgSize, *pt1, *pt2);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_clipLine_1: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_clipLine_1\n");
            return {};
        }
    }
    __declspec(dllexport) bool __stdcall Imgproc_clipLine_2(Rect* imgRect, Point* pt1, Point* pt2) {
        try {
            return ::cv::clipLine(*imgRect, *pt1, *pt2);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_clipLine_2: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_clipLine_2\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_putText_0(Mat* img, const char* text, Point* org, int fontFace, double fontScale, Scalar* color, int thickness, int lineType, bool bottomLeftOrigin) {
        try {
            ::cv::putText(img ? *img : (InputOutputArray)cv::noArray(), text, *org, fontFace, fontScale, *color, thickness, lineType, bottomLeftOrigin);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_putText_0: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_putText_0\n");
        }
    }
    __declspec(dllexport) CVSize __stdcall Imgproc_getTextSize_0(const char* text, int fontFace, double fontScale, int thickness, CV_OUT int* baseLine) {
        try {
            Size result = ::cv::getTextSize(text, fontFace, fontScale, thickness, baseLine);
            return {result.width, result.height};
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_getTextSize_0: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_getTextSize_0\n");
            return {};
        }
    }
    __declspec(dllexport) double __stdcall Imgproc_getFontScaleFromHeight(const int fontFace, const int pixelHeight, const int thickness) {
        try {
            return ::cv::getFontScaleFromHeight(fontFace, pixelHeight, thickness);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_getFontScaleFromHeight: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_getFontScaleFromHeight\n");
            return {};
        }
    }
    __declspec(dllexport) Point* __stdcall Imgproc_putText_1(Mat* img, const char* text, Point* org, Scalar* color, FontFace& fface, int size, int weight, PutTextFlags flags, Range wrap) {
        try {
            return new Point(::cv::putText(img ? *img : (InputOutputArray)cv::noArray(), text, *org, *color, fface, size, weight, flags, wrap));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_putText_1: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Imgproc_putText_1\n");
            return nullptr;
        }
    }
    __declspec(dllexport) CVRect __stdcall Imgproc_getTextSize_1(Size* imgsize, const char* text, Point* org, FontFace& fface, int size, int weight, PutTextFlags flags, Range wrap) {
        try {
            Rect result = ::cv::getTextSize(*imgsize, text, *org, fface, size, weight, flags, wrap);
            return {result.x, result.y, result.width, result.height};
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_getTextSize_1: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_getTextSize_1\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_approxPolyDP(Mat* curve, Mat* approxCurve, double epsilon, bool closed) {
        try {
            ::cv::approxPolyDP(curve ? *curve : (InputArray)cv::noArray(), approxCurve ? *approxCurve : (OutputArray)cv::noArray(), epsilon, closed);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_approxPolyDP: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_approxPolyDP\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_approxPolyN(Mat* curve, Mat* approxCurve, int nsides, float epsilon_percentage, bool ensure_convex) {
        try {
            ::cv::approxPolyN(curve ? *curve : (InputArray)cv::noArray(), approxCurve ? *approxCurve : (OutputArray)cv::noArray(), nsides, epsilon_percentage, ensure_convex);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_approxPolyN: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_approxPolyN\n");
        }
    }
    __declspec(dllexport) CVRotatedRect __stdcall Imgproc_minAreaRect(Mat* points) {
        try {
            RotatedRect result = ::cv::minAreaRect(points ? *points : (InputArray)cv::noArray());
            return { { result.center.x, result.center.y }, { result.size.width, result.size.height }, result.angle };
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_minAreaRect: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_minAreaRect\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_boxPoints(RotatedRect* box, Mat* points) {
        try {
            ::cv::boxPoints(*box, points ? *points : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_boxPoints: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_boxPoints\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_minEnclosingCircle(Mat* points, Point2f* center, CV_OUT float& radius) {
        try {
            ::cv::minEnclosingCircle(points ? *points : (InputArray)cv::noArray(), *center, radius);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_minEnclosingCircle: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_minEnclosingCircle\n");
        }
    }
    __declspec(dllexport) double __stdcall Imgproc_minEnclosingTriangle(Mat* points, Mat* triangle) {
        try {
            return ::cv::minEnclosingTriangle(points ? *points : (InputArray)cv::noArray(), triangle ? *triangle : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_minEnclosingTriangle: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_minEnclosingTriangle\n");
            return {};
        }
    }
    __declspec(dllexport) double __stdcall Imgproc_minEnclosingConvexPolygon(Mat* points, Mat* polygon, int k) {
        try {
            return ::cv::minEnclosingConvexPolygon(points ? *points : (InputArray)cv::noArray(), polygon ? *polygon : (OutputArray)cv::noArray(), k);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_minEnclosingConvexPolygon: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_minEnclosingConvexPolygon\n");
            return {};
        }
    }
    __declspec(dllexport) CVMoments __stdcall Imgproc_moments(Mat* array, bool binaryImage) {
        try {
            Moments result = ::cv::moments(array ? *array : (InputArray)cv::noArray(), binaryImage);
            return {result.m00, result.m10, result.m01, result.m20, result.m11, result.m02, result.m30, result.m21, result.m12, result.m03, result.mu20, result.mu11, result.mu02, result.mu30, result.mu21, result.mu12, result.mu03, result.nu20, result.nu11, result.nu02, result.nu30, result.nu21, result.nu12, result.nu03};
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_moments: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_moments\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_HuMoments(const Moments* m, Mat* hu) {
        try {
            ::cv::HuMoments(*m, hu ? *hu : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_HuMoments: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_HuMoments\n");
        }
    }
    __declspec(dllexport) double __stdcall Imgproc_matchShapes(Mat* contour1, Mat* contour2, int method, double parameter) {
        try {
            return ::cv::matchShapes(contour1 ? *contour1 : (InputArray)cv::noArray(), contour2 ? *contour2 : (InputArray)cv::noArray(), method, parameter);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_matchShapes: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_matchShapes\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_convexHull(Mat* points, Mat* hull, bool clockwise, bool returnPoints) {
        try {
            ::cv::convexHull(points ? *points : (InputArray)cv::noArray(), hull ? *hull : (OutputArray)cv::noArray(), clockwise, returnPoints);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_convexHull: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_convexHull\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_convexityDefects(Mat* contour, Mat* convexhull, Mat* convexityDefects) {
        try {
            ::cv::convexityDefects(contour ? *contour : (InputArray)cv::noArray(), convexhull ? *convexhull : (InputArray)cv::noArray(), convexityDefects ? *convexityDefects : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_convexityDefects: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_convexityDefects\n");
        }
    }
    __declspec(dllexport) bool __stdcall Imgproc_isContourConvex(Mat* contour) {
        try {
            return ::cv::isContourConvex(contour ? *contour : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_isContourConvex: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_isContourConvex\n");
            return {};
        }
    }
    __declspec(dllexport) float __stdcall Imgproc_intersectConvexConvex(Mat* p1, Mat* p2, Mat* p12, bool handleNested) {
        try {
            return ::cv::intersectConvexConvex(p1 ? *p1 : (InputArray)cv::noArray(), p2 ? *p2 : (InputArray)cv::noArray(), p12 ? *p12 : (OutputArray)cv::noArray(), handleNested);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_intersectConvexConvex: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_intersectConvexConvex\n");
            return {};
        }
    }
    __declspec(dllexport) CVRotatedRect __stdcall Imgproc_fitEllipse(Mat* points) {
        try {
            RotatedRect result = ::cv::fitEllipse(points ? *points : (InputArray)cv::noArray());
            return { { result.center.x, result.center.y }, { result.size.width, result.size.height }, result.angle };
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_fitEllipse: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_fitEllipse\n");
            return {};
        }
    }
    __declspec(dllexport) CVRotatedRect __stdcall Imgproc_fitEllipseAMS(Mat* points) {
        try {
            RotatedRect result = ::cv::fitEllipseAMS(points ? *points : (InputArray)cv::noArray());
            return { { result.center.x, result.center.y }, { result.size.width, result.size.height }, result.angle };
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_fitEllipseAMS: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_fitEllipseAMS\n");
            return {};
        }
    }
    __declspec(dllexport) CVRotatedRect __stdcall Imgproc_fitEllipseDirect(Mat* points) {
        try {
            RotatedRect result = ::cv::fitEllipseDirect(points ? *points : (InputArray)cv::noArray());
            return { { result.center.x, result.center.y }, { result.size.width, result.size.height }, result.angle };
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_fitEllipseDirect: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_fitEllipseDirect\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_getClosestEllipsePoints(RotatedRect* ellipse_params, Mat* points, Mat* closest_pts) {
        try {
            ::cv::getClosestEllipsePoints(*ellipse_params, points ? *points : (InputArray)cv::noArray(), closest_pts ? *closest_pts : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_getClosestEllipsePoints: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_getClosestEllipsePoints\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_fitLine(Mat* points, Mat* line, int distType, double param, double reps, double aeps) {
        try {
            ::cv::fitLine(points ? *points : (InputArray)cv::noArray(), line ? *line : (OutputArray)cv::noArray(), distType, param, reps, aeps);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_fitLine: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_fitLine\n");
        }
    }
    __declspec(dllexport) double __stdcall Imgproc_pointPolygonTest(Mat* contour, Point2f* pt, bool measureDist) {
        try {
            return ::cv::pointPolygonTest(contour ? *contour : (InputArray)cv::noArray(), *pt, measureDist);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_pointPolygonTest: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_pointPolygonTest\n");
            return {};
        }
    }
    __declspec(dllexport) int __stdcall Imgproc_rotatedRectangleIntersection(RotatedRect* rect1, RotatedRect* rect2, Mat* intersectingRegion) {
        try {
            return ::cv::rotatedRectangleIntersection(*rect1, *rect2, intersectingRegion ? *intersectingRegion : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_rotatedRectangleIntersection: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_rotatedRectangleIntersection\n");
            return {};
        }
    }
    __declspec(dllexport) double __stdcall Imgproc_arcLength(Mat* curve, bool closed) {
        try {
            return ::cv::arcLength(curve ? *curve : (InputArray)cv::noArray(), closed);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_arcLength: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_arcLength\n");
            return {};
        }
    }
    __declspec(dllexport) double __stdcall Imgproc_contourArea(Mat* contour, bool oriented) {
        try {
            return ::cv::contourArea(contour ? *contour : (InputArray)cv::noArray(), oriented);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_contourArea: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_contourArea\n");
            return {};
        }
    }
    __declspec(dllexport) CVRect __stdcall Imgproc_boundingRect(Mat* array) {
        try {
            Rect result = ::cv::boundingRect(array ? *array : (InputArray)cv::noArray());
            return {result.x, result.y, result.width, result.height};
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_boundingRect: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Imgproc_boundingRect\n");
            return {};
        }
    }
    __declspec(dllexport) Mat* __stdcall Imgproc_getRotationMatrix2D(Point2f* center, double angle, double scale) {
        try {
            return new Mat(::cv::getRotationMatrix2D(*center, angle, scale));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_getRotationMatrix2D: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Imgproc_getRotationMatrix2D\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Imgproc_getAffineTransform_0(const Point2f* src, const Point2f* dst) {
        try {
            return new Mat(::cv::getAffineTransform(src, dst));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_getAffineTransform_0: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Imgproc_getAffineTransform_0\n");
            return nullptr;
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_invertAffineTransform(Mat* M, Mat* iM) {
        try {
            ::cv::invertAffineTransform(M ? *M : (InputArray)cv::noArray(), iM ? *iM : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_invertAffineTransform: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_invertAffineTransform\n");
        }
    }
    __declspec(dllexport) Mat* __stdcall Imgproc_getPerspectiveTransform_0(Mat* src, Mat* dst, int solveMethod) {
        try {
            return new Mat(::cv::getPerspectiveTransform(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (InputArray)cv::noArray(), solveMethod));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_getPerspectiveTransform_0: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Imgproc_getPerspectiveTransform_0\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Imgproc_getPerspectiveTransform_1(const Point2f* src, const Point2f* dst, int solveMethod) {
        try {
            return new Mat(::cv::getPerspectiveTransform(src, dst, solveMethod));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_getPerspectiveTransform_1: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Imgproc_getPerspectiveTransform_1\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Imgproc_getAffineTransform_1(Mat* src, Mat* dst) {
        try {
            return new Mat(::cv::getAffineTransform(src ? *src : (InputArray)cv::noArray(), dst ? *dst : (InputArray)cv::noArray()));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_getAffineTransform_1: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Imgproc_getAffineTransform_1\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Imgproc_calcHistSimple(Mat* image, Mat* hist, int channel, Mat* mask, const int* histSize, const float* ranges, int dims, bool accumulate) {
        try {
            int ch[] = { channel };
            const Mat* images = image;
            const float* ranges_arr[] = { ranges };
            ::cv::calcHist(images, 1, ch, mask ? *mask : (InputArray)cv::noArray(), hist ? *hist : (OutputArray)cv::noArray(), dims, histSize, ranges_arr, true, accumulate);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_calcHistSimple: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_calcHistSimple\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_calcHist(Mat** images, int nimages, const int* channels, int channelsCount, Mat* mask, Mat* hist, const int* histSize, int histSizeCount, const float* ranges, int rangesCount, bool accumulate) {
        try {
            std::vector<Mat> imgs;
            if (images) {
                for (int i = 0; i < nimages; ++i)
                    if (images[i]) imgs.push_back(*images[i]);
            }
            std::vector<int> ch(channels, channels + channelsCount);
            std::vector<int> hs(histSize, histSize + histSizeCount);
            std::vector<float> r(ranges, ranges + rangesCount);
            ::cv::calcHist(imgs, ch, mask ? *mask : (InputArray)cv::noArray(), hist ? *hist : (OutputArray)cv::noArray(), hs, r, accumulate);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_calcHist: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_calcHist\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_calcBackProjectSimple(Mat* image, Mat* hist, Mat* backProject, const float* ranges, int rangesCount, double scale) {
        try {
            if (!image || !hist || !backProject || !ranges || rangesCount < 2) return;
            int ch[] = { 0 };
            const float* ranges_arr[] = { ranges };
            ::cv::calcBackProject(image, 1, ch, *hist, *backProject, ranges_arr, scale, true);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_calcBackProjectSimple: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_calcBackProjectSimple\n");
        }
    }
    __declspec(dllexport) void __stdcall Imgproc_calcBackProject(Mat** images, int nimages, const int* channels, int channelsCount, Mat* hist, Mat* backProject, const float* ranges, int rangesCount, double scale) {
        try {
            if (!images || nimages <= 0 || !channels || channelsCount <= 0 || !ranges || rangesCount < 2) return;
            std::vector<Mat> imgs;
            for (int i = 0; i < nimages; ++i)
                if (images[i]) imgs.push_back(*images[i]);
            if (imgs.empty()) return;
            std::vector<int> ch(channels, channels + channelsCount);
            std::vector<float> r(ranges, ranges + rangesCount);
            ::cv::calcBackProject(imgs, ch, hist ? *hist : (InputArray)cv::noArray(), backProject ? *backProject : (OutputArray)cv::noArray(), r, scale);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_calcBackProject: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_calcBackProject\n");
        }
    }
    __declspec(dllexport) CLAHE* __stdcall Imgproc_createCLAHE(double clipLimit, int tileCols, int tileRows) {
        try {
            Ptr<CLAHE> p = ::cv::createCLAHE(clipLimit, Size(tileCols, tileRows));
            CLAHE* raw = p.get();
            g_clahe_instances[raw] = p;
            return raw;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_createCLAHE: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Imgproc_createCLAHE\n");
            return nullptr;
        }
    }
    __declspec(dllexport) int __stdcall Imgproc_ellipse2Poly(Point* center, Size* axes, int angle, int arcStart, int arcEnd, int delta, Point* pts, int maxPts) {
        try {
            std::vector<Point> poly;
            ::cv::ellipse2Poly(*center, *axes, angle, arcStart, arcEnd, delta, poly);
            int count = (int)poly.size();
            int n = std::min(count, maxPts);
            for (int i = 0; i < n; ++i)
                pts[i] = poly[i];
            return count;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_ellipse2Poly: %s\n", e.what());
            return 0;
        } catch (...) {
            printf("Unknown Exception in Imgproc_ellipse2Poly\n");
            return 0;
        }
    }

    __declspec(dllexport) void __stdcall Imgproc_flip(Mat* src, Mat* dst, int flipCode) {
        try {
            if (!src || !dst) return;
            flip(*src, *dst, flipCode);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_flip: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_flip\n");
        }
    }

    __declspec(dllexport) void __stdcall Imgproc_rotate(Mat* src, Mat* dst, int rotateCode) {
        try {
            if (!src || !dst) return;
            rotate(*src, *dst, rotateCode);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_rotate: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_rotate\n");
        }
    }

    __declspec(dllexport) void __stdcall Imgproc_LUT(Mat* src, Mat* lut, Mat* dst) {
        try {
            if (!src || !lut || !dst) return;
            LUT(*src, *lut, *dst);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_LUT: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_LUT\n");
        }
    }

    __declspec(dllexport) void __stdcall Imgproc_buildGammaLUT(Mat* lut, double gamma) {
        try {
            if (!lut) return;
            if (gamma <= 0.0) gamma = 1.0;
            lut->create(1, 256, CV_8U);
            for (int i = 0; i < 256; ++i)
                lut->at<uchar>(0, i) = saturate_cast<uchar>(pow(i / 255.0, gamma) * 255.0);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgproc_buildGammaLUT: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgproc_buildGammaLUT\n");
        }
    }

}
