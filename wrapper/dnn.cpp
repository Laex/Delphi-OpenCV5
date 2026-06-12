#include <opencv2/opencv.hpp>
#include <opencv2/dnn/dnn.hpp>
#include <algorithm>
#include <cctype>
#include "yolo_postprocess.h"
using namespace cv;
using namespace cv::dnn;
using namespace std;

extern "C" void Core_setLastError(const char* msg);

namespace {

static Net loadDetectionNet(const char* modelPath, const char* configPath) {
    const string path = modelPath ? modelPath : "";
    if (path.empty())
        return Net();
    string ext;
    if (path.size() >= 5)
        ext = path.substr(path.size() - 5);
    transform(ext.begin(), ext.end(), ext.begin(),
        [](unsigned char c) { return (char)tolower(c); });
    if (ext == ".onnx")
        return readNetFromONNX(path);
    return readNet(path, configPath ? configPath : "");
}

static void configureDetectionModel(DetectionModel& model) {
    model.setPreferableBackend(DNN_BACKEND_OPENCV);
    model.setPreferableTarget(DNN_TARGET_CPU);
    model.setInputScale(1.0 / 255.0);
    model.setInputMean(Scalar(0, 0, 0));
}

static bool isCustomYoloModelPath(const char* modelPath) {
    const string path = modelPath ? modelPath : "";
    string lower = path;
    transform(lower.begin(), lower.end(), lower.begin(),
        [](unsigned char c) { return (char)tolower(c); });
    return lower.find("yolox") != string::npos
        || lower.find("yolov5") != string::npos
        || lower.find("yolo_v5") != string::npos
        || lower.find("yolov8") != string::npos
        || lower.find("yolo_v8") != string::npos;
}

} // namespace

