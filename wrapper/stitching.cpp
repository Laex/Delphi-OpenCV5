#include <opencv2/opencv.hpp>
#include <opencv2/stitching.hpp>
using namespace cv;
using namespace std;

extern "C" {

    struct DelphiStitcher {
        Ptr<Stitcher> stitcher;
    };

    __declspec(dllexport) DelphiStitcher* __stdcall Stitching_create(int mode) {
        try {
            auto* holder = new DelphiStitcher();
            holder->stitcher = Stitcher::create((Stitcher::Mode)mode);
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Stitching_create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Stitching_create\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Stitching_Destroy(DelphiStitcher* self) {
        delete self;
    }

    __declspec(dllexport) int __stdcall Stitching_stitch(
        DelphiStitcher* self, Mat** images, int count, Mat* pano)
    {
        try {
            if (!self || !self->stitcher || !images || count <= 0 || !pano)
                return (int)Stitcher::ERR_NEED_MORE_IMGS;
            vector<Mat> imgs;
            imgs.reserve(count);
            for (int i = 0; i < count; ++i)
                if (images[i]) imgs.push_back(*images[i]);
            if (imgs.size() < 2)
                return (int)Stitcher::ERR_NEED_MORE_IMGS;
            return (int)self->stitcher->stitch(imgs, *pano);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Stitching_stitch: %s\n", e.what());
            return (int)Stitcher::ERR_CAMERA_PARAMS_ADJUST_FAIL;
        } catch (...) {
            printf("Unknown Exception in Stitching_stitch\n");
            return (int)Stitcher::ERR_CAMERA_PARAMS_ADJUST_FAIL;
        }
    }

}
