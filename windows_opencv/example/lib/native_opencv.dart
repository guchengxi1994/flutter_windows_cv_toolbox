import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

// C function signatures
typedef _CVersionFunc = ffi.Pointer<Utf8> Function();
typedef _CProcessImageFunc = ffi.Void Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);
typedef _CBlindWaterMarkEncFunc = ffi.Void Function(ffi.Pointer<Utf8>);
typedef _CBlindGetWaterMarkFunc = ffi.Void Function(ffi.Pointer<Utf8>);

// Dart function signatures
typedef _VersionFunc = ffi.Pointer<Utf8> Function();
typedef _ProcessImageFunc = void Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);
typedef _BlindWaterMarkEncFunc = void Function(ffi.Pointer<Utf8>);
typedef _GetBlindWaterMarkFunc = void Function(ffi.Pointer<Utf8>);

// Getting a library that holds needed symbols
ffi.DynamicLibrary _openDynamicLibrary() {
  return ffi.DynamicLibrary.open("native_opencv_windows_plugin.dll");
}

ffi.DynamicLibrary _lib = _openDynamicLibrary();

// Looking for the functions
final _VersionFunc _version =
    _lib.lookup<ffi.NativeFunction<_CVersionFunc>>('version').asFunction();
final _ProcessImageFunc _processImage = _lib
    .lookup<ffi.NativeFunction<_CProcessImageFunc>>('process_image')
    .asFunction();
final _BlindWaterMarkEncFunc _blindWaterMarkEncFunc = _lib
    .lookup<ffi.NativeFunction<_CBlindWaterMarkEncFunc>>(
        'blind_watermark_encode')
    .asFunction();
final _GetBlindWaterMarkFunc _getBlindWaterMarkEncFunc = _lib
    .lookup<ffi.NativeFunction<_CBlindGetWaterMarkFunc>>(
        'blind_watermark_decode')
    .asFunction();

String opencvVersion() {
  return _version().toDartString();
}

/// this is demo
void processImage(ProcessImageArguments args) {
  _processImage(args.inputPath.toNativeUtf8(), args.outputPath.toNativeUtf8());
}

void blindWaterMarkEncode(BlindwatermarkArguments args) {
  _blindWaterMarkEncFunc(args.inputPath.toNativeUtf8());
}

void getBlindWaterMarkEncode(BlindwatermarkArguments args) {
  _getBlindWaterMarkEncFunc(args.inputPath.toNativeUtf8());
}

class ProcessImageArguments {
  final String inputPath;
  final String outputPath;

  ProcessImageArguments(this.inputPath, this.outputPath);
}

class BlindwatermarkArguments {
  final String inputPath;
  BlindwatermarkArguments(this.inputPath);
}
