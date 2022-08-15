# include "blind_watermark.h"

/*
 * 功能：
 *      为加快傅里叶变换的速度，优化图像尺寸
 * 参数：
 *      image：原图像
 * 返回值：
 *      cv::Mat：填充后的图像
 * 注意：
 *      该函数会导致生成的图像右边和下边有黑边，因为边界用 0 填充了
 */
cv::Mat BlindWatermark::optimizeImageDim(cv::Mat image) 
{
// 因为不想要黑边使图片好看，所以注释了
# if 0
    cv::Mat padded = cv::Mat();

    // 1 计算需要扩展的行数和列数
    int addPixelRows = cv::getOptimalDFTSize(image.rows);
    int addPixelCols = cv::getOptimalDFTSize(image.cols);

    // 2 扩展面积至最优，边界用 0 填充
    cv::copyMakeBorder(image, padded, 0, addPixelRows - image.rows, 0, addPixelCols - image.cols,
            cv::BORDER_CONSTANT, cv::Scalar::all(0));

    return padded;
#endif

#if 1
    return image;
#endif
}

/*
 * 功能：
 *      分离多通道获取 B 通道（因傅里叶变换只能处理单通道）
 * 参数：
 *      image：多通道原图像
 * 返回值：
 *      cv::Mat：B 通道的图像
 */ 
cv::Mat BlindWatermark::splitSrc(cv::Mat image) 
{
    // 清空 allPlanes
    if (!this->allPlanes.empty()) {
        this->allPlanes.clear();
    }

    // 优化图像尺寸
    cv::Mat optimizeImage = this->optimizeImageDim(image);

    // 分离多通道
    cv::split(optimizeImage, this->allPlanes);

    // 获取 B 通道
    cv::Mat padded = cv::Mat();
    if (this->allPlanes.size() > 1) {
        for (int i = 0; i < this->allPlanes.size(); i++) {
            if (i == 0) {
                padded = this->allPlanes[i];
                break;
            }
        }
    } 
    else {
        padded = image;
    }

    return padded;
}

/*
 * 功能：
 *     对图片进行傅里叶转换并在频域上添加文本
 * 参数：
 *      image：空间域图像
 *      watermarkText：水印文字
 * 返回值：
 *      无
 * 说明：
 *      对 complexImage 进行操作
 */ 
void BlindWatermark::addImageWatermarkWithText(cv::Mat image, string watermarkText)
{
    if (!this->planes.empty()) {
        this->planes.clear();
    }

    // ------------- DFT ------------------------
    // 1 将多通道分为单通道（因为读入的是彩色图）
    cv::Mat padded = this->splitSrc(image);
    padded.convertTo(padded, CV_32F);

    // 2 将单通道扩展至双通道，以接收 DFT 的复数结果
    this->planes.push_back(padded);
    this->planes.push_back(cv::Mat::zeros(padded.size(), CV_32F));
    // 将 planes 数组组合合并成一个多通道 Mat
    cv::merge(this->planes, this->complexImage);

    // 3 进行离散傅里叶变换
    cv::dft(this->complexImage, this->complexImage);
    // ------------- DFT ------------------------

    // 添加文本水印
    cv::Scalar scalar = cv::Scalar(0, 0, 0, 0);
    cv::Point point = cv::Point(40, 40);
    cv::putText(this->complexImage, watermarkText, point, cv::FONT_HERSHEY_DUPLEX, 1.0, scalar);
    cv::flip(this->complexImage, this->complexImage, -1);
    cv::putText(this->complexImage, watermarkText, point, cv::FONT_HERSHEY_DUPLEX, 1.0, scalar);
    cv::flip(this->complexImage, this->complexImage, -1);

    this->planes.clear();
}

/*
 * 功能：
 *      从含隐水印的图像中获取傅里叶变换结果
 * 参数：
 *      image：含隐水印的图像
 * 说明：
 *      对 this->complexImage 进行操作
 */
void BlindWatermark::getImageWatermarkWithText(cv::Mat image) 
{
    // planes 数组中存的通道数若开始不为空，需清空.
    if (!this->planes.empty()) {
        this->planes.clear();
    }

    // ------------- DFT ------------------------
    // 1 将多通道分为单通道（因为读入的是彩色图）
    cv::Mat padded = splitSrc(image);
    padded.convertTo(padded, CV_32F);

    // 2 将单通道扩展至双通道，以接收 DFT 的复数结果
    this->planes.push_back(padded);
    this->planes.push_back(cv::Mat::zeros(padded.size(), CV_32F));
    // 将 planes 合并成一个多通道 Mat
    cv::merge(this->planes, this->complexImage);

    // 3 进行离散傅里叶变换
    cv::dft(this->complexImage, this->complexImage);
    // ------------- DFT ------------------------

    this->planes.clear();
}

/*
 * 功能：
 *      剪切和重分布幅度图象限
 * 参数：
 *      image：幅度图
 * 返回值：
 *      无
 */
