import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cbj_smart_device_flutter/presentation/home_page.dart';
import 'package:cbj_smart_device_flutter/presentation/server/camera_widget.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isAndroid || Platform.isIOS) {
      cameras = await availableCameras();
    }
  } on CameraException catch (e) {
    print('${e.code} ${e.description}');
  }

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    ),
  );
}
