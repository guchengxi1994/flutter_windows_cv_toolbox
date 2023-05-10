#include <iostream>
#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

struct BilateralFilterStruct
{
    int kernalSize;
    double color;
    double space;
    bool addWeight;
};

class Filter
{
private:
    /* data */
public:
    Filter(/* args */);
    ~Filter();
    Mat result;
    void bilateral(char *filename, BilateralFilterStruct s)
    {
        cv::Mat src = cv::imread(filename);
        if (src.empty())
        {
            cout << "[c++] image read error" << endl;
            return;
        }
        cv::bilateralFilter(src, result, s.kernalSize, s.color, s.space);
        if (s.addWeight)
        {
            cv::addWeighted(src, 0.3, result, 0.7, 0, result);
        }
    }

    void bilateral(unsigned char *byteData, int32_t byteSize, BilateralFilterStruct s)
    {
        cv::Mat src;
        vector<unsigned char> ImVec(byteData, byteData + byteSize);
        src = cv::imdecode(ImVec, cv::IMREAD_COLOR);
        if (src.empty())
        {
            printf(" Error opening image\n");
            return;
        }
        cv::bilateralFilter(src, result, s.kernalSize, s.color, s.space);
        if (s.addWeight)
        {
            cv::addWeighted(src, 0.3, result, 0.7, 0, result);
        }
    }
};

Filter::Filter(/* args */)
{
}

Filter::~Filter()
{
}
