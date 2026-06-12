#include <opencv2/opencv.hpp>
#include <vector>
#include <cstring>
#include <stdexcept>
using namespace cv;

extern "C" void Core_setLastError(const char* msg);

struct ImencodeBodyResult {
    int status; // >0 size, <0 -need, 0 fail
};

static ImencodeBodyResult imencodeBody(const char* ext, Mat* img, unsigned char* buffer, int bufferSize)
{
    ImencodeBodyResult r = { 0 };
    try {
        if (!ext || !img) return r;
        std::vector<uchar> data;
        if (!::cv::imencode(ext, *img, data))
            return r;
        const int need = (int)data.size();
        if (!buffer || bufferSize < need) {
            r.status = -need;
            return r;
        }
        memcpy(buffer, data.data(), need);
        r.status = need;
        return r;
    } catch (const cv::Exception& e) {
        Core_setLastError(e.what());
        return r;
    } catch (const std::exception& e) {
        Core_setLastError(e.what());
        return r;
    } catch (...) {
        Core_setLastError("Unknown exception in Imgcodecs_imencode");
        return r;
    }
}

extern "C" {

    // ==========================================
    // Global Functions
    // ==========================================
    __declspec(dllexport) Mat* __stdcall Imgcodecs_imread_0(const char* filename, int flags) {
        try {
            return new Mat(::cv::imread(filename, flags));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgcodecs_imread_0: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Imgcodecs_imread_0\n");
            return nullptr;
        }
    }
    __declspec(dllexport) void __stdcall Imgcodecs_imread_1(const char* filename, Mat* dst, int flags) {
        try {
            ::cv::imread(filename, dst ? *dst : (OutputArray)cv::noArray(), flags);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgcodecs_imread_1: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Imgcodecs_imread_1\n");
        }
    }

    __declspec(dllexport) bool __stdcall Imgcodecs_imwrite(const char* filename, Mat* img) {
        try {
            return ::cv::imwrite(filename, img ? *img : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgcodecs_imwrite: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Imgcodecs_imwrite\n");
            return false;
        }
    }
    __declspec(dllexport) bool __stdcall Imgcodecs_imwrite_1(const char* filename, Mat* img, const int* params, int paramsCount) {
        try {
            std::vector<int> p;
            if (params && paramsCount > 0) p.assign(params, params + paramsCount);
            return ::cv::imwrite(filename, img ? *img : (InputArray)cv::noArray(), p);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgcodecs_imwrite_1: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Imgcodecs_imwrite_1\n");
            return false;
        }
    }

    // Returns encoded size on success, negative required size if buffer too small, 0 on failure.
    __declspec(dllexport) int __stdcall Imgcodecs_imencode(
        const char* ext, Mat* img, unsigned char* buffer, int bufferSize)
    {
        ImencodeBodyResult r = imencodeBody(ext, img, buffer, bufferSize);
        return r.status;
    }

    __declspec(dllexport) Mat* __stdcall Imgcodecs_imdecode(
        const unsigned char* buffer, int bufferSize, int flags)
    {
        try {
            if (!buffer || bufferSize <= 0) return new Mat();
            std::vector<uchar> data(buffer, buffer + bufferSize);
            return new Mat(::cv::imdecode(data, flags));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Imgcodecs_imdecode: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Imgcodecs_imdecode\n");
            return nullptr;
        }
    }

}
