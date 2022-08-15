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