void BlindWatermark::shiftDFT(cv::Mat &magnitudeImage) 
{
    // 如果图像的尺寸是奇数的话对图像进行裁剪并重新排列（减去补充部分）
    magnitudeImage = magnitudeImage(cv::Rect(0, 0, magnitudeImage.cols & -2, magnitudeImage.rows & -2));

    // 重新排列图像的象限，使得图像的中心在象限的原点
    int cx = magnitudeImage.cols / 2;
    int cy = magnitudeImage.rows / 2;

    cv::Mat q0 = cv::Mat(magnitudeImage, cv::Rect(0, 0, cx, cy));    // 左上
    cv::Mat q1 = cv::Mat(magnitudeImage, cv::Rect(cx, 0, cx, cy));   // 右上
    cv::Mat q2 = cv::Mat(magnitudeImage, cv::Rect(0, cy, cx, cy));   // 左下
    cv::Mat q3 = cv::Mat(magnitudeImage, cv::Rect(cx, cy, cx, cy));  // 右下

    // 交换象限
    cv::Mat tmp = cv::Mat();

    // 左上与右下交换
    q0.copyTo(tmp);
    q3.copyTo(q0);
    tmp.copyTo(q3);

    // 右上与左下交换
    q1.copyTo(tmp);
    q2.copyTo(q1);
    tmp.copyTo(q2);
}

/*
 * 功能：
 *      优化由 dft 操作产生的图像，使其能显示
 * 参数：
 *      complexImage：傅里叶变换结果
 * 返回值：
 *      cv::Mat：转化的频域图
 */
cv::Mat BlindWatermark::createOptimizedMagnitude(cv::Mat complexImage1) 
{
    vector<cv::Mat> newPlanes;

    // 1 将傅里叶变化结果即复数转换为幅值，转换到对数尺度，即 log(1+sqrt(Re(DFT(I))^2 + Im(DFT(I))^2)
    /* 将多通道数组分离成几个单通道数组，
     * newPlanes[0] = Re(DFT(I), newPlanes[1]=Im(DFT(I))
     * 即 newPlanes[0] 为实部, newPlanes[1] 为虚部
    */
    cv::split(complexImage1, newPlanes);
    // 计算幅值矩阵
    cv::magnitude(newPlanes[0], newPlanes[1], newPlanes[0]);
    cv::Mat mag = newPlanes[0];
    mag += cv::Scalar::all(1);
    // 转换到对数尺度
    cv::log(mag, mag);

    // 2 剪切和重分布幅度图象限
    this->shiftDFT(mag);

    // 3 归一化，用 0 到 255 之间的浮点值将矩阵变换为可视化的图像格式
    mag.convertTo(mag, CV_8UC1);
    cv::normalize(mag, mag, 0, 255, cv::NORM_MINMAX, CV_8UC1);

    return mag;
}

/*
 * 功能：
 *     将频域的图转换为空间域
 * 参数：
 *      complexImage：频域图像
 *      allPlanes：所有通道的图像
 * 返回值：
 *      cv::Mat：空间域的图像
 */ 
cv::Mat BlindWatermark::antitransformImage(cv::Mat complexImage1) 
{
    cv::Mat invDFT = cv::Mat();
    cv::idft(complexImage1, invDFT, cv::DFT_SCALE | cv::DFT_REAL_OUTPUT, 0);
    
    cv::Mat restoredImage = cv::Mat();
    invDFT.convertTo(restoredImage, CV_8U);

    // 合并多通道
    allPlanes.erase(allPlanes.begin());
    allPlanes.insert(allPlanes.begin(), restoredImage);
    cv::Mat lastImage = cv::Mat();
    cv::merge(allPlanes, lastImage);

    planes.clear();

    return lastImage;
}

char* BlindWatermark::enc(char* filename, char* watermarkText)
{
    // 读取图片 
    cv::Mat img1 = cv::imread(filename, cv::IMREAD_COLOR);

    // 加水印
    addImageWatermarkWithText(img1, watermarkText);

    cv::Mat img2 = createOptimizedMagnitude(this->complexImage);
    cv::imwrite("enc_img2.png", img2);

    // 注意该反傅里叶变换的图，需要用 .png 格式保存，如果用 jpg 会导致水印文字丢失
    cv::Mat img3 = antitransformImage(this->complexImage);
    cv::imwrite("enc_img3.png", img3);
    return "enc_img3.png";
}

char* BlindWatermark::dec(char* filename)
{
    // 读取图片 
    cv::Mat img1 = cv::imread(filename, cv::IMREAD_COLOR);

    // 读取图片水印
    getImageWatermarkWithText(img1);

    cv::Mat img2 = createOptimizedMagnitude(this->complexImage);
    cv::imwrite("dec_img2.png", img2);

    cv::Mat img3 = antitransformImage(this->complexImage);
    cv::imwrite("dec_img3.png", img3);
    return "dec_img2.png";
}