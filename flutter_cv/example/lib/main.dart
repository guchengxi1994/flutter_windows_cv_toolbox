// ignore_for_file: library_private_types_in_public_api, avoid_init_to_null, avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cv/lib.dart';

import 'blur.dart';
import 'low_poly.dart';
import 'simple_camera.dart';
import 'simple_use.dart';
import 'yolo.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(title)),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Wrap(
          runSpacing: 20,
          spacing: 20,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    return const SimpleUseForm();
                  }));
                },
                child: const Text("simple use")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    return const SimpleCameraForm();
                  }));
                },
                child: const Text("camera")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    return const YoloV3Form();
                  }));
                },
                child: const Text("Yolo")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    return const LowPolyForm();
                  }));
                },
                child: const Text("low poly")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    return const BlurForm();
                  }));
                },
                child: const Text("blur")),
          ],
        ),
      ),
    );
  }
}
