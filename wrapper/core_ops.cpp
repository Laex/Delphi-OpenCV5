#include <opencv2/opencv.hpp>
#include <stdexcept>
using namespace cv;
using namespace std;

extern "C" void Core_setLastError(const char* msg);

static void copyMatChannel(const Mat& src, Mat& dst, int cn)
{
    if (cn < 0 || cn >= src.channels()) return;
    const int depth = src.depth();
    const int type1 = CV_MAKETYPE(depth, 1);
    if (dst.rows != src.rows || dst.cols != src.cols || dst.type() != type1) {
        Core_setLastError("Core_split: pre-allocate each channel Mat (rows x cols, CV_8UC1 etc.)");
        return;
    }
    const int ch = src.channels();
    const size_t es = src.elemSize1();
    for (int y = 0; y < src.rows; ++y) {
        const uchar* sp = src.ptr(y);
        uchar* dp = dst.ptr(y);
        for (int x = 0; x < src.cols; ++x)
            memcpy(dp + (size_t)x * es, sp + ((size_t)x * ch + cn) * es, es);
    }
}

static int coreSplitBody(Mat* src, Mat* dst0, Mat* dst1, Mat* dst2, Mat* dst3, int maxDst)
{
    try {
        if (!src || maxDst <= 0) return 0;
        const int n = src->channels();
        Mat* dsts[4] = { dst0, dst1, dst2, dst3 };
        int limit = n;
        if (limit > maxDst) limit = maxDst;
        if (limit > 4) limit = 4;
        for (int i = 0; i < limit; ++i) {
            if (dsts[i])
                copyMatChannel(*src, *dsts[i], i);
        }
        return n;
    } catch (const cv::Exception& e) {
        Core_setLastError(e.what());
        return 0;
    } catch (const std::exception& e) {
        Core_setLastError(e.what());
        return 0;
    } catch (...) {
        Core_setLastError("Unknown exception in Core_split");
        return 0;
    }
}

