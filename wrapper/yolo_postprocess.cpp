#include <opencv2/opencv.hpp>
#include <opencv2/dnn/dnn.hpp>
#include <algorithm>
#include <cctype>
#include <cmath>
#include <vector>
#include "yolo_postprocess.h"

using namespace cv;
using namespace cv::dnn;

namespace {

enum YoloFormat { YOLO_V5, YOLO_V8, YOLO_X };

static YoloFormat toInternal(YoloPostprocessFormat fmt) {
    switch (fmt) {
    case YOLO_FMT_V5: return YOLO_V5;
    case YOLO_FMT_V8: return YOLO_V8;
    default: return YOLO_X;
    }
}

static void yoloPostprocess(const Mat& out, YoloFormat fmt, int inputSize,
    float confTh, float nmsTh,
    std::vector<int>& classIds,
    std::vector<float>& confidences,
    std::vector<Rect2d>& boxes)
{
    CV_Assert(out.dims == 3);
    const bool hasObj = (fmt != YOLO_V8);
    const int nclasses = 80;
    const int stride = 4 + (hasObj ? 1 : 0) + nclasses;

    const float* data = nullptr;
    std::vector<float> buf;
    int N = 0;
    if (fmt == YOLO_V8) {
        const int C = out.size[1];
        N = out.size[2];
        CV_Assert(C == stride);
        const float* src = out.ptr<float>();
        buf.resize((size_t)N * C);
        for (int i = 0; i < C; ++i)
            for (int j = 0; j < N; ++j)
                buf[j * C + i] = src[i * N + j];
        data = buf.data();
    } else {
        N = out.size[1];
        CV_Assert(out.size[2] == stride);
        data = out.ptr<float>();
    }

    std::vector<float> gridX, gridY, strideVec;
    if (fmt == YOLO_X) {
        const int strides[] = {8, 16, 32};
        gridX.resize(N);
        gridY.resize(N);
        strideVec.resize(N);
        int idx = 0;
        for (int si = 0; si < 3; ++si) {
            const int gs = inputSize / strides[si];
            for (int y = 0; y < gs; ++y)
                for (int x = 0; x < gs; ++x) {
                    gridX[idx] = (float)x;
                    gridY[idx] = (float)y;
                    strideVec[idx] = (float)strides[si];
                    ++idx;
                }
        }
        CV_Assert(idx == N);
    }

    const int classOff = hasObj ? 5 : 4;
    const double scale = 1.0 / inputSize;
    std::vector<Rect> intBoxes;
    std::vector<int> allCls;
    std::vector<float> allConf;
    std::vector<Rect2d> allBoxes;

    for (int i = 0; i < N; ++i) {
        const float* r = data + (size_t)i * stride;
        const float obj = hasObj ? r[4] : 1.0f;
        if (obj < confTh)
            continue;

        int bestCls = 0;
        float bestScore = 0.f;
        for (int c = 0; c < nclasses; ++c) {
            const float s = r[classOff + c] * obj;
            if (s > bestScore) {
                bestScore = s;
                bestCls = c;
            }
        }
        if (bestScore < confTh)
            continue;

        float cx, cy, w, h;
        if (fmt == YOLO_X) {
            cx = (r[0] + gridX[i]) * strideVec[i];
            cy = (r[1] + gridY[i]) * strideVec[i];
            w = std::exp(r[2]) * strideVec[i];
            h = std::exp(r[3]) * strideVec[i];
        } else {
            cx = r[0];
            cy = r[1];
            w = r[2];
            h = r[3];
        }

        intBoxes.emplace_back((int)(cx - w / 2), (int)(cy - h / 2), (int)w, (int)h);
        allConf.push_back(bestScore);
        allCls.push_back(bestCls);
        allBoxes.emplace_back((cx - w / 2) * scale, (cy - h / 2) * scale, w * scale, h * scale);
    }

    std::vector<int> indices;
    NMSBoxes(intBoxes, allConf, confTh, nmsTh, indices);
    for (int idx : indices) {
        classIds.push_back(allCls[idx]);
        confidences.push_back(allConf[idx]);
        boxes.push_back(allBoxes[idx]);
    }
}

static Mat makeYoloBlob(const Mat& frame, int inputSize, YoloFormat fmt) {
    switch (fmt) {
    case YOLO_X:
        return blobFromImage(frame, 1.0, Size(inputSize, inputSize), Scalar(), false, false, CV_32F);
    case YOLO_V8:
        return blobFromImage(frame, 1.0 / 255.0, Size(inputSize, inputSize), Scalar(), true, false, CV_32F);
    default:
        return blobFromImage(frame, 1.0 / 255.0, Size(inputSize, inputSize), Scalar(), true, false, CV_32F);
    }
}

} // namespace

YoloPostprocessFormat yoloFormatFromModelPath(const char* modelPath) {
    const std::string path = modelPath ? modelPath : "";
    std::string lower = path;
    std::transform(lower.begin(), lower.end(), lower.begin(),
        [](unsigned char c) { return (char)std::tolower(c); });
    if (lower.find("yolox") != std::string::npos)
        return YOLO_FMT_X;
    if (lower.find("yolov8") != std::string::npos || lower.find("yolo_v8") != std::string::npos)
        return YOLO_FMT_V8;
    if (lower.find("yolov5") != std::string::npos || lower.find("yolo_v5") != std::string::npos)
        return YOLO_FMT_V5;
    return YOLO_FMT_X;
}

bool yoloDetect(Net& net, const Mat& frame, int inputSize,
    YoloPostprocessFormat fmt, float confThreshold, float nmsThreshold,
    std::vector<int>& classIds, std::vector<float>& confidences, std::vector<Rect>& boxes)
{
    classIds.clear();
    confidences.clear();
    boxes.clear();
    if (frame.empty() || inputSize <= 0)
        return false;

    const YoloFormat internal = toInternal(fmt);
    Mat blob = makeYoloBlob(frame, inputSize, internal);
    net.setInput(blob);
    Mat out = net.forward();
    if (out.type() != CV_32F)
        out.convertTo(out, CV_32F);

    std::vector<Rect2d> normBoxes;
    yoloPostprocess(out, internal, inputSize, confThreshold, nmsThreshold,
        classIds, confidences, normBoxes);

    const double fw = frame.cols;
    const double fh = frame.rows;
    boxes.resize(normBoxes.size());
    for (size_t i = 0; i < normBoxes.size(); ++i) {
        const Rect2d& b = normBoxes[i];
        boxes[i] = Rect(
            (int)std::round(b.x * fw),
            (int)std::round(b.y * fh),
            (int)std::round(b.width * fw),
            (int)std::round(b.height * fh));
    }
    return true;
}
