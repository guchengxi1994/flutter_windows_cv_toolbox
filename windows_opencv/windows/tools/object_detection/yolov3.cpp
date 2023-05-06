#include "yolov3.h"

Yolov3::Yolov3()
{
    confThreshold = 0.5F;
    nmsThreshold = 0.4F;
    inpWidth = 416;
    inpHeight = 416;
}

Net Yolov3::initYolov3(char *modelPath, char *classnamePath, char *configFilePath)
{
    std::string class_names_string = classnamePath;
    std::ifstream class_names_file(class_names_string.c_str());
    if (class_names_file.is_open())
    {
        std::string name = "";
        while (std::getline(class_names_file, name))
        {
            class_names.push_back(name);
        }
    }
    else
    {
        std::cout << "don't open class_names_file!" << endl;
    }
    cv::String modelConfiguration = configFilePath;
    cv::String modelWeights = modelPath;

    cv::dnn::Net net = cv::dnn::readNetFromDarknet(modelConfiguration, modelWeights); //读取网络模型和参数，初始化网络
    std::cout << "Read Darknet..." << std::endl;
    net.setPreferableBackend(cv::dnn::DNN_BACKEND_OPENCV);
    net.setPreferableTarget(cv::dnn::DNN_TARGET_OPENCL_FP16);

    return net;
}

void Yolov3::postProcess(Mat &frame, const vector<Mat> &out)
{
    std::vector<float> confidences;
    std::vector<Rect> boxes;
    std::vector<int> classIds;

    for (int num = 0; num < out.size(); num++)
    {
        double value;
        Point Position;
        //得到每个输出的数据
        float *data = (float *)out[num].data;

        for (int i = 0; i < out[num].rows; i++, data += out[num].cols)
        {
            //得到每个输出的所有类别的分数
            Mat sorces = out[num].row(i).colRange(5, out[num].cols);

            //获取最大得分的值和位置
            minMaxLoc(sorces, 0, &value, 0, &Position);
            if (value > confThreshold)
            {
                // data[0],data[1],data[2],data[3]都是相对于原图像的比例
                int center_x = (int)(data[0] * frame.cols);
                int center_y = (int)(data[1] * frame.rows);
                int width = (int)(data[2] * frame.cols);
                int height = (int)(data[3] * frame.rows);
                int box_x = center_x - width / 2;
                int box_y = center_y - height / 2;

                classIds.push_back(Position.x);
                confidences.push_back((float)value);
                boxes.push_back(Rect(box_x, box_y, width, height));
            }
        }
    }

    //执行非极大值抑制，以消除具有较低置信度的冗余重叠框
    std::vector<int> perfect_indx;
    NMSBoxes(boxes, confidences, confThreshold, nmsThreshold, perfect_indx);
    for (int i = 0; i < perfect_indx.size(); i++)
    {
        int idx = perfect_indx[i];
        Rect box = boxes[idx];
        drawPred(idx, confidences[idx], box.x, box.y, box.x + box.width, box.y + box.height, frame);
    }
}

std::vector<cv::String> Yolov3::getOutputsNames(const Net &net)
{
    static vector<String> names;
    if (names.empty())
    {
        //得到输出层的索引号
        std::vector<int> out_layer_indx = net.getUnconnectedOutLayers();

        //得到网络中所有层的名称
        std::vector<String> all_layers_names = net.getLayerNames();

        //在名称中获取输出层的名称
        names.resize(out_layer_indx.size());
        for (int i = 0; i < out_layer_indx.size(); i++)
        {
            names[i] = all_layers_names[out_layer_indx[i] - 1];
        }
    }
    return names;
}

void Yolov3::drawPred(int classId, float conf, int left, int top, int right, int bottom, Mat &frame)
{
    // Draw a rectangle displaying the bounding box
    rectangle(frame, Point(left, top), Point(right, bottom), Scalar(255, 178, 50), 3);

    // Get the label for the class name and its confidence
    string label = format("%.5f", conf);
    if (!class_names.empty())
    {
        CV_Assert(classId < (int)class_names.size());
        label = class_names[classId] + ":" + label;
    }
    // Display the label at the top of the bounding box
    int baseLine;
    Size labelSize = getTextSize(label, FONT_HERSHEY_SIMPLEX, 0.5, 1, &baseLine);
    top = max(top, labelSize.height);
    rectangle(frame, Point(left, top - round(1.5 * labelSize.height)), Point(left + round(1.5 * labelSize.width), top + baseLine), Scalar(255, 255, 255), FILLED);
    putText(frame, label, Point(left, top), FONT_HERSHEY_SIMPLEX, 0.75, Scalar(0, 0, 0), 1);
}

