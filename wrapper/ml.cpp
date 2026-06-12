#include <opencv2/opencv.hpp>
#include <vector>
#include <cmath>
#include <limits>

using namespace cv;
using namespace std;

extern "C" {

    struct DelphiKNN {
        Mat samples;
        Mat responses;
        int layout;
        bool trained;

        DelphiKNN() : layout(0), trained(false) {}
    };

    static float rowDistance(const Mat& a, int ia, const Mat& b, int ib) {
        float sum = 0.f;
        const float* pa = a.ptr<float>(ia);
        const float* pb = b.ptr<float>(ib);
        for (int j = 0; j < a.cols; ++j) {
            float d = pa[j] - pb[j];
            sum += d * d;
        }
        return sqrtf(sum);
    }

    __declspec(dllexport) DelphiKNN* __stdcall Ml_KNN_Create() {
        try {
            return new DelphiKNN();
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Ml_KNN_Destroy(DelphiKNN* self) {
        delete self;
    }

    __declspec(dllexport) bool __stdcall Ml_KNN_train(DelphiKNN* self, Mat* samples, Mat* responses, int layout) {
        try {
            if (!self || !samples || !responses) return false;
            self->samples = samples->clone();
            self->responses = responses->clone();
            self->layout = layout;
            self->trained = true;
            return true;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Ml_KNN_train: %s\n", e.what());
            return false;
        } catch (...) {
            return false;
        }
    }

    __declspec(dllexport) float __stdcall Ml_KNN_findNearest(DelphiKNN* self, Mat* samples, int k,
        Mat* results, Mat* neighborResponses, Mat* dist) {
        try {
            if (!self || !self->trained || !samples || !results) return -1.f;
            if (k <= 0) k = 1;
            int nTest = samples->rows;
            int nTrain = self->samples.rows;
            results->create(nTest, 1, CV_32F);
            if (neighborResponses)
                neighborResponses->create(nTest, k, CV_32F);
            if (dist)
                dist->create(nTest, k, CV_32F);

            float lastErr = 0.f;
            for (int ti = 0; ti < nTest; ++ti) {
                vector<pair<float, int>> nn;
                nn.reserve(nTrain);
                for (int tr = 0; tr < nTrain; ++tr) {
                    float d = rowDistance(*samples, ti, self->samples, tr);
                    nn.emplace_back(d, tr);
                }
                sort(nn.begin(), nn.end());
                int kk = min(k, (int)nn.size());
                vector<float> votes;
                float bestDist = nn[0].first;
                for (int j = 0; j < kk; ++j) {
                    if (neighborResponses)
                        neighborResponses->at<float>(ti, j) = self->responses.at<float>(nn[j].second, 0);
                    if (dist)
                        dist->at<float>(ti, j) = nn[j].first;
                    votes.push_back(self->responses.at<float>(nn[j].second, 0));
                }
                sort(votes.begin(), votes.end());
                float pred = votes[votes.size() / 2];
                results->at<float>(ti, 0) = pred;
                lastErr = bestDist;
            }
            return lastErr;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Ml_KNN_findNearest: %s\n", e.what());
            return -1.f;
        } catch (...) {
            return -1.f;
        }
    }

    struct DelphiSVM {
        Mat weights;
        float bias;
        int svmType;
        int kernelType;
        bool trained;

        DelphiSVM() : bias(0.f), svmType(100), kernelType(0), trained(false) {}
    };

    __declspec(dllexport) DelphiSVM* __stdcall Ml_SVM_Create(int svmType, int kernelType) {
        try {
            auto* h = new DelphiSVM();
            h->svmType = svmType;
            h->kernelType = kernelType;
            return h;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Ml_SVM_Destroy(DelphiSVM* self) {
        delete self;
    }

    __declspec(dllexport) bool __stdcall Ml_SVM_train(DelphiSVM* self, Mat* samples, Mat* responses, int layout) {
        (void)layout;
        try {
            if (!self || !samples || !responses || self->kernelType != 0) return false;
            int n = samples->rows;
            if (n < 2) return false;
            Mat pos(0, samples->cols, CV_32F), neg(0, samples->cols, CV_32F);
            for (int i = 0; i < n; ++i) {
                float label = responses->at<float>(i, 0);
                Mat row = samples->row(i);
                if (label >= 0.5f)
                    pos.push_back(row);
                else
                    neg.push_back(row);
            }
            if (pos.rows == 0 || neg.rows == 0) return false;
            Scalar meanPos = mean(pos);
            Scalar meanNeg = mean(neg);
            self->weights.create(1, samples->cols, CV_32F);
            for (int j = 0; j < samples->cols; ++j)
                self->weights.at<float>(0, j) = (float)(meanPos[j] - meanNeg[j]);
            float wnorm = (float)cv::norm(self->weights);
            if (wnorm > 1e-6f)
                self->weights /= wnorm;
            float midPos = 0.f, midNeg = 0.f;
            for (int i = 0; i < pos.rows; ++i)
                midPos += (float)(pos.row(i).dot(self->weights));
            for (int i = 0; i < neg.rows; ++i)
                midNeg += (float)(neg.row(i).dot(self->weights));
            midPos /= max(1, pos.rows);
            midNeg /= max(1, neg.rows);
            self->bias = -(midPos + midNeg) * 0.5f;
            self->trained = true;
            return true;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Ml_SVM_train: %s\n", e.what());
            return false;
        } catch (...) {
            return false;
        }
    }

    __declspec(dllexport) float __stdcall Ml_SVM_predict(DelphiSVM* self, Mat* samples, Mat* results) {
        try {
            if (!self || !self->trained || !samples) return -1.f;
            if (results)
                results->create(samples->rows, 1, CV_32F);
            float last = 0.f;
            for (int i = 0; i < samples->rows; ++i) {
                float score = (float)samples->row(i).dot(self->weights) + self->bias;
                float label = score >= 0.f ? 1.f : 0.f;
                if (results)
                    results->at<float>(i, 0) = label;
                last = label;
            }
            return last;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Ml_SVM_predict: %s\n", e.what());
            return -1.f;
        } catch (...) {
            return -1.f;
        }
    }

    struct DelphiPCA {
        PCA pca;
        bool trained;

        DelphiPCA() : trained(false) {}
    };

    __declspec(dllexport) DelphiPCA* __stdcall Ml_PCA_Create(Mat* data, int maxComponents, int flags) {
        try {
            if (!data) return nullptr;
            auto* h = new DelphiPCA();
            h->pca = PCA(*data, Mat(), flags, maxComponents);
            h->trained = true;
            return h;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Ml_PCA_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Ml_PCA_Destroy(DelphiPCA* self) {
        delete self;
    }

    __declspec(dllexport) Mat* __stdcall Ml_PCA_project(DelphiPCA* self, Mat* vec) {
        try {
            if (!self || !self->trained || !vec) return nullptr;
            return new Mat(self->pca.project(*vec));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Ml_PCA_project: %s\n", e.what());
            return nullptr;
        } catch (...) {
            return nullptr;
        }
    }

    __declspec(dllexport) int __stdcall Ml_PCA_getComponents(DelphiPCA* self) {
        if (!self || !self->trained) return 0;
        return self->pca.eigenvectors.rows;
    }

}
