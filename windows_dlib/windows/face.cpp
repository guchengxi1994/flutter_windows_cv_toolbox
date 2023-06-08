#pragma warning(disable : 4458 4459 4127 4456 4189 4018)

#include <opencv2/opencv.hpp>

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32)
#define IS_WIN32
#endif

#ifdef __ANDROID__
#include <android/log.h>
#endif

#ifdef IS_WIN32
#include <windows.h>
#endif

#define MONITOR_ON -1
#define MONITOR_OFF 2
#define MONITOR_STANBY 1

#if defined(__GNUC__)
// Attributes to prevent 'unused' function from being removed and to make it visible
#define FUNCTION_ATTRIBUTE __attribute__((visibility("default"))) __attribute__((used))
#elif defined(_MSC_VER)
// Marking a function for export
#define FUNCTION_ATTRIBUTE __declspec(dllexport)
#endif

#include "face/beauty.cpp"

static BeautyImage *beautyImage = new BeautyImage();

extern "C"
{
    FUNCTION_ATTRIBUTE
    int detect_face_points(char *inputImagePath, uchar **encodedOutput)
    {
        try
        {
            beautyImage->detectPoints(inputImagePath);
            cv::Mat res = beautyImage->result;
            std::vector<uchar> buf;
            cv::imencode(".png", res, buf); // save output into buf
            *encodedOutput = (unsigned char *)malloc(buf.size());
            for (int i = 0; i < buf.size(); i++)
                (*encodedOutput)[i] = buf[i];
            std::cout << "[cpp] done" << std::endl;
            return (int)buf.size();
        }
        catch (const std::exception &e)
        {
            std::cerr << e.what() << '\n';
            return -1;
        }
    }

    FUNCTION_ATTRIBUTE
    int big_eyes(char *inputImagePath, int factor, uchar **encodedOutput)
    {
        try
        {
            beautyImage->bigEyes(inputImagePath, factor);
            cv::Mat res = beautyImage->result;
            std::vector<uchar> buf;
            cv::imencode(".png", res, buf); // save output into buf
            *encodedOutput = (unsigned char *)malloc(buf.size());
            for (int i = 0; i < buf.size(); i++)
                (*encodedOutput)[i] = buf[i];
            std::cout << "[cpp] done" << std::endl;
            return (int)buf.size();
        }
        catch (const std::exception &e)
        {
            std::cerr << e.what() << '\n';
            return -1;
        }
    }

    FUNCTION_ATTRIBUTE
    int thin_face(char *inputImagePath, int factor, uchar **encodedOutput)
    {
        try
        {
            beautyImage->thinFace(inputImagePath, factor);
            cv::Mat res = beautyImage->result;
            std::vector<uchar> buf;
            cv::imencode(".png", res, buf); // save output into buf
            *encodedOutput = (unsigned char *)malloc(buf.size());
            for (int i = 0; i < buf.size(); i++)
                (*encodedOutput)[i] = buf[i];
            std::cout << "[cpp] done" << std::endl;
            return (int)buf.size();
        }
        catch (const std::exception &e)
        {
            std::cerr << e.what() << '\n';
            return -1;
        }
    }

    FUNCTION_ATTRIBUTE
    void lock_screen()
    {
        LockWorkStation();
    }

    FUNCTION_ATTRIBUTE
    void sleep_windows()
    {
        PostMessage(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, MONITOR_OFF);
    }
}