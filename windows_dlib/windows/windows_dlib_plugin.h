#ifndef FLUTTER_PLUGIN_WINDOWS_DLIB_PLUGIN_H_
#define FLUTTER_PLUGIN_WINDOWS_DLIB_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace windows_dlib {

class WindowsDlibPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  WindowsDlibPlugin();

  virtual ~WindowsDlibPlugin();

  // Disallow copy and assign.
  WindowsDlibPlugin(const WindowsDlibPlugin&) = delete;
  WindowsDlibPlugin& operator=(const WindowsDlibPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace windows_dlib

#endif  // FLUTTER_PLUGIN_WINDOWS_DLIB_PLUGIN_H_
