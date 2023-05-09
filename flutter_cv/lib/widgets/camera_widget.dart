// ignore_for_file: avoid_init_to_null

import 'dart:async';
import 'dart:typed_data';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_cv/cv.dart';

import '../camera.dart';

typedef CInitCamera = ffi.Void Function(
    ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);

typedef InitCamera = void Function(
    ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedOutput);

typedef CFlutterEmbeddingCamera = ffi.Void Function(
    ffi.Pointer<ffi.NativeFunction<ffi.Void Function(ffi.Int32)>>);

typedef FlutterEmbeddingCamera = void Function(
    ffi.Pointer<ffi.NativeFunction<ffi.Void Function(ffi.Int32)>>);

typedef CFlutterGetCameraImage = ffi.Int32 Function(
    ffi.Pointer<CameraStruct> c);

typedef FlutterGetCameraImage = int Function(ffi.Pointer<CameraStruct> c);

@Deprecated("blink")
class FlutterCameraWidget extends StatefulWidget {
  const FlutterCameraWidget({super.key});

  @override
  State<FlutterCameraWidget> createState() => _FlutterCameraWidgetState();
}

class _FlutterCameraWidgetState extends State<FlutterCameraWidget> {
  static final ffi.DynamicLibrary _lib =
      ffi.DynamicLibrary.open("native_opencv_windows_plugin.dll");
  static ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedImPtr = malloc.allocate(8);

  late final FlutterEmbeddingCamera func = _lib
      .lookup<ffi.NativeFunction<CFlutterEmbeddingCamera>>('cameraCallback')
      .asFunction();
  late final InitCamera initCamera =
      _lib.lookup<ffi.NativeFunction<CInitCamera>>('initCamera').asFunction();

  late final FlutterGetCameraImage getImageFromCamera = _lib
      .lookup<ffi.NativeFunction<CFlutterGetCameraImage>>('getCameraImage')
      .asFunction();

  static List<Uint8List> dataList = [];

  @Deprecated("cannot use in an isolate")
  static void getImgData(int length) {
    ffi.Pointer<ffi.Uint8> cppPointer = encodedImPtr.elementAt(0).value;
    Uint8List encodedImBytes = cppPointer.asTypedList(length);
    // print(encodedImBytes.length);
    dataList.add(encodedImBytes);
  }

  static Uint8List getImgData2(int length) {
    ffi.Pointer<ffi.Uint8> cppPointer = encodedImPtr.elementAt(0).value;
    Uint8List encodedImBytes = cppPointer.asTypedList(length);
    return encodedImBytes;
  }

  bool started = false;

  ffi.Pointer<CameraStruct> inAddress = calloc<CameraStruct>()
    ..ref.width = 600
    ..ref.height = 400
    ..ref.mode = 1
    ..ref.fps = 15;

  late final stream =
      Stream<Uint8List?>.periodic(const Duration(milliseconds: 100), (x) {
    if (!started) {
      return null;
    }
    try {
      int length = getImageFromCamera(inAddress);
      if (length == -1) {
        return null;
      }
      final f = getImgData2(length);

      return f;
    } catch (e) {
      return null;
    }
  });

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      initCamera(encodedImPtr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return started == false
        ? Container(
            color: Colors.blueGrey,
            width: 600,
            height: 400,
            child: Center(
              child: InkWell(
                onTap: () async {
                  // func(ffi.Pointer.fromFunction(getImgData));
                  setState(() {
                    started = true;
                  });
                },
                child: const Text("Tap to start"),
              ),
            ),
          )
        : SizedBox(
            width: 600,
            height: 400,
            child: StreamBuilder(
                stream: stream,
                builder: (c, s) {
                  if (s.hasData && s.data != null) {
                    return Image.memory(s.data as Uint8List);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          );
  }
}

class FlutterCameraWidgetV2 extends StatefulWidget {
  const FlutterCameraWidgetV2({super.key});

  @override
  State<FlutterCameraWidgetV2> createState() => _FlutterCameraWidgetV2State();
}

class _FlutterCameraWidgetV2State extends State<FlutterCameraWidgetV2> {
  Uint8List? data = null;
  late ui.Image? image = null;
  Timer? _timer;

  static ffi.Pointer<ffi.Pointer<ffi.Uint8>> encodedImPtr = malloc.allocate(8);

  static final ffi.DynamicLibrary _lib =
      ffi.DynamicLibrary.open("native_opencv_windows_plugin.dll");

  late final FlutterGetCameraImage getImageFromCamera = _lib
      .lookup<ffi.NativeFunction<CFlutterGetCameraImage>>('getCameraImage')
      .asFunction();
  late final InitCamera initCamera =
      _lib.lookup<ffi.NativeFunction<CInitCamera>>('initCamera').asFunction();
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      initCamera(encodedImPtr);
    });
  }

  ffi.Pointer<CameraStruct> inAddress = calloc<CameraStruct>()
    ..ref.width = 600
    ..ref.height = 400
    ..ref.mode = 1
    ..ref.fps = 15;

  void start() {
    _timer?.cancel();
    _timer =
        Timer.periodic(const Duration(milliseconds: 1000 ~/ 20), (timer) async {
      int length = getImageFromCamera(inAddress);
      if (length == -1) {
        return;
      }
      ffi.Pointer<ffi.Uint8> cppPointer = encodedImPtr.elementAt(0).value;
      data = cppPointer.asTypedList(length);

      if (data != null && mounted) {
        image = await decodeImageFromList(data!);
        setState(() {});
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    /// FIXME
    ///
    /// a memory leak if setState() is being called
    _timer?.cancel();
    FlutterCV.stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return image == null
        ? Container(
            color: Colors.blueGrey,
            width: 600,
            height: 400,
            child: Center(
              child: InkWell(
                onTap: () async {
                  start();
                },
                child: const Text("Tap to start"),
              ),
            ),
          )
        : SizedBox(
            width: 600,
            height: 400,
            child: CustomPaint(
              painter: CustomImagePainter(image!),
              child: Stack(
                children: [
                  Positioned(
                      right: 20,
                      bottom: 20,
                      child: InkWell(
                        onTap: () async {
                          _timer?.cancel();
                          FlutterCV.stopCamera();
                        },
                        child: Container(
                          color: Colors.white.withOpacity(0.5),
                          width: 150,
                          height: 30,
                          child: const Center(
                            child: Text("Tap to stop"),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          );
  }
}

class CustomImagePainter extends CustomPainter {
  final ui.Image image;

  CustomImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    canvas.drawImage(image, Offset.zero, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      this != oldDelegate;
}
