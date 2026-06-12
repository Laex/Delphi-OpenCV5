#include <opencv2/opencv.hpp>
using namespace cv;
using namespace std;

extern "C" {

    // ==========================================
    // Class Mat
    // ==========================================
    __declspec(dllexport) Mat* __stdcall Mat_Ctor_0(int rows, int cols, int type) {
        return new Mat(rows, cols, type);
    }
    __declspec(dllexport) Mat* __stdcall Mat_Ctor_1(Size* size, int type) {
        return new Mat(*size, type);
    }
    __declspec(dllexport) Mat* __stdcall Mat_Ctor_2(int rows, int cols, int type, Scalar* s) {
        return new Mat(rows, cols, type, *s);
    }
    __declspec(dllexport) Mat* __stdcall Mat_Ctor_3(Size* size, int type, Scalar* s) {
        return new Mat(*size, type, *s);
    }
    __declspec(dllexport) Mat* __stdcall Mat_Ctor_4(int ndims, const int* sizes, int type) {
        return new Mat(ndims, sizes, type);
    }
    __declspec(dllexport) Mat* __stdcall Mat_Ctor_5(int ndims, const int* sizes, int type, Scalar* s) {
        return new Mat(ndims, sizes, type, *s);
    }
    __declspec(dllexport) Mat* __stdcall Mat_Ctor_6(Mat* m) {
        return new Mat(*m);
    }
    __declspec(dllexport) Mat* __stdcall Mat_Ctor_7(Mat* m, const Range& rowRange, const Range& colRange) {
        return new Mat(*m, rowRange, colRange);
    }
    __declspec(dllexport) Mat* __stdcall Mat_Ctor_8(Mat* m, Rect* roi) {
        return new Mat(*m, *roi);
    }
    __declspec(dllexport) Mat* __stdcall Mat_Ctor_9(Mat* m, const Range* ranges) {
        return new Mat(*m, ranges);
    }
    __declspec(dllexport) Mat* __stdcall Mat_Ctor_10() {
        return new Mat();
    }
    __declspec(dllexport) void __stdcall Mat_Destroy(Mat* self) {
        if (self) delete self;
    }
    __declspec(dllexport) Mat* __stdcall Mat_Copy(Mat* self) {
        return new Mat(*self);
    }
    __declspec(dllexport) int __stdcall Mat_get_rows(Mat* self) {
        return self->rows;
    }
    __declspec(dllexport) void __stdcall Mat_set_rows(Mat* self, int val) {
        self->rows = val;
    }
    __declspec(dllexport) int __stdcall Mat_get_cols(Mat* self) {
        return self->cols;
    }
    __declspec(dllexport) void __stdcall Mat_set_cols(Mat* self, int val) {
        self->cols = val;
    }
    __declspec(dllexport) Mat* __stdcall Mat_row(Mat* self, int y) {
        try {
            return new Mat(self->row(y));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_row: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_row\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_col(Mat* self, int x) {
        try {
            return new Mat(self->col(x));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_col: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_col\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_rowRange_0(Mat* self, int startrow, int endrow) {
        try {
            return new Mat(self->rowRange(startrow, endrow));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_rowRange_0: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_rowRange_0\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_rowRange_1(Mat* self, const Range& r) {
        try {
            return new Mat(self->rowRange(r));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_rowRange_1: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_rowRange_1\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_colRange_0(Mat* self, int startcol, int endcol) {
        try {
            return new Mat(self->colRange(startcol, endcol));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_colRange_0: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_colRange_0\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_colRange_1(Mat* self, const Range& r) {
        try {
            return new Mat(self->colRange(r));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_colRange_1: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_colRange_1\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_diag_0(Mat* self, int d) {
        try {
            return new Mat(self->diag(d));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_diag_0: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_diag_0\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_diag_1(Mat* self, Mat* d) {
        try {
            return new Mat(self->diag(*d));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_diag_1: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_diag_1\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_clone(Mat* self) {
        try {
            return new Mat(self->clone());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_clone: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_clone\n");
            return nullptr;
        }
    }
    __declspec(dllexport) void __stdcall Mat_copyTo_0(Mat* self, Mat* m) {
        try {
            self->copyTo(m ? *m : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_copyTo_0: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_copyTo_0\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_copyTo_1(Mat* self, Mat* m, Mat* mask) {
        try {
            self->copyTo(m ? *m : (OutputArray)cv::noArray(), mask ? *mask : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_copyTo_1: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_copyTo_1\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_copyAt_0(Mat* self, Mat* m) {
        try {
            self->copyAt(m ? *m : (OutputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_copyAt_0: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_copyAt_0\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_copyAt_1(Mat* self, Mat* m, Mat* mask) {
        try {
            self->copyAt(m ? *m : (OutputArray)cv::noArray(), mask ? *mask : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_copyAt_1: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_copyAt_1\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_convertTo(Mat* self, Mat* m, int rtype, double alpha, double beta) {
        try {
            self->convertTo(m ? *m : (OutputArray)cv::noArray(), rtype, alpha, beta);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_convertTo: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_convertTo\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_assignTo(Mat* self, Mat* m, int type) {
        try {
            self->assignTo(*m, type);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_assignTo: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_assignTo\n");
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_setTo(Mat* self, Mat* value, Mat* mask) {
        try {
            return &self->setTo(value ? *value : (InputArray)cv::noArray(), mask ? *mask : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_setTo: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_setTo\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_setZero(Mat* self) {
        try {
            return &self->setZero();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_setZero: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_setZero\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_reshape_0(Mat* self, int cn, int rows) {
        try {
            return new Mat(self->reshape(cn, rows));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_reshape_0: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_reshape_0\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_reshape_1(Mat* self, int cn, int newndims, const int* newsz) {
        try {
            return new Mat(self->reshape(cn, newndims, newsz));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_reshape_1: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_reshape_1\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_reinterpret(Mat* self, int type) {
        try {
            return new Mat(self->reinterpret(type));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_reinterpret: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_reinterpret\n");
            return nullptr;
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_cross(Mat* self, Mat* m) {
        try {
            return new Mat(self->cross(m ? *m : (InputArray)cv::noArray()));
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_cross: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_cross\n");
            return nullptr;
        }
    }
    __declspec(dllexport) double __stdcall Mat_dot(Mat* self, Mat* m) {
        try {
            return self->dot(m ? *m : (InputArray)cv::noArray());
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_dot: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Mat_dot\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Mat_create_0(Mat* self, int rows, int cols, int type) {
        try {
            self->create(rows, cols, type);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_create_0: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_create_0\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_create_1(Mat* self, Size* size, int type) {
        try {
            self->create(*size, type);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_create_1: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_create_1\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_create_2(Mat* self, int ndims, const int* sizes, int type) {
        try {
            self->create(ndims, sizes, type);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_create_2: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_create_2\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_createSameSize(Mat* self, Mat* arr, int type) {
        try {
            self->createSameSize(arr ? *arr : (InputArray)cv::noArray(), type);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_createSameSize: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_createSameSize\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_fit_0(Mat* self, int rows, int cols, int type) {
        try {
            self->fit(rows, cols, type);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_fit_0: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_fit_0\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_fit_1(Mat* self, Size* size, int type) {
        try {
            self->fit(*size, type);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_fit_1: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_fit_1\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_fit_2(Mat* self, int ndims, const int* sizes, int type) {
        try {
            self->fit(ndims, sizes, type);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_fit_2: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_fit_2\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_fitSameSize(Mat* self, Mat* arr, int type) {
        try {
            self->fitSameSize(arr ? *arr : (InputArray)cv::noArray(), type);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_fitSameSize: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_fitSameSize\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_addref(Mat* self) {
        try {
            self->addref();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_addref: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_addref\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_release(Mat* self) {
        try {
            self->release();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_release: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_release\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_deallocate(Mat* self) {
        try {
            self->deallocate();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_deallocate: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_deallocate\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_copySize(Mat* self, Mat* m) {
        try {
            self->copySize(*m);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_copySize: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_copySize\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_push_back_(Mat* self, const void* elem) {
        try {
            self->push_back_(elem);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_push_back_: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_push_back_\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_push_back(Mat* self, Mat* m) {
        try {
            self->push_back(*m);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_push_back: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_push_back\n");
        }
    }
    __declspec(dllexport) void __stdcall Mat_locateROI(Mat* self, Size* wholeSize, Point* ofs) {
        try {
            self->locateROI(*wholeSize, *ofs);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_locateROI: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_locateROI\n");
        }
    }
    __declspec(dllexport) Mat* __stdcall Mat_adjustROI(Mat* self, int dtop, int dbottom, int dleft, int dright) {
        try {
            return &self->adjustROI(dtop, dbottom, dleft, dright);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_adjustROI: %s\n", e.what());
            return nullptr;
        } catch (...) {
            printf("Unknown Exception in Mat_adjustROI\n");
            return nullptr;
        }
    }
    __declspec(dllexport) bool __stdcall Mat_isContinuous(Mat* self) {
        try {
            return self->isContinuous();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_isContinuous: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Mat_isContinuous\n");
            return {};
        }
    }
    __declspec(dllexport) bool __stdcall Mat_isSubmatrix(Mat* self) {
        try {
            return self->isSubmatrix();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_isSubmatrix: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Mat_isSubmatrix\n");
            return {};
        }
    }
    __declspec(dllexport) int __stdcall Mat_type(Mat* self) {
        try {
            return self->type();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_type: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Mat_type\n");
            return {};
        }
    }
    __declspec(dllexport) int __stdcall Mat_depth(Mat* self) {
        try {
            return self->depth();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_depth: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Mat_depth\n");
            return {};
        }
    }
    __declspec(dllexport) int __stdcall Mat_channels(Mat* self) {
        try {
            return self->channels();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_channels: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Mat_channels\n");
            return {};
        }
    }
    __declspec(dllexport) bool __stdcall Mat_empty(Mat* self) {
        try {
            return self->empty();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_empty: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Mat_empty\n");
            return {};
        }
    }
    __declspec(dllexport) int __stdcall Mat_checkVector(Mat* self, int elemChannels, int depth, bool requireContinuous) {
        try {
            return self->checkVector(elemChannels, depth, requireContinuous);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_checkVector: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Mat_checkVector\n");
            return {};
        }
    }
    __declspec(dllexport) uchar* __stdcall Mat_ptr_0(Mat* self, int i0) {
        try {
            return self->ptr(i0);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_ptr_0: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Mat_ptr_0\n");
            return {};
        }
    }
    __declspec(dllexport) uchar* __stdcall Mat_ptr_1(Mat* self, int row, int col) {
        try {
            return self->ptr(row, col);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_ptr_1: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Mat_ptr_1\n");
            return {};
        }
    }
    __declspec(dllexport) uchar* __stdcall Mat_ptr_2(Mat* self, int i0, int i1, int i2) {
        try {
            return self->ptr(i0, i1, i2);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_ptr_2: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Mat_ptr_2\n");
            return {};
        }
    }
    __declspec(dllexport) uchar* __stdcall Mat_ptr_3(Mat* self, const int* idx) {
        try {
            return self->ptr(idx);
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_ptr_3: %s\n", e.what());
            return {};
        } catch (...) {
            printf("Unknown Exception in Mat_ptr_3\n");
            return {};
        }
    }
    __declspec(dllexport) void __stdcall Mat_updateContinuityFlag(Mat* self) {
        try {
            self->updateContinuityFlag();
        } catch (const cv::Exception& e) {
            printf("OpenCV Exception in Mat_updateContinuityFlag: %s\n", e.what());
        } catch (...) {
            printf("Unknown Exception in Mat_updateContinuityFlag\n");
        }
    }

}
