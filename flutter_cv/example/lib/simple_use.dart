// ignore_for_file: avoid_init_to_null

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cv/lib.dart';

import 'utils.dart';

class SimpleUseForm extends StatefulWidget {
  const SimpleUseForm({super.key});

  @override
  State<SimpleUseForm> createState() => _SimpleUseFormState();
}

class _SimpleUseFormState extends State<SimpleUseForm> {
  late String? imagePath = "";
  late Uint8List? imageData = null;

  void showVersion() {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final snackbar = SnackBar(
      content: Text('OpenCV version: ${FlutterCV.getOpencvVersion()}'),
    );

    scaffoldMessenger
      ..removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss)
      ..showSnackBar(snackbar);
  }

  Future<void> imsave() async {
    if (imageData == null) {
      return;
    }

    FlutterCV.imsave(r"image_save_test.png", imageData!,
        height: 675, width: 1200);
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
          SizedBox(
            width: 500,
            height: 400,
            child: imageData == null ? null : Image.memory(imageData!),
          ),
          Wrap(
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
            ],
          )
        ],
      ),
    );
  }
}
