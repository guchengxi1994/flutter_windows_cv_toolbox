import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

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
