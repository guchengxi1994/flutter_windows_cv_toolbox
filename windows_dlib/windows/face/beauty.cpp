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
    std::vector<std::vector<cv::Point2f>> getPoints(cv::Mat mat);
    void LocalTranslationWarp_Eye(cv::Mat &img, cv::Mat &dst, int warpX, int warpY, int endX, int endY, float radius);
    void BilinearInsert(cv::Mat &src, cv::Mat &dst, float ux, float uy, int i, int j);
    cv::Mat LocalTranslationWarp_Face(cv::Mat &img, int warpX, int warpY, int endX, int endY, float radius);

public:
    shape_predictor pose_model;
    cv::Mat result;
    BeautyImage(/* args */);
    ~BeautyImage();
    void detectPoints(char *filename);
    void bigEyes(char *filename, int i);
    void thinFace(char *filename, int b);
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

void BeautyImage::bigEyes(char *filename, int b)
{
    cv::Mat src = cv::imread(filename);
    cv::Mat dst = src.clone();
    std::vector<std::vector<cv::Point2f>> detected = getPoints(src);
    for (auto points_vec : detected)
    {

        cv::Point2f left_landmark = points_vec[38];
        cv::Point2f left_landmark_down = points_vec[27];

        cv::Point2f right_landmark = points_vec[44];
        cv::Point2f right_landmark_down = points_vec[27];

        cv::Point2f endPt = points_vec[30];

        // # 计算第4个点到第6个点的距离作为距离
        /*float r_left = sqrt(
            (left_landmark.x - left_landmark_down.x) * (left_landmark.x - left_landmark_down.x) +
            (left_landmark.y - left_landmark_down.y) * (left_landmark.y - left_landmark_down.y));
        cout << "左眼距离:" << r_left;*/
        float r_left = b;

        //	# 计算第14个点到第16个点的距离作为距离
        // float	r_right = sqrt(
        //	(right_landmark.x - right_landmark_down.x) * (right_landmark.x - right_landmark_down.x) +
        //	(right_landmark.y - right_landmark_down.y) * (right_landmark.y - right_landmark_down.y));
        // cout << "右眼距离:" << r_right;
        float r_right = b;
        //	# 瘦左
        LocalTranslationWarp_Eye(src, dst, left_landmark.x, left_landmark.y, endPt.x, endPt.y, r_left);
        src = dst.clone();
        //	# 瘦右
        LocalTranslationWarp_Eye(src, dst, right_landmark.x, right_landmark.y, endPt.x, endPt.y, r_right);
    }
    result = dst;
}

std::vector<std::vector<cv::Point2f>> BeautyImage::getPoints(cv::Mat mat)
{
    std::cout << "人脸检测开始" << std::endl;
    std::vector<std::vector<cv::Point2f>> rets;
    cv_image<bgr_pixel> cimg(mat);

    std::vector<dlib::rectangle> dets = detector(cimg);

    for (auto var : dets)
    {
        // 定义shape对象保存检测的68个关键点
        full_object_detection shape = pose_model(cimg, var);
        // 读取关键点到容器中
        std::vector<cv::Point2f> points_vec;
        for (int i = 0; i < (int)shape.num_parts(); ++i)
        {
            auto a = shape.part(i);
            cv::Point2f ff(a.x(), a.y());
            points_vec.push_back(ff);
        }
        rets.push_back(points_vec);
    }
    std::cout << "人脸检测结束:" << dets.size() << "张人脸数据" << std::endl;
    return rets;
}

