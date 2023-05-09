import 'package:flutter/material.dart';
import 'package:flutter_cv/lib.dart';

class SimpleCameraForm extends StatefulWidget {
  const SimpleCameraForm({super.key});

  @override
  State<SimpleCameraForm> createState() => _SimpleCameraFormState();
}

class _SimpleCameraFormState extends State<SimpleCameraForm> {
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
      body: const Center(
        child: FlutterCameraWidgetV2(),
      ),
    );
  }
}
