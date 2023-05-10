#include <iostream>
#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

static Mat sharpen_4 = (Mat_<char>(3, 3) << 0, -1, 0,
                        -1, 5, -1,
                        0, -1, 0);

static Mat sharpen_8 = (Mat_<char>(3, 3) << -1, -1, -1,
                        -1, 9, -1,
                        -1, -1, -1);

class Sharpen
{
private:
public:
    Sharpen(/* args */);
    ~Sharpen();
    Mat result;

    void image_sharpen(char *filename, int method)
    {
        cv::Mat src = cv::imread(filename);
        if (src.empty())
        {
            cout << "[c++] image read error" << endl;
            return;
        }
        if (method == 4)
        {
            filter2D(src, result, CV_32F, sharpen_4);
        }
        else
        {
            filter2D(src, result, CV_32F, sharpen_8);
        }
        convertScaleAbs(result, result);
    }

    void image_sharpen(unsigned char *byteData,int32_t byteSize, int method)
    {
        cv::Mat src;
        vector<unsigned char> ImVec(byteData, byteData + byteSize);
        src = cv::imdecode(ImVec, cv::IMREAD_COLOR);
        if (src.empty())
        {
            printf(" Error opening image\n");
            return;
        }
        if (method == 4)
        {
            filter2D(src, result, CV_32F, sharpen_4);
        }
        else
        {
            filter2D(src, result, CV_32F, sharpen_8);
        }
        convertScaleAbs(result, result);
    }
};

Sharpen::Sharpen(/* args */)
{
}

Sharpen::~Sharpen()
{
}
