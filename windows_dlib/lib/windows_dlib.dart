import 'windows_dlib_platform_interface.dart';

class WindowsDlib {
  Future<String?> getPlatformVersion() {
    return WindowsDlibPlatform.instance.getPlatformVersion();
  }

  Future dlibTest() async {
    return WindowsDlibPlatform.instance.dlibTest();
  }
}
