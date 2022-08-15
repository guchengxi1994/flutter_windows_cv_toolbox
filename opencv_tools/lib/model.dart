import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:opencv_tools/typedefs/c_function.dart';
import 'package:opencv_tools/typedefs/dart_function.dart';

part './_types.dart';

class OpencvTools {
  OpencvTools._();

  static final ffi.DynamicLibrary _lib =
      ffi.DynamicLibrary.open("native_opencv_windows_plugin.dll");

  static String getOpencvVersion() {
    final VersionFunc versionFunc =
        _lib.lookup<ffi.NativeFunction<CVersionFunc>>('version').asFunction();
    return versionFunc().toDartString();
  }

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

  static String getBlindWatermark(BlindWatermarkModel model) {
    final GetBlindWaterMarkFunc getBlindWaterMarkFunc = _lib
        .lookup<ffi.NativeFunction<CGetBlindWaterMarkFunc>>(
            'blind_watermark_decode')
        .asFunction();
    final result =
        getBlindWaterMarkFunc(model.imgPath.toNativeUtf8()).toDartString();
    return result;
  }
}
