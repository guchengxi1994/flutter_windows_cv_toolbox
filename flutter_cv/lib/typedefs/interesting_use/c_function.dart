import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

/// add a blind watermark to image
/// input1 : file path pointer,
/// input2 : message string pointer,
typedef CAddBlindWaterMarkFunc = ffi.Pointer<Utf8> Function(
    ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

/// get a blind watermark from image
/// input1 : file path pointer,
typedef CGetBlindWaterMarkFunc = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>);

/// convert color
typedef CConvertColorFunc = ffi.Pointer<Utf8> Function(
    ffi.Pointer<Utf8>, ffi.Int);

/// yolov3
typedef CYolov3DetectionFunc = ffi.Void Function(
    ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

/// yolov3 with result
typedef CYolov3DetectionWithResultFunc = ffi.Int32 Function(
    ffi.Pointer<Utf8>,
    ffi.Pointer<Utf8>,
    ffi.Pointer<Utf8>,
    ffi.Pointer<Utf8>,
    ffi.Pointer<ffi.Pointer<ffi.Uint8>>);

/// poly
typedef CLowPolyFunc = ffi.Void Function(ffi.Pointer<Utf8>);

/// poly image
typedef CLowPolyImageFunc = ffi.Int32 Function(
    ffi.Pointer<Utf8> path, ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);

/// camera
typedef CStartCameraFunc = ffi.Void Function();

typedef CStopCameraFunc = ffi.Void Function();
