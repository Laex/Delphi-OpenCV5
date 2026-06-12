#include <opencv2/opencv.hpp>
#include <cstring>
#ifdef _WIN32
#include <windows.h>
#include <eh.h>
#include <stdexcept>
#endif
using namespace cv;

namespace {

thread_local char g_lastError[4096] = {0};

void setLastError(const char* msg) {
    if (!msg) msg = "Unknown error";
    strncpy_s(g_lastError, msg, sizeof(g_lastError) - 1);
    g_lastError[sizeof(g_lastError) - 1] = '\0';
}

#ifdef _WIN32
void ocvSehTranslator(unsigned int, _EXCEPTION_POINTERS*) {
    throw std::runtime_error("Structured exception (SEH) in OpenCV wrapper");
}
#endif

} // namespace

extern "C" {

void Core_setLastError(const char* msg) {
    setLastError(msg);
}

__declspec(dllexport) void __stdcall Core_getLastError(char* buffer, int bufferSize) {
    if (!buffer || bufferSize <= 0) return;
    strncpy_s(buffer, bufferSize, g_lastError, _TRUNCATE);
}

__declspec(dllexport) void __stdcall Core_clearLastError() {
    g_lastError[0] = '\0';
}

__declspec(dllexport) void __stdcall Core_getVersionString(char* buffer, int bufferSize) {
    if (!buffer || bufferSize <= 0) return;
    const std::string ver = CV_VERSION;
    strncpy_s(buffer, bufferSize, ver.c_str(), _TRUNCATE);
}

__declspec(dllexport) const char* __stdcall Core_getBuildInformation() {
    try {
        static std::string info;
        info = getBuildInformation();
        return info.c_str();
    } catch (const cv::Exception& e) {
        setLastError(e.what());
        return "";
    } catch (...) {
        setLastError("Unknown exception in getBuildInformation");
        return "";
    }
}

__declspec(dllexport) void __stdcall Core_installSehTranslator() {
#ifdef _WIN32
    _set_se_translator(ocvSehTranslator);
#endif
}

}

#ifdef _WIN32
BOOL WINAPI DllMain(HINSTANCE, DWORD reason, LPVOID) {
    if (reason == DLL_PROCESS_ATTACH)
        Core_installSehTranslator();
    return TRUE;
}
#endif
