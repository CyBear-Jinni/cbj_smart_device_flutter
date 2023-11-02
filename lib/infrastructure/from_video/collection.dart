import "dart:async";

import "package:burt_network/burt_network.dart";

import 'server.dart';

/// Default details for a camera
///
/// Used when first creating the camera objects
CameraDetails getDefaultDetails(CameraName name) => CameraDetails(
      name: name,
      resolutionWidth: 300,
      resolutionHeight: 300,
      quality: 50,
      fps: 24,
      status: CameraStatus.CAMERA_ENABLED,
    );

/// Returns the camera depending on device program is running
// ///
// /// Uses [cameraNames] or [cameraIndexes]
// Camera getCamera(CameraName name) => Platform.isWindows
//     ? Camera.fromIndex(cameraIndexes[name]!)
//     : Camera.fromName(cameraNames[name]!);

/// Class to cotain all video devices
class VideoCollection {
  // /// Holds a list of available cameras
  // Map<CameraName, CameraManager> cameras = {
  //   for (final name in CameraName.values)
  //     if (name != CameraName.CAMERA_NAME_UNDEFINED)
  //       name: CameraManager(
  //         camera: getCamera(name),
  //         details: getDefaultDetails(name),
  //       )
  // };

  /// [VideoServer] to send messages through
  ///
  /// Default port is 8002 for video
  final videoServer = VideoServer(port: 8002);

  /// Function to initiliaze cameras
  Future<void> init() async {
    await videoServer.init();
    // for (final camera in cameras.values) {
    //   await camera.init();
    // }
    logger.info("Video program initialized");
  }
}

/// Holds all the devices connected
final collection = VideoCollection();
