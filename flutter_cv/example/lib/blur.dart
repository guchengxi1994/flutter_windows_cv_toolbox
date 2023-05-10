// ignore_for_file: avoid_init_to_null

import 'dart:io';
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

  Future<void> imageSharpen4() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }

    final r = FlutterCV.imageSharpen(4, filename: imagePath);
    imageData = r;
    setState(() {});
  }

  Future<void> imageSharpen8() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }

    final r = FlutterCV.imageSharpen(8, filename: imagePath);
    imageData = r;
    setState(() {});
  }

  Future<void> bilateral() async {
    imagePath = await pickAnImage();

    if (imagePath == null) {
      return;
    }

    final r = FlutterCV.bilateralFilter(filename: imagePath);
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
          Row(
            children: [
              const Text("processed:"),
              SizedBox(
                width: 300,
                height: 300,
                child: imageData == null ? null : Image.memory(imageData!),
              ),
              const Text("origin:"),
              SizedBox(
                width: 300,
                height: 300,
                child: imagePath == null ? null : Image.file(File(imagePath!)),
              )
            ],
          ),
          Expanded(
              child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              ElevatedButton(
                onPressed: imageBlur1,
                child: const Text('image blur'),
              ),
              ElevatedButton(
                onPressed: imageSharpen4,
                child: const Text('image sharpen1'),
              ),
              ElevatedButton(
                onPressed: imageSharpen8,
                child: const Text('image sharpen2'),
              ),
              ElevatedButton(
                onPressed: bilateral,
                child: const Text('image bilateral filter'),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
