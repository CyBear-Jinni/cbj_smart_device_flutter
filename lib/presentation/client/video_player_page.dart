import 'dart:convert';
import 'dart:typed_data';
import "dart:ui" as ui;

import 'package:cbj_smart_device/application/usecases/smart_server_u/smart_server_u.dart';
import 'package:cbj_smart_device_flutter/presentation/client/smart_device_client.dart';
import 'package:flutter/material.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  SmartDeviceClient? smartDeviceClient = SmartDeviceClient();
  ui.Image? image;

  Future videoStream() async {
    await SmartDeviceClient.createStreamWithSmartDevice('192.168.31.75', 50054);

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
        title: const Text('Video Player'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          TextButton(
            onPressed: () {},
            child: const Text('This is video player'),
          ),
          if (image != null)
            Row(
              children: [
                Expanded(child: RawImage(image: image, fit: BoxFit.contain)),
              ],
            ),
        ],
      ),
    );
  }
}
