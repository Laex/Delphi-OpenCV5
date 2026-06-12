#include <opencv2/opencv.hpp>
using namespace cv;
using namespace std;

extern "C" {

    // ==========================================
    // Class VideoCapture
    // ==========================================
    __declspec(dllexport) VideoCapture* __stdcall VideoCapture_Ctor_0() {
        return new VideoCapture();
    }
    __declspec(dllexport) VideoCapture* __stdcall VideoCapture_Ctor_1(const char* filename, int apiPreference) {
        return new VideoCapture(filename, apiPreference);
    }
    __declspec(dllexport) VideoCapture* __stdcall VideoCapture_Ctor_2(int index, int apiPreference) {
        return new VideoCapture(index, apiPreference);
    }
    __declspec(dllexport) VideoCapture* __stdcall VideoCapture_Ctor_3() {
        return new VideoCapture();
    }
    __declspec(dllexport) void __stdcall VideoCapture_Destroy(VideoCapture* self) {
        if (self) delete self;
    }
    __declspec(dllexport) bool __stdcall VideoCapture_open_0(VideoCapture* self, const char* filename, int apiPreference) {
        try {
            return self->open(filename, apiPreference);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoCapture_open_0: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoCapture_open_0\n");
            return {};
        }
    }
    __declspec(dllexport) bool __stdcall VideoCapture_open_1(VideoCapture* self, int index, int apiPreference) {
        try {
            return self->open(index, apiPreference);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoCapture_open_1: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoCapture_open_1\n");
            return {};
        }
    }
    __declspec(dllexport) bool __stdcall VideoCapture_isOpened(VideoCapture* self) {
        try {
            return self->isOpened();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoCapture_isOpened: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoCapture_isOpened\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall VideoCapture_release(VideoCapture* self) {
        try {
            self->release();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoCapture_release: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in VideoCapture_release\n");
        }
    }
    __declspec(dllexport) bool __stdcall VideoCapture_grab(VideoCapture* self) {
        try {
            return self->grab();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoCapture_grab: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoCapture_grab\n");
            return {};
        }
    }
    __declspec(dllexport) bool __stdcall VideoCapture_retrieve(VideoCapture* self, Mat* image, int flag) {
        try {
            return self->retrieve(image ? *image : (OutputArray)cv::noArray(), flag);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoCapture_retrieve: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoCapture_retrieve\n");
            return {};
        }
    }
    __declspec(dllexport) bool __stdcall VideoCapture_read(VideoCapture* self, Mat* image) {
        try {
            return self->read(image ? *image : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoCapture_read: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoCapture_read\n");
            return {};
        }
    }
    __declspec(dllexport) bool __stdcall VideoCapture_set(VideoCapture* self, int propId, double value) {
        try {
            return self->set(propId, value);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoCapture_set: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoCapture_set\n");
            return {};
        }
    }
    __declspec(dllexport) double __stdcall VideoCapture_get(VideoCapture* self, int propId) {
        try {
            return self->get(propId);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoCapture_get: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoCapture_get\n");
            return {};
        }
    }
    __declspec(dllexport) const char* __stdcall VideoCapture_getBackendName(VideoCapture* self) {
        try {
            static thread_local std::string last_str;
            last_str = std::string(self->getBackendName());
            return last_str.c_str();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoCapture_getBackendName: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in VideoCapture_getBackendName\n");
            return nullptr;
        }
    }

    // ==========================================
    // Class VideoWriter
    // ==========================================
    __declspec(dllexport) VideoWriter* __stdcall VideoWriter_Ctor_0() {
        return new VideoWriter();
    }
    __declspec(dllexport) VideoWriter* __stdcall VideoWriter_Ctor_1(const char* filename, int fourcc, double fps, Size* frameSize, bool isColor) {
        return new VideoWriter(filename, fourcc, fps, *frameSize, isColor);
    }
    __declspec(dllexport) VideoWriter* __stdcall VideoWriter_Ctor_2(const char* filename, int apiPreference, int fourcc, double fps, Size* frameSize, bool isColor) {
        return new VideoWriter(filename, apiPreference, fourcc, fps, *frameSize, isColor);
    }
    __declspec(dllexport) VideoWriter* __stdcall VideoWriter_Ctor_3() {
        return new VideoWriter();
    }
    __declspec(dllexport) void __stdcall VideoWriter_Destroy(VideoWriter* self) {
        if (self) delete self;
    }
    __declspec(dllexport) bool __stdcall VideoWriter_open_0(VideoWriter* self, const char* filename, int fourcc, double fps, Size* frameSize, bool isColor) {
        try {
            return self->open(filename, fourcc, fps, *frameSize, isColor);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoWriter_open_0: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoWriter_open_0\n");
            return {};
        }
    }
    __declspec(dllexport) bool __stdcall VideoWriter_open_1(VideoWriter* self, const char* filename, int apiPreference, int fourcc, double fps, Size* frameSize, bool isColor) {
        try {
            return self->open(filename, apiPreference, fourcc, fps, *frameSize, isColor);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoWriter_open_1: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoWriter_open_1\n");
            return {};
        }
    }
    __declspec(dllexport) bool __stdcall VideoWriter_isOpened(VideoWriter* self) {
        try {
            return self->isOpened();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoWriter_isOpened: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoWriter_isOpened\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall VideoWriter_release(VideoWriter* self) {
        try {
            self->release();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoWriter_release: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in VideoWriter_release\n");
        }
    }
    __declspec(dllexport) bool __stdcall VideoWriter_write(VideoWriter* self, Mat* image) {
        try {
            return self->write(image ? *image : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoWriter_write: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoWriter_write\n");
            return {};
        }
    }
    __declspec(dllexport) bool __stdcall VideoWriter_set(VideoWriter* self, int propId, double value) {
        try {
            return self->set(propId, value);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoWriter_set: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoWriter_set\n");
            return {};
        }
    }
    __declspec(dllexport) double __stdcall VideoWriter_get(VideoWriter* self, int propId) {
        try {
            return self->get(propId);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoWriter_get: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoWriter_get\n");
            return {};
        }
    }
    __declspec(dllexport) int __stdcall VideoWriter_fourcc(VideoWriter* self, char c1, char c2, char c3, char c4) {
        try {
            return self->fourcc(c1, c2, c3, c4);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoWriter_fourcc: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in VideoWriter_fourcc\n");
            return {};
        }
    }
    __declspec(dllexport) const char* __stdcall VideoWriter_getBackendName(VideoWriter* self) {
        try {
            static thread_local std::string last_str;
            last_str = std::string(self->getBackendName());
            return last_str.c_str();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in VideoWriter_getBackendName: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in VideoWriter_getBackendName\n");
            return nullptr;
        }
    }

}
