# The Flutter tooling requires that developers have a version of Visual Studio
# installed that includes CMake 3.14 or later. You should not increase this
# version, as doing so will cause the plugin to fail to compile for some
# customers of the plugin.
cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "windows_dlib")
project(${PROJECT_NAME} LANGUAGES CXX)

set(dlib_DIR D:/dlib-19.24)
include_directories(${dlib_DIR})

# get_cmake_property(_variableNames VARIABLES)
# list (SORT _variableNames)
# foreach (_variableName ${_variableNames})
# message(STATUS "${_variableName}=${${_variableName}}")
# endforeach()
# set(CMAKE_BUILD_TYPE "Debug")

set(CMAKE_BUILD_TYPE "Debug")

if(CMAKE_BUILD_TYPE AND(CMAKE_BUILD_TYPE STREQUAL "Debug"))
  message("DEBUG MODE")
  link_directories(
    D:/dlib-19.24/build_gpu/dlib/Debug
  )
else()
  message("RELEASE MODE")
  link_directories(
    D:/dlib-19.24/build_gpu/dlib/Release
  )
endif()

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "windows_dlib_plugin")

set(OpenCV_DIR D:/opencv/opencv/build)
find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})

set(OPENCV_DLL
  $<$<CONFIG:Debug>:${OPENCV_DLL_DEBUG}>
  $<$<CONFIG:Profile>:${OPENCV_DLL_RELEASE}>
  $<$<CONFIG:Release>:${OPENCV_DLL_RELEASE}>
)

get_target_property(OPENCV_DLL_DEBUG opencv_world IMPORTED_LOCATION_DEBUG)
get_target_property(OPENCV_DLL_RELEASE opencv_world IMPORTED_LOCATION_RELEASE)

# Any new source files that you add to the plugin should be added here.
list(APPEND PLUGIN_SOURCES
  "windows_dlib_plugin.cpp"
  "windows_dlib_plugin.h"
)

# Define the plugin library target. Its name must not be changed (see comment
# on PLUGIN_NAME above).
add_library(${PLUGIN_NAME} SHARED
  "include/windows_dlib/windows_dlib_plugin_c_api.h"
  "windows_dlib_plugin_c_api.cpp"
  "simple_use.cpp"
  "face.cpp"
  ${PLUGIN_SOURCES}
)

# Apply a standard set of build settings that are configured in the
# application-level CMakeLists.txt. This can be removed for plugins that want
# full control over build settings.
apply_standard_settings(${PLUGIN_NAME})

# Symbols are hidden by default to reduce the chance of accidental conflicts
# between plugins. This should not be removed; any symbols that should be
# exported should be explicitly exported with the FLUTTER_PLUGIN_EXPORT macro.
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

# Source include directories and library dependencies. Add any plugin-specific
# dependencies here.
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE ${OpenCV_LIBS} flutter flutter_wrapper_plugin dlib)

# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(windows_dlib_bundled_libraries
  ""
  "${_OpenCV_LIB_PATH}/${OpenCV_DLL_NAME}"
  PARENT_SCOPE
)

# message("path: " ${PROJECT_BINARY_DIR}/release/dlib.dll)

if(CMAKE_BUILD_TYPE AND(CMAKE_BUILD_TYPE STREQUAL "Debug"))
  file(COPY "D:/dlib-19.24/build_gpu/dlib/Debug/dlib.lib" DESTINATION ${runner_BINARY_DIR}/Debug)
  file(COPY "D:/dlib-19.24/build_gpu/dlib/Debug/dlib19.24.0_debug_64bit_msvc1933.pdb" DESTINATION ${runner_BINARY_DIR}/Debug)
else()
  file(COPY "D:/dlib-19.24/build_gpu/dlib/Release/dlib.lib" DESTINATION ${runner_BINARY_DIR}/release)
endif()
