cmake_minimum_required(VERSION 3.16)
project(opencv_delphi_wrapper CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Поиск OpenCV. Пользователь должен будет указать OpenCV_DIR при конфигурировании, 
# если OpenCV установлен не в стандартных путях.
find_package(OpenCV REQUIRED)

include_directories(${OpenCV_INCLUDE_DIRS})

add_library(opencv_delphi_wrapper SHARED
    core.cpp
    imgcodecs.cpp
    highgui.cpp
    imgproc.cpp
    videoio.cpp
    video.cpp
    objdetect.cpp
    calib3d.cpp
    features2d.cpp
    dnn.cpp
    ml.cpp
    tracking.cpp
    stereo.cpp
    photo.cpp
    stitching.cpp
    persistence.cpp
    core_ops.cpp
    core_diag.cpp
    ptcloud.cpp
    helpers.cpp
    dnn_models.cpp
    yolo_postprocess.cpp
)

target_link_libraries(opencv_delphi_wrapper
    ${OpenCV_LIBS}
)

if(MSVC)
    target_compile_options(opencv_delphi_wrapper PRIVATE /EHa)
endif()

# Настройка вывода для сборки в корневую папку bin
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/../bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/../bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/../bin)
