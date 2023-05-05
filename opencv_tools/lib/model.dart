import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:opencv_tools/typedefs/c_function.dart';
import 'package:opencv_tools/typedefs/dart_function.dart';
import 'package:opencv_tools/utils.dart';

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

  /// low poly
  static void lowPoly(String s) {
    final LowPolyFunc func =
        _lib.lookup<ffi.NativeFunction<CLowPolyFunc>>("low_poly").asFunction();
    func(s.toNativeUtf8());
  }

  /// pixes
  ///
  /// https://github.com/khaifunglim97/flutter_ffi_examples/blob/master/example/lib/main.dart
  static final _opencvImgPixelsPtr = _lib.lookup<
      ffi.NativeFunction<
          ffi.Int32 Function(
              ffi.Pointer<ffi.Uint8>, ffi.Int32)>>('opencv_img_pixels');

  static final opencvImgPixels = _opencvImgPixelsPtr
      .asFunction<int Function(ffi.Pointer<ffi.Uint8>, int)>();

  static int imagePixesBytedata(ByteData bytesData) {
    Uint8List preOpencvPixels = bytesData.buffer
        .asUint8List(bytesData.offsetInBytes, bytesData.lengthInBytes);
    final preOpencvPtr = preOpencvPixels.allocatePointer();
    int result = opencvImgPixels(preOpencvPtr, preOpencvPixels.length);
    calloc.free(preOpencvPtr);
    return result;
  }

  static int imagePixesUint8List(Uint8List list) {
    final preOpencvPtr = list.allocatePointer();
    int result = opencvImgPixels(preOpencvPtr, list.length);
    calloc.free(preOpencvPtr);
    return result;
  }

  /// encode test
  ///
  /// https://levelup.gitconnected.com/building-a-flutter-computer-vision-app-using-dart-ffi-opencv-and-tensorflow-part-2-81472b4ac380
  static late int Function(int height, int width, ffi.Pointer<ffi.Uint8> bytes,
      ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput) encodeIm;

  static Uint8List encodeImgToPng(Uint8List list) {
    encodeIm = _lib
        .lookup<
                ffi.NativeFunction<
                    ffi.Int32 Function(
                        ffi.Int32 height,
                        ffi.Int32 width,
                        ffi.Pointer<ffi.Uint8> bytes,
                        ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput)>>(
            'encodeImToPng')
        .asFunction();

    ffi.Pointer<ffi.Uint8> bytesPtr = malloc.allocate(list.length);
    ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedImPtr = malloc.allocate(8);
    bytesPtr.asTypedList(list.length).setAll(0, list);

    int encodedImgLen = encodeIm(500, 500, bytesPtr, encodedImPtr);
    ffi.Pointer<ffi.Uint8> cppPointer = encodedImPtr.elementAt(0).value;
    Uint8List encodedImBytes = cppPointer.asTypedList(encodedImgLen);
    // malloc.free(bytesPtr);
    // malloc.free(cppPointer);
    // malloc.free(encodedImPtr);
    return encodedImBytes;
  }

  static Uint8List lowPolyImage(String path,
      {int width = 800, int height = 600}) {
    final LowPolyImageFunc func = _lib
        .lookup<ffi.NativeFunction<CLowPolyImageFunc>>("low_poly_image")
        .asFunction();
    ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedImPtr = malloc.allocate(8);
    int length = func(path.toNativeUtf8(), height, width, encodedImPtr);

    ffi.Pointer<ffi.Uint8> cppPointer = encodedImPtr.elementAt(0).value;
    Uint8List encodedImBytes = cppPointer.asTypedList(length);
    return encodedImBytes;
  }
}
