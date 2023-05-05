import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ffi/ffi.dart';
import 'package:tuple/tuple.dart';

class ImageUtils {
  ImageUtils._();

  static Future<Tuple2<int, int>?> getImageSize(Uint8List imgData) async {
    try {
      final codec = await ui.instantiateImageCodec(imgData);
      final image = await codec.getNextFrame().then((value) => value.image);
      return Tuple2(image.width, image.height);
    } catch (_) {
      return null;
    }
  }
}

extension Uint8ListBlobConversion on Uint8List {
  Pointer<Uint8> allocatePointer() {
    final blob = calloc<Uint8>(length);
    final blobBytes = blob.asTypedList(length);
    blobBytes.setAll(0, this);
    return blob;
  }
}
