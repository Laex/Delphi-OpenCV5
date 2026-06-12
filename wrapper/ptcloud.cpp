#include <opencv2/opencv.hpp>
#include <opencv2/ptcloud.hpp>
using namespace cv;
using namespace std;

static Mat prepareVerticesForIO(const Mat& v) {
    if (v.empty()) return Mat();
    vector<Point3f> cloud;
    if (v.cols == 3 && (v.channels() == 1 || v.type() == CV_32FC3)) {
        for (int i = 0; i < v.rows; ++i)
            cloud.emplace_back(v.at<float>(i, 0), v.at<float>(i, 1), v.at<float>(i, 2));
    } else if (v.type() == CV_32FC3) {
        for (int i = 0; i < v.rows; ++i)
            cloud.push_back(v.at<Point3f>(i, 0));
        if (cloud.empty() && v.cols > 0) {
            for (int i = 0; i < v.cols; ++i)
                cloud.push_back(v.at<Point3f>(0, i));
        }
    } else if (v.channels() == 1 && v.cols % 3 == 0) {
        const int n = v.cols / 3;
        const float* p = v.ptr<float>(0);
        for (int i = 0; i < n; ++i)
            cloud.emplace_back(p[i * 3], p[i * 3 + 1], p[i * 3 + 2]);
    }
    if (cloud.empty()) return Mat();
    return Mat(cloud);
}

extern "C" {

    __declspec(dllexport) bool __stdcall Ptcloud_loadPointCloud(
        const char* filename, Mat* vertices, Mat* normals, Mat* rgb)
    {
        try {
            if (!filename || !vertices) return false;
            loadPointCloud(filename, *vertices,
                normals ? *normals : noArray(),
                rgb ? *rgb : noArray());
            return !vertices->empty();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Ptcloud_loadPointCloud: %s\n", e.what());
            return false;
        } catch (...) {
            return false;
        }
    }

    __declspec(dllexport) void __stdcall Ptcloud_savePointCloud(
        const char* filename, Mat* vertices, Mat* normals, Mat* rgb)
    {
        try {
            if (!filename || !vertices) return;
            Mat verts = prepareVerticesForIO(*vertices);
            if (verts.empty()) return;
            savePointCloud(filename, verts,
                normals ? *normals : noArray(),
                rgb ? *rgb : noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Ptcloud_savePointCloud: %s\n", e.what());
        } catch (...) {}
    }

}
