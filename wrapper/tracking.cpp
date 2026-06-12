#include <opencv2/opencv.hpp>

#include <opencv2/video/tracking.hpp>

using namespace cv;

using namespace std;



extern "C" {



    __declspec(dllexport) void __stdcall Tracking_CamShift(Mat* probImage, int* windowRect,

        TermCriteria* criteria, float* centerX, float* centerY, float* width, float* height, float* angle) {

        try {

            if (!probImage || !windowRect || !criteria) return;

            Rect win(windowRect[0], windowRect[1], windowRect[2], windowRect[3]);

            RotatedRect rr = CamShift(*probImage, win, *criteria);

            windowRect[0] = win.x;

            windowRect[1] = win.y;

            windowRect[2] = win.width;

            windowRect[3] = win.height;

            if (centerX) *centerX = rr.center.x;

            if (centerY) *centerY = rr.center.y;

            if (width) *width = rr.size.width;

            if (height) *height = rr.size.height;

            if (angle) *angle = rr.angle;

        } catch (const cv::Exception& e) {

            printf("OpenCV Exception in Tracking_CamShift: %s\n", e.what());

        } catch (...) {

        }

    }



    __declspec(dllexport) int __stdcall Tracking_meanShift(Mat* probImage, int* windowRect, TermCriteria* criteria) {

        try {

            if (!probImage || !windowRect || !criteria) return 0;

            Rect win(windowRect[0], windowRect[1], windowRect[2], windowRect[3]);

            int count = meanShift(*probImage, win, *criteria);

            windowRect[0] = win.x;

            windowRect[1] = win.y;

            windowRect[2] = win.width;

            windowRect[3] = win.height;

            return count;

        } catch (const cv::Exception& e) {

            printf("OpenCV Exception in Tracking_meanShift: %s\n", e.what());

            return -1;

        } catch (...) {

            return -1;

        }

    }



    struct DelphiKalman {

        KalmanFilter kf;

    };



    __declspec(dllexport) DelphiKalman* __stdcall Tracking_Kalman_Create(int dynamParams, int measureParams, int controlParams, int type) {

        try {

            auto* h = new DelphiKalman();

            h->kf = KalmanFilter(dynamParams, measureParams, controlParams, type);

            return h;

        } catch (...) {

            return nullptr;

        }

    }



    __declspec(dllexport) void __stdcall Tracking_Kalman_Destroy(DelphiKalman* self) {

        delete self;

    }



    __declspec(dllexport) Mat* __stdcall Tracking_Kalman_predict(DelphiKalman* self, Mat* control) {

        try {

            if (!self) return nullptr;

            return new Mat(self->kf.predict(control ? *control : Mat()));

        } catch (const cv::Exception& e) {

            printf("OpenCV Exception in Tracking_Kalman_predict: %s\n", e.what());

            return nullptr;

        } catch (...) {

            return nullptr;

        }

    }



    __declspec(dllexport) Mat* __stdcall Tracking_Kalman_correct(DelphiKalman* self, Mat* measurement) {

        try {

            if (!self || !measurement) return nullptr;

            return new Mat(self->kf.correct(*measurement));

        } catch (const cv::Exception& e) {

            printf("OpenCV Exception in Tracking_Kalman_correct: %s\n", e.what());

            return nullptr;

        } catch (...) {

            return nullptr;

        }

    }



    __declspec(dllexport) Mat* __stdcall Tracking_Kalman_get_state(DelphiKalman* self) {
        try {
            if (!self) return nullptr;
            return new Mat(self->kf.statePost.clone());
        } catch (...) {
            return nullptr;
        }
    }

    struct DelphiTrackerMIL {
        Ptr<TrackerMIL> tracker;
    };

    __declspec(dllexport) DelphiTrackerMIL* __stdcall Tracking_TrackerMIL_Create() {
        try {
            auto* h = new DelphiTrackerMIL();
            h->tracker = TrackerMIL::create();
            return h;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Tracking_TrackerMIL_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Tracking_TrackerMIL_Destroy(DelphiTrackerMIL* self) {
        delete self;
    }

    __declspec(dllexport) void __stdcall Tracking_TrackerMIL_init(
        DelphiTrackerMIL* self, Mat* image, int x, int y, int w, int h)
    {
        try {
            if (!self || !self->tracker || !image) return;
            self->tracker->init(*image, Rect(x, y, w, h));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Tracking_TrackerMIL_init: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) bool __stdcall Tracking_TrackerMIL_update(
        DelphiTrackerMIL* self, Mat* image, int* x, int* y, int* w, int* h)
    {
        try {
            if (!self || !self->tracker || !image) return false;
            Rect box;
            bool ok = self->tracker->update(*image, box);
            if (x) *x = box.x;
            if (y) *y = box.y;
            if (w) *w = box.width;
            if (h) *h = box.height;
            return ok;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Tracking_TrackerMIL_update: %s\n", e.what());
            return false;
        } catch (...) {
            return false;
        }
    }

    struct DelphiTrackerNano {
        Ptr<TrackerNano> tracker;
    };

    __declspec(dllexport) DelphiTrackerNano* __stdcall Tracking_TrackerNano_Create() {
        try {
            auto* h = new DelphiTrackerNano();
            h->tracker = TrackerNano::create();
            return h;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Tracking_TrackerNano_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Tracking_TrackerNano_Destroy(DelphiTrackerNano* self) {
        delete self;
    }

    __declspec(dllexport) void __stdcall Tracking_TrackerNano_init(
        DelphiTrackerNano* self, Mat* image, int x, int y, int w, int h)
    {
        try {
            if (!self || !self->tracker || !image) return;
            self->tracker->init(*image, Rect(x, y, w, h));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Tracking_TrackerNano_init: %s\n", e.what());
        } catch (...) {}
    }

    __declspec(dllexport) bool __stdcall Tracking_TrackerNano_update(
        DelphiTrackerNano* self, Mat* image, int* x, int* y, int* w, int* h)
    {
        try {
            if (!self || !self->tracker || !image) return false;
            Rect box;
            bool ok = self->tracker->update(*image, box);
            if (x) *x = box.x;
            if (y) *y = box.y;
            if (w) *w = box.width;
            if (h) *h = box.height;
            return ok;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Tracking_TrackerNano_update: %s\n", e.what());
            return false;
        } catch (...) {
            return false;
        }
    }

}

