// import "dart:async";
// import "dart:typed_data";
//
// import "package:burt_network/burt_network.dart";
//
// import "collection.dart";
// import "periodic_timer.dart";
//
// /// Reads from a camera and streams its data and [CameraDetails] to the dashboard.
// ///
// /// This class uses a few timers to keep track of everything:
// /// - `frameTimer` is used to read the camera with an FPS of [CameraDetails.fps]
// /// - `fpsTimer` reports the FPS using [LoggerUtils.debug]
// /// - `statusTimer` to periodically send the camera's status to the dashboard
// ///
// /// To use this class,
// /// - Call [init] to initialize the camera and [dispose] when you're finished
// /// - Use [isRunning] and [details] to see the state of the camera
// /// - Use [start] and [stop] to control whether the camera is running
// /// - Call [updateDetails] when you want to update the camera's [CameraDetails]
// ///
// /// This class does not start itself, and can be started and stopped when the dashboard
// /// connects or disconnects using [VideoCollection.videoServer].
// class CameraManager {
//   /// The native camera object from OpenCV.
//   // final Camera camera;
//
//   /// Holds the current details of the camera.
//   ///
//   /// Use [updateDetails] to change this.
//   final CameraDetails details;
//
//   /// A timer to periodically send the camera status to the dashboard.
//   Timer? statusTimer;
//
//   /// A timer to read from the camera at an FPS given by [details].
//   PeriodicTimer? frameTimer;
//
//   /// A timer to log out the [fpsCount] every 5 seconds using [LoggerUtils.debug].
//   Timer? fpsTimer;
//
//   /// Records how many FPS this camera is actually running at.
//   int fpsCount = 0;
//
//   /// Creates a new manager for the given camera and default details.
//   // CameraManager({required this.camera, required this.details});
//
//   /// Whether the camera is running.
//   bool get isRunning => frameTimer != null;
//
//   /// The name of this camera (where it is on the rover).
//   CameraName get name => details.name;
//
//   /// Initializes the camera but does not call [start].
//   Future<void> init() async {
//     logger.verbose("Initializing camera: ${details.name}");
//     statusTimer = Timer.periodic(
//       const Duration(seconds: 5),
//       (_) => collection.videoServer.sendMessage(VideoData(details: details)),
//     );
//     // if (!camera.isOpened) {
//     //   logger.verbose("Camera $name is not connected");
//     //   updateDetails(CameraDetails(status: CameraStatus.CAMERA_DISCONNECTED));
//     }
//   }
//
//   /// Disposes of the camera and the timers.
//   // void dispose() {
//   //   logger.info("Releasing camera $name");
//   //   camera.dispose();
//   //   frameTimer?.cancel();
//   //   fpsTimer?.cancel();
//   //   statusTimer?.cancel();
//   // }
//
//   /// Starts the camera and timers.
//   void start() {
//     // if (isRunning || details.status != CameraStatus.CAMERA_ENABLED) return;
//     // logger.verbose("Starting camera $name");
//     // final interval = details.fps == 0
//     //     ? Duration.zero
//     //     : Duration(milliseconds: 1000 ~/ details.fps);
//     // // frameTimer = PeriodicTimer(interval, sendFrame);
//     // fpsTimer = Timer.periodic(const Duration(seconds: 5), (_) {
//     //   logger.debug("Camera $name sent ${fpsCount ~/ 5} frames");
//     //   fpsCount = 0;
//     // });
//   }
//
//   /// Cancels all timers and stops reading the camera.
//   void stop() {
//     logger.verbose("Stopping camera $name");
//     frameTimer?.cancel();
//     fpsTimer?.cancel();
//     frameTimer = null; // easy way to check if you're stopped
//   }
//
//   /// Updates the camera's [details], which will take effect on the next [sendFrame] call.
//   ///
//   /// This function echoes the details to the dashboard as part of the handshake protocol, and
//   /// resets the timers in case the FPS has changed. Always use this function insted of modifying
//   /// [details] directly so these steps are not forgotten.
//   void updateDetails(CameraDetails newDetails) {
//     details.mergeFromMessage(newDetails);
//     collection.videoServer.sendMessage(VideoData(details: details));
//     stop();
//     start();
//   }
//
//   /// Reads a frame from the [camera] and sends it to the dashboard.
//   ///
//   /// - If the camera could not read the frame, sets the status to [CameraStatus.CAMERA_NOT_RESPONDING]
//   /// - If the frame was too large to send, calls [updateDetails] with a lower [CameraDetails.quality]
//   /// - If the quality is already too low, sets the status to [CameraStatus.FRAME_TOO_LARGE]
import 'dart:typed_data';

import 'package:burt_network/burt_network.dart';
import 'package:cbj_smart_device_flutter/infrastructure/from_video/collection.dart';

Future<void> sendFrame(Uint8List? data) async {
  final CameraDetails details = CameraDetails(
    name: CameraName.ROVER_FRONT,
    resolutionWidth: 300,
    resolutionHeight: 300,
    quality: 50,
    fps: 24,
    status: CameraStatus.CAMERA_ENABLED,
  );

  collection.videoServer.sendMessage(VideoData(frame: data, details: details));
}
// }
