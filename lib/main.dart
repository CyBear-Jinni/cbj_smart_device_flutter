import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cbj_smart_device_flutter/commands/flutter_commands.dart';
import 'package:cbj_smart_device_flutter/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:network_tools_flutter/network_tools_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    PhoneCommandsD();
    final appDocDirectory = await getApplicationDocumentsDirectory();
    await configureNetworkTools(appDocDirectory.path, enableDebugging: true);
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
