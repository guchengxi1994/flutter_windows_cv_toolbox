#ifndef CVTCOLOR_H
#define CVTCOLOR_H

#include <opencv2/opencv.hpp>

class CvtColor
{
private:
    /* data */
public:
    char* cvtColor(char* filename, int cvtType);
    CvtColor(/* args */);
    ~CvtColor();
};

CvtColor::CvtColor(/* args */)
{
}

CvtColor::~CvtColor()
{
}

#endif // CVTCOLOR_H
