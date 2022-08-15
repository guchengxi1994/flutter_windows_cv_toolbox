// modified from https://www.cnblogs.com/PikapBai/p/15875524.html

#ifndef CVUTIL_H
#define CVUTIL_H

#include <stdlib.h>
#include <string>
#include <vector>

#include <opencv2/opencv.hpp>

using namespace std;


class CvUtil
{
private:
    cv::Mat complexImage;
    vector<cv::Mat> planes;
    vector<cv::Mat> allPlanes;
    cv::Mat optimizeImageDim(cv::Mat image);
    cv::Mat splitSrc(cv::Mat image);

    void addImageWatermarkWithText(cv::Mat image, string watermarkText);
    void getImageWatermarkWithText(cv::Mat image);

    void shiftDFT(cv::Mat &magnitudeImage);
    cv::Mat createOptimizedMagnitude(cv::Mat complexImage);

    cv::Mat antitransformImage(cv::Mat complexImage);

public:
    void enc(char* filename);
    void dec(char* filename);
    CvUtil(/* args */);
    ~CvUtil();
};

CvUtil::CvUtil(/* args */)
{
}

CvUtil::~CvUtil()
{
}

#endif // CVUTIL_H