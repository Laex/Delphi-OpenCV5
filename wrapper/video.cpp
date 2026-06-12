#include <opencv2/opencv.hpp>
#include <opencv2/video/background_segm.hpp>
using namespace cv;
using namespace std;

extern "C" {

    struct DelphiMOG2 {
        Ptr<BackgroundSubtractorMOG2> bs;
    };

    __declspec(dllexport) DelphiMOG2* __stdcall Video_createBackgroundSubtractorMOG2(
        int history, double varThreshold, bool detectShadows)
    {
        try {
            auto* holder = new DelphiMOG2();
            holder->bs = createBackgroundSubtractorMOG2(history, varThreshold, detectShadows);
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Video_createBackgroundSubtractorMOG2: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Video_createBackgroundSubtractorMOG2\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Video_MOG2_Destroy(DelphiMOG2* self) {
        delete self;
    }

    __declspec(dllexport) void __stdcall Video_MOG2_apply(
        DelphiMOG2* self, Mat* image, Mat* fgmask, double learningRate)
    {
        try {
            if (!self || !self->bs || !image || !fgmask) return;
            self->bs->apply(*image, *fgmask, learningRate);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Video_MOG2_apply: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Video_MOG2_apply\n");
        }
    }

    struct DelphiKNN {
        Ptr<BackgroundSubtractorKNN> bs;
    };

    __declspec(dllexport) DelphiKNN* __stdcall Video_createBackgroundSubtractorKNN(
        int history, double dist2Threshold, bool detectShadows)
    {
        try {
            auto* holder = new DelphiKNN();
            holder->bs = createBackgroundSubtractorKNN(history, dist2Threshold, detectShadows);
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Video_createBackgroundSubtractorKNN: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Video_KNN_Destroy(DelphiKNN* self) {
        delete self;
    }

    __declspec(dllexport) void __stdcall Video_KNN_apply(
        DelphiKNN* self, Mat* image, Mat* fgmask, double learningRate)
    {
        try {
            if (!self || !self->bs || !image || !fgmask) return;
            self->bs->apply(*image, *fgmask, learningRate);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Video_KNN_apply: %s\n", e.what());
        } catch (...) {}
    }

    // ==========================================
    // Global Functions
    // ==========================================
    __declspec(dllexport) int __stdcall Video_buildOpticalFlowPyramid(Mat* img, OutputArrayOfArrays pyramid, Size* winSize, int maxLevel, bool withDerivatives, int pyrBorder, int derivBorder, bool tryReuseInputImage) {
        try {
            return ::cv::buildOpticalFlowPyramid(img ? *img : (InputArray)cv::noArray(), pyramid, *winSize, maxLevel, withDerivatives, pyrBorder, derivBorder, tryReuseInputImage);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Video_buildOpticalFlowPyramid: %s\n", e.what());
            return -1;
        } catch (...) {
            printf("Unknown Exception in Video_buildOpticalFlowPyramid\n");
            return -1;
        }
    }
    __declspec(dllexport) void __stdcall Video_calcOpticalFlowPyrLK(Mat* prevImg, Mat* nextImg, Mat* prevPts, Mat* nextPts, Mat* status, Mat* err, Size* winSize, int maxLevel, TermCriteria* criteria, int flags, double minEigThreshold) {
        try {
            ::cv::calcOpticalFlowPyrLK(prevImg ? *prevImg : (InputArray)cv::noArray(), nextImg ? *nextImg : (InputArray)cv::noArray(), prevPts ? *prevPts : (InputArray)cv::noArray(), nextPts ? *nextPts : (InputOutputArray)cv::noArray(), status ? *status : (OutputArray)cv::noArray(), err ? *err : (OutputArray)cv::noArray(), *winSize, maxLevel, *criteria, flags, minEigThreshold);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Video_calcOpticalFlowPyrLK: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Video_calcOpticalFlowPyrLK\n");
        }
    }
    __declspec(dllexport) void __stdcall Video_calcOpticalFlowFarneback(Mat* prev, Mat* next, Mat* flow, double pyr_scale, int levels, int winsize, int iterations, int poly_n, double poly_sigma, int flags) {
        try {
            ::cv::calcOpticalFlowFarneback(prev ? *prev : (InputArray)cv::noArray(), next ? *next : (InputArray)cv::noArray(), flow ? *flow : (InputOutputArray)cv::noArray(), pyr_scale, levels, winsize, iterations, poly_n, poly_sigma, flags);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Video_calcOpticalFlowFarneback: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Video_calcOpticalFlowFarneback\n");
        }
    }

}
