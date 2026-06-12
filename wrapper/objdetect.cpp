#include <opencv2/opencv.hpp>
#include <opencv2/objdetect.hpp>
#include <opencv2/objdetect/barcode.hpp>
#include <opencv2/objdetect/aruco_detector.hpp>
#include <opencv2/objdetect/aruco_board.hpp>
#include <opencv2/objdetect/charuco_detector.hpp>
#include <opencv2/objdetect/face.hpp>
#include <algorithm>
#include <cstring>
using namespace cv;
using namespace std;

extern "C" {

    struct DelphiGridBoard;

    struct CVSize { int width, height; };

    static void PackStrings(const vector<string>& items, char* buffer, int bufferSize) {
        if (!buffer || bufferSize <= 0)
            return;
        int pos = 0;
        for (const string& s : items) {
            const int need = (int)s.size() + 1;
            if (pos + need >= bufferSize)
                break;
            memcpy(buffer + pos, s.c_str(), (size_t)need);
            pos += need;
        }
        if (pos < bufferSize)
            buffer[pos] = '\0';
    }

    static void ArucoCornersToMat(const vector<vector<Point2f>>& corners, Mat& out) {
        const int n = (int)corners.size();
        out.create(n, 4, CV_32FC2);
        for (int i = 0; i < n; ++i) {
            const int m = std::min(4, (int)corners[i].size());
            for (int j = 0; j < m; ++j)
                out.at<Vec2f>(i, j) = corners[i][j];
        }
    }

    // ==========================================
    // Chessboard / circles grid
    // ==========================================
    __declspec(dllexport) bool __stdcall Objdetect_findChessboardCorners(Mat* image, Size* patternSize, Mat* corners, int flags) {
        try {
            return ::cv::findChessboardCorners(image ? *image : (InputArray)cv::noArray(), *patternSize,
                corners ? *corners : (OutputArray)cv::noArray(), flags);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_findChessboardCorners: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Objdetect_findChessboardCorners\n");
            return false;
        }
    }

    __declspec(dllexport) bool __stdcall Objdetect_checkChessboard(Mat* img, Size* size) {
        try {
            return ::cv::checkChessboard(img ? *img : (InputArray)cv::noArray(), *size);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_checkChessboard: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Objdetect_checkChessboard\n");
            return false;
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_drawChessboardCorners(Mat* image, Size* patternSize, Mat* corners, bool patternWasFound) {
        try {
            ::cv::drawChessboardCorners(image ? *image : (InputOutputArray)cv::noArray(), *patternSize,
                corners ? *corners : (InputArray)cv::noArray(), patternWasFound);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_drawChessboardCorners: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Objdetect_drawChessboardCorners\n");
        }
    }

    __declspec(dllexport) bool __stdcall Objdetect_findCirclesGrid(Mat* image, Size* patternSize, Mat* centers, int flags) {
        try {
            return ::cv::findCirclesGrid(image ? *image : (InputArray)cv::noArray(), *patternSize,
                centers ? *centers : (OutputArray)cv::noArray(), flags);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_findCirclesGrid: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Objdetect_findCirclesGrid\n");
            return false;
        }
    }

    __declspec(dllexport) bool __stdcall Objdetect_findCirclesGridEx(Mat* image, Size* patternSize, Mat* centers,
        int flags, float minArea, float maxArea, float minCircularity)
    {
        try {
            SimpleBlobDetector::Params params;
            params.filterByArea = true;
            params.minArea = minArea;
            params.maxArea = maxArea;
            params.filterByCircularity = true;
            params.minCircularity = minCircularity;
            Ptr<SimpleBlobDetector> detector = SimpleBlobDetector::create(params);
            return ::cv::findCirclesGrid(image ? *image : (InputArray)cv::noArray(), *patternSize,
                centers ? *centers : (OutputArray)cv::noArray(), flags, detector);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_findCirclesGridEx: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Objdetect_findCirclesGridEx\n");
            return false;
        }
    }

    // ==========================================
    // QRCodeDetector
    // ==========================================
    __declspec(dllexport) QRCodeDetector* __stdcall Objdetect_QRCodeDetector_Create() {
        try {
            return new QRCodeDetector();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_QRCodeDetector_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Objdetect_QRCodeDetector_Create\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_QRCodeDetector_Destroy(QRCodeDetector* self) {
        delete self;
    }

    __declspec(dllexport) void __stdcall Objdetect_QRCodeDetector_setEpsX(QRCodeDetector* self, double epsX) {
        if (self) self->setEpsX(epsX);
    }

    __declspec(dllexport) void __stdcall Objdetect_QRCodeDetector_setEpsY(QRCodeDetector* self, double epsY) {
        if (self) self->setEpsY(epsY);
    }

    __declspec(dllexport) bool __stdcall Objdetect_QRCodeDetector_detect(QRCodeDetector* self, Mat* img, Mat* points) {
        try {
            if (!self || !img) return false;
            return self->detect(*img, points ? *points : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_QRCodeDetector_detect: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Objdetect_QRCodeDetector_detect\n");
            return false;
        }
    }

    __declspec(dllexport) bool __stdcall Objdetect_QRCodeDetector_detectAndDecode(QRCodeDetector* self, Mat* img, Mat* points,
        char* textBuffer, int textBufferSize) {
        try {
            if (!self || !img) return false;
            string text = self->detectAndDecode(*img, points ? *points : (OutputArray)cv::noArray());
            if (textBuffer && textBufferSize > 0) {
                strncpy(textBuffer, text.c_str(), (size_t)textBufferSize - 1);
                textBuffer[textBufferSize - 1] = '\0';
            }
            return !text.empty();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_QRCodeDetector_detectAndDecode: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Objdetect_QRCodeDetector_detectAndDecode\n");
            return false;
        }
    }

    __declspec(dllexport) int __stdcall Objdetect_QRCodeDetector_detectAndDecodeMulti(QRCodeDetector* self, Mat* img, Mat* points,
        char* textBuffer, int textBufferSize) {
        try {
            if (!self || !img) return 0;
            vector<string> decoded;
            self->detectAndDecodeMulti(*img, decoded, points ? *points : (OutputArray)cv::noArray());
            PackStrings(decoded, textBuffer, textBufferSize);
            return (int)decoded.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_QRCodeDetector_detectAndDecodeMulti: %s\n", e.what());
            return 0;
        } catch (...) {
            printf("Unknown Exception in Objdetect_QRCodeDetector_detectAndDecodeMulti\n");
            return 0;
        }
    }

    // ==========================================
    // BarcodeDetector (cv::barcode)
    // ==========================================
    __declspec(dllexport) barcode::BarcodeDetector* __stdcall Objdetect_BarcodeDetector_Create() {
        try {
            return new barcode::BarcodeDetector();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_BarcodeDetector_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Objdetect_BarcodeDetector_Create\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_BarcodeDetector_Destroy(barcode::BarcodeDetector* self) {
        delete self;
    }

    __declspec(dllexport) bool __stdcall Objdetect_BarcodeDetector_detectAndDecodeWithType(barcode::BarcodeDetector* self, Mat* img,
        char* textBuffer, int textBufferSize, char* typeBuffer, int typeBufferSize, Mat* points) {
        try {
            if (!self || !img) return false;
            vector<string> info, types;
            bool ok = self->detectAndDecodeWithType(*img, info, types, points ? *points : (OutputArray)cv::noArray());
            PackStrings(info, textBuffer, textBufferSize);
            PackStrings(types, typeBuffer, typeBufferSize);
            return ok;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_BarcodeDetector_detectAndDecodeWithType: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Objdetect_BarcodeDetector_detectAndDecodeWithType\n");
            return false;
        }
    }

    // ==========================================
    // ArucoDetector
    // ==========================================
    __declspec(dllexport) aruco::ArucoDetector* __stdcall Objdetect_ArucoDetector_Create(int dictionaryId) {
        try {
            auto dict = aruco::getPredefinedDictionary((aruco::PredefinedDictionaryType)dictionaryId);
            return new aruco::ArucoDetector(dict);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_ArucoDetector_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Objdetect_ArucoDetector_Create\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_ArucoDetector_Destroy(aruco::ArucoDetector* self) {
        delete self;
    }

    __declspec(dllexport) int __stdcall Objdetect_ArucoDetector_detectMarkers(aruco::ArucoDetector* self, Mat* image,
        Mat* markerCorners, Mat* ids) {
        try {
            if (!self || !image) return 0;
            vector<vector<Point2f>> corners;
            vector<int> idsVec;
            self->detectMarkers(*image, corners, idsVec);
            if (markerCorners)
                ArucoCornersToMat(corners, *markerCorners);
            if (ids && !idsVec.empty()) {
                Mat(idsVec, true).copyTo(*ids);
            } else if (ids) {
                ids->release();
            }
            return (int)idsVec.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_ArucoDetector_detectMarkers: %s\n", e.what());
            return 0;
        } catch (...) {
            printf("Unknown Exception in Objdetect_ArucoDetector_detectMarkers\n");
            return 0;
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_generateArucoMarker(int dictionaryId, int markerId, int sidePixels, Mat* out) {
        try {
            if (!out) return;
            auto dict = aruco::getPredefinedDictionary((aruco::PredefinedDictionaryType)dictionaryId);
            Mat marker;
            aruco::generateImageMarker(dict, markerId, sidePixels, marker);
            copyMakeBorder(marker, *out, 40, 40, 40, 40, BORDER_CONSTANT, Scalar(255));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_generateArucoMarker: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Objdetect_generateArucoMarker\n");
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_encodeQRCode(const char* text, Mat* qrcode) {
        try {
            if (!text || !qrcode) return;
            Ptr<QRCodeEncoder> encoder = QRCodeEncoder::create();
            Mat qr, scaled;
            encoder->encode(string(text), qr);
            resize(qr, scaled, Size(), 4.0, 4.0, INTER_NEAREST);
            copyMakeBorder(scaled, *qrcode, 50, 50, 50, 50, BORDER_CONSTANT, Scalar(255));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_encodeQRCode: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Objdetect_encodeQRCode\n");
        }
    }

    // ==========================================
    // Chessboard SB / subpix / sharpness
    // ==========================================
    __declspec(dllexport) bool __stdcall Objdetect_findChessboardCornersSB(Mat* image, Size* patternSize, Mat* corners, int flags, Mat* meta) {
        try {
            return ::cv::findChessboardCornersSB(image ? *image : (InputArray)cv::noArray(), *patternSize,
                corners ? *corners : (OutputArray)cv::noArray(), flags,
                meta ? *meta : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_findChessboardCornersSB: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Objdetect_findChessboardCornersSB\n");
            return false;
        }
    }

    __declspec(dllexport) bool __stdcall Objdetect_find4QuadCornerSubpix(Mat* img, Mat* corners, Size* regionSize) {
        try {
            return ::cv::find4QuadCornerSubpix(img ? *img : (InputArray)cv::noArray(),
                corners ? *corners : (InputOutputArray)cv::noArray(), *regionSize);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_find4QuadCornerSubpix: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Objdetect_find4QuadCornerSubpix\n");
            return false;
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_estimateChessboardSharpness(Mat* image, Size* patternSize, Mat* corners,
        float riseDistance, bool vertical, Mat* sharpness, double* outScalar) {
        try {
            Scalar s = ::cv::estimateChessboardSharpness(image ? *image : (InputArray)cv::noArray(), *patternSize,
                corners ? *corners : (InputArray)cv::noArray(), riseDistance, vertical,
                sharpness ? *sharpness : (OutputArray)cv::noArray());
            if (outScalar) {
                outScalar[0] = s[0];
                outScalar[1] = s[1];
                outScalar[2] = s[2];
                outScalar[3] = s[3];
            }
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_estimateChessboardSharpness: %s\n", e.what());
            if (outScalar) {
                outScalar[0] = outScalar[1] = outScalar[2] = outScalar[3] = 0;
            }
        } catch (...) {
            printf("Unknown Exception in Objdetect_estimateChessboardSharpness\n");
            if (outScalar) {
                outScalar[0] = outScalar[1] = outScalar[2] = outScalar[3] = 0;
            }
        }
    }

    // ==========================================
    // ArUco drawing / marker generation
    // ==========================================
    __declspec(dllexport) void __stdcall Objdetect_drawDetectedMarkers(Mat* image, Mat* corners, Mat* ids,
        double borderB, double borderG, double borderR) {
        try {
            if (!image || !corners) return;
            vector<vector<Point2f>> cornerVec;
            const int n = corners->rows;
            cornerVec.resize(n);
            for (int i = 0; i < n; ++i) {
                cornerVec[i].resize(4);
                for (int j = 0; j < 4; ++j)
                    cornerVec[i][j] = corners->at<Vec2f>(i, j);
            }
            Mat idsMat;
            if (ids && !ids->empty())
                idsMat = *ids;
            ::cv::aruco::drawDetectedMarkers(*image, cornerVec, idsMat.empty() ? noArray() : idsMat,
                Scalar(borderB, borderG, borderR));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_drawDetectedMarkers: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Objdetect_drawDetectedMarkers\n");
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_generateArucoMarkerEx(int dictionaryId, int markerId, int sidePixels,
        int borderBits, Mat* out) {
        try {
            if (!out) return;
            auto dict = aruco::getPredefinedDictionary((aruco::PredefinedDictionaryType)dictionaryId);
            Mat marker;
            aruco::generateImageMarker(dict, markerId, sidePixels, marker, borderBits);
            copyMakeBorder(marker, *out, 40, 40, 40, 40, BORDER_CONSTANT, Scalar(255));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_generateArucoMarkerEx: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Objdetect_generateArucoMarkerEx\n");
        }
    }

    __declspec(dllexport) int __stdcall Objdetect_ArucoDetector_detectMarkersEx(aruco::ArucoDetector* self, Mat* image,
        Mat* markerCorners, Mat* ids, Mat* rejectedImgPoints) {
        try {
            if (!self || !image) return 0;
            vector<vector<Point2f>> corners, rejected;
            vector<int> idsVec;
            self->detectMarkers(*image, corners, idsVec, rejected);
            if (markerCorners)
                ArucoCornersToMat(corners, *markerCorners);
            if (ids && !idsVec.empty())
                Mat(idsVec, true).copyTo(*ids);
            else if (ids)
                ids->release();
            if (rejectedImgPoints)
                ArucoCornersToMat(rejected, *rejectedImgPoints);
            return (int)idsVec.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_ArucoDetector_detectMarkersEx: %s\n", e.what());
            return 0;
        } catch (...) {
            printf("Unknown Exception in Objdetect_ArucoDetector_detectMarkersEx\n");
            return 0;
        }
    }

    // ==========================================
    // QRCodeDetector extended
    // ==========================================
    __declspec(dllexport) void __stdcall Objdetect_QRCodeDetector_setUseAlignmentMarkers(QRCodeDetector* self, bool useAlignmentMarkers) {
        if (self) self->setUseAlignmentMarkers(useAlignmentMarkers);
    }

    __declspec(dllexport) bool __stdcall Objdetect_QRCodeDetector_decode(QRCodeDetector* self, Mat* img, Mat* points,
        char* textBuffer, int textBufferSize, Mat* straightQrcode) {
        try {
            if (!self || !img) return false;
            string text = self->decode(*img, points ? *points : (InputArray)cv::noArray(),
                straightQrcode ? *straightQrcode : (OutputArray)cv::noArray());
            if (textBuffer && textBufferSize > 0) {
                strncpy(textBuffer, text.c_str(), (size_t)textBufferSize - 1);
                textBuffer[textBufferSize - 1] = '\0';
            }
            return !text.empty();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_QRCodeDetector_decode: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Objdetect_QRCodeDetector_decode\n");
            return false;
        }
    }

    __declspec(dllexport) bool __stdcall Objdetect_QRCodeDetector_detectMulti(QRCodeDetector* self, Mat* img, Mat* points) {
        try {
            if (!self || !img) return false;
            return self->detectMulti(*img, points ? *points : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_QRCodeDetector_detectMulti: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Objdetect_QRCodeDetector_detectMulti\n");
            return false;
        }
    }

    __declspec(dllexport) int __stdcall Objdetect_QRCodeDetector_decodeMulti(QRCodeDetector* self, Mat* img, Mat* points,
        char* textBuffer, int textBufferSize) {
        try {
            if (!self || !img) return 0;
            vector<string> decoded;
            self->decodeMulti(*img, points ? *points : (InputArray)cv::noArray(), decoded);
            PackStrings(decoded, textBuffer, textBufferSize);
            return (int)decoded.size();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_QRCodeDetector_decodeMulti: %s\n", e.what());
            return 0;
        } catch (...) {
            printf("Unknown Exception in Objdetect_QRCodeDetector_decodeMulti\n");
            return 0;
        }
    }

    __declspec(dllexport) bool __stdcall Objdetect_QRCodeDetector_detectAndDecodeCurved(QRCodeDetector* self, Mat* img,
        Mat* points, char* textBuffer, int textBufferSize, Mat* straightQrcode) {
        try {
            if (!self || !img) return false;
            string text = self->detectAndDecodeCurved(*img, points ? *points : (OutputArray)cv::noArray(),
                straightQrcode ? *straightQrcode : (OutputArray)cv::noArray());
            if (textBuffer && textBufferSize > 0) {
                strncpy(textBuffer, text.c_str(), (size_t)textBufferSize - 1);
                textBuffer[textBufferSize - 1] = '\0';
            }
            return !text.empty();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_QRCodeDetector_detectAndDecodeCurved: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Objdetect_QRCodeDetector_detectAndDecodeCurved\n");
            return false;
        }
    }

    __declspec(dllexport) int __stdcall Objdetect_QRCodeDetector_getEncoding(QRCodeDetector* self, int codeIdx) {
        try {
            if (!self) return 0;
            return (int)self->getEncoding(codeIdx);
        } catch (...) {
            return 0;
        }
    }

    // ==========================================
    // BarcodeDetector extended
    // ==========================================
    __declspec(dllexport) bool __stdcall Objdetect_BarcodeDetector_detect(barcode::BarcodeDetector* self, Mat* img, Mat* points) {
        try {
            if (!self || !img) return false;
            return self->detect(*img, points ? *points : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_BarcodeDetector_detect: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Objdetect_BarcodeDetector_detect\n");
            return false;
        }
    }

    __declspec(dllexport) bool __stdcall Objdetect_BarcodeDetector_decodeWithType(barcode::BarcodeDetector* self, Mat* img,
        Mat* points, char* textBuffer, int textBufferSize, char* typeBuffer, int typeBufferSize) {
        try {
            if (!self || !img) return false;
            vector<string> info, types;
            bool ok = self->decodeWithType(*img, points ? *points : (InputArray)cv::noArray(), info, types);
            PackStrings(info, textBuffer, textBufferSize);
            PackStrings(types, typeBuffer, typeBufferSize);
            return ok;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_BarcodeDetector_decodeWithType: %s\n", e.what());
            return false;
        } catch (...) {
            printf("Unknown Exception in Objdetect_BarcodeDetector_decodeWithType\n");
            return false;
        }
    }

    __declspec(dllexport) double __stdcall Objdetect_BarcodeDetector_getDownsamplingThreshold(barcode::BarcodeDetector* self) {
        try {
            return self ? self->getDownsamplingThreshold() : 0;
        } catch (...) {
            return 0;
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_BarcodeDetector_setDownsamplingThreshold(barcode::BarcodeDetector* self, double thresh) {
        try {
            if (self) self->setDownsamplingThreshold(thresh);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_BarcodeDetector_setDownsamplingThreshold: %s\n", e.what());
        }
    }

    __declspec(dllexport) double __stdcall Objdetect_BarcodeDetector_getGradientThreshold(barcode::BarcodeDetector* self) {
        try {
            return self ? self->getGradientThreshold() : 0;
        } catch (...) {
            return 0;
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_BarcodeDetector_setGradientThreshold(barcode::BarcodeDetector* self, double thresh) {
        try {
            if (self) self->setGradientThreshold(thresh);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_BarcodeDetector_setGradientThreshold: %s\n", e.what());
        }
    }

    // ==========================================
    // QRCodeEncoder
    // ==========================================
    struct DelphiQRCodeEncoder {
        Ptr<QRCodeEncoder> enc;
    };

    __declspec(dllexport) DelphiQRCodeEncoder* __stdcall Objdetect_QRCodeEncoder_Create(int version, int correctionLevel, int mode) {
        try {
            QRCodeEncoder::Params params;
            if (version >= 0)
                params.version = version;
            params.correction_level = (QRCodeEncoder::CorrectionLevel)correctionLevel;
            if (mode >= 0)
                params.mode = (QRCodeEncoder::EncodeMode)mode;
            auto* holder = new DelphiQRCodeEncoder();
            holder->enc = QRCodeEncoder::create(params);
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_QRCodeEncoder_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Objdetect_QRCodeEncoder_Create\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_QRCodeEncoder_Destroy(DelphiQRCodeEncoder* self) {
        delete self;
    }

    __declspec(dllexport) void __stdcall Objdetect_QRCodeEncoder_encode(DelphiQRCodeEncoder* self, const char* text, Mat* qrcode) {
        try {
            if (!self || !text || !qrcode) return;
            self->enc->encode(string(text), *qrcode);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_QRCodeEncoder_encode: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Objdetect_QRCodeEncoder_encode\n");
        }
    }

    // ==========================================
    // GridBoard / CharucoBoard (calibration patterns)
    // ==========================================
    struct DelphiGridBoard {
        aruco::GridBoard board;
        DelphiGridBoard(int markersX, int markersY, float markerLength, float markerSeparation, int dictionaryId)
            : board(Size(markersX, markersY), markerLength, markerSeparation,
                    aruco::getPredefinedDictionary((aruco::PredefinedDictionaryType)dictionaryId)) {}
    };

    struct DelphiCharucoBoard {
        aruco::CharucoBoard board;
        DelphiCharucoBoard(int squaresX, int squaresY, float squareLength, float markerLength, int dictionaryId)
            : board(Size(squaresX, squaresY), squareLength, markerLength,
                    aruco::getPredefinedDictionary((aruco::PredefinedDictionaryType)dictionaryId)) {}
    };

    struct DelphiCharucoDetector {
        aruco::CharucoDetector detector;
        explicit DelphiCharucoDetector(const aruco::CharucoBoard& board) : detector(board) {}
    };

    __declspec(dllexport) DelphiGridBoard* __stdcall Objdetect_GridBoard_Create(int markersX, int markersY,
        float markerLength, float markerSeparation, int dictionaryId) {
        try {
            return new DelphiGridBoard(markersX, markersY, markerLength, markerSeparation, dictionaryId);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_GridBoard_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Objdetect_GridBoard_Create\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_GridBoard_Destroy(DelphiGridBoard* self) {
        delete self;
    }

    __declspec(dllexport) void __stdcall Objdetect_GridBoard_generateImage(DelphiGridBoard* self, int outWidth, int outHeight,
        int marginSize, int borderBits, Mat* img) {
        try {
            if (!self || !img) return;
            Mat generated;
            self->board.generateImage(Size(outWidth, outHeight), generated, marginSize, borderBits);
            generated.copyTo(*img);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_GridBoard_generateImage: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Objdetect_GridBoard_generateImage\n");
        }
    }

    static void MatToArucoCorners(const Mat& in, vector<vector<Point2f>>& corners) {
        corners.resize(in.rows);
        for (int i = 0; i < in.rows; ++i) {
            corners[i].resize(4);
            for (int j = 0; j < 4; ++j)
                corners[i][j] = in.at<Vec2f>(i, j);
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_ArucoDetector_refineDetectedMarkers(
        aruco::ArucoDetector* self, Mat* image, DelphiGridBoard* board,
        Mat* markerCorners, Mat* ids, Mat* rejectedImgPoints,
        Mat* cameraMatrix, Mat* distCoeffs)
    {
        try {
            if (!self || !image || !board || !markerCorners || !ids)
                return;
            vector<vector<Point2f>> corners, rejected;
            MatToArucoCorners(*markerCorners, corners);
            if (rejectedImgPoints && !rejectedImgPoints->empty())
                MatToArucoCorners(*rejectedImgPoints, rejected);
            vector<int> idsVec;
            ids->copyTo(idsVec);
            self->refineDetectedMarkers(*image, board->board, corners, idsVec, rejected,
                cameraMatrix ? *cameraMatrix : noArray(),
                distCoeffs ? *distCoeffs : noArray());
            ArucoCornersToMat(corners, *markerCorners);
            if (!idsVec.empty())
                Mat(idsVec, true).copyTo(*ids);
            if (rejectedImgPoints)
                ArucoCornersToMat(rejected, *rejectedImgPoints);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_ArucoDetector_refineDetectedMarkers: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Objdetect_ArucoDetector_refineDetectedMarkers\n");
        }
    }

    __declspec(dllexport) DelphiCharucoBoard* __stdcall Objdetect_CharucoBoard_Create(int squaresX, int squaresY,
        float squareLength, float markerLength, int dictionaryId) {
        try {
            return new DelphiCharucoBoard(squaresX, squaresY, squareLength, markerLength, dictionaryId);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_CharucoBoard_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Objdetect_CharucoBoard_Create\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_CharucoBoard_Destroy(DelphiCharucoBoard* self) {
        delete self;
    }

    __declspec(dllexport) void __stdcall Objdetect_CharucoBoard_generateImage(DelphiCharucoBoard* self, int outWidth, int outHeight,
        int marginSize, int borderBits, Mat* img) {
        try {
            if (!self || !img) return;
            Mat generated;
            self->board.generateImage(Size(outWidth, outHeight), generated, marginSize, borderBits);
            generated.copyTo(*img);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_CharucoBoard_generateImage: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Objdetect_CharucoBoard_generateImage\n");
        }
    }

    __declspec(dllexport) DelphiCharucoDetector* __stdcall Objdetect_CharucoDetector_Create(DelphiCharucoBoard* board) {
        try {
            if (!board) return nullptr;
            return new DelphiCharucoDetector(board->board);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_CharucoDetector_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Objdetect_CharucoDetector_Create\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_CharucoDetector_Destroy(DelphiCharucoDetector* self) {
        delete self;
    }

    __declspec(dllexport) void __stdcall Objdetect_CharucoDetector_detectBoard(DelphiCharucoDetector* self, Mat* image,
        Mat* charucoCorners, Mat* charucoIds, Mat* markerCorners, Mat* markerIds) {
        try {
            if (!self || !image) return;
            self->detector.detectBoard(*image,
                charucoCorners ? *charucoCorners : (OutputArray)cv::noArray(),
                charucoIds ? *charucoIds : (OutputArray)cv::noArray(),
                markerCorners ? *markerCorners : (InputOutputArray)cv::noArray(),
                markerIds ? *markerIds : (InputOutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_CharucoDetector_detectBoard: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Objdetect_CharucoDetector_detectBoard\n");
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_drawDetectedCornersCharuco(Mat* image, Mat* charucoCorners, Mat* charucoIds,
        double colorB, double colorG, double colorR) {
        try {
            if (!image || !charucoCorners) return;
            Mat idsMat;
            if (charucoIds && !charucoIds->empty())
                idsMat = *charucoIds;
            ::cv::aruco::drawDetectedCornersCharuco(*image, *charucoCorners,
                idsMat.empty() ? noArray() : idsMat, Scalar(colorB, colorG, colorR));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_drawDetectedCornersCharuco: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Objdetect_drawDetectedCornersCharuco\n");
        }
    }

    // ==========================================
    // FaceDetectorYN (requires OpenCV DNN)
    // ==========================================
    struct DelphiFaceDetectorYN {
        Ptr<FaceDetectorYN> det;
    };

    __declspec(dllexport) DelphiFaceDetectorYN* __stdcall Objdetect_FaceDetectorYN_Create(
        const char* model, const char* config, CVSize* inputSize,
        float scoreThreshold, float nmsThreshold, int topK, int backendId, int targetId) {
        try {
            if (!model || !inputSize)
                return nullptr;
            auto* holder = new DelphiFaceDetectorYN();
            holder->det = FaceDetectorYN::create(model, config ? config : "",
                Size(inputSize->width, inputSize->height),
                scoreThreshold, nmsThreshold, topK, backendId, targetId);
            if (!holder->det) {
                delete holder;
                return nullptr;
            }
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_FaceDetectorYN_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Objdetect_FaceDetectorYN_Create\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_FaceDetectorYN_Destroy(DelphiFaceDetectorYN* self) {
        delete self;
    }

    __declspec(dllexport) void __stdcall Objdetect_FaceDetectorYN_setInputSize(DelphiFaceDetectorYN* self, CVSize* inputSize) {
        if (self && self->det && inputSize)
            self->det->setInputSize(Size(inputSize->width, inputSize->height));
    }

    __declspec(dllexport) CVSize __stdcall Objdetect_FaceDetectorYN_getInputSize(DelphiFaceDetectorYN* self) {
        CVSize result = {0, 0};
        if (self && self->det) {
            Size s = self->det->getInputSize();
            result.width = s.width;
            result.height = s.height;
        }
        return result;
    }

    __declspec(dllexport) void __stdcall Objdetect_FaceDetectorYN_setScoreThreshold(DelphiFaceDetectorYN* self, float scoreThreshold) {
        if (self && self->det)
            self->det->setScoreThreshold(scoreThreshold);
    }

    __declspec(dllexport) float __stdcall Objdetect_FaceDetectorYN_getScoreThreshold(DelphiFaceDetectorYN* self) {
        if (self && self->det)
            return self->det->getScoreThreshold();
        return 0.f;
    }

    __declspec(dllexport) void __stdcall Objdetect_FaceDetectorYN_setNMSThreshold(DelphiFaceDetectorYN* self, float nmsThreshold) {
        if (self && self->det)
            self->det->setNMSThreshold(nmsThreshold);
    }

    __declspec(dllexport) float __stdcall Objdetect_FaceDetectorYN_getNMSThreshold(DelphiFaceDetectorYN* self) {
        if (self && self->det)
            return self->det->getNMSThreshold();
        return 0.f;
    }

    __declspec(dllexport) void __stdcall Objdetect_FaceDetectorYN_setTopK(DelphiFaceDetectorYN* self, int topK) {
        if (self && self->det)
            self->det->setTopK(topK);
    }

    __declspec(dllexport) int __stdcall Objdetect_FaceDetectorYN_getTopK(DelphiFaceDetectorYN* self) {
        if (self && self->det)
            return self->det->getTopK();
        return 0;
    }

    __declspec(dllexport) int __stdcall Objdetect_FaceDetectorYN_detect(DelphiFaceDetectorYN* self, Mat* image, Mat* faces) {
        try {
            if (!self || !self->det || !image || !faces)
                return -1;
            self->det->detect(*image, *faces);
            return faces->rows;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_FaceDetectorYN_detect: %s\n", e.what());
            return -1;
        } catch (...) {
            printf("Unknown Exception in Objdetect_FaceDetectorYN_detect\n");
            return -1;
        }
    }

    // FaceRecognizerSF (requires OpenCV DNN)
    struct DelphiFaceRecognizerSF {
        Ptr<FaceRecognizerSF> rec;
    };

    __declspec(dllexport) DelphiFaceRecognizerSF* __stdcall Objdetect_FaceRecognizerSF_Create(
        const char* model, const char* config, int backendId, int targetId)
    {
        try {
            auto* holder = new DelphiFaceRecognizerSF();
            holder->rec = FaceRecognizerSF::create(model ? model : "",
                config ? config : "", backendId, targetId);
            return holder;
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_FaceRecognizerSF_Create: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Objdetect_FaceRecognizerSF_Create\n");
            return nullptr;
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_FaceRecognizerSF_Destroy(DelphiFaceRecognizerSF* self) {
        delete self;
    }

    __declspec(dllexport) void __stdcall Objdetect_FaceRecognizerSF_alignCrop(
        DelphiFaceRecognizerSF* self, Mat* srcImg, Mat* faceBox, Mat* alignedImg)
    {
        try {
            if (self && self->rec && srcImg && faceBox && alignedImg)
                self->rec->alignCrop(*srcImg, *faceBox, *alignedImg);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_FaceRecognizerSF_alignCrop: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Objdetect_FaceRecognizerSF_alignCrop\n");
        }
    }

    __declspec(dllexport) void __stdcall Objdetect_FaceRecognizerSF_feature(
        DelphiFaceRecognizerSF* self, Mat* alignedImg, Mat* faceFeature)
    {
        try {
            if (self && self->rec && alignedImg && faceFeature)
                self->rec->feature(*alignedImg, *faceFeature);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_FaceRecognizerSF_feature: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Objdetect_FaceRecognizerSF_feature\n");
        }
    }

    __declspec(dllexport) double __stdcall Objdetect_FaceRecognizerSF_match(
        DelphiFaceRecognizerSF* self, Mat* feature1, Mat* feature2, int disType)
    {
        try {
            if (self && self->rec && feature1 && feature2)
                return self->rec->match(*feature1, *feature2, disType);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Objdetect_FaceRecognizerSF_match: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Objdetect_FaceRecognizerSF_match\n");
        }
        return -1.0;
    }

}
