import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

import 'struct.dart';

// C function signatures

/// get current opencv version
typedef CVersionFunc = ffi.Pointer<Utf8> Function();

// imread
typedef CImreadFunc = ffi.Int32 Function(
    ffi.Pointer<Utf8> path, ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);

// imwrite
typedef CImsaveFunc = ffi.Void Function(
    ffi.Pointer<Utf8> path,
    ffi.Int32 height,
    ffi.Int32 width,
    ffi.Pointer<ffi.Uint8> bytes,
    ffi.Int32 length);

// blur
typedef CImageBlur = ffi.Int32 Function(ffi.Pointer<ImageBlurStruct> s,
    ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);

// sharpen from filepath
typedef CSharpenFromPathFunc = ffi.Int32 Function(ffi.Pointer<Utf8> path,
    ffi.Int method, ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);

// bilateral filter
typedef CBilateralFilterFunc = ffi.Int32 Function(
    ffi.Pointer<Utf8> path,
    ffi.Pointer<BilateralFilterStruct> s,
    ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);
