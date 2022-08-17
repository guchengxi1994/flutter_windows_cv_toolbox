#pragma warning(disable:4244)
#ifndef YOLOV3_H
#define YOLOV3_H
#include <vector>
#include <fstream>
#include <sstream>
#include <iostream>
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;
using namespace dnn;
using namespace cuda;

class Yolov3
{
private:
    /* data */
    vector<cv::String> class_names;// Class Name
    float confThreshold; // Confidence threshold
    float nmsThreshold;  //Non - maximum suppression threshold
	int inpWidth;        // Width of network's input image
	int inpHeight;       // Height of network's input image
public:
    Yolov3(/* args */);
    ~Yolov3();
    Net initYolov3(char* modelPath,char* classnamePath,char* configFilePath);
    void postProcess(Mat& frame,const vector<Mat>& out);
    vector<cv::String> getOutputsNames(const Net& net);
    void runYolov3(Net& net, char* imgPath);
    void drawPred(int classId, float conf, int left, int top, int right, int bottom, Mat& frame);
};



Yolov3::~Yolov3()
{
}


#endif // YOLOV3_H