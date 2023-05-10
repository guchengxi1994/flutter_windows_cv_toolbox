import 'dart:ffi';
import 'package:ffi/ffi.dart';

class ImageBlurStruct extends Struct {
  factory ImageBlurStruct.allocate(
          String filename, String method, int kernelSize) =>
      calloc<ImageBlurStruct>().ref
        ..filename = filename.toNativeUtf8()
        ..kernelSize = kernelSize
        ..method = method.toNativeUtf8();

  external Pointer<Utf8> filename;

  external Pointer<Utf8> method;

  @Int32()
  external int kernelSize;
}

class BilateralFilterStruct extends Struct {
  @Int32()
  external int kernalSize;

  @Bool()
  external bool addWeight;

  @Double()
  external double color;

  @Double()
  external double space;
}
