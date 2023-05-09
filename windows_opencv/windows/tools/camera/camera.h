#pragma warning(disable : 4189)
#include <opencv2/opencv.hpp>
#include <iostream>
using namespace std;
using namespace cv;

#pragma once
static int IS_CAMERA_ON = 0;

struct CameraStruct
{
    int width;
    int height;
    int mode;
    int fps;
};

struct RealTimeFaceDetection{
    int count;
};
