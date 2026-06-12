#include <opencv2/opencv.hpp>
#include <opencv2/core/persistence.hpp>
#include <cstring>
using namespace cv;
using namespace std;

extern "C" {

    struct DelphiFileStorage {
        FileStorage fs;
    };

    __declspec(dllexport) DelphiFileStorage* __stdcall Persistence_create(
        const char* filename, int flags)
    {
        try {
            auto* holder = new DelphiFileStorage();
            holder->fs.open(filename ? filename : "", flags);
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Persistence_create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Persistence_create\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Persistence_Destroy(DelphiFileStorage* self) {
        if (self) {
            self->fs.release();
            delete self;
        }
    }

    __declspec(dllexport) bool __stdcall Persistence_isOpened(DelphiFileStorage* self) {
        if (!self) return false;
        return self->fs.isOpened();
    }

    __declspec(dllexport) void __stdcall Persistence_release(DelphiFileStorage* self) {
        if (self) self->fs.release();
    }

    __declspec(dllexport) void __stdcall Persistence_writeMat(
        DelphiFileStorage* self, const char* name, Mat* val)
    {
        try {
            if (!self || !name || !val) return;
            write(self->fs, String(name), *val);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Persistence_writeMat: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Persistence_writeMat\n");
        }
    }

    __declspec(dllexport) bool __stdcall Persistence_readMat(
        DelphiFileStorage* self, const char* name, Mat* val)
    {
        try {
            if (!self || !name || !val) return false;
            FileNode node = self->fs[name];
            if (node.empty()) return false;
            read(node, *val);
            return !val->empty();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Persistence_readMat: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Persistence_readMat\n");
            return false;
        }
    }

    __declspec(dllexport) void __stdcall Persistence_writeInt(
        DelphiFileStorage* self, const char* name, int val)
    {
        try {
            if (!self || !name) return;
            self->fs << name << val;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Persistence_writeInt: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) void __stdcall Persistence_writeDouble(
        DelphiFileStorage* self, const char* name, double val)
    {
        try {
            if (!self || !name) return;
            self->fs << name << val;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Persistence_writeDouble: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) void __stdcall Persistence_writeString(
        DelphiFileStorage* self, const char* name, const char* val)
    {
        try {
            if (!self || !name) return;
            self->fs << name << String(val ? val : "");
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Persistence_writeString: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) bool __stdcall Persistence_readInt(
        DelphiFileStorage* self, const char* name, int* val)
    {
        try {
            if (!self || !name || !val) return false;
            FileNode node = self->fs[name];
            if (node.empty()) return false;
            *val = (int)node;
            return true;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Persistence_readInt: %s\n", e.what());
            return false;
        } catch (...) {
            return false;
        }
    }

    __declspec(dllexport) bool __stdcall Persistence_readDouble(
        DelphiFileStorage* self, const char* name, double* val)
    {
        try {
            if (!self || !name || !val) return false;
            FileNode node = self->fs[name];
            if (node.empty()) return false;
            *val = (double)node;
            return true;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Persistence_readDouble: %s\n", e.what());
            return false;
        } catch (...) {
            return false;
        }
    }

    __declspec(dllexport) bool __stdcall Persistence_readString(
        DelphiFileStorage* self, const char* name, char* buffer, int bufferSize)
    {
        try {
            if (!self || !name || !buffer || bufferSize <= 0) return false;
            FileNode node = self->fs[name];
            if (node.empty()) return false;
            String s = (String)node;
            int n = (int)min(s.size(), (size_t)(bufferSize - 1));
            if (n > 0) memcpy(buffer, s.c_str(), n);
            buffer[n] = '\0';
            return true;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Persistence_readString: %s\n", e.what());
            return false;
        } catch (...) {
            return false;
        }
    }

}
