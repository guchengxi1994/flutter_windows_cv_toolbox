// ignore_for_file: avoid_init_to_null

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cv/lib.dart';

import 'utils.dart';

class LowPolyForm extends StatefulWidget {
  const LowPolyForm({super.key});

  @override
  State<LowPolyForm> createState() => _LowPolyFormState();
}

class _LowPolyFormState extends State<LowPolyForm> {
  late String? imagePath = "";
  late Uint8List? imageData = null;

  Future<void> getPolyImage() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }

    final r = FlutterCV.lowPolyImage(imagePath!);
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
            onPressed: getPolyImage,
            child: const Text('image low poly'),
          ),
        ],
      ),
    );
  }
}