void BeautyImage::LocalTranslationWarp_Eye(cv::Mat &img, cv::Mat &dst, int warpX, int warpY, int endX, int endY, float radius)
{
    // 平移距离
    float ddradius = radius * radius;
    // 计算|m-c|^2
    size_t mc = (endX - warpX) * (endX - warpX) + (endY - warpY) * (endY - warpY);
    // 计算 图像的高  宽 通道数量
    int height = img.rows;
    int width = img.cols;
    int chan = img.channels();

    auto Abs = [&](float f)
    {
        return f > 0 ? f : -f;
    };

    for (int i = 0; i < width; i++)
    {
        for (int j = 0; j < height; j++)
        {
            // # 计算该点是否在形变圆的范围之内
            // # 优化，第一步，直接判断是会在（startX, startY)的矩阵框中
            if ((Abs(i - warpX) > radius) && (Abs(j - warpY) > radius))
                continue;

            float distance = (i - warpX) * (i - warpX) + (j - warpY) * (j - warpY);
            if (distance < ddradius)
            {
                float rnorm = sqrt(distance) / radius;
                float ratio = 1 - (rnorm - 1) * (rnorm - 1) * 0.5;
                // 映射原位置
                float UX = warpX + ratio * (i - warpX);
                float UY = warpY + ratio * (j - warpY);

                // 根据双线性插值得到UX UY的值
                BilinearInsert(img, dst, UX, UY, i, j);
            }
        }
    }
}

void BeautyImage::BilinearInsert(cv::Mat &src, cv::Mat &dst, float ux, float uy, int i, int j)
{
    auto Abs = [&](float f)
    {
        return f > 0 ? f : -f;
    };

    int c = src.channels();
    if (c == 3)
    {
        // 存储图像得浮点坐标
        CvPoint2D32f uv;
        CvPoint3D32f f1;
        CvPoint3D32f f2;

        // 取整数
        int iu = (int)ux;
        int iv = (int)uy;
        uv.x = iu + 1;
        uv.y = iv + 1;

        // step图象像素行的实际宽度  三个通道进行计算(0 , 1 2  三通道)
        f1.x = ((uchar *)(src.data + src.step * iv))[iu * 3] * (1 - Abs(uv.x - iu)) +
               ((uchar *)(src.data + src.step * iv))[(iu + 1) * 3] * (uv.x - iu);
        f1.y = ((uchar *)(src.data + src.step * iv))[iu * 3 + 1] * (1 - Abs(uv.x - iu)) +
               ((uchar *)(src.data + src.step * iv))[(iu + 1) * 3 + 1] * (uv.x - iu);
        f1.z = ((uchar *)(src.data + src.step * iv))[iu * 3 + 2] * (1 - Abs(uv.x - iu)) +
               ((uchar *)(src.data + src.step * iv))[(iu + 1) * 3 + 2] * (uv.x - iu);

        f2.x = ((uchar *)(src.data + src.step * (iv + 1)))[iu * 3] * (1 - Abs(uv.x - iu)) +
               ((uchar *)(src.data + src.step * (iv + 1)))[(iu + 1) * 3] * (uv.x - iu);
        f2.y = ((uchar *)(src.data + src.step * (iv + 1)))[iu * 3 + 1] * (1 - Abs(uv.x - iu)) +
               ((uchar *)(src.data + src.step * (iv + 1)))[(iu + 1) * 3 + 1] * (uv.x - iu);
        f2.z = ((uchar *)(src.data + src.step * (iv + 1)))[iu * 3 + 2] * (1 - Abs(uv.x - iu)) +
               ((uchar *)(src.data + src.step * (iv + 1)))[(iu + 1) * 3 + 2] * (uv.x - iu);

        ((uchar *)(dst.data + dst.step * j))[i * 3] = f1.x * (1 - Abs(uv.y - iv)) + f2.x * (Abs(uv.y - iv)); // 三个通道进行赋值
        ((uchar *)(dst.data + dst.step * j))[i * 3 + 1] = f1.y * (1 - Abs(uv.y - iv)) + f2.y * (Abs(uv.y - iv));
        ((uchar *)(dst.data + dst.step * j))[i * 3 + 2] = f1.z * (1 - Abs(uv.y - iv)) + f2.z * (Abs(uv.y - iv));
    }
}

