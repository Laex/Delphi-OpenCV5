#include <opencv2/opencv.hpp>
#include <map>
#include <string>
using namespace cv;
using namespace std;

extern "C" {

    typedef void (__cdecl *DelphiMouseCallback)(int event, int x, int y, int flags, void* userdata);
    typedef void (__cdecl *DelphiTrackbarCallback)(int pos, void* userdata);

    struct MouseBridge {
        DelphiMouseCallback cb;
        void* userdata;
    };

    struct TrackbarBridge {
        DelphiTrackbarCallback cb;
        void* userdata;
    };

    static map<string, MouseBridge> g_mouseBridges;
    static map<string, TrackbarBridge> g_trackbarBridges;

    static void MouseBridgeProc(int event, int x, int y, int flags, void* userdata) {
        auto* b = static_cast<MouseBridge*>(userdata);
        if (b && b->cb)
            b->cb(event, x, y, flags, b->userdata);
    }

    static void TrackbarBridgeProc(int pos, void* userdata) {
        auto* b = static_cast<TrackbarBridge*>(userdata);
        if (b && b->cb)
            b->cb(pos, b->userdata);
    }

    // ==========================================    // Global Functions
    // ==========================================
    __declspec(dllexport) void __stdcall Highgui_namedWindow(const char* winname, int flags) {
        try {
            ::cv::namedWindow(winname, flags);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Highgui_namedWindow: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Highgui_namedWindow\n");
        }
    }
    __declspec(dllexport) void __stdcall Highgui_destroyWindow(const char* winname) {
        try {
            ::cv::destroyWindow(winname);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Highgui_destroyWindow: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Highgui_destroyWindow\n");
        }
    }
    __declspec(dllexport) void __stdcall Highgui_destroyAllWindows() {
        try {
            ::cv::destroyAllWindows();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Highgui_destroyAllWindows: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Highgui_destroyAllWindows\n");
        }
    }
    __declspec(dllexport) int __stdcall Highgui_waitKey(int delay) {
        try {
            return ::cv::waitKey(delay);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Highgui_waitKey: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Highgui_waitKey\n");
            return {};
        }
    }
    __declspec(dllexport) int __stdcall Highgui_pollKey() {
        try {
            return ::cv::pollKey();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Highgui_pollKey: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Highgui_pollKey\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Highgui_imshow(const char* winname, Mat* mat) {
        try {
            ::cv::imshow(winname, mat ? *mat : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Highgui_imshow: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Highgui_imshow\n");
        }
    }

    __declspec(dllexport) void __stdcall Highgui_selectROI(
        const char* winname, Mat* img, bool showCrosshair, bool fromCenter,
        int* outX, int* outY, int* outW, int* outH)
    {
        try {
            if (!img) return;
            Rect r;
            if (winname && winname[0])
                r = selectROI(winname, *img, showCrosshair, fromCenter, false);
            else
                r = selectROI(*img, showCrosshair, fromCenter, false);
            if (outX) *outX = r.x;
            if (outY) *outY = r.y;
            if (outW) *outW = r.width;
            if (outH) *outH = r.height;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Highgui_selectROI: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) void __stdcall Highgui_setMouseCallback(
        const char* winname, DelphiMouseCallback onMouse, void* userdata)
    {
        try {
            if (!winname) return;
            string key(winname);
            MouseBridge& b = g_mouseBridges[key];
            b.cb = onMouse;
            b.userdata = userdata;
            setMouseCallback(winname, MouseBridgeProc, &b);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Highgui_setMouseCallback: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) int __stdcall Highgui_createTrackbar(
        const char* trackbarname, const char* winname, int* value, int count,
        DelphiTrackbarCallback onChange, void* userdata)
    {
        try {
            if (!trackbarname || !winname || !value) return -1;
            string key(string(winname) + "\0" + trackbarname);
            TrackbarBridge& b = g_trackbarBridges[key];
            b.cb = onChange;
            b.userdata = userdata;
            if (onChange)
                return createTrackbar(trackbarname, winname, value, count, TrackbarBridgeProc, &b);
            return createTrackbar(trackbarname, winname, value, count, nullptr, nullptr);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Highgui_createTrackbar: %s\n", e.what());
            return -1;
        } catch (...) {
            return -1;
        }
    }

}