void Yolov3::runYolov3(Net &net, char *imgPath)
{
    // 从一个帧创建一个4D blob
    cv::Mat blob;

    double start = getTickCount() * 1.0;

    Mat frame = imread(imgPath);

    // 1/255:将图像像素值归一化0到1的目标范围
    // Scalar(0, 0, 0):我们不在此处执行任何均值减法，因此将[0,0,0]传递给函数的mean参数
    blob = cv::dnn::blobFromImage(frame, 1 / 255.0, cv::Size(inpWidth, inpHeight), cv::Scalar(0, 0, 0), true, false);

    // 设置网络的输入
    net.setInput(blob);

    // 运行向前传递以获得输出层的输出
    std::vector<cv::Mat> outs;
    net.forward(outs, getOutputsNames(net)); // forward需要知道它的结束层

    // 以较低的置信度移除边界框
    postProcess(frame, outs); //端到端，输入和输出

    std::cout << "succeed!!!" << std::endl;
    cv::Mat detectedFrame;
    frame.convertTo(detectedFrame, CV_8U);

    double end = getTickCount() * 1.0;

    double time = (end - start) / getTickFrequency() * 1000;

    char runtime[100];
    sprintf_s(runtime, "%.2f", time); // 帧率保留两位小数
    std::string fpsString("Run Time:");
    fpsString = fpsString + runtime + "ms";
    ;                                 // 在"FPS:"后加入帧率数值字符串
                                      //显示帧率
    putText(detectedFrame,            // 图像矩阵
            fpsString,                // string型文字内容
            cv::Point(5, 20),         // 文字坐标，以左下角为原点
            cv::FONT_HERSHEY_SIMPLEX, // 字体类型
            0.5,                      // 字体大小
            cv::Scalar(0, 255, 0));   // 字体颜色
                                      // 显示detectedFrame
    imwrite("C:/Users/xiaoshuyui/Desktop/yolov3.jpg", detectedFrame);
}

cv::Mat Yolov3::runYolov3WithResult(Net &net, char *imgPath)
{
    // 从一个帧创建一个4D blob
    cv::Mat blob;

    double start = getTickCount() * 1.0;

    Mat frame = imread(imgPath);

    // 1/255:将图像像素值归一化0到1的目标范围
    // Scalar(0, 0, 0):我们不在此处执行任何均值减法，因此将[0,0,0]传递给函数的mean参数
    blob = cv::dnn::blobFromImage(frame, 1 / 255.0, cv::Size(inpWidth, inpHeight), cv::Scalar(0, 0, 0), true, false);

    // 设置网络的输入
    net.setInput(blob);

    // 运行向前传递以获得输出层的输出
    std::vector<cv::Mat> outs;
    net.forward(outs, getOutputsNames(net)); // forward需要知道它的结束层

    // 以较低的置信度移除边界框
    postProcess(frame, outs); //端到端，输入和输出

    std::cout << "succeed!!!" << std::endl;
    cv::Mat detectedFrame;
    frame.convertTo(detectedFrame, CV_8U);

    double end = getTickCount() * 1.0;

    double time = (end - start) / getTickFrequency() * 1000;

    char runtime[100];
    sprintf_s(runtime, "%.2f", time); // 帧率保留两位小数
    std::string fpsString("Run Time:");
    fpsString = fpsString + runtime + "ms";
    ;                                 // 在"FPS:"后加入帧率数值字符串
                                      //显示帧率
    putText(detectedFrame,            // 图像矩阵
            fpsString,                // string型文字内容
            cv::Point(5, 20),         // 文字坐标，以左下角为原点
            cv::FONT_HERSHEY_SIMPLEX, // 字体类型
            0.5,                      // 字体大小
            cv::Scalar(0, 255, 0));   // 字体颜色
                                      // 显示detectedFrame
    // imwrite("yolov3.jpg", detectedFrame);
    return detectedFrame;
}