extern "C" {

    __declspec(dllexport) void __stdcall Core_add(Mat* src1, Mat* src2, Mat* dst, Mat* mask, int dtype) {
        try {
            if (!src1 || !src2 || !dst) return;
            add(*src1, *src2, *dst, mask ? *mask : noArray(), dtype);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Core_add: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) void __stdcall Core_subtract(Mat* src1, Mat* src2, Mat* dst, Mat* mask, int dtype) {
        try {
            if (!src1 || !src2 || !dst) return;
            subtract(*src1, *src2, *dst, mask ? *mask : noArray(), dtype);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Core_subtract: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) void __stdcall Core_absdiff(Mat* src1, Mat* src2, Mat* dst) {
        try {
            if (!src1 || !src2 || !dst) return;
            absdiff(*src1, *src2, *dst);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Core_absdiff: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) void __stdcall Core_inRange(Mat* src, Scalar* lowerb, Scalar* upperb, Mat* dst) {
        try {
            if (!src || !lowerb || !upperb || !dst) return;
            inRange(*src, *lowerb, *upperb, *dst);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Core_inRange: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) void __stdcall Core_bitwise_and(Mat* src1, Mat* src2, Mat* dst, Mat* mask) {
        try {
            if (!src1 || !src2 || !dst) return;
            bitwise_and(*src1, *src2, *dst, mask ? *mask : noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Core_bitwise_and: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) void __stdcall Core_bitwise_or(Mat* src1, Mat* src2, Mat* dst, Mat* mask) {
        try {
            if (!src1 || !src2 || !dst) return;
            bitwise_or(*src1, *src2, *dst, mask ? *mask : noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Core_bitwise_or: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) void __stdcall Core_bitwise_xor(Mat* src1, Mat* src2, Mat* dst, Mat* mask) {
        try {
            if (!src1 || !src2 || !dst) return;
            bitwise_xor(*src1, *src2, *dst, mask ? *mask : noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Core_bitwise_xor: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) void __stdcall Core_bitwise_not(Mat* src, Mat* dst, Mat* mask) {
        try {
            if (!src || !dst) return;
            bitwise_not(*src, *dst, mask ? *mask : noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Core_bitwise_not: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) void __stdcall Core_minMaxLoc(Mat* src, Mat* mask,
        double* minVal, double* maxVal, int* minX, int* minY, int* maxX, int* maxY)
    {
        try {
            if (!src) return;
            double minV = 0, maxV = 0;
            Point minLoc, maxLoc;
            minMaxLoc(*src, &minV, &maxV, &minLoc, &maxLoc, mask ? *mask : noArray());
            if (minVal) *minVal = minV;
            if (maxVal) *maxVal = maxV;
            if (minX) *minX = minLoc.x;
            if (minY) *minY = minLoc.y;
            if (maxX) *maxX = maxLoc.x;
            if (maxY) *maxY = maxLoc.y;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Core_minMaxLoc: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) int __stdcall Core_countNonZero(Mat* src, Mat* mask) {
        try {
            if (!src) return 0;
            if (mask && !mask->empty()) {
                Mat masked;
                src->copyTo(masked, *mask);
                return countNonZero(masked);
            }
            return countNonZero(*src);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Core_countNonZero: %s\n", e.what());
            return -1;
        } catch (...) {
            return -1;
        }
    }

    __declspec(dllexport) int __stdcall Core_split(Mat* src, Mat* dst0, Mat* dst1, Mat* dst2, Mat* dst3, int maxDst) {
        return coreSplitBody(src, dst0, dst1, dst2, dst3, maxDst);
    }

    __declspec(dllexport) void __stdcall Core_merge(Mat* src0, Mat* src1, Mat* src2, Mat* src3, int nsrc, Mat* dst) {
        try {
            if (!dst || nsrc <= 0) return;
            vector<Mat> ch;
            Mat* srcs[4] = { src0, src1, src2, src3 };
            int limit = nsrc;
            if (limit > 4) limit = 4;
            for (int i = 0; i < limit; ++i)
                if (srcs[i]) ch.push_back(*srcs[i]);
            if (ch.empty()) return;
            merge(ch, *dst);
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            printf("OpenCV Exception in Core_merge: %s\n", e.what());
        } catch (...) {
            Core_setLastError("Unknown exception in Core_merge");
        }
    }

    __declspec(dllexport) void __stdcall Core_multiply(Mat* src1, Mat* src2, Mat* dst, double scale, int dtype) {
        try {
            if (!src1 || !src2 || !dst) return;
            multiply(*src1, *src2, *dst, scale, dtype);
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            printf("OpenCV Exception in Core_multiply: %s\n", e.what());
        } catch (...) {
            Core_setLastError("Unknown exception in Core_multiply");
        }
    }

    __declspec(dllexport) void __stdcall Core_divide(Mat* src1, Mat* src2, Mat* dst, double scale, int dtype) {
        try {
            if (!src1 || !src2 || !dst) return;
            divide(*src1, *src2, *dst, scale, dtype);
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            printf("OpenCV Exception in Core_divide: %s\n", e.what());
        } catch (...) {
            Core_setLastError("Unknown exception in Core_divide");
        }
    }

    __declspec(dllexport) void __stdcall Core_meanStdDev(Mat* src, Mat* mask, Mat* mean, Mat* stddev) {
        try {
            if (!src || !mean || !stddev) return;
            meanStdDev(*src, *mean, *stddev, mask ? *mask : noArray());
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            printf("OpenCV Exception in Core_meanStdDev: %s\n", e.what());
        } catch (...) {
            Core_setLastError("Unknown exception in Core_meanStdDev");
        }
    }

    __declspec(dllexport) void __stdcall Core_addWeighted(Mat* src1, double alpha, Mat* src2, double beta, double gamma, Mat* dst) {
        try {
            if (!src1 || !src2 || !dst) return;
            addWeighted(*src1, alpha, *src2, beta, gamma, *dst);
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            printf("OpenCV Exception in Core_addWeighted: %s\n", e.what());
        } catch (...) {
            Core_setLastError("Unknown exception in Core_addWeighted");
        }
    }

}
