import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:flutter_cv/typedefs/simple_use/struct.dart';

// dart function signatures

/// get current opencv version
typedef VersionFunc = ffi.Pointer<Utf8> Function();

// imread
typedef ImreadFunc = int Function(
    ffi.Pointer<Utf8> path, ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);

// imsave
typedef ImsaveFunc = void Function(ffi.Pointer<Utf8> path, int height,
    int width, ffi.Pointer<ffi.Uint8> bytes, int length);

// blur
typedef ImageBlur = int Function(ffi.Pointer<ImageBlurStruct> s,
    ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);

// sharpen from filepath
typedef SharpenFromPathFunc = int Function(ffi.Pointer<Utf8> path, int method,
    ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);

// bilateral filter
typedef BilateralFilterFunc = int Function(
    ffi.Pointer<Utf8> path,
    ffi.Pointer<BilateralFilterStruct> s,
    ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);
