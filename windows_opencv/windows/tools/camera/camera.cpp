#pragma warning(disable : 4189)
#include <opencv2/opencv.hpp>
#include <iostream>
using namespace std;
using namespace cv;

#pragma once
static int IS_CAMERA_ON = 0;

class FlutterCamera
{
private:
    VideoCapture capture;

public:
    FlutterCamera(/* args */);
    ~FlutterCamera();
    void startCamera();
    void stopCamera();
    void cameraCallback(void (*refreshUint8List)(int), uchar **encodedOutput);
    int getImage(uchar **encodedOutput);
};

FlutterCamera::FlutterCamera(/* args */)
{
}

FlutterCamera::~FlutterCamera()
{
}

void FlutterCamera::startCamera()
{
    if (IS_CAMERA_ON == 1)
    {
        cout << "[cpp] camera is on" << endl;
        return;
    }

    capture.open(0, CAP_DSHOW);
    if (!capture.isOpened())
    {
        cerr << "Couldn't open camera." << endl;
        return;
    }

    IS_CAMERA_ON = 1;

    // 设置参数
    capture.set(CAP_PROP_FRAME_WIDTH, 800);  // 宽度
    capture.set(CAP_PROP_FRAME_HEIGHT, 600); // 高度
    capture.set(CAP_PROP_FPS, 30);           // 帧率

    // 查询参数
    double frameWidth = capture.get(CAP_PROP_FRAME_WIDTH);
    double frameHeight = capture.get(CAP_PROP_FRAME_HEIGHT);
    double fps = capture.get(CAP_PROP_FPS);

    while (IS_CAMERA_ON == 1)
    {
        Mat frame;
        capture >> frame;
        imshow("flutter camera", frame);
        if (waitKey(33) == 27)
        {
            IS_CAMERA_ON = 0;
            break; // ESC 键退出
        }
    }

    // 释放
    capture.release();
    destroyWindow("flutter camera");
}

void FlutterCamera::stopCamera()
{
    IS_CAMERA_ON = 0;
    capture.release();  
}

void FlutterCamera::cameraCallback(void (*refreshUint8List)(int), uchar **encodedOutput)
{
    if (IS_CAMERA_ON == 1)
    {
        cout << "[cpp] camera is on" << endl;
        return;
    }

    capture.open(0, CAP_DSHOW);
    if (!capture.isOpened())
    {
        cerr << "Couldn't open camera." << endl;
        return;
    }

    IS_CAMERA_ON = 1;

    // 设置参数
    capture.set(CAP_PROP_FRAME_WIDTH, 800);  // 宽度
    capture.set(CAP_PROP_FRAME_HEIGHT, 600); // 高度
    capture.set(CAP_PROP_FPS, 15);           // 帧率

    // 查询参数
    double frameWidth = capture.get(CAP_PROP_FRAME_WIDTH);
    double frameHeight = capture.get(CAP_PROP_FRAME_HEIGHT);
    double fps = capture.get(CAP_PROP_FPS);

    while (IS_CAMERA_ON == 1)
    {
        Mat frame;
        capture >> frame;

        vector<uchar> buf;
        cv::imencode(".png", frame, buf); // save output into buf
        *encodedOutput = (unsigned char *)malloc(buf.size());
        for (int i = 0; i < buf.size(); i++)
            (*encodedOutput)[i] = buf[i];
        refreshUint8List((int)buf.size());
    }
}

int FlutterCamera::getImage(uchar **encodedOutput)
{
    if (IS_CAMERA_ON != 1)
    {
        capture.open(0, CAP_DSHOW);
        if (!capture.isOpened())
        {
            cerr << "Couldn't open camera." << endl;
            return -1;
        }
        IS_CAMERA_ON = 1;
        // 设置参数
        capture.set(CAP_PROP_FRAME_WIDTH, 800);  // 宽度
        capture.set(CAP_PROP_FRAME_HEIGHT, 600); // 高度
        capture.set(CAP_PROP_FPS, 15);           // 帧率

        // 查询参数
        double frameWidth = capture.get(CAP_PROP_FRAME_WIDTH);
        double frameHeight = capture.get(CAP_PROP_FRAME_HEIGHT);
        double fps = capture.get(CAP_PROP_FPS);
        cout << "[cpp] camera is on" << endl;
    }

    try
    {
        Mat frame;
        capture >> frame;
        vector<uchar> buf;
        cv::imencode(".png", frame, buf); // save output into buf
        *encodedOutput = (unsigned char *)malloc(buf.size());
        for (int i = 0; i < buf.size(); i++)
            (*encodedOutput)[i] = buf[i];

        return (int)buf.size();
    }
    catch (const std::exception &e)
    {
        std::cerr << e.what() << '\n';
        return -1;
    }
}

// int FlutterCamera::getImage(uchar **encodedOutput)
// {
//     try
//     {
//         Mat frame(100, 100, CV_8UC3);
//         randu(frame, Scalar(0, 0, 0), Scalar(255, 255, 255));
//         // capture >> frame;
//         cout<<encodedOutput<<endl;
//         cvtColor(frame, frame, COLOR_BGR2RGBA);     
//         vector<uchar> buf;
//         cv::imencode(".png", frame, buf); // save output into buf
//         *encodedOutput = (unsigned char *)malloc(buf.size());
//         for (int i = 0; i < buf.size(); i++)
//             (*encodedOutput)[i] = buf[i];

//         return (int)buf.size();
//     }
//     catch (const std::exception &e)
//     {
//         std::cerr << e.what() << '\n';
//         return -1;
//     }
// }
