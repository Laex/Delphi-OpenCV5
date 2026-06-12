#include <opencv2/opencv.hpp>
#include <opencv2/calib.hpp>
#include <opencv2/geometry/3d.hpp>
using namespace cv;
using namespace std;

static vector<Point3f> matToPoint3fVector(Mat* m) {
    vector<Point3f> pts;
    if (!m || m->empty()) return pts;
    int n = m->checkVector(3, CV_32F);
    if (n > 0) {
        pts.resize(n);
        const Point3f* p = m->ptr<Point3f>(0);
        for (int i = 0; i < n; ++i)
            pts[i] = p[i];
        return pts;
    }
    Mat flat = m->reshape(1, m->rows);
    pts.resize(flat.rows);
    for (int i = 0; i < flat.rows; ++i)
        pts[i] = Point3f(flat.at<float>(i, 0), flat.at<float>(i, 1), flat.at<float>(i, 2));
    return pts;
}

static vector<Point2f> matToPoint2fVector(Mat* m) {
    vector<Point2f> pts;
    if (!m || m->empty()) return pts;
    if (m->cols == 2 && m->depth() == CV_32F) {
        pts.resize(m->rows);
        for (int i = 0; i < m->rows; ++i)
            pts[i] = Point2f(m->at<float>(i, 0), m->at<float>(i, 1));
        return pts;
    }
    if (m->channels() == 2 && m->depth() == CV_32F) {
        pts.resize(m->rows * m->cols);
        int idx = 0;
        for (int i = 0; i < m->rows; ++i) {
            const float* p = m->ptr<float>(i);
            for (int j = 0; j < m->cols; ++j) {
                pts[idx++] = Point2f(p[j * 2], p[j * 2 + 1]);
            }
        }
        return pts;
    }
    int n = m->checkVector(2, CV_32F);
    if (n <= 0) return pts;
    pts.resize(n);
    const Point2f* p = m->ptr<Point2f>(0);
    for (int i = 0; i < n; ++i)
        pts[i] = p[i];
    return pts;
}

