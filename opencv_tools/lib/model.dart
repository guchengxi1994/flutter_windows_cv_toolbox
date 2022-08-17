import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:opencv_tools/typedefs/c_function.dart';
import 'package:opencv_tools/typedefs/dart_function.dart';

part './_types.dart';
part './_constants.dart';

class OpencvTools {
  OpencvTools._();

  /// 注册插件
  static final ffi.DynamicLibrary _lib =
      ffi.DynamicLibrary.open("native_opencv_windows_plugin.dll");

  /// 获取当前使用的`opencv`版本号
  static String getOpencvVersion() {
    final VersionFunc versionFunc =
        _lib.lookup<ffi.NativeFunction<CVersionFunc>>('version').asFunction();
    return versionFunc().toDartString();
  }

  /// 将特定字符串盲水印加到图像中
  static String addBlindWatermarkToImage(BlindWatermarkModel model) {
    final AddBlindWaterMarkFunc addBlindWaterMarkFunc = _lib
        .lookup<ffi.NativeFunction<CAddBlindWaterMarkFunc>>(
            'blind_watermark_encode')
        .asFunction();
    final result = addBlindWaterMarkFunc(
            model.imgPath.toNativeUtf8(), model.message.toNativeUtf8())
        .toDartString();
    return result;
  }

  /// 获取特定图像的盲水印
  static String getBlindWatermark(BlindWatermarkModel model) {
    final GetBlindWaterMarkFunc getBlindWaterMarkFunc = _lib
        .lookup<ffi.NativeFunction<CGetBlindWaterMarkFunc>>(
            'blind_watermark_decode')
        .asFunction();
    final result =
        getBlindWaterMarkFunc(model.imgPath.toNativeUtf8()).toDartString();
    return result;
  }

  /// convert color
  static String convertColor(ConvertColorModel model) {
    final ConvertColorFunc convertColorFunc = _lib
        .lookup<ffi.NativeFunction<CConvertColorFunc>>('convert_color')
        .asFunction();
    final result = convertColorFunc(model.imgPath.toNativeUtf8(), model.cvtType)
        .toDartString();
    return result;
  }

  /// yolov3
  static void yolov3Detection(Yolov3Model model) {
    final Yolov3DetectionFunc func = _lib
        .lookup<ffi.NativeFunction<CYolov3DetectionFunc>>("yolov3_detection")
        .asFunction();
    func(model.inputImagePath.toNativeUtf8(), model.modelPath.toNativeUtf8(),
        model.coconamePath.toNativeUtf8(), model.cfgFilePath.toNativeUtf8());
  }
}
