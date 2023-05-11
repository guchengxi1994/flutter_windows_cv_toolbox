// ignore_for_file: avoid_init_to_null

import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:windows_dlib/windows_dlib.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _windowsDlibPlugin = WindowsDlib();
  Uint8List? result = null;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _windowsDlibPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    child: Image.file(File(
                        r"C:\Users\xiaoshuyui\Desktop\不常用的东西\realface\47.png")),
                  ),
                  result == null
                      ? const SizedBox(
                          width: 300,
                          height: 300,
                        )
                      : SizedBox(
                          child: Image.memory(result!),
                        ),
                ],
              ),
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(
                  onPressed: () {
                    _windowsDlibPlugin.dlibTest();
                  },
                  child: const Text("test")),
              ElevatedButton(
                  onPressed: () async {
                    result = await _windowsDlibPlugin.facePointsDetection(
                        r"C:\Users\xiaoshuyui\Desktop\不常用的东西\realface\47.png");
                    setState(() {});
                  },
                  child: const Text("test face points detection")),
              ElevatedButton(
                  onPressed: () async {
                    result = await _windowsDlibPlugin.bigEyes(
                        r"C:\Users\xiaoshuyui\Desktop\不常用的东西\realface\47.png",
                        15);
                    setState(() {});
                  },
                  child: const Text("big eyes")),
              ElevatedButton(
                  onPressed: () async {
                    result = await _windowsDlibPlugin.thinFace(
                        r"C:\Users\xiaoshuyui\Desktop\不常用的东西\realface\47.png",
                        30);
                    setState(() {});
                  },
                  child: const Text("thin face")),
            ],
          ),
        ),
      ),
    );
  }
}
