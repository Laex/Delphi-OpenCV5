#pragma once



#ifdef _WIN32

#ifndef EXCEPTION_EXECUTE_HANDLER

#define EXCEPTION_EXECUTE_HANDLER 1

#endif



extern "C" void Core_setLastError(const char* msg);



#define OCV_SEH_BEGIN \

    __try {



#define OCV_SEH_END(defaultVal) \

    } __except (EXCEPTION_EXECUTE_HANDLER) { \

        Core_setLastError("Structured exception (SEH) in OpenCV wrapper"); \

        return (defaultVal); \

    }



#define OCV_SEH_END_VOID \

    } __except (EXCEPTION_EXECUTE_HANDLER) { \

        Core_setLastError("Structured exception (SEH) in OpenCV wrapper"); \

        return; \

    }



#else

#define OCV_SEH_BEGIN

#define OCV_SEH_END(defaultVal)

#define OCV_SEH_END_VOID

#endif

