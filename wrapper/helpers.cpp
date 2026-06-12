#include <opencv2/opencv.hpp>
#include <opencv2/imgproc.hpp>
#include <vector>
using namespace cv;
using namespace std;

extern "C" {

struct MatVector {
    vector<Mat> data;
};

__declspec(dllexport) MatVector* __stdcall MatVector_Create() {
    try {
        return new MatVector();
    } catch (...) {
        return nullptr;
    }
}

__declspec(dllexport) void __stdcall MatVector_Destroy(MatVector* self) {
    delete self;
}

__declspec(dllexport) int __stdcall MatVector_size(MatVector* self) {
    return self ? (int)self->data.size() : 0;
}

__declspec(dllexport) void __stdcall MatVector_clear(MatVector* self) {
    if (self) self->data.clear();
}

__declspec(dllexport) Mat* __stdcall MatVector_at(MatVector* self, int index) {
    try {
        if (!self || index < 0 || index >= (int)self->data.size())
            return nullptr;
        return new Mat(self->data[index]);
    } catch (const cv::Exception& e) {
        printf("OpenCV Exception in MatVector_at: %s\n", e.what());
        return nullptr;
    } catch (...) {
        return nullptr;
    }
}

__declspec(dllexport) void* __stdcall MatVector_data(MatVector* self) {
    return self ? (void*)&self->data : nullptr;
}

__declspec(dllexport) void __stdcall Helpers_findContours(
    Mat* image, MatVector* contours, Mat* hierarchy, int mode, int method, int offsetX, int offsetY)
{
    try {
        if (!image || !contours) return;
        contours->data.clear();
        Point offset(offsetX, offsetY);
        if (hierarchy)
            findContours(*image, contours->data, *hierarchy, mode, method, offset);
        else
            findContours(*image, contours->data, mode, method, offset);
    } catch (const cv::Exception& e) {
        printf("OpenCV Exception in Helpers_findContours: %s\n", e.what());
    } catch (...) {}
}

__declspec(dllexport) void __stdcall Helpers_drawContours(
    Mat* image, MatVector* contours, int contourIdx, int b, int g, int r, int thickness)
{
    try {
        if (!image || !contours || contourIdx < 0 || contourIdx >= (int)contours->data.size())
            return;
        drawContours(*image, contours->data, contourIdx, Scalar(b, g, r), thickness);
    } catch (const cv::Exception& e) {
        printf("OpenCV Exception in Helpers_drawContours: %s\n", e.what());
    } catch (...) {}
}

}
