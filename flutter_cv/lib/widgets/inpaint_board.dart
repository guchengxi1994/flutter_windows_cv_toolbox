// ignore_for_file: avoid_init_to_null

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cv/lib.dart';
import 'package:painter/painter.dart';

class InpaintBoard extends StatefulWidget {
  const InpaintBoard({super.key, required this.filePath});
  final String filePath;

  @override
  State<InpaintBoard> createState() => _InpaintBoardState();
}

class _InpaintBoardState extends State<InpaintBoard> {
  late Uint8List filedata;
  late Uint8List origin;

  @override
  void initState() {
    super.initState();
    filedata = File(widget.filePath).readAsBytesSync();
    origin = File(widget.filePath).readAsBytesSync();
  }

  static PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    controller.drawColor = Colors.white;
    return controller;
  }

  PainterController _controller = _newController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Listener(
                onPointerUp: (event) async {
                  // print("end");
                  PictureDetails? details = _controller.finish();

                  final i = await details.toPNG();

                  final result = FlutterCV.inpaint(filedata, i);
                  setState(() {
                    _controller = _newController();
                    filedata = result;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: MemoryImage(filedata), fit: BoxFit.fitHeight)),
                  child: Painter(_controller),
                ),
              )),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              flex: 1,
              child: Image.memory(
                origin,
                fit: BoxFit.fitWidth,
              ))
        ],
      ),
    );
  }
}
