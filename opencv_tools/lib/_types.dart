part of './model.dart';

class BlindWatermarkModel {
  final String imgPath;
  final String message;
  BlindWatermarkModel({required this.imgPath, this.message = "XiaoShuYuI"});
}

class ConvertColorModel {
  final String imgPath;
  final int cvtType;
  ConvertColorModel({required this.imgPath, required this.cvtType});
}

class Yolov3Model {
  final String inputImagePath;
  final String modelPath;
  final String coconamePath;
  final String cfgFilePath;

  Yolov3Model(
      {required this.cfgFilePath,
      required this.coconamePath,
      required this.inputImagePath,
      required this.modelPath});
}
