import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:ffi' as ffi;

import 'windows_dlib_platform_interface.dart';

typedef CFunc = ffi.Void Function();
typedef Func = void Function();

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
}
