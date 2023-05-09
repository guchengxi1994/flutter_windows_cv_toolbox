import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

/// add a blind watermark to image
/// input1 : file path pointer,
/// input2 : message string pointer,
typedef AddBlindWaterMarkFunc = ffi.Pointer<Utf8> Function(
    ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

/// get a blind watermark from image
/// input1 : file path pointer,
typedef GetBlindWaterMarkFunc = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>);

/// convet color
typedef ConvertColorFunc = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>, int);

/// yolov3
typedef Yolov3DetectionFunc = void Function(
    ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

/// yolov3 with results
typedef Yolov3DetectionWithResultFunc = int Function(
    ffi.Pointer<Utf8>,
    ffi.Pointer<Utf8>,
    ffi.Pointer<Utf8>,
    ffi.Pointer<Utf8>,
    ffi.Pointer<ffi.Pointer<ffi.Uint8>>);

/// poly
typedef LowPolyFunc = void Function(ffi.Pointer<Utf8>);

/// poly image
typedef LowPolyImageFunc = int Function(
    ffi.Pointer<Utf8> path, ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);

/// camera
typedef StartCameraFunc = void Function();

typedef StopCameraFunc = void Function();

/// inpaint
typedef ImageInpaintFunc = int Function(
    ffi.Pointer<ffi.Uint8> input,
    int inLength,
    ffi.Pointer<ffi.Uint8> mask,
    int maskLength,
    ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);