extern "C" {

    __declspec(dllexport) double __stdcall Calib3d_calibrateCamera(
        Mat** objectPointsViews, Mat** imagePointsViews, int viewCount,
        Size* imageSize, Mat* cameraMatrix, Mat* distCoeffs,
        Mat* rvecsOut, Mat* tvecsOut, int flags, TermCriteria* criteria)
    {
        try {
            if (!objectPointsViews || !imagePointsViews || viewCount <= 0 || !imageSize ||
                !cameraMatrix || !distCoeffs)
                return -1.0;

            vector<vector<Point3f>> objectPoints;
            vector<vector<Point2f>> imagePoints;
            objectPoints.reserve(viewCount);
            imagePoints.reserve(viewCount);

            for (int i = 0; i < viewCount; ++i) {
                objectPoints.push_back(matToPoint3fVector(objectPointsViews[i]));
                imagePoints.push_back(matToPoint2fVector(imagePointsViews[i]));
            }

            vector<Mat> rvecs, tvecs;
            TermCriteria crit = criteria ? *criteria
                : TermCriteria(TermCriteria::COUNT + TermCriteria::EPS, 30, DBL_EPSILON);

            double err = calibrateCamera(objectPoints, imagePoints, *imageSize,
                *cameraMatrix, *distCoeffs, rvecs, tvecs, flags, crit);

            if (rvecsOut) {
                rvecsOut->create((int)rvecs.size(), 3, CV_64F);
                for (int i = 0; i < (int)rvecs.size(); ++i)
                    for (int j = 0; j < 3; ++j)
                        rvecsOut->at<double>(i, j) = rvecs[i].at<double>(j, 0);
            }
            if (tvecsOut) {
                tvecsOut->create((int)tvecs.size(), 3, CV_64F);
                for (int i = 0; i < (int)tvecs.size(); ++i)
                    for (int j = 0; j < 3; ++j)
                        tvecsOut->at<double>(i, j) = tvecs[i].at<double>(j, 0);
            }
            return err;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_calibrateCamera: %s\n", e.what());
            return -1.0;
        } catch (...) {
            printf("Unknown Exception in Calib3d_calibrateCamera\n");
            return -1.0;
        }
    }

    __declspec(dllexport) void __stdcall Calib3d_projectPoints(
        Mat* objectPoints, Mat* rvec, Mat* tvec,
        Mat* cameraMatrix, Mat* distCoeffs, Mat* imagePoints)
    {
        try {
            if (!objectPoints || !rvec || !tvec || !cameraMatrix || !distCoeffs || !imagePoints)
                return;

            vector<Point3f> objPts = matToPoint3fVector(objectPoints);
            if (objPts.empty())
                return;

            vector<Point2f> imgPts;
            projectPoints(objPts, *rvec, *tvec, *cameraMatrix, *distCoeffs, imgPts);

            if (imagePoints->rows != (int)imgPts.size() || imagePoints->type() != CV_32FC2)
                imagePoints->create((int)imgPts.size(), 1, CV_32FC2);
            for (int i = 0; i < (int)imgPts.size(); ++i)
                imagePoints->at<Point2f>(i, 0) = imgPts[i];
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_projectPoints: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Calib3d_projectPoints\n");
        }
    }

    __declspec(dllexport) Mat* __stdcall Calib3d_initCameraMatrix2D(
        Mat** objectPointsViews, Mat** imagePointsViews, int viewCount,
        Size* imageSize, double aspectRatio)
    {
        try {
            if (!objectPointsViews || !imagePointsViews || viewCount <= 0 || !imageSize)
                return nullptr;
            vector<vector<Point3f>> objectPoints;
            vector<vector<Point2f>> imagePoints;
            for (int i = 0; i < viewCount; ++i) {
                objectPoints.push_back(matToPoint3fVector(objectPointsViews[i]));
                imagePoints.push_back(matToPoint2fVector(imagePointsViews[i]));
            }
            Mat k = initCameraMatrix2D(objectPoints, imagePoints, *imageSize, aspectRatio);
            return new Mat(k);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_initCameraMatrix2D: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Calib3d_initCameraMatrix2D\n");
            return nullptr;
        }
    }

    __declspec(dllexport) bool __stdcall Calib3d_solvePnP(
        Mat* objectPoints, Mat* imagePoints, Mat* cameraMatrix, Mat* distCoeffs,
        Mat* rvec, Mat* tvec, bool useExtrinsicGuess, int flags)
    {
        try {
            if (!objectPoints || !imagePoints || !cameraMatrix || !distCoeffs || !rvec || !tvec)
                return false;
            vector<Point3f> objPts = matToPoint3fVector(objectPoints);
            vector<Point2f> imgPts = matToPoint2fVector(imagePoints);
            return solvePnP(objPts, imgPts, *cameraMatrix, *distCoeffs, *rvec, *tvec, useExtrinsicGuess, flags);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_solvePnP: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Calib3d_solvePnP\n");
            return false;
        }
    }

    __declspec(dllexport) void __stdcall Calib3d_undistortPoints(
        Mat* distorted, Mat* undistorted, Mat* cameraMatrix, Mat* distCoeffs,
        Mat* R, Mat* P)
    {
        try {
            if (!distorted || !undistorted || !cameraMatrix || !distCoeffs)
                return;
            undistortPoints(*distorted, *undistorted, *cameraMatrix, *distCoeffs,
                R ? *R : noArray(), P ? *P : noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_undistortPoints: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Calib3d_undistortPoints\n");
        }
    }

    __declspec(dllexport) Mat* __stdcall Calib3d_findHomography(Mat* srcPoints, Mat* dstPoints,
        int method, double ransacReprojThreshold, Mat* mask)
    {
        try {
            if (!srcPoints || !dstPoints) return nullptr;
            vector<Point2f> src = matToPoint2fVector(srcPoints);
            vector<Point2f> dst = matToPoint2fVector(dstPoints);
            if (src.size() < 4 || dst.size() < 4)
                return new Mat();
            Mat m = findHomography(src, dst, method, ransacReprojThreshold,
                mask ? *mask : noArray());
            return new Mat(m);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_findHomography: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Calib3d_Rodrigues(Mat* src, Mat* dst, Mat* jacobian)
    {
        try {
            if (!src || !dst) return;
            Rodrigues(*src, *dst, jacobian ? *jacobian : noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_Rodrigues: %s\n", e.what());
        } catch (...) {
        }
    }

    __declspec(dllexport) bool __stdcall Calib3d_solvePnPRansac(
        Mat* objectPoints, Mat* imagePoints, Mat* cameraMatrix, Mat* distCoeffs,
        Mat* rvec, Mat* tvec, bool useExtrinsicGuess, int iterationsCount,
        float reprojectionError, double confidence, Mat* inliers, int flags)
    {
        try {
            if (!objectPoints || !imagePoints || !cameraMatrix || !distCoeffs || !rvec || !tvec)
                return false;
            vector<Point3f> objPts = matToPoint3fVector(objectPoints);
            vector<Point2f> imgPts = matToPoint2fVector(imagePoints);
            return solvePnPRansac(objPts, imgPts, *cameraMatrix, *distCoeffs, *rvec, *tvec,
                useExtrinsicGuess, iterationsCount, reprojectionError, confidence,
                inliers ? *inliers : noArray(), flags);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_solvePnPRansac: %s\n", e.what());
            return false;
        } catch (...) {
            return false;
        }
    }

    __declspec(dllexport) double __stdcall Calib3d_stereoCalibrate(
        Mat* objectPoints, Mat* imagePoints1, Mat* imagePoints2,
        Mat* cameraMatrix1, Mat* distCoeffs1, Mat* cameraMatrix2, Mat* distCoeffs2,
        Size* imageSize, Mat* R, Mat* T, Mat* E, Mat* F, int flags, TermCriteria* criteria)
    {
        try {
            if (!objectPoints || !imagePoints1 || !imagePoints2 || !cameraMatrix1 ||
                !distCoeffs1 || !cameraMatrix2 || !distCoeffs2 || !imageSize || !R || !T || !E || !F)
                return -1.0;
            vector<Point3f> obj = matToPoint3fVector(objectPoints);
            vector<Point2f> img1 = matToPoint2fVector(imagePoints1);
            vector<Point2f> img2 = matToPoint2fVector(imagePoints2);
            vector<vector<Point3f>> objViews = { obj };
            vector<vector<Point2f>> img1Views = { img1 };
            vector<vector<Point2f>> img2Views = { img2 };
            TermCriteria crit = criteria ? *criteria
                : TermCriteria(TermCriteria::COUNT + TermCriteria::EPS, 30, 1e-6);
            return stereoCalibrate(objViews, img1Views, img2Views, *cameraMatrix1, *distCoeffs1,
                *cameraMatrix2, *distCoeffs2, *imageSize, *R, *T, *E, *F, flags, crit);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_stereoCalibrate: %s\n", e.what());
            return -1.0;
        } catch (...) {
            return -1.0;
        }
    }

    __declspec(dllexport) int __stdcall Calib3d_recoverPose(
        Mat* points1, Mat* points2, Mat* cameraMatrix1, Mat* distCoeffs1,
        Mat* cameraMatrix2, Mat* distCoeffs2, Mat* E, Mat* R, Mat* T,
        int method, double prob, double threshold, Mat* mask)
    {
        try {
            if (!points1 || !points2 || !cameraMatrix1 || !distCoeffs1 ||
                !cameraMatrix2 || !distCoeffs2 || !E || !R || !T)
                return 0;
            vector<Point2f> pts1 = matToPoint2fVector(points1);
            vector<Point2f> pts2 = matToPoint2fVector(points2);
            if (pts1.size() < 5 || pts2.size() < 5)
                return 0;
            return recoverPose(pts1, pts2, *cameraMatrix1, *distCoeffs1,
                *cameraMatrix2, *distCoeffs2, *E, *R, *T, method, prob, threshold,
                mask ? *mask : noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_recoverPose: %s\n", e.what());
            return 0;
        } catch (...) {
            return 0;
        }
    }

    __declspec(dllexport) void __stdcall Calib3d_triangulatePoints(
        Mat* projMatr1, Mat* projMatr2, Mat* projPoints1, Mat* projPoints2, Mat* points4D)
    {
        try {
            if (!projMatr1 || !projMatr2 || !projPoints1 || !projPoints2 || !points4D)
                return;
            vector<Point2f> pts1 = matToPoint2fVector(projPoints1);
            vector<Point2f> pts2 = matToPoint2fVector(projPoints2);
            if (pts1.empty() || pts2.empty())
                return;
            triangulatePoints(*projMatr1, *projMatr2, pts1, pts2, *points4D);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_triangulatePoints: %s\n", e.what());
        } catch (...) {
        }
    }

    __declspec(dllexport) Mat* __stdcall Calib3d_estimateAffine2D(
        Mat* from, Mat* to, Mat* inliers, int method, double ransacReprojThreshold,
        int maxIters, double confidence, int refineIters)
    {
        try {
            if (!from || !to) return nullptr;
            vector<Point2f> src = matToPoint2fVector(from);
            vector<Point2f> dst = matToPoint2fVector(to);
            if (src.size() < 3 || dst.size() < 3)
                return new Mat();
            Mat m = estimateAffine2D(src, dst, inliers ? *inliers : noArray(),
                method, ransacReprojThreshold, (size_t)maxIters, confidence, (size_t)refineIters);
            return new Mat(m);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_estimateAffine2D: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) Mat* __stdcall Calib3d_estimateAffinePartial2D(
        Mat* from, Mat* to, Mat* inliers, int method, double ransacReprojThreshold,
        int maxIters, double confidence, int refineIters)
    {
        try {
            if (!from || !to) return nullptr;
            vector<Point2f> src = matToPoint2fVector(from);
            vector<Point2f> dst = matToPoint2fVector(to);
            if (src.size() < 3 || dst.size() < 3)
                return new Mat();
            Mat m = estimateAffinePartial2D(src, dst, inliers ? *inliers : noArray(),
                method, ransacReprojThreshold, (size_t)maxIters, confidence, (size_t)refineIters);
            return new Mat(m);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_estimateAffinePartial2D: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) Mat* __stdcall Calib3d_findFundamentalMat(
        Mat* points1, Mat* points2, int method, double ransacReprojThreshold,
        double confidence, Mat* mask)
    {
        try {
            if (!points1 || !points2) return nullptr;
            vector<Point2f> pts1 = matToPoint2fVector(points1);
            vector<Point2f> pts2 = matToPoint2fVector(points2);
            if (pts1.size() < 7 || pts2.size() < 7)
                return new Mat();
            Mat f = findFundamentalMat(pts1, pts2, method, ransacReprojThreshold,
                confidence, mask ? *mask : noArray());
            return new Mat(f);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_findFundamentalMat: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) Mat* __stdcall Calib3d_findEssentialMat(
        Mat* points1, Mat* points2, Mat* cameraMatrix, int method,
        double prob, double threshold, Mat* mask)
    {
        try {
            if (!points1 || !points2 || !cameraMatrix) return nullptr;
            vector<Point2f> pts1 = matToPoint2fVector(points1);
            vector<Point2f> pts2 = matToPoint2fVector(points2);
            if (pts1.size() < 5 || pts2.size() < 5)
                return new Mat();
            Mat e = findEssentialMat(pts1, pts2, *cameraMatrix, method, prob, threshold, 1000,
                mask ? *mask : noArray());
            return new Mat(e);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_findEssentialMat: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Calib3d_decomposeEssentialMat(
        Mat* E, Mat* R1, Mat* R2, Mat* t)
    {
        try {
            if (!E || !R1 || !R2 || !t) return;
            decomposeEssentialMat(*E, *R1, *R2, *t);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Calib3d_decomposeEssentialMat: %s\n", e.what());
        } catch (...) {}
    }

}
