#include <dlib/opencv.h>
#include <opencv2/opencv.hpp>
#include <dlib/image_processing/frontal_face_detector.h>
#include <dlib/image_processing/render_face_detections.h>
#include <dlib/image_processing.h>

using namespace dlib;

static frontal_face_detector detector = get_frontal_face_detector();

class BeautyImage
{
private:
    /* data */
public:
    shape_predictor pose_model;
    cv::Mat result;
    BeautyImage(/* args */);
    ~BeautyImage();
    void detectPoints(char *filename);
};

BeautyImage::BeautyImage(/* args */)
{
    deserialize("D:/github_repo/flutter_windows_opencv/windows_dlib/model/shape_predictor_68_face_landmarks.dat") >> pose_model;
}

BeautyImage::~BeautyImage()
{
}

void BeautyImage::detectPoints(char *filename)
{
    result = cv::imread(filename);
    if (result.empty())
    {
        return;
    }
    cv_image<bgr_pixel> cimg(result);
    std::vector<rectangle> faces = detector(cimg);
    // Find the pose of each face.
    std::vector<full_object_detection> shapes;
    for (unsigned long i = 0; i < faces.size(); ++i)
        shapes.push_back(pose_model(cimg, faces[i]));

    if (!shapes.empty())
    {
        for (int i = 0; i < 68; i++)
        {
            circle(result, cvPoint(shapes[0].part(i).x(), shapes[0].part(i).y()), 3, cv::Scalar(0, 0, 255), -1);
            //	shapes[0].part(i).x();//68个
        }
    }
}
