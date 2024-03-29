#pragma warning(disable : 4702)
#include <opencv2/opencv.hpp>
#include <chrono>
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

// blind watermark
#include "tools/blind_watermark/blind_watermark.cpp"
// convert color
#include "tools/cvt_color/cvt_color.cpp"
// yolov3
#include "tools/object_detection/yolov3.cpp"
// low_poly
#include "tools/low_poly/low_poly.cpp"

long long int get_now()
{
    return chrono::duration_cast<std::chrono::milliseconds>(
               chrono::system_clock::now().time_since_epoch())
        .count();
}

void platform_log(const char *fmt, ...)
{
    va_list args;
    va_start(args, fmt);
#ifdef __ANDROID__
    __android_log_vprint(ANDROID_LOG_VERBOSE, "ndk", fmt, args);
#elif defined(IS_WIN32)
    char *buf = new char[4096];
    std::fill_n(buf, 4096, '\0');
    _vsprintf_p(buf, 4096, fmt, args);
    OutputDebugStringA(buf);
    delete[] buf;
#else
    vprintf(fmt, args);
#endif
    va_end(args);
}

// Avoiding name mangling
extern "C"
{
    FUNCTION_ATTRIBUTE
    const char *version()
    {
        return CV_VERSION;
    }

    FUNCTION_ATTRIBUTE
    void process_image(char *inputImagePath, char *outputImagePath)
    {
        long long start = get_now();

        Mat input = imread(inputImagePath, IMREAD_GRAYSCALE);
        Mat threshed, withContours;

        vector<vector<Point>> contours;
        vector<Vec4i> hierarchy;

        adaptiveThreshold(input, threshed, 255, ADAPTIVE_THRESH_GAUSSIAN_C, THRESH_BINARY_INV, 77, 6);
        findContours(threshed, contours, hierarchy, RETR_TREE, CHAIN_APPROX_TC89_L1);

        cvtColor(threshed, withContours, COLOR_GRAY2BGR);
        drawContours(withContours, contours, -1, Scalar(0, 255, 0), 4);

        imwrite(outputImagePath, withContours);

        int evalInMillis = static_cast<int>(get_now() - start);
        platform_log("Processing done in %dms\n", evalInMillis);
    }

    FUNCTION_ATTRIBUTE
    char *blind_watermark_encode(char *inputImagePath, char *message)
    {
        BlindWatermark blindWatermark;
        return blindWatermark.enc(inputImagePath, message);
    }

    FUNCTION_ATTRIBUTE
    char *blind_watermark_decode(char *inputImagePath)
    {
        BlindWatermark blindWatermark;
        return blindWatermark.dec(inputImagePath);
    }

    FUNCTION_ATTRIBUTE
    char *convert_color(char *inputImagePath, int cvtType)
    {
        CvtColor cvt;
        return cvt.cvtColor(inputImagePath, cvtType);
    }

    FUNCTION_ATTRIBUTE
    void yolov3_detection(char *inputImagePath, char *modelPath, char *coconamePath, char *cfgFilePath)
    {
        Yolov3 *yolov3 = new Yolov3();
        dnn::Net net = yolov3->initYolov3(modelPath, coconamePath, cfgFilePath);
        yolov3->runYolov3(net, inputImagePath);
    }

    FUNCTION_ATTRIBUTE
    int yolov3_with_result_detection(char *inputImagePath, char *modelPath, char *coconamePath, char *cfgFilePath, uchar **encodedOutput)
    {
        Yolov3 *yolov3 = new Yolov3();
        dnn::Net net = yolov3->initYolov3(modelPath, coconamePath, cfgFilePath);
        cv::Mat res = yolov3->runYolov3WithResult(net, inputImagePath);
        cout << "[cpp] " << res.channels() << endl;
        vector<uchar> buf;
        cv::imencode(".jpg", res, buf); // save output into buf
        *encodedOutput = (unsigned char *)malloc(buf.size());
        for (int i = 0; i < buf.size(); i++)
            (*encodedOutput)[i] = buf[i];
        cout << "[cpp] done" << endl;
        return (int)buf.size();
    }

    FUNCTION_ATTRIBUTE
    int encodeImToPng(int h, int w, uchar *rawBytes, uchar **encodedOutput)
    {
        cv::Mat img = cv::Mat(h, w, CV_8UC3, rawBytes);
        vector<uchar> buf;
        cv::imencode(".jpg", img, buf); // save output into buf
        *encodedOutput = (unsigned char *)malloc(buf.size());
        for (int i = 0; i < buf.size(); i++)
            (*encodedOutput)[i] = buf[i];
        return (int)buf.size();
    }

    FUNCTION_ATTRIBUTE
    void low_poly(char *inputImagePath)
    {
        TriangleStyle t(inputImagePath, 300, 100, 700);
        t.save();
        cv::Mat res = t.result_image;
        cout << "[cpp] done" << endl;
    }

    FUNCTION_ATTRIBUTE
    int low_poly_image(char *inputImagePath, uchar **encodedOutput)
    {
        TriangleStyle t(inputImagePath, 300, 100, 700);
        cv::Mat res = t.result_image;
        vector<uchar> buf;
        cv::imencode(".png", res, buf); // save output into buf
        *encodedOutput = (unsigned char *)malloc(buf.size());
        for (int i = 0; i < buf.size(); i++)
            (*encodedOutput)[i] = buf[i];
        cout << "[cpp] done" << endl;
        return (int)buf.size();
    }

    FUNCTION_ATTRIBUTE
    int image_inpaint(uchar *inputBytes, int32_t inputLength, uchar *maskBytes, int32_t maskLength, uchar **encodedOutput)
    {
        vector<unsigned char> ImVec(inputBytes, inputBytes + inputLength);
        cv::Mat img = cv::imdecode(ImVec, IMREAD_COLOR);
        vector<unsigned char> maskVec(maskBytes, maskBytes + maskLength);
        cv::Mat mask = cv::imdecode(maskVec, IMREAD_GRAYSCALE);
        cv::resize(mask,mask,cv::Size(img.rows,img.cols));
        // cv::imwrite("C:/Users/xiaoshuyui/Desktop/aaaaaaaaaaa.png",mask);
        cv::Mat dst;
        cv::inpaint(img, mask, dst, 3, INPAINT_TELEA);
        vector<uchar> buf;
        cv::imencode(".png", dst, buf); // save output into buf
        *encodedOutput = (unsigned char *)malloc(buf.size());
        for (int i = 0; i < buf.size(); i++)
            (*encodedOutput)[i] = buf[i];
        cout << "[cpp] done" << endl;
        return (int)buf.size();
    }
}