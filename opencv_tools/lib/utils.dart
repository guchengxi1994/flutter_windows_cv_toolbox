import 'dart:typed_data';
import 'dart:ui' as ui;

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
