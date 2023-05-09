// ignore_for_file: avoid_init_to_null

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cv/lib.dart';

import 'utils.dart';

@Deprecated("only for test")
class InpaintForm extends StatefulWidget {
  const InpaintForm({super.key});

  @override
  State<InpaintForm> createState() => _InpaintFormState();
}

class _InpaintFormState extends State<InpaintForm> {
  late Uint8List? imageData = null;

  Future<void> imageInpaintTest() async {
    File f = File(
        r"D:\github_repo\flutter_windows_opencv\flutter_cv\example\lib\input.jpg");
    File mask = File(
        r"D:\github_repo\flutter_windows_opencv\flutter_cv\example\lib\input-mask.bmp");

    final r = FlutterCV.inpaint(f.readAsBytesSync(), mask.readAsBytesSync());
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
            onPressed: imageInpaintTest,
            child: const Text('image inpaint test'),
          ),
        ],
      ),
    );
  }
}

class InpaintFormV2 extends StatefulWidget {
  const InpaintFormV2({super.key});

  @override
  State<InpaintFormV2> createState() => _InpaintFormV2State();
}

class _InpaintFormV2State extends State<InpaintFormV2> {
  late String? imagePath = null;

  Future<void> imread() async {
    final i = await pickAnImage();

    if (i == null) {
      return;
    }

    setState(() {
      imagePath = i;
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
          Expanded(
              child: imagePath == null
                  ? const SizedBox()
                  : InpaintBoard(
                      filePath: imagePath!,
                    )),
          ElevatedButton(
            onPressed: imread,
            child: const Text('image inpaint test'),
          ),
        ],
      ),
    );
  }
}
