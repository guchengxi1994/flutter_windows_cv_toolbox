// ignore_for_file: avoid_init_to_null

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cv/lib.dart';

import 'utils.dart';

class BlurForm extends StatefulWidget {
  const BlurForm({super.key});

  @override
  State<BlurForm> createState() => _BlurFormState();
}

class _BlurFormState extends State<BlurForm> {
  late String? imagePath = "";
  late Uint8List? imageData = null;

  Future<void> imageBlur1() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }

    final r = FlutterCV.imageBlur(10, "aaa", filename: imagePath!);
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
          ElevatedButton(
            onPressed: imageBlur1,
            child: const Text('image blur'),
          ),
        ],
      ),
    );
  }
}
