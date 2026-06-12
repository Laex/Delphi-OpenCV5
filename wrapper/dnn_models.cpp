#include <opencv2/opencv.hpp>
#include <opencv2/dnn.hpp>
using namespace cv;
using namespace cv::dnn;
using namespace std;

extern "C" void Core_setLastError(const char* msg);

extern "C" {

    struct DelphiClassificationModel { ClassificationModel* model; };
    struct DelphiSegmentationModel { SegmentationModel* model; };
    struct DelphiTextDetectionEAST { TextDetectionModel_EAST* model; };
    struct DelphiTextDetectionDB {
        TextDetectionModel_DB* model;
        Size inputSize;
    };

    static TextDetectionModel_DB* createTextDetectionDB(const char* modelPath) {
        const string path = modelPath ? modelPath : "";
        if (path.empty()) return nullptr;
        Net net = readNetFromONNX(path);
        if (net.empty()) return nullptr;
        auto* m = new TextDetectionModel_DB(net);
        m->setPreferableBackend(DNN_BACKEND_OPENCV);
        m->setPreferableTarget(DNN_TARGET_CPU);
        m->setBinaryThreshold(0.3f);
        m->setPolygonThreshold(0.5f);
        m->setMaxCandidates(200);
        m->setUnclipRatio(2.0);
        const Scalar mean(122.67891434, 116.66876762, 104.00698793);
        const Size defaultSize(736, 736);
        m->setInputScale(1.0 / 255.0);
        m->setInputMean(mean);
        m->setInputSize(defaultSize);
        m->setInputParams(1.0 / 255.0, defaultSize, mean);
        return m;
    }

    __declspec(dllexport) DelphiClassificationModel* __stdcall Dnn_ClassificationModel_Create(
        const char* modelPath, const char* configPath)
    {
        try {
            auto* h = new DelphiClassificationModel();
            h->model = new ClassificationModel(modelPath ? modelPath : "", configPath ? configPath : "");
            return h;
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            return nullptr;
        } catch (...) { return nullptr; }
    }

    __declspec(dllexport) void __stdcall Dnn_ClassificationModel_Destroy(DelphiClassificationModel* self) {
        if (self) {
            delete self->model;
            delete self;
        }
    }

    __declspec(dllexport) void __stdcall Dnn_ClassificationModel_setInputSize(
        DelphiClassificationModel* self, int w, int h)
    {
        if (self && self->model) self->model->setInputSize(Size(w, h));
    }

    __declspec(dllexport) int __stdcall Dnn_ClassificationModel_classify(
        DelphiClassificationModel* self, Mat* frame, int* classId, float* conf)
    {
        try {
            if (!self || !self->model || !frame || !classId || !conf) return 0;
            int id = 0;
            float c = 0.f;
            self->model->classify(*frame, id, c);
            *classId = id;
            *conf = c;
            return 1;
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            return -1;
        } catch (...) { return -1; }
    }

    __declspec(dllexport) DelphiSegmentationModel* __stdcall Dnn_SegmentationModel_Create(
        const char* modelPath, const char* configPath)
    {
        try {
            auto* h = new DelphiSegmentationModel();
            h->model = new SegmentationModel(modelPath ? modelPath : "", configPath ? configPath : "");
            return h;
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            return nullptr;
        } catch (...) { return nullptr; }
    }

    __declspec(dllexport) void __stdcall Dnn_SegmentationModel_Destroy(DelphiSegmentationModel* self) {
        if (self) {
            delete self->model;
            delete self;
        }
    }

    __declspec(dllexport) void __stdcall Dnn_SegmentationModel_setInputSize(
        DelphiSegmentationModel* self, int w, int h)
    {
        if (self && self->model) self->model->setInputSize(Size(w, h));
    }

    __declspec(dllexport) int __stdcall Dnn_SegmentationModel_segment(
        DelphiSegmentationModel* self, Mat* frame, Mat* mask)
    {
        try {
            if (!self || !self->model || !frame || !mask) return 0;
            self->model->segment(*frame, *mask);
            return 1;
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            return -1;
        } catch (...) { return -1; }
    }

    __declspec(dllexport) DelphiTextDetectionEAST* __stdcall Dnn_TextDetectionEAST_Create(
        const char* modelPath, const char* configPath)
    {
        try {
            auto* h = new DelphiTextDetectionEAST();
            h->model = new TextDetectionModel_EAST(modelPath ? modelPath : "", configPath ? configPath : "");
            return h;
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            return nullptr;
        } catch (...) { return nullptr; }
    }

    __declspec(dllexport) void __stdcall Dnn_TextDetectionEAST_Destroy(DelphiTextDetectionEAST* self) {
        if (self) {
            delete self->model;
            delete self;
        }
    }

    __declspec(dllexport) void __stdcall Dnn_TextDetectionEAST_setInputSize(
        DelphiTextDetectionEAST* self, int w, int h)
    {
        if (self && self->model) self->model->setInputSize(Size(w, h));
    }

    __declspec(dllexport) int __stdcall Dnn_TextDetectionEAST_detect(
        DelphiTextDetectionEAST* self, Mat* frame, Mat* boxes, Mat* confidences,
        float confThreshold, float nmsThreshold)
    {
        try {
            if (!self || !self->model || !frame || !boxes || !confidences) return 0;
            self->model->setConfidenceThreshold(confThreshold);
            self->model->setNMSThreshold(nmsThreshold);
            vector<RotatedRect> rects;
            vector<float> conf;
            self->model->detectTextRectangles(*frame, rects, conf);
            boxes->create((int)rects.size(), 5, CV_32F);
            for (int i = 0; i < (int)rects.size(); ++i) {
                boxes->at<float>(i, 0) = rects[i].center.x;
                boxes->at<float>(i, 1) = rects[i].center.y;
                boxes->at<float>(i, 2) = rects[i].size.width;
                boxes->at<float>(i, 3) = rects[i].size.height;
                boxes->at<float>(i, 4) = rects[i].angle;
            }
            confidences->create((int)conf.size(), 1, CV_32F);
            for (int i = 0; i < (int)conf.size(); ++i)
                confidences->at<float>(i, 0) = conf[i];
            return (int)rects.size();
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            return -1;
        } catch (...) { return -1; }
    }

    __declspec(dllexport) DelphiTextDetectionDB* __stdcall Dnn_TextDetectionDB_Create(
        const char* modelPath, const char* configPath)
    {
        (void)configPath;
        try {
            auto* h = new DelphiTextDetectionDB();
            h->model = createTextDetectionDB(modelPath);
            h->inputSize = Size(736, 736);
            if (!h->model) {
                delete h;
                Core_setLastError("Failed to load TextDetectionModel_DB (PPOCR ONNX)");
                return nullptr;
            }
            return h;
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            return nullptr;
        } catch (...) { return nullptr; }
    }

    __declspec(dllexport) void __stdcall Dnn_TextDetectionDB_Destroy(DelphiTextDetectionDB* self) {
        if (self) {
            delete self->model;
            delete self;
        }
    }

    __declspec(dllexport) void __stdcall Dnn_TextDetectionDB_setInputSize(
        DelphiTextDetectionDB* self, int w, int h)
    {
        if (!self || !self->model) return;
        int aw = ((w + 31) / 32) * 32;
        int ah = ((h + 31) / 32) * 32;
        if (aw < 32) aw = 32;
        if (ah < 32) ah = 32;
        self->inputSize = Size(aw, ah);
        const Scalar mean(122.67891434, 116.66876762, 104.00698793);
        self->model->setInputSize(self->inputSize);
        self->model->setInputParams(1.0 / 255.0, self->inputSize, mean);
    }

    __declspec(dllexport) int __stdcall Dnn_TextDetectionDB_detect(
        DelphiTextDetectionDB* self, Mat* frame, Mat* polygons, Mat* confidences,
        float confThreshold)
    {
        try {
            if (!self || !self->model || !frame || !polygons || !confidences) return 0;
            self->model->setBinaryThreshold(confThreshold);
            Mat input;
            if (frame->size() != self->inputSize)
                resize(*frame, input, self->inputSize);
            else
                input = *frame;
            vector<vector<Point>> polys;
            vector<float> conf;
            self->model->detect(input, polys, conf);
            const float sx = frame->cols > 0 ? (float)frame->cols / (float)self->inputSize.width : 1.f;
            const float sy = frame->rows > 0 ? (float)frame->rows / (float)self->inputSize.height : 1.f;
            const int n = (int)polys.size();
            polygons->create(n, 8, CV_32F);
            for (int i = 0; i < n; ++i) {
                const vector<Point>& p = polys[i];
                for (int k = 0; k < 4; ++k) {
                    const Point pt = (k < (int)p.size()) ? p[k] : Point(0, 0);
                    polygons->at<float>(i, k * 2) = (float)pt.x * sx;
                    polygons->at<float>(i, k * 2 + 1) = (float)pt.y * sy;
                }
            }
            confidences->create(n, 1, CV_32F);
            for (int i = 0; i < n; ++i)
                confidences->at<float>(i, 0) = conf[i];
            return n;
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            return -1;
        } catch (...) { return -1; }
    }

}
