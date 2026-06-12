#include <opencv2/opencv.hpp>
#include <opencv2/stereo.hpp>
using namespace cv;
using namespace std;

extern "C" {

    __declspec(dllexport) void __stdcall Stereo_stereoRectify(
        Mat* cameraMatrix1, Mat* distCoeffs1, Mat* cameraMatrix2, Mat* distCoeffs2,
        Size* imageSize, Mat* R, Mat* T,
        Mat* R1, Mat* R2, Mat* P1, Mat* P2, Mat* Q,
        int flags, double alpha, Size* newImageSize,
        Rect* validPixROI1, Rect* validPixROI2)
    {
        try {
            if (!cameraMatrix1 || !distCoeffs1 || !cameraMatrix2 || !distCoeffs2 ||
                !imageSize || !R || !T || !R1 || !R2 || !P1 || !P2 || !Q)
                return;
            Size newSize = newImageSize ? *newImageSize : Size();
            stereoRectify(*cameraMatrix1, *distCoeffs1, *cameraMatrix2, *distCoeffs2,
                *imageSize, *R, *T, *R1, *R2, *P1, *P2, *Q, flags, alpha, newSize,
                validPixROI1, validPixROI2);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Stereo_stereoRectify: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Stereo_stereoRectify\n");
        }
    }

    __declspec(dllexport) void __stdcall Stereo_reprojectImageTo3D(
        Mat* disparity, Mat* image3d, Mat* Q, bool handleMissingValues, int ddepth)
    {
        try {
            if (!disparity || !image3d || !Q) return;
            reprojectImageTo3D(*disparity, *image3d, *Q, handleMissingValues, ddepth);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Stereo_reprojectImageTo3D: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Stereo_reprojectImageTo3D\n");
        }
    }

    struct DelphiStereoMatcher {
        Ptr<StereoMatcher> matcher;
    };

    __declspec(dllexport) DelphiStereoMatcher* __stdcall Stereo_SGBM_Create(
        int minDisparity, int numDisparities, int blockSize)
    {
        try {
            auto* holder = new DelphiStereoMatcher();
            holder->matcher = StereoSGBM::create(minDisparity, numDisparities, blockSize);
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Stereo_SGBM_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) DelphiStereoMatcher* __stdcall Stereo_BM_Create(
        int numDisparities, int blockSize)
    {
        try {
            auto* holder = new DelphiStereoMatcher();
            holder->matcher = StereoBM::create(numDisparities, blockSize);
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Stereo_BM_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Stereo_Matcher_Destroy(DelphiStereoMatcher* self) {
        delete self;
    }

    __declspec(dllexport) void __stdcall Stereo_Matcher_compute(
        DelphiStereoMatcher* self, Mat* left, Mat* right, Mat* disparity)
    {
        try {
            if (!self || !self->matcher || !left || !right || !disparity) return;
            self->matcher->compute(*left, *right, *disparity);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Stereo_Matcher_compute: %s\n", e.what());
        } catch (...) {}
    }

}
