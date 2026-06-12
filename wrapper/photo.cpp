#include <opencv2/opencv.hpp>
#include <opencv2/photo.hpp>
#include <stdexcept>
using namespace cv;
using namespace std;

extern "C" void Core_setLastError(const char* msg);

static void fastNlMeansDenoisingColoredBody(
    Mat* src, Mat* dst, float h, float hColor, int templateWindowSize, int searchWindowSize)
{
    try {
        if (!src || !dst) return;
        fastNlMeansDenoisingColored(*src, *dst, h, hColor, templateWindowSize, searchWindowSize);
    } catch (const cv::Exception& e) {
        Core_setLastError(e.what());
    } catch (const std::exception& e) {
        Core_setLastError(e.what());
    } catch (...) {
        Core_setLastError("Unknown exception in Photo_fastNlMeansDenoisingColored");
    }
}

static void seamlessCloneBody(Mat* src, Mat* dst, Mat* mask, Point* p, Mat* blend, int flags)
{
    try {
        if (!src || !dst || !mask || !p || !blend) return;
        seamlessClone(*src, *dst, *mask, *p, *blend, flags);
    } catch (const cv::Exception& e) {
        Core_setLastError(e.what());
    } catch (const std::exception& e) {
        Core_setLastError(e.what());
    } catch (...) {
        Core_setLastError("Unknown exception in Photo_seamlessClone");
    }
}

extern "C" {

    __declspec(dllexport) void __stdcall Photo_inpaint(
        Mat* src, Mat* inpaintMask, Mat* dst, double inpaintRadius, int flags)
    {
        try {
            if (!src || !inpaintMask || !dst) return;
            inpaint(*src, *inpaintMask, *dst, inpaintRadius, flags);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Photo_inpaint: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Photo_inpaint\n");
        }
    }

    __declspec(dllexport) void __stdcall Photo_fastNlMeansDenoising(
        Mat* src, Mat* dst, float h, int templateWindowSize, int searchWindowSize)
    {
        try {
            if (!src || !dst) return;
            fastNlMeansDenoising(*src, *dst, h, templateWindowSize, searchWindowSize);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Photo_fastNlMeansDenoising: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) void __stdcall Photo_fastNlMeansDenoisingColored(
        Mat* src, Mat* dst, float h, float hColor, int templateWindowSize, int searchWindowSize)
    {
        fastNlMeansDenoisingColoredBody(src, dst, h, hColor, templateWindowSize, searchWindowSize);
    }

    __declspec(dllexport) void __stdcall Photo_seamlessClone(
        Mat* src, Mat* dst, Mat* mask, Point* p, Mat* blend, int flags)
    {
        seamlessCloneBody(src, dst, mask, p, blend, flags);
    }

}
