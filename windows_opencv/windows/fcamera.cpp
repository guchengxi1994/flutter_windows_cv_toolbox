
#pragma warning(disable : 4702)
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32)
#define IS_WIN32
#endif

#ifdef __ANDROID__
#include <android/log.h>
#endif

#ifdef IS_WIN32
#include <windows.h>
#endif

#if defined(__GNUC__)
// Attributes to prevent 'unused' function from being removed and to make it visible
#define FUNCTION_ATTRIBUTE __attribute__((visibility("default"))) __attribute__((used))
#elif defined(_MSC_VER)
// Marking a function for export
#define FUNCTION_ATTRIBUTE __declspec(dllexport)
#endif

// camera
#include "tools/camera/camera.cpp"

#include <fstream>
#include <opencv2/opencv.hpp>
#pragma once
static FlutterCamera flutterCamera;
#pragma once
static uchar **cameraEncodedOutput;

extern "C"
{
    FUNCTION_ATTRIBUTE
    void startCamera()
    {
        flutterCamera = FlutterCamera();
        flutterCamera.startCamera();
    }

    FUNCTION_ATTRIBUTE
    void stopCamera()
    {
        try
        {
            flutterCamera.stopCamera();
        }
        catch (const std::exception &e)
        {
            std::cerr << e.what() << '\n';
        }
    }

    FUNCTION_ATTRIBUTE
    void initCamera(uchar **encodedOutput)
    {
        cameraEncodedOutput = encodedOutput;
        flutterCamera = FlutterCamera();
        cout << "[cpp] initial camera done" << endl;
    }

    FUNCTION_ATTRIBUTE
    void cameraCallback(void (*refreshUint8List)(int))
    {
        flutterCamera = FlutterCamera();
        cout << "[cpp] camera on" << endl;
        flutterCamera.cameraCallback(refreshUint8List, cameraEncodedOutput);
    }

    FUNCTION_ATTRIBUTE
    int getCameraImage(CameraStruct c)
    {
        return flutterCamera.getImage(cameraEncodedOutput, c.width, c.height, c.fps);
    }
}