extern "C" {

    struct DelphiNet {
        cv::dnn::Net net;
    };

    __declspec(dllexport) DelphiNet* __stdcall Dnn_readNet(const char* model, const char* config) {
        auto* holder = new DelphiNet();
        try {
            holder->net = cv::dnn::readNet(model ? model : "", config ? config : "");
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Dnn_readNet: %s\n", e.what());
            holder->net = cv::dnn::Net();
        } catch (...) {
            printf("Unknown Exception in Dnn_readNet\n");
            holder->net = cv::dnn::Net();
        }
        return holder;
    }

    __declspec(dllexport) void __stdcall Dnn_Destroy(DelphiNet* self) {
        delete self;
    }

    __declspec(dllexport) bool __stdcall Dnn_empty(DelphiNet* self) {
        if (!self) return true;
        return self->net.empty();
    }

    __declspec(dllexport) void __stdcall Dnn_setPreferableBackend(DelphiNet* self, int backendId) {
        if (self) self->net.setPreferableBackend(backendId);
    }

    __declspec(dllexport) void __stdcall Dnn_setPreferableTarget(DelphiNet* self, int targetId) {
        if (self) self->net.setPreferableTarget(targetId);
    }

    __declspec(dllexport) void __stdcall Dnn_setInput(DelphiNet* self, Mat* blob, const char* name, double scale, Scalar* mean) {
        try {
            if (!self || !blob) return;
            Scalar m = mean ? *mean : Scalar();
            self->net.setInput(*blob, name ? name : "", scale, m);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Dnn_setInput: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Dnn_setInput\n");
        }
    }

    __declspec(dllexport) Mat* __stdcall Dnn_forward(DelphiNet* self, const char* outputName) {
        try {
            if (!self) return nullptr;
            Mat* out = new Mat();
            *out = self->net.forward(outputName ? outputName : "");
            return out;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Dnn_forward: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Dnn_forward\n");
            return nullptr;
        }
    }

    __declspec(dllexport) Mat* __stdcall Dnn_blobFromImage(
        Mat* image, double scalefactor, Size* size, Scalar* mean, bool swapRB, bool crop)
    {
        try {
            if (!image) return nullptr;
            Mat* out = new Mat();
            *out = dnn::blobFromImage(*image, scalefactor,
                size ? *size : Size(), mean ? *mean : Scalar(), swapRB, crop);
            return out;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Dnn_blobFromImage: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Dnn_blobFromImage\n");
            return nullptr;
        }
    }

    __declspec(dllexport) Mat* __stdcall Dnn_blobFromImages(
        Mat** images, int count, double scalefactor, Size* size, Scalar* mean, bool swapRB, bool crop)
    {
        try {
            if (!images || count <= 0) return nullptr;
            vector<Mat> imgs;
            imgs.reserve(count);
            for (int i = 0; i < count; ++i)
                if (images[i]) imgs.push_back(*images[i]);
            if (imgs.empty()) return nullptr;
            Mat* out = new Mat();
            *out = dnn::blobFromImages(imgs, scalefactor,
                size ? *size : Size(), mean ? *mean : Scalar(), swapRB, crop);
            return out;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Dnn_blobFromImages: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) DelphiNet* __stdcall Dnn_readNetFromONNX(const char* model) {
        auto* holder = new DelphiNet();
        try {
            holder->net = cv::dnn::readNetFromONNX(model ? model : "");
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Dnn_readNetFromONNX: %s\n", e.what());
            holder->net = cv::dnn::Net();
        } catch (...) {
            holder->net = cv::dnn::Net();
        }
        return holder;
    }

    __declspec(dllexport) int __stdcall Dnn_NMSBoxes(Mat* bboxes, Mat* scores,
        float scoreThreshold, float nmsThreshold, Mat* indices, float eta, int topK)
    {
        try {
            if (!bboxes || !scores || !indices) return 0;
            vector<Rect> boxes;
            vector<float> sc;
            for (int i = 0; i < bboxes->rows; ++i) {
                int x, y, w, h;
                if (bboxes->type() == CV_32FC1) {
                    x = (int)bboxes->at<float>(i, 0);
                    y = (int)bboxes->at<float>(i, 1);
                    w = (int)bboxes->at<float>(i, 2);
                    h = (int)bboxes->at<float>(i, 3);
                } else {
                    x = bboxes->at<int>(i, 0);
                    y = bboxes->at<int>(i, 1);
                    w = bboxes->at<int>(i, 2);
                    h = bboxes->at<int>(i, 3);
                }
                boxes.emplace_back(x, y, w, h);
            }
            for (int i = 0; i < scores->rows; ++i)
                sc.push_back(scores->at<float>(i, 0));
            vector<int> idx;
            dnn::NMSBoxes(boxes, sc, scoreThreshold, nmsThreshold, idx, eta, topK);
            indices->create((int)idx.size(), 1, CV_32S);
            for (int i = 0; i < (int)idx.size(); ++i)
                indices->at<int>(i, 0) = idx[i];
            return (int)idx.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Dnn_NMSBoxes: %s\n", e.what());
            return -1;
        } catch (...) {
            return -1;
        }
    }

    __declspec(dllexport) DelphiNet* __stdcall Dnn_readNetFromTensorflow(const char* model, const char* config) {
        auto* holder = new DelphiNet();
        try {
            holder->net = cv::dnn::readNetFromTensorflow(model ? model : "",
                config ? config : "");
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Dnn_readNetFromTensorflow: %s\n", e.what());
            holder->net = cv::dnn::Net();
        } catch (...) {
            holder->net = cv::dnn::Net();
        }
        return holder;
    }

    __declspec(dllexport) DelphiNet* __stdcall Dnn_readNetFromTFLite(const char* model, int engine) {
        auto* holder = new DelphiNet();
        try {
            holder->net = cv::dnn::readNetFromTFLite(String(model ? model : ""), engine);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Dnn_readNetFromTFLite: %s\n", e.what());
            holder->net = cv::dnn::Net();
        } catch (...) {
            holder->net = cv::dnn::Net();
        }
        return holder;
    }

    __declspec(dllexport) int __stdcall Dnn_getLayerNames(DelphiNet* self, char* buffer, int bufferSize) {
        if (!self || !buffer || bufferSize <= 0)
            return 0;
        try {
            vector<string> names = self->net.getLayerNames();
            int pos = 0;
            for (const auto& name : names) {
                int need = (int)name.size() + 1;
                if (pos + need >= bufferSize)
                    break;
                memcpy(buffer + pos, name.c_str(), name.size());
                buffer[pos + name.size()] = '\0';
                pos += need;
            }
            if (pos < bufferSize)
                buffer[pos] = '\0';
            return (int)names.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Dnn_getLayerNames: %s\n", e.what());
            return 0;
        } catch (...) {
            return 0;
        }
    }

    __declspec(dllexport) int __stdcall Dnn_softNMSBoxes(Mat* bboxes, Mat* scores, Mat* updatedScores,
        float scoreThreshold, float nmsThreshold, Mat* indices, int topK, float sigma, int method)
    {
        try {
            if (!bboxes || !scores || !updatedScores || !indices) return 0;
            vector<Rect> boxes;
            vector<float> sc;
            for (int i = 0; i < bboxes->rows; ++i) {
                int x, y, w, h;
                if (bboxes->type() == CV_32FC1) {
                    x = (int)bboxes->at<float>(i, 0);
                    y = (int)bboxes->at<float>(i, 1);
                    w = (int)bboxes->at<float>(i, 2);
                    h = (int)bboxes->at<float>(i, 3);
                } else {
                    x = bboxes->at<int>(i, 0);
                    y = bboxes->at<int>(i, 1);
                    w = bboxes->at<int>(i, 2);
                    h = bboxes->at<int>(i, 3);
                }
                boxes.emplace_back(x, y, w, h);
            }
            for (int i = 0; i < scores->rows; ++i)
                sc.push_back(scores->at<float>(i, 0));
            vector<float> updated;
            vector<int> idx;
            dnn::softNMSBoxes(boxes, sc, updated, scoreThreshold, nmsThreshold, idx,
                (size_t)topK, sigma, (dnn::SoftNMSMethod)method);
            updatedScores->create((int)updated.size(), 1, CV_32F);
            for (int i = 0; i < (int)updated.size(); ++i)
                updatedScores->at<float>(i, 0) = updated[i];
            indices->create((int)idx.size(), 1, CV_32S);
            for (int i = 0; i < (int)idx.size(); ++i)
                indices->at<int>(i, 0) = idx[i];
            return (int)idx.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Dnn_softNMSBoxes: %s\n", e.what());
            return -1;
        } catch (...) {
            return -1;
        }
    }

    __declspec(dllexport) int64_t __stdcall Dnn_getPerfProfile(DelphiNet* self, Mat* timingsOut) {
        try {
            if (!self || !timingsOut) return 0;
            vector<double> timings;
            int64_t t = self->net.getPerfProfile(timings);
            timingsOut->create((int)timings.size(), 1, CV_64F);
            for (int i = 0; i < (int)timings.size(); ++i)
                timingsOut->at<double>(i, 0) = timings[i];
            return t;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Dnn_getPerfProfile: %s\n", e.what());
            return 0;
        } catch (...) {
            return 0;
        }
    }

    __declspec(dllexport) int __stdcall Dnn_forwardMulti(DelphiNet* self, const char** outputNames,
        int nameCount, Mat** outputMats, int maxOutputs)
    {
        try {
            if (!self || !outputNames || nameCount <= 0 || !outputMats || maxOutputs <= 0)
                return 0;
            vector<string> names;
            names.reserve(nameCount);
            for (int i = 0; i < nameCount; ++i)
                if (outputNames[i]) names.emplace_back(outputNames[i]);
            if (names.empty()) return 0;
            vector<Mat> blobs;
            self->net.forward(blobs, names);
            int count = min((int)blobs.size(), maxOutputs);
            for (int i = 0; i < count; ++i) {
                if (outputMats[i])
                    *outputMats[i] = blobs[i];
            }
            return count;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Dnn_forwardMulti: %s\n", e.what());
            return -1;
        } catch (...) {
            return -1;
        }
    }

    struct DelphiDetectionModel {
        bool yoloCustomMode;
        YoloPostprocessFormat yoloFmt;
        int inputWidth;
        int inputHeight;
        Net yoloNet;
        DetectionModel model;
    };

    __declspec(dllexport) DelphiDetectionModel* __stdcall Dnn_DetectionModel_Create(
        const char* modelPath, const char* configPath)
    {
        try {
            if (isCustomYoloModelPath(modelPath)) {
                Net net = loadDetectionNet(modelPath, configPath);
                if (net.empty()) {
                    Core_setLastError("Failed to load custom YOLO ONNX network");
                    return nullptr;
                }
                net.setPreferableBackend(DNN_BACKEND_OPENCV);
                net.setPreferableTarget(DNN_TARGET_CPU);
                auto* holder = new DelphiDetectionModel();
                holder->yoloCustomMode = true;
                holder->yoloFmt = yoloFormatFromModelPath(modelPath);
                holder->inputWidth = 640;
                holder->inputHeight = 640;
                holder->yoloNet = net;
                return holder;
            }
            auto* holder = new DelphiDetectionModel();
            holder->yoloCustomMode = false;
            holder->yoloFmt = YOLO_FMT_X;
            holder->inputWidth = 0;
            holder->inputHeight = 0;
            holder->model = DetectionModel(
                modelPath ? modelPath : "",
                configPath ? configPath : "");
            configureDetectionModel(holder->model);
            return holder;
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            printf("OpenCV Exception in Dnn_DetectionModel_Create: %s\n", e.what());
            return nullptr;
        } catch (const std::exception& e) {
            Core_setLastError(e.what());
            printf("Exception in Dnn_DetectionModel_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            Core_setLastError("Unknown exception in Dnn_DetectionModel_Create");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Dnn_DetectionModel_Destroy(DelphiDetectionModel* self) {
        delete self;
    }

    __declspec(dllexport) void __stdcall Dnn_DetectionModel_setInputSize(
        DelphiDetectionModel* self, int width, int height)
    {
        if (!self) return;
        if (self->yoloCustomMode) {
            self->inputWidth = width;
            self->inputHeight = height;
        } else {
            self->model.setInputSize(width, height);
        }
    }

    __declspec(dllexport) int __stdcall Dnn_DetectionModel_detect(
        DelphiDetectionModel* self, Mat* frame, Mat* classIds, Mat* confidences, Mat* boxes,
        float confThreshold, float nmsThreshold)
    {
        try {
            if (!self || !frame || !classIds || !confidences || !boxes) return 0;
            vector<int> ids;
            vector<float> conf;
            vector<Rect> rects;
            if (self->yoloCustomMode) {
                const int sz = self->inputWidth > 0 ? self->inputWidth : 640;
                if (!yoloDetect(self->yoloNet, *frame, sz, self->yoloFmt,
                        confThreshold, nmsThreshold, ids, conf, rects))
                    return 0;
            } else {
                self->model.detect(*frame, ids, conf, rects, confThreshold, nmsThreshold);
            }
            classIds->create((int)ids.size(), 1, CV_32S);
            for (int i = 0; i < (int)ids.size(); ++i)
                classIds->at<int>(i, 0) = ids[i];
            confidences->create((int)conf.size(), 1, CV_32F);
            for (int i = 0; i < (int)conf.size(); ++i)
                confidences->at<float>(i, 0) = conf[i];
            boxes->create((int)rects.size(), 4, CV_32S);
            for (int i = 0; i < (int)rects.size(); ++i) {
                boxes->at<int>(i, 0) = rects[i].x;
                boxes->at<int>(i, 1) = rects[i].y;
                boxes->at<int>(i, 2) = rects[i].width;
                boxes->at<int>(i, 3) = rects[i].height;
            }
            return (int)ids.size();
        } catch (const cv::Exception& e) {
            Core_setLastError(e.what());
            printf("OpenCV Exception in Dnn_DetectionModel_detect: %s\n", e.what());
            return -1;
        } catch (...) {
            return -1;
        }
    }

    __declspec(dllexport) int __stdcall Dnn_getUnconnectedOutLayersNames(DelphiNet* self, char* buffer, int bufferSize) {
        if (!self || !buffer || bufferSize <= 0)
            return 0;
        try {
            vector<string> names = self->net.getUnconnectedOutLayersNames();
            int pos = 0;
            for (const auto& name : names) {
                int need = (int)name.size() + 1;
                if (pos + need >= bufferSize)
                    break;
                memcpy(buffer + pos, name.c_str(), name.size());
                buffer[pos + name.size()] = '\0';
                pos += need;
            }
            if (pos < bufferSize)
                buffer[pos] = '\0';
            return (int)names.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Dnn_getUnconnectedOutLayersNames: %s\n", e.what());
            return 0;
        } catch (...) {
            return 0;
        }
    }

}
