#include "include/windows_dlib/windows_dlib_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "windows_dlib_plugin.h"

void WindowsDlibPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  windows_dlib::WindowsDlibPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
