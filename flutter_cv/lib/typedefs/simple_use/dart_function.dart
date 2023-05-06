import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

// dart function signatures

/// get current opencv version
typedef VersionFunc = ffi.Pointer<Utf8> Function();

// imread
typedef ImreadFunc = int Function(
    ffi.Pointer<Utf8> path, ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);

// imsave
typedef ImsaveFunc = void Function(ffi.Pointer<Utf8> path, int height,
    int width, ffi.Pointer<ffi.Uint8> bytes, int length);
