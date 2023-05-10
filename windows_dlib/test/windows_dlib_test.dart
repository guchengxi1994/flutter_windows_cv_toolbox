import 'package:flutter_test/flutter_test.dart';
import 'package:windows_dlib/windows_dlib.dart';
import 'package:windows_dlib/windows_dlib_platform_interface.dart';
import 'package:windows_dlib/windows_dlib_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWindowsDlibPlatform
    with MockPlatformInterfaceMixin
    implements WindowsDlibPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future dlibTest() {
    // TODO: implement dlibTest
    throw UnimplementedError();
  }
}

void main() {
  final WindowsDlibPlatform initialPlatform = WindowsDlibPlatform.instance;

  test('$MethodChannelWindowsDlib is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWindowsDlib>());
  });

  test('getPlatformVersion', () async {
    WindowsDlib windowsDlibPlugin = WindowsDlib();
    MockWindowsDlibPlatform fakePlatform = MockWindowsDlibPlatform();
    WindowsDlibPlatform.instance = fakePlatform;

    expect(await windowsDlibPlugin.getPlatformVersion(), '42');
  });
}
