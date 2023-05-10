import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'windows_dlib_method_channel.dart';

abstract class WindowsDlibPlatform extends PlatformInterface {
  /// Constructs a WindowsDlibPlatform.
  WindowsDlibPlatform() : super(token: _token);

  static final Object _token = Object();

  static WindowsDlibPlatform _instance = MethodChannelWindowsDlib();

  /// The default instance of [WindowsDlibPlatform] to use.
  ///
  /// Defaults to [MethodChannelWindowsDlib].
  static WindowsDlibPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WindowsDlibPlatform] when
  /// they register themselves.
  static set instance(WindowsDlibPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future dlibTest();
}
