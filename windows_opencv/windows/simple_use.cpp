
#pragma warning(disable : 4702)
#include <opencv2/opencv.hpp>
#include <fstream>

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

// blur
#include "tools/img_blur/image_blur.cpp"
// sharpen
#include "tools/sharpen/sharpen.cpp"
// filters
#include "tools/filter/filter.cpp"

using namespace cv;
using namespace std;

extern "C"
{
    FUNCTION_ATTRIBUTE
    int32_t opencv_img_pixels(unsigned char *byteData, int32_t byteSize)
    {
        Mat src, dst;

        vector<unsigned char> ImVec(byteData, byteData + byteSize);
        src = imdecode(ImVec, IMREAD_COLOR);
        if (src.empty())
        {
            printf(" Error opening image\n");
            return -1;
        }

        return (int32_t)src.total();
    }

    FUNCTION_ATTRIBUTE
    int read_image(char *inputImagePath, uchar **encodedOutput)
    {
        cv::Mat res = cv::imread(inputImagePath);
        vector<uchar> buf;
        cv::imencode(".png", res, buf); // save output into buf
        *encodedOutput = (unsigned char *)malloc(buf.size());
        for (int i = 0; i < buf.size(); i++)
            (*encodedOutput)[i] = buf[i];
        cout << "[cpp] done" << endl;
        return (int)buf.size();
    }

    FUNCTION_ATTRIBUTE
    void save_image(char *inputImagePath, int h, int w, uint8_t *rawBytes, int length)
    {
        fstream file;
        file.open(inputImagePath, ios::out | ios::binary);
        if (!file.is_open())
        {
            cout << "[cpp] "
                 << "error" << endl;
            return;
        }
        file.write((char *)rawBytes, length);
        file.close();
        cout << "[cpp] done" << endl;
    }

    FUNCTION_ATTRIBUTE
    int image_blur(BlurStruct s, uchar **encodedOutput)
    {
        try
        {
            ImageBlur *blur = new ImageBlur();
            blur->imageBlur(s.filename, s.method, s.kernelSize);
            vector<uchar> buf;
            cv::imencode(".png", blur->result, buf); // save output into buf
            *encodedOutput = (unsigned char *)malloc(buf.size());
            for (int i = 0; i < buf.size(); i++)
                (*encodedOutput)[i] = buf[i];
            cout << "[cpp] done" << endl;
            return (int)buf.size();
        }
        catch (const std::exception &e)
        {
            std::cerr << e.what() << '\n';
            return -1;
        }
    }

    FUNCTION_ATTRIBUTE
    int image_sharpen(char *filename, int method, uchar **encodedOutput)
    {
        try
        {
            Sharpen *s = new Sharpen();
            s->image_sharpen(filename, method);
            vector<uchar> buf;
            cv::imencode(".png", s->result, buf); // save output into buf
            *encodedOutput = (unsigned char *)malloc(buf.size());
            for (int i = 0; i < buf.size(); i++)
                (*encodedOutput)[i] = buf[i];
            cout << "[cpp] done" << endl;
            return (int)buf.size();
        }
        catch (const std::exception &e)
        {
            std::cerr << e.what() << '\n';
            return -1;
        }
    }

    FUNCTION_ATTRIBUTE
    int bilateral_filter(char *filename, BilateralFilterStruct s, uchar **encodedOutput)
    {
        try
        {
            Filter *f = new Filter();
            f->bilateral(filename, s);
            vector<uchar> buf;
            cv::imencode(".png", f->result, buf); // save output into buf
            *encodedOutput = (unsigned char *)malloc(buf.size());
            for (int i = 0; i < buf.size(); i++)
                (*encodedOutput)[i] = buf[i];
            cout << "[cpp] done" << endl;
            return (int)buf.size();
        }
        catch (const std::exception &e)
        {
            std::cerr << e.what() << '\n';
            return -1;
        }
    }
}