void BeautyImage::thinFace(char *filename, int b)
{
    cv::Mat src = cv::imread(filename);
    cv::Mat dst = src.clone();

    std::vector<std::vector<cv::Point2f>> detected = getPoints(src);

    for (auto points_vec : detected)
    {
        cv::Point2f endPt = points_vec[34];
        for (int i = 3; i < 15; i = i + 2)
        {
            cv::Point2f start_landmark = points_vec[i];
            cv::Point2f end_landmark = points_vec[i + 2];

            // 计算瘦脸距离
            /*float dis = sqrt(
                (start_landmark.x - end_landmark.x) * (start_landmark.x - end_landmark.x) +
                (start_landmark.y - end_landmark.y) * (start_landmark.y - end_landmark.y));*/
            float dis = b;
            dst = LocalTranslationWarp_Face(dst, start_landmark.x, start_landmark.y, endPt.x, endPt.y, dis);

            /*
            //指定位置
            Point2f left_landmark = points_vec[2];
            Point2f	left_landmark_down = points_vec[5];

            Point2f	right_landmark = points_vec[13];
            Point2f	right_landmark_down = points_vec[15];

            Point2f	endPt = points_vec[30];

            //# 计算第4个点到第6个点的距离作为瘦脸距离
            float r_left = sqrt(
                (left_landmark.x - left_landmark_down.x) * (left_landmark.x - left_landmark_down.x) +
                (left_landmark.y - left_landmark_down.y) * (left_landmark.y - left_landmark_down.y));
            cout << "左边瘦脸距离:" << r_left;


            //	# 计算第14个点到第16个点的距离作为瘦脸距离
            float	r_right = sqrt(
                (right_landmark.x - right_landmark_down.x) * (right_landmark.x - right_landmark_down.x) +
                (right_landmark.y - right_landmark_down.y) * (right_landmark.y - right_landmark_down.y));
            cout << "右边瘦脸距离:" << r_right;
                //	# 瘦左边脸                         源图像   坐标移动点 x           y                  结束点x       y     瘦脸距离
            LocalTranslationWarp(src, dst, left_landmark.x, left_landmark.y, endPt.x, endPt.y, r_left);
            //	# 瘦右边脸
            LocalTranslationWarp(src, dst, right_landmark.x, right_landmark.y, endPt.x, endPt.y, r_right);
            */
        }
    }

    result = dst;
}

cv::Mat BeautyImage::LocalTranslationWarp_Face(cv::Mat &img, int warpX, int warpY, int endX, int endY, float radius)
{
    cv::Mat dst = img.clone();
    // 平移距离
    float ddradius = radius * radius;
    // 计算|m-c|^2
    size_t mc = (endX - warpX) * (endX - warpX) + (endY - warpY) * (endY - warpY);
    // 计算 图像的高  宽 通道数量
    int height = img.rows;
    int width = img.cols;
    int chan = img.channels();

    auto Abs = [&](float f)
    {
        return f > 0 ? f : -f;
    };

    for (int i = 0; i < width; i++)
    {
        for (int j = 0; j < height; j++)
        {
            // # 计算该点是否在形变圆的范围之内
            // # 优化，第一步，直接判断是会在（startX, startY)的矩阵框中
            if ((Abs(i - warpX) > radius) && (Abs(j - warpY) > radius))
                continue;

            float distance = (i - warpX) * (i - warpX) + (j - warpY) * (j - warpY);
            if (distance < ddradius)
            {
                // # 计算出（i, j）坐标的原坐标
                // # 计算公式中右边平方号里的部分
                float ratio = (ddradius - distance) / (ddradius - distance + mc);
                ratio *= ratio;

                // 映射原位置
                float UX = i - ratio * (endX - warpX);
                float UY = j - ratio * (endY - warpY);

                // 根据双线性插值得到UX UY的值
                BilinearInsert(img, dst, UX, UY, i, j);
                // 改变当前的值
            }
        }
    }

    return dst;
}
