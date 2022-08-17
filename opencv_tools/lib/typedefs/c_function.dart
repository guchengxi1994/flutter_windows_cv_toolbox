import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

// C function signatures

/// get current opencv version
typedef CVersionFunc = ffi.Pointer<Utf8> Function();

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
