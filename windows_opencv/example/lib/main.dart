// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'native_opencv.dart';

const title = 'Native OpenCV Example';

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

  void showVersion() {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final snackbar = SnackBar(
      content: Text('OpenCV version: ${opencvVersion()}'),
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

  Future<void> takeImageAndProcess() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }

    setState(() {
      _isWorking = true;
    });

    // Creating a port for communication with isolate and arguments for entry point
    final port = ReceivePort();
    final args =
        ProcessImageArguments(imagePath!, "${Directory.current.path}/temp.jpg");
    debugPrint("${Directory.current.path}/temp.jpg");
    // Spawning an isolate
    Isolate.spawn<ProcessImageArguments>(
      processImage,
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

  Future<void> blindWatermark() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }
    setState(() {
      _isWorking = true;
    });

    // Creating a port for communication with isolate and arguments for entry point
    final port = ReceivePort();
    final args = BlindwatermarkArguments(imagePath!);
    // Spawning an isolate
    Isolate.spawn<BlindwatermarkArguments>(
      blindWaterMarkEncode,
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
    final args = BlindwatermarkArguments(imagePath!);
    // Spawning an isolate
    Isolate.spawn<BlindwatermarkArguments>(
      getBlindWaterMarkEncode,
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
                if (_isProcessed && !_isWorking)
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 3000, maxHeight: 300),
                    child: Image.file(
                      File(imagePath!),
                      alignment: Alignment.center,
                    ),
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: showVersion,
                      child: const Text('Show version'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: takeImageAndProcess,
                      child: const Text('Process photo'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: blindWatermark,
                      child: const Text('Blind watermark'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: getBlindWatermark,
                      child: const Text('De blind watermark'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
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
        ],
      ),
    );
  }
}
