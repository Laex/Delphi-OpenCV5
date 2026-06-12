#pragma once

#include <opencv2/opencv.hpp>
#include <opencv2/dnn/dnn.hpp>
#include <vector>

enum YoloPostprocessFormat {
    YOLO_FMT_X = 0,
    YOLO_FMT_V5 = 1,
    YOLO_FMT_V8 = 2
};

YoloPostprocessFormat yoloFormatFromModelPath(const char* modelPath);

bool yoloDetect(cv::dnn::Net& net, const cv::Mat& frame, int inputSize,
    YoloPostprocessFormat fmt, float confThreshold, float nmsThreshold,
    std::vector<int>& classIds, std::vector<float>& confidences, std::vector<cv::Rect>& boxes);
