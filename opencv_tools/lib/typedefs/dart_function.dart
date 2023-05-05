import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

// dart function signatures

/// get current opencv version
typedef VersionFunc = ffi.Pointer<Utf8> Function();

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

/// poly
typedef LowPolyFunc = void Function(ffi.Pointer<Utf8>);

/// poly image
typedef LowPolyImageFunc = int Function(ffi.Pointer<Utf8> path, int height,
    int width, ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);
