import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:ffi' as ffi;

import 'windows_dlib_platform_interface.dart';

typedef CFunc = ffi.Void Function();
typedef Func = void Function();

typedef CDetectFacePoints = ffi.Int32 Function(
    ffi.Pointer<Utf8> path, ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);
typedef DetectFacePoints = int Function(
    ffi.Pointer<Utf8> path, ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);

/// An implementation of [WindowsDlibPlatform] that uses method channels.
class MethodChannelWindowsDlib extends WindowsDlibPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('windows_dlib');

  static final ffi.DynamicLibrary _lib =
      ffi.DynamicLibrary.open("windows_dlib_plugin.dll");

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future dlibTest() async {
    Func func =
        _lib.lookup<ffi.NativeFunction<CFunc>>("dlib_simple_test").asFunction();
    func();
  }

  @override
  Future<Uint8List?> facePointsDetection(String filename) async {
    ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedImPtr = malloc.allocate(8);
    final DetectFacePoints func = _lib
        .lookup<ffi.NativeFunction<CDetectFacePoints>>("detect_face_points")
        .asFunction();
    final length = func(filename.toNativeUtf8(), encodedImPtr);
    if (length == -1) {
      return null;
    }
    ffi.Pointer<ffi.Uint8> cppPointer = encodedImPtr.elementAt(0).value;
    Uint8List encodedImBytes = cppPointer.asTypedList(length);
    return encodedImBytes;
  }
}
