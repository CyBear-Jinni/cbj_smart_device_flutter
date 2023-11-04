import 'dart:convert';
import 'dart:typed_data';
import "dart:ui" as ui;

import 'package:cbj_smart_device/application/usecases/smart_server_u/smart_server_u.dart';
import 'package:cbj_smart_device_flutter/presentation/client/smart_device_client.dart';
import 'package:flutter/material.dart';

class ImageStreamPage extends StatefulWidget {
  const ImageStreamPage({super.key});

  @override
  State<ImageStreamPage> createState() => _ImageStreamPageState();
}

class _ImageStreamPageState extends State<ImageStreamPage> {
  SmartDeviceClient smartDeviceClient = SmartDeviceClient();
  ui.Image? image;

  Future videoStream() async {
    await smartDeviceClient.createStreamWithSmartDevice('192.168.31.75', 50054);

    print('Listen to Stream');

    ClientRequestsToSmartDeviceServer.steam.listen((event) {
      print('Element from stream $event');
    });

    SmartDeviceServerRequestsToSmartDeviceClient.steam.stream
        .listen((value) async {
      print(
          'Value from Stream ${value.allRemoteCommands.smartDeviceInfo.stateMassage}');
      List<int> bytes = json
          .decode(value.allRemoteCommands.smartDeviceInfo.stateMassage)
          .cast<int>();
      Uint8List ulist = Uint8List.fromList(bytes.toList());

      ui.Codec codec = await ui.instantiateImageCodec(ulist);
      ui.FrameInfo frame = await codec.getNextFrame();
      if (!mounted) {
        return;
      }
      setState(() {
        image = frame.image;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    videoStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Stream'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          TextButton(
            onPressed: () {},
            child: const Text('This is image steam'),
          ),
          if (image != null)
            Expanded(
              child: RawImage(
                image: image,
                fit: BoxFit.scaleDown,
              ),
            ),
        ],
      ),
    );
  }
}
