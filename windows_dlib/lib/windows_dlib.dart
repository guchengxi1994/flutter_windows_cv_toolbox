import 'dart:typed_data';

import 'windows_dlib_platform_interface.dart';

class WindowsDlib {
  Future<String?> getPlatformVersion() {
    return WindowsDlibPlatform.instance.getPlatformVersion();
  }

  Future dlibTest() async {
    return WindowsDlibPlatform.instance.dlibTest();
  }

  Future<Uint8List?> facePointsDetection(String f) async {
    return WindowsDlibPlatform.instance.facePointsDetection(f);
  }
}
