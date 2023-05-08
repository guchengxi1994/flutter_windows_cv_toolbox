//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <native_opencv_windows/native_opencv_windows_plugin.h>
#include <texture_rgba_renderer/texture_rgba_renderer_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  NativeOpencvWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("NativeOpencvWindowsPlugin"));
  TextureRgbaRendererPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("TextureRgbaRendererPluginCApi"));
}
