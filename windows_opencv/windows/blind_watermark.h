// modified from https://www.cnblogs.com/PikapBai/p/15875524.html

#ifndef BLINDWATERMARK_H
#define BLINDWATERMARK_H

#include <stdlib.h>
#include <string>
#include <vector>

#include <opencv2/opencv.hpp>

using namespace std;


class BlindWatermark
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
    char* enc(char* filename,char* watermarkText);
    char* dec(char* filename);
    BlindWatermark(/* args */);
    ~BlindWatermark();
};

BlindWatermark::BlindWatermark(/* args */)
{
}

BlindWatermark::~BlindWatermark()
{
}

#endif // BLINDWATERMARK_H