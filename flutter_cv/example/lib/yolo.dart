// ignore_for_file: avoid_init_to_null

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cv/lib.dart';

import 'utils.dart';

class YoloV3Form extends StatefulWidget {
  const YoloV3Form({super.key});

  @override
  State<YoloV3Form> createState() => _YoloV3FormState();
}

class _YoloV3FormState extends State<YoloV3Form> {
  late String? imagePath = "";
  late Uint8List? imageData = null;
  bool _isWorking = false;

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
      _isWorking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(Icons.chevron_left),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          _isWorking
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: 500,
                  height: 400,
                  child: imageData == null ? null : Image.memory(imageData!),
                ),
          ElevatedButton(
            onPressed: yolov3_2,
            child: const Text('yolov3'),
          ),
        ],
      ),
    );
  }
}
