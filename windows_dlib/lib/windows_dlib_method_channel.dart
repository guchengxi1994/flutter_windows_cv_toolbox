import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'windows_dlib_platform_interface.dart';

/// An implementation of [WindowsDlibPlatform] that uses method channels.
class MethodChannelWindowsDlib extends WindowsDlibPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('windows_dlib');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
