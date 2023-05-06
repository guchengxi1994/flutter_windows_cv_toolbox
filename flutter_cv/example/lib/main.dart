// ignore_for_file: library_private_types_in_public_api, avoid_init_to_null, avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cv/lib.dart';

const title = 'Flutter CV Example';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isProcessed = false;
  bool _isWorking = false;
  late String? imagePath = "";
  late Uint8List? result = null;

  void showVersion() {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final snackbar = SnackBar(
      content: Text('OpenCV version: ${FlutterCV.getOpencvVersion()}'),
    );

    scaffoldMessenger
      ..removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss)
      ..showSnackBar(snackbar);
  }

  Future<String?> pickAnImage() async {
    return FilePicker.platform.pickFiles(
        dialogTitle: 'Pick an image',
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["jpg", "png"]).then((v) => v?.files.first.path);
  }

  Future<void> blindWatermark() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }
    setState(() {
      _isWorking = true;
    });

    final args =
        BlindWatermarkModel(imgPath: imagePath!, message: "IO, the best");

    // Creating a port for communication with isolate and arguments for entry point
    final port = ReceivePort();
    // Spawning an isolate
    Isolate.spawn<BlindWatermarkModel>(
      FlutterCV.addBlindWatermarkToImage,
      args,
      onError: port.sendPort,
      onExit: port.sendPort,
    );

    // Making a variable to store a subscription in
    late StreamSubscription sub;

    // Listening for messages on port
    sub = port.listen((_) async {
      // Cancel a subscription after message received called
      await sub.cancel();

      setState(() {
        _isProcessed = true;
        _isWorking = false;
      });
    });
  }

  Future<void> getBlindWatermark() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }
    setState(() {
      _isWorking = true;
    });

    // Creating a port for communication with isolate and arguments for entry point
    final port = ReceivePort();
    final args = BlindWatermarkModel(imgPath: imagePath!, message: "");
    // Spawning an isolate
    Isolate.spawn<BlindWatermarkModel>(
      FlutterCV.getBlindWatermark,
      args,
      onError: port.sendPort,
      onExit: port.sendPort,
    );

    // Making a variable to store a subscription in
    late StreamSubscription sub;

    // Listening for messages on port
    sub = port.listen((_) async {
      // Cancel a subscription after message received called
      await sub.cancel();

      setState(() {
        _isProcessed = true;
        _isWorking = false;
      });
    });
  }

  Future<void> cvtColor() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }
    setState(() {
      _isWorking = true;
    });

    // Creating a port for communication with isolate and arguments for entry point
    final port = ReceivePort();
    final args = ConvertColorModel(
        imgPath: imagePath!, cvtType: CvtColor.RGB2HLSFULL /* or 69 */);
    // Spawning an isolate
    Isolate.spawn<ConvertColorModel>(
      FlutterCV.convertColor,
      args,
      onError: port.sendPort,
      onExit: port.sendPort,
    );

    // Making a variable to store a subscription in
    late StreamSubscription sub;

    // Listening for messages on port
    sub = port.listen((_) async {
      // Cancel a subscription after message received called
      await sub.cancel();

      setState(() {
        _isProcessed = true;
        _isWorking = false;
      });
    });
  }

  Future<void> yolov3() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }
    setState(() {
      _isWorking = true;
    });

    // Creating a port for communication with isolate and arguments for entry point
    final port = ReceivePort();
    final args = Yolov3Model(
        cfgFilePath:
            'D:\\github_repo\\flutter_windows_opencv\\windows_opencv\\nn_models\\yolov3.cfg',
        coconamePath:
            'D:\\github_repo\\flutter_windows_opencv\\windows_opencv\\nn_models\\coco_names.txt',
        inputImagePath: imagePath!,
        modelPath:
            'D:\\github_repo\\flutter_windows_opencv\\windows_opencv\\nn_models\\yolov3.weights');
    // Spawning an isolate
    Isolate.spawn<Yolov3Model>(
      FlutterCV.yolov3Detection,
      args,
      onError: port.sendPort,
      onExit: port.sendPort,
    );

    // Making a variable to store a subscription in
    late StreamSubscription sub;

    // Listening for messages on port
    sub = port.listen((_) async {
      // Cancel a subscription after message received called
      await sub.cancel();

      setState(() {
        File f = File("C:/Users/xiaoshuyui/Desktop/yolov3.jpg");
        imageData = f.readAsBytesSync();
        _isProcessed = true;
        _isWorking = false;
      });
    });
  }

  Future<void> yolov3_2() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }
    setState(() {
      _isWorking = true;
    });

    // Creating a port for communication with isolate and arguments for entry point
    final args = Yolov3Model(
        cfgFilePath:
            'D:\\github_repo\\flutter_windows_opencv\\windows_opencv\\nn_models\\yolov3.cfg',
        coconamePath:
            'D:\\github_repo\\flutter_windows_opencv\\windows_opencv\\nn_models\\coco_names.txt',
        inputImagePath: imagePath!,
        modelPath:
            'D:\\github_repo\\flutter_windows_opencv\\windows_opencv\\nn_models\\yolov3.weights');
    final r = await compute(FlutterCV.yolov3WithResultDetection, args);

    setState(() {
      imageData = r;
      _isProcessed = true;
      _isWorking = false;
    });
  }

  Future<void> getPixes() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }
    File f = File(imagePath!);
    final fileData = await f.readAsBytes();

    final r = FlutterCV.imagePixesUint8List(fileData);
    print(r);
  }

  Uint8List? imageData = null;

  Future<void> imsave() async {
    if (imageData == null) {
      return;
    }

    FlutterCV.imsave(r"C:\Users\xiaoshuyui\Desktop\tupiantest.png", imageData!,
        height: 675, width: 1200);
  }

  Future<void> getEncodedLength() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }
    File f = File(imagePath!);
    final fileData = await f.readAsBytes();

    final r = FlutterCV.encodeImgToPng(fileData);
    imageData = r;
    setState(() {});
  }

  Future<void> lowPoly() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }

    FlutterCV.lowPoly(imagePath!);
  }

  Future<void> getPolyImage() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }

    final r = FlutterCV.lowPolyImage(imagePath!);
    imageData = r;
    setState(() {});
  }

  Future<void> imageBlur1() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }

    final r = FlutterCV.imageBlur(10, "aaa", filename: imagePath!);
    imageData = r;
    setState(() {});
  }

  Future<void> imread() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }

    final r = FlutterCV.imread(imagePath!);
    imageData = r;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(title)),
      body: Stack(
        children: <Widget>[
          Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    ElevatedButton(
                      onPressed: showVersion,
                      child: const Text('Show version'),
                    ),
                    ElevatedButton(
                      onPressed: imread,
                      child: const Text('read image'),
                    ),
                    ElevatedButton(
                      onPressed: imsave,
                      child: const Text('save image'),
                    ),
                    ElevatedButton(
                      onPressed: blindWatermark,
                      child: const Text('Add Blind watermark'),
                    ),
                    ElevatedButton(
                      onPressed: getBlindWatermark,
                      child: const Text('Get blind watermark'),
                    ),
                    ElevatedButton(
                      onPressed: cvtColor,
                      child: const Text('Convert color'),
                    ),
                    ElevatedButton(
                      onPressed: yolov3,
                      child: const Text('yolov3'),
                    ),
                    ElevatedButton(
                      onPressed: yolov3_2,
                      child: const Text('yolov3 2'),
                    ),
                    ElevatedButton(
                      onPressed: getPixes,
                      child: const Text('Get pixes'),
                    ),
                    ElevatedButton(
                      onPressed: getEncodedLength,
                      child: const Text('Get Length'),
                    ),
                    ElevatedButton(
                      onPressed: lowPoly,
                      child: const Text('Low poly'),
                    ),
                    ElevatedButton(
                      onPressed: getPolyImage,
                      child: const Text('Get Low poly'),
                    ),
                    ElevatedButton(
                      onPressed: imageBlur1,
                      child: const Text('blur 1'),
                    ),
                  ],
                ),
                if (imageData != null) Image.memory(imageData!),
              ],
            ),
          ),
          if (_isWorking)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(.7),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          if (result != null)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 3000, maxHeight: 300),
              child: Image.memory(
                result!,
                alignment: Alignment.center,
              ),
            ),
        ],
      ),
    );
  }
}
