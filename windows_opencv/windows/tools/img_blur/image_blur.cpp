#include <opencv2/opencv.hpp>
using namespace std;

class ImageBlur
{
private:
    /* data */
public:
    void imageBlur(char *filename, char *method, int kernelSize)
    {
        cv::Mat src = cv::imread(filename);
        if (src.empty())
        {
            cout << "[c++] image read error" << endl;
            return;
        }
        if (strcmp(method, "mean") == 0)
        {
            cv::blur(src, result, cv::Size(kernelSize, kernelSize));
            cout << "[c++] mean blur done" << endl;
        }
        else if (strcmp(method, "median") == 0)
        {
            cv::medianBlur(src, result, kernelSize);
            cout << "[c++] median blur done" << endl;
        }
        else if (strcmp(method, "fast") == 0)
        {
            cv::fastNlMeansDenoisingColored(src, result, 15, 15, kernelSize);
        }
        else if (strcmp(method, "gaussian") == 0)
        {
            cv::GaussianBlur(src, result, cv::Size(kernelSize, kernelSize), 0);
            cout << "[c++] gaussian blur done" << endl;
        }
        else
        {
            cv::blur(src, result, cv::Size(kernelSize, kernelSize));
            cout << "[c++] mean blur done" << endl;
        }
    }

    void imageBlur(char *filename, char *method, int kernelSize, char *savepath)
    {
        cv::Mat src = cv::imread(filename);
        if (src.empty())
        {
            cout << "[c++] image read error" << endl;
            return;
        }
        if (strcmp(method, "mean") == 0)
        {
            cv::blur(src, result, cv::Size(kernelSize, kernelSize));
            cout << "[c++] mean blur done" << endl;
        }
        else if (strcmp(method, "median") == 0)
        {
            cv::medianBlur(src, result, kernelSize);
            cout << "[c++] median blur done" << endl;
        }
        else if (strcmp(method, "fast") == 0)
        {
            cv::fastNlMeansDenoisingColored(src, result, 15, 15, kernelSize);
        }
        else if (strcmp(method, "gaussian") == 0)
        {
            cv::GaussianBlur(src, result, cv::Size(kernelSize, kernelSize), 0);
            cout << "[c++] gaussian blur done" << endl;
        }
        else
        {
            cv::blur(src, result, cv::Size(kernelSize, kernelSize));
            cout << "[c++] mean blur done" << endl;
        }
        cv::imwrite(savepath, result);
    }

    void imageBlur(unsigned char *byteData, int32_t byteSize, char *method, int kernelSize)
    {
        cv::Mat src;
        vector<unsigned char> ImVec(byteData, byteData + byteSize);
        src = cv::imdecode(ImVec, cv::IMREAD_COLOR);
        if (src.empty())
        {
            printf(" Error opening image\n");
            return;
        }
        if (strcmp(method, "mean") == 0)
        {
            cv::blur(src, result, cv::Size(kernelSize, kernelSize));
            cout << "[c++] mean blur done" << endl;
        }
        else if (strcmp(method, "median") == 0)
        {
            cv::medianBlur(src, result, kernelSize);
            cout << "[c++] median blur done" << endl;
        }
        else if (strcmp(method, "fast") == 0)
        {
            cv::fastNlMeansDenoisingColored(src, result, 15, 15, kernelSize);
        }
        else if (strcmp(method, "gaussian") == 0)
        {
            cv::GaussianBlur(src, result, cv::Size(kernelSize, kernelSize), 0);
            cout << "[c++] gaussian blur done" << endl;
        }
        else
        {
            cv::blur(src, result, cv::Size(kernelSize, kernelSize));
            cout << "[c++] mean blur done" << endl;
        }
    }

    void imageBlur(unsigned char *byteData, int32_t byteSize, char *method, int kernelSize, char *savepath)
    {
        cv::Mat src;
        vector<unsigned char> ImVec(byteData, byteData + byteSize);
        src = cv::imdecode(ImVec, cv::IMREAD_COLOR);
        if (src.empty())
        {
            printf(" Error opening image\n");
            return;
        }
        if (strcmp(method, "mean") == 0)
        {
            cv::blur(src, result, cv::Size(kernelSize, kernelSize));
            cout << "[c++] mean blur done" << endl;
        }
        else if (strcmp(method, "median") == 0)
        {
            cv::medianBlur(src, result, kernelSize);
            cout << "[c++] median blur done" << endl;
        }
        else if (strcmp(method, "fast") == 0)
        {
            cv::fastNlMeansDenoisingColored(src, result, 15, 15, kernelSize);
        }
        else if (strcmp(method, "gaussian") == 0)
        {
            cv::GaussianBlur(src, result, cv::Size(kernelSize, kernelSize), 0);
            cout << "[c++] gaussian blur done" << endl;
        }
        else
        {
            cv::blur(src, result, cv::Size(kernelSize, kernelSize));
            cout << "[c++] mean blur done" << endl;
        }
        cv::imwrite(savepath, result);
    }

    cv::Mat result;
    ImageBlur(/* args */);
    ~ImageBlur();
};

ImageBlur::ImageBlur(/* args */)
{
}

ImageBlur::~ImageBlur()
{
}

struct BlurStruct
{
    char *filename;
    char *method;
    int kernelSize;
};
