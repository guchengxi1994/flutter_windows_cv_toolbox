#include "cvt_color.h"

char *CvtColor::cvtColor(char *filename, int cvtType)
{
    cv::Mat origin = cv::imread(filename, cv::IMREAD_COLOR);
    cv::Mat dst = cv::Mat();
    cv::cvtColor(origin, dst, cvtType);
    cv::imwrite("result.jpg", dst);
    return "result.jpg";
}
