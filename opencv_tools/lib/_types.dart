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
