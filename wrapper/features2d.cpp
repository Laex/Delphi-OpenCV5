#include <opencv2/opencv.hpp>
#include <opencv2/features.hpp>
using namespace cv;
using namespace std;

extern "C" {

    static void keypointsToMat(const vector<KeyPoint>& kps, Mat& out) {
        out.create((int)kps.size(), 7, CV_32F);
        for (int i = 0; i < (int)kps.size(); ++i) {
            out.at<float>(i, 0) = kps[i].pt.x;
            out.at<float>(i, 1) = kps[i].pt.y;
            out.at<float>(i, 2) = kps[i].size;
            out.at<float>(i, 3) = kps[i].angle;
            out.at<float>(i, 4) = kps[i].response;
            out.at<float>(i, 5) = (float)kps[i].octave;
            out.at<float>(i, 6) = (float)kps[i].class_id;
        }
    }

    static void matToKeypoints(Mat* m, vector<KeyPoint>& kps) {
        kps.clear();
        if (!m || m->empty()) return;
        kps.resize(m->rows);
        for (int i = 0; i < m->rows; ++i) {
            kps[i].pt.x = m->at<float>(i, 0);
            kps[i].pt.y = m->at<float>(i, 1);
            if (m->cols > 2) kps[i].size = m->at<float>(i, 2);
            if (m->cols > 3) kps[i].angle = m->at<float>(i, 3);
            if (m->cols > 4) kps[i].response = m->at<float>(i, 4);
            if (m->cols > 5) kps[i].octave = (int)m->at<float>(i, 5);
            if (m->cols > 6) kps[i].class_id = (int)m->at<float>(i, 6);
        }
    }

    static void matToMatches(Mat* m, vector<DMatch>& dm) {
        dm.clear();
        if (!m || m->empty()) return;
        dm.resize(m->rows);
        for (int i = 0; i < m->rows; ++i) {
            dm[i].queryIdx = (int)m->at<float>(i, 0);
            dm[i].trainIdx = (int)m->at<float>(i, 1);
            dm[i].imgIdx = (int)m->at<float>(i, 2);
            dm[i].distance = m->at<float>(i, 3);
        }
    }

    static void matchesToMat(const vector<DMatch>& matches, Mat& out) {
        out.create((int)matches.size(), 4, CV_32F);
        for (int i = 0; i < (int)matches.size(); ++i) {
            out.at<float>(i, 0) = (float)matches[i].queryIdx;
            out.at<float>(i, 1) = (float)matches[i].trainIdx;
            out.at<float>(i, 2) = (float)matches[i].imgIdx;
            out.at<float>(i, 3) = matches[i].distance;
        }
    }

    struct DelphiORB {
        Ptr<ORB> orb;
    };

    __declspec(dllexport) DelphiORB* __stdcall Features2d_ORB_Create(int nfeatures) {
        try {
            auto* holder = new DelphiORB();
            holder->orb = ORB::create(nfeatures);
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_ORB_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Features2d_ORB_Create\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Features2d_ORB_Destroy(DelphiORB* self) {
        delete self;
    }

    __declspec(dllexport) int __stdcall Features2d_ORB_detectAndCompute(
        DelphiORB* self, Mat* image, Mat* mask, Mat* keypoints, Mat* descriptors)
    {
        try {
            if (!self || !self->orb || !image || !keypoints || !descriptors)
                return 0;
            vector<KeyPoint> kps;
            self->orb->detectAndCompute(*image, mask ? *mask : noArray(), kps, *descriptors);
            keypointsToMat(kps, *keypoints);
            return (int)kps.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_ORB_detectAndCompute: %s\n", e.what());
            return -1;
        } catch (...) {
            printf("Unknown Exception in Features2d_ORB_detectAndCompute\n");
            return -1;
        }
    }

    __declspec(dllexport) void __stdcall Features2d_goodFeaturesToTrack(
        Mat* image, Mat* corners, int maxCorners, double qualityLevel,
        double minDistance, Mat* mask, int blockSize, bool useHarris, double k)
    {
        try {
            if (!image || !corners)
                return;
            goodFeaturesToTrack(*image, *corners, maxCorners, qualityLevel, minDistance,
                mask ? *mask : noArray(), blockSize, useHarris, k);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_goodFeaturesToTrack: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Features2d_goodFeaturesToTrack\n");
        }
    }

    struct DelphiBFMatcher {
        Ptr<BFMatcher> matcher;
    };

    __declspec(dllexport) DelphiBFMatcher* __stdcall Features2d_BFMatcher_Create(int normType, bool crossCheck) {
        try {
            auto* holder = new DelphiBFMatcher();
            holder->matcher = BFMatcher::create(normType, crossCheck);
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_BFMatcher_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Features2d_BFMatcher_Create\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Features2d_BFMatcher_Destroy(DelphiBFMatcher* self) {
        delete self;
    }

    __declspec(dllexport) int __stdcall Features2d_BFMatcher_match(
        DelphiBFMatcher* self, Mat* queryDescriptors, Mat* trainDescriptors, Mat* matches)
    {
        try {
            if (!self || !self->matcher || !queryDescriptors || !trainDescriptors || !matches)
                return 0;
            vector<DMatch> dm;
            self->matcher->match(*queryDescriptors, *trainDescriptors, dm);
            matchesToMat(dm, *matches);
            return (int)dm.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_BFMatcher_match: %s\n", e.what());
            return -1;
        } catch (...) {
            printf("Unknown Exception in Features2d_BFMatcher_match\n");
            return -1;
        }
    }

    __declspec(dllexport) int __stdcall Features2d_drawFeatureMatches(
        Mat* img1, Mat* img2, Mat* keypoints1, Mat* keypoints2, Mat* matches,
        Mat* outImg, int maxMatches)
    {
        try {
            if (!img1 || !img2 || !keypoints1 || !keypoints2 || !matches || !outImg)
                return 0;

            vector<KeyPoint> kps1, kps2;
            for (int i = 0; i < keypoints1->rows; ++i) {
                KeyPoint kp;
                kp.pt.x = keypoints1->at<float>(i, 0);
                kp.pt.y = keypoints1->at<float>(i, 1);
                kp.size = keypoints1->at<float>(i, 2);
                kps1.push_back(kp);
            }
            for (int i = 0; i < keypoints2->rows; ++i) {
                KeyPoint kp;
                kp.pt.x = keypoints2->at<float>(i, 0);
                kp.pt.y = keypoints2->at<float>(i, 1);
                kp.size = keypoints2->at<float>(i, 2);
                kps2.push_back(kp);
            }

            vector<DMatch> dm;
            for (int i = 0; i < matches->rows; ++i) {
                DMatch m;
                m.queryIdx = (int)matches->at<float>(i, 0);
                m.trainIdx = (int)matches->at<float>(i, 1);
                m.imgIdx = (int)matches->at<float>(i, 2);
                m.distance = matches->at<float>(i, 3);
                dm.push_back(m);
            }
            if (maxMatches > 0 && (int)dm.size() > maxMatches)
                dm.resize(maxMatches);

            Mat left, right;
            if (img1->channels() == 1)
                cvtColor(*img1, left, COLOR_GRAY2BGR);
            else
                left = img1->clone();
            if (img2->channels() == 1)
                cvtColor(*img2, right, COLOR_GRAY2BGR);
            else
                right = img2->clone();

            Mat canvas(left.rows, left.cols + right.cols, CV_8UC3);
            left.copyTo(canvas(Rect(0, 0, left.cols, left.rows)));
            right.copyTo(canvas(Rect(left.cols, 0, right.cols, right.rows)));

            Scalar lineColor(0, 255, 0);
            Scalar ptColor(0, 0, 255);
            int offsetX = left.cols;
            for (const auto& m : dm) {
                if (m.queryIdx < 0 || m.trainIdx < 0 ||
                    m.queryIdx >= (int)kps1.size() || m.trainIdx >= (int)kps2.size())
                    continue;
                Point2f p1 = kps1[m.queryIdx].pt;
                Point2f p2 = kps2[m.trainIdx].pt;
                p2.x += (float)offsetX;
                line(canvas, p1, p2, lineColor, 1, LINE_AA);
                circle(canvas, p1, 3, ptColor, FILLED, LINE_AA);
                circle(canvas, p2, 3, ptColor, FILLED, LINE_AA);
            }
            canvas.copyTo(*outImg);
            return (int)dm.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_drawFeatureMatches: %s\n", e.what());
            return -1;
        } catch (...) {
            printf("Unknown Exception in Features2d_drawFeatureMatches\n");
            return -1;
        }
    }

    struct DelphiFlannMatcher {
        Ptr<FlannBasedMatcher> matcher;
    };

    struct DelphiSIFT {
        Ptr<SIFT> sift;
    };

    __declspec(dllexport) DelphiSIFT* __stdcall Features2d_SIFT_Create(int nfeatures) {
        try {
            auto* holder = new DelphiSIFT();
            holder->sift = SIFT::create(nfeatures > 0 ? nfeatures : 0);
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_SIFT_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Features2d_SIFT_Destroy(DelphiSIFT* self) {
        delete self;
    }

    __declspec(dllexport) int __stdcall Features2d_SIFT_detectAndCompute(
        DelphiSIFT* self, Mat* image, Mat* mask, Mat* keypoints, Mat* descriptors)
    {
        try {
            if (!self || !self->sift || !image || !keypoints || !descriptors)
                return 0;
            vector<KeyPoint> kps;
            self->sift->detectAndCompute(*image, mask ? *mask : noArray(), kps, *descriptors);
            keypointsToMat(kps, *keypoints);
            return (int)kps.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_SIFT_detectAndCompute: %s\n", e.what());
            return -1;
        } catch (...) {
            return -1;
        }
    }

    __declspec(dllexport) DelphiFlannMatcher* __stdcall Features2d_FlannMatcher_Create(int indexParamsType) {
        (void)indexParamsType;
        try {
            auto* holder = new DelphiFlannMatcher();
            holder->matcher = FlannBasedMatcher::create();
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_FlannMatcher_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Features2d_FlannMatcher_Destroy(DelphiFlannMatcher* self) {
        delete self;
    }

    __declspec(dllexport) int __stdcall Features2d_FlannMatcher_match(
        DelphiFlannMatcher* self, Mat* queryDescriptors, Mat* trainDescriptors, Mat* matches)
    {
        try {
            if (!self || !self->matcher || !queryDescriptors || !trainDescriptors || !matches)
                return 0;
            vector<DMatch> dm;
            self->matcher->match(*queryDescriptors, *trainDescriptors, dm);
            matchesToMat(dm, *matches);
            return (int)dm.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_FlannMatcher_match: %s\n", e.what());
            return -1;
        } catch (...) {
            return -1;
        }
    }

    __declspec(dllexport) int __stdcall Features2d_BFMatcher_knnMatch(
        DelphiBFMatcher* self, Mat* queryDescriptors, Mat* trainDescriptors, Mat* matches, int k)
    {
        try {
            if (!self || !self->matcher || !queryDescriptors || !trainDescriptors || !matches || k <= 0)
                return 0;
            vector<vector<DMatch>> knn;
            self->matcher->knnMatch(*queryDescriptors, *trainDescriptors, knn, k);
            int total = 0;
            for (const auto& row : knn) total += (int)row.size();
            matches->create(total, 4, CV_32F);
            int idx = 0;
            for (const auto& row : knn) {
                for (const auto& m : row) {
                    matches->at<float>(idx, 0) = (float)m.queryIdx;
                    matches->at<float>(idx, 1) = (float)m.trainIdx;
                    matches->at<float>(idx, 2) = (float)m.imgIdx;
                    matches->at<float>(idx, 3) = m.distance;
                    ++idx;
                }
            }
            return total;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_BFMatcher_knnMatch: %s\n", e.what());
            return -1;
        } catch (...) {
            return -1;
        }
    }

    __declspec(dllexport) int __stdcall Features2d_filterMatchesByRatio(
        Mat* knnMatches, int k, float ratio, Mat* goodMatches)
    {
        try {
            if (!knnMatches || !goodMatches || k <= 1 || knnMatches->rows < k)
                return 0;
            int queries = knnMatches->rows / k;
            vector<DMatch> dm;
            for (int q = 0; q < queries; ++q) {
                float d1 = knnMatches->at<float>(q * k, 3);
                float d2 = knnMatches->at<float>(q * k + 1, 3);
                if (d2 > 1e-6f && d1 < ratio * d2) {
                    DMatch m;
                    m.queryIdx = (int)knnMatches->at<float>(q * k, 0);
                    m.trainIdx = (int)knnMatches->at<float>(q * k, 1);
                    m.imgIdx = (int)knnMatches->at<float>(q * k, 2);
                    m.distance = d1;
                    dm.push_back(m);
                }
            }
            matchesToMat(dm, *goodMatches);
            return (int)dm.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_filterMatchesByRatio: %s\n", e.what());
            return -1;
        } catch (...) {
            return -1;
        }
    }

    __declspec(dllexport) void __stdcall Features2d_drawKeypoints(
        Mat* image, Mat* keypoints, Mat* outImage, int flags)
    {
        try {
            if (!image || !keypoints || !outImage) return;
            vector<KeyPoint> kps;
            matToKeypoints(keypoints, kps);
            drawKeypoints(*image, kps, *outImage, Scalar(), (DrawMatchesFlags)flags);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_drawKeypoints: %s\n", e.what());
        } catch (...) {
        }
    }

    __declspec(dllexport) void __stdcall Features2d_drawMatches(
        Mat* img1, Mat* keypoints1, Mat* img2, Mat* keypoints2, Mat* matches,
        Mat* outImg, int maxMatches)
    {
        try {
            if (!img1 || !keypoints1 || !img2 || !keypoints2 || !matches || !outImg)
                return;
            vector<KeyPoint> kps1, kps2;
            vector<DMatch> dm;
            matToKeypoints(keypoints1, kps1);
            matToKeypoints(keypoints2, kps2);
            matToMatches(matches, dm);
            if (maxMatches > 0 && (int)dm.size() > maxMatches)
                dm.resize(maxMatches);
            drawMatches(*img1, kps1, *img2, kps2, dm, *outImg);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_drawMatches: %s\n", e.what());
        } catch (...) {
        }
    }

    struct DelphiGFTT {
        Ptr<GFTTDetector> detector;
    };

    struct DelphiMSER {
        Ptr<MSER> detector;
    };

    __declspec(dllexport) DelphiGFTT* __stdcall Features2d_GFTT_Create(
        int maxCorners, double qualityLevel, double minDistance, int blockSize, bool useHarris, double k)
    {
        try {
            auto* holder = new DelphiGFTT();
            holder->detector = GFTTDetector::create(maxCorners, qualityLevel, minDistance,
                blockSize, useHarris, k);
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_GFTT_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Features2d_GFTT_Destroy(DelphiGFTT* self) {
        delete self;
    }

    __declspec(dllexport) int __stdcall Features2d_GFTT_detectAndCompute(
        DelphiGFTT* self, Mat* image, Mat* mask, Mat* keypoints, Mat* descriptors)
    {
        try {
            if (!self || !self->detector || !image || !keypoints || !descriptors)
                return 0;
            vector<KeyPoint> kps;
            self->detector->detect(*image, kps, mask ? *mask : noArray());
            descriptors->release();
            keypointsToMat(kps, *keypoints);
            return (int)kps.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_GFTT_detectAndCompute: %s\n", e.what());
            return -1;
        } catch (...) {
            return -1;
        }
    }

    __declspec(dllexport) DelphiMSER* __stdcall Features2d_MSER_Create(
        int delta, int minArea, int maxArea, double maxVariation, double minDiversity,
        int maxEvolution, double areaThreshold, double minMargin, int edgeBlurSize)
    {
        try {
            auto* holder = new DelphiMSER();
            holder->detector = MSER::create(delta, minArea, maxArea, maxVariation, minDiversity,
                maxEvolution, areaThreshold, minMargin, edgeBlurSize);
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_MSER_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Features2d_MSER_Destroy(DelphiMSER* self) {
        delete self;
    }

    __declspec(dllexport) int __stdcall Features2d_MSER_detectAndCompute(
        DelphiMSER* self, Mat* image, Mat* mask, Mat* keypoints, Mat* descriptors)
    {
        try {
            if (!self || !self->detector || !image || !keypoints || !descriptors)
                return 0;
            (void)mask;
            vector<vector<Point>> regions;
            vector<Rect> bboxes;
            self->detector->detectRegions(*image, regions, bboxes);
            vector<KeyPoint> kps;
            kps.reserve(bboxes.size());
            for (const auto& r : bboxes) {
                KeyPoint kp;
                kp.pt = Point2f(r.x + r.width * 0.5f, r.y + r.height * 0.5f);
                kp.size = (float)max(r.width, r.height);
                kps.push_back(kp);
            }
            descriptors->release();
            keypointsToMat(kps, *keypoints);
            return (int)kps.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_MSER_detectAndCompute: %s\n", e.what());
            return -1;
        } catch (...) {
            return -1;
        }
    }

    struct DelphiFAST {
        Ptr<FastFeatureDetector> detector;
    };

    __declspec(dllexport) DelphiFAST* __stdcall Features2d_FAST_Create(
        int threshold, bool nonmaxSuppression, int type)
    {
        try {
            auto* holder = new DelphiFAST();
            holder->detector = FastFeatureDetector::create(threshold, nonmaxSuppression,
                (FastFeatureDetector::DetectorType)type);
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_FAST_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Features2d_FAST_Destroy(DelphiFAST* self) {
        delete self;
    }

    __declspec(dllexport) int __stdcall Features2d_FAST_detectAndCompute(
        DelphiFAST* self, Mat* image, Mat* mask, Mat* keypoints, Mat* descriptors)
    {
        try {
            if (!self || !self->detector || !image || !keypoints || !descriptors)
                return 0;
            vector<KeyPoint> kps;
            self->detector->detect(*image, kps, mask ? *mask : noArray());
            descriptors->release();
            keypointsToMat(kps, *keypoints);
            return (int)kps.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_FAST_detectAndCompute: %s\n", e.what());
            return -1;
        } catch (...) {
            return -1;
        }
    }

    __declspec(dllexport) int __stdcall Features2d_FlannMatcher_knnMatch(
        DelphiFlannMatcher* self, Mat* queryDescriptors, Mat* trainDescriptors, Mat* matches, int k)
    {
        try {
            if (!self || !self->matcher || !queryDescriptors || !trainDescriptors || !matches || k <= 0)
                return 0;
            vector<vector<DMatch>> knn;
            self->matcher->knnMatch(*queryDescriptors, *trainDescriptors, knn, k);
            int total = 0;
            for (const auto& row : knn) total += (int)row.size();
            matches->create(total, 4, CV_32F);
            int idx = 0;
            for (const auto& row : knn) {
                for (const auto& m : row) {
                    matches->at<float>(idx, 0) = (float)m.queryIdx;
                    matches->at<float>(idx, 1) = (float)m.trainIdx;
                    matches->at<float>(idx, 2) = (float)m.imgIdx;
                    matches->at<float>(idx, 3) = m.distance;
                    ++idx;
                }
            }
            return total;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Features2d_FlannMatcher_knnMatch: %s\n", e.what());
            return -1;
        } catch (...) {
            return -1;
        }
    }

}
