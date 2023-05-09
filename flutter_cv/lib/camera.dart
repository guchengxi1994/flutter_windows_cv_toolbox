import 'package:flutter_cv/typedefs/c_function.dart';
import 'package:flutter_cv/typedefs/dart_function.dart';
import 'dart:ffi' as ffi;

class Camera {
  Camera._();

  static startCamera(ffi.DynamicLibrary lib) {
    final StartCameraFunc func = lib
        .lookup<ffi.NativeFunction<CStartCameraFunc>>('startCamera')
        .asFunction();
    func();
  }

  static stopCamera(ffi.DynamicLibrary lib) {
    final StopCameraFunc func = lib
        .lookup<ffi.NativeFunction<CStopCameraFunc>>('stopCamera')
        .asFunction();
    func();
  }
}

class CameraStruct extends ffi.Struct {
  @ffi.Int32()
  external int width;
  @ffi.Int32()
  external int height;
  @ffi.Int32()
  external int mode;
  @ffi.Int32()
  external int fps;
}
