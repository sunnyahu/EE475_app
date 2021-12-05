import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:pill_pal/blue/data/packets.dart';

void startScanner() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }
    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }
    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });

  // bring service to foreground
  service.setForegroundMode(true);
  final fb = FlutterReactiveBle();

  // start broadcasting
  Timer.periodic(const Duration(seconds: 8), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
        title: "PillPal Scanning Service",
        content: "Scanning for your PillPal Bottles");
    final scan =
        fb.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency);
    final sub = scan.listen(null);
    bool scanned = false;
    List<PillPacket> results = [];
    sub.onData((result) {
      scanned = true;
      if (PillPacket.isPillPalPacket(result)) {
        results.add(PillPacket(result));
      }
    });
    sub.onDone(() {
      print(results);
      print(scanned);
      service.sendData({"devices": results});
    });
    sub.onError((error) {
      print(error);
      timer.cancel();
    });
  });
}


// class ScanTask extends TaskHandler {
//   @override
//   Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
//     WidgetsFlutterBinding.ensureInitialized();
//     // final service = FlutterBackgroundService();
//     final fb = FlutterReactiveBle();

//     // start broadcasting
//     Timer.periodic(const Duration(seconds: 8), (timer) async {
//       FlutterForegroundTask.updateService(
//           notificationTitle: "PillPal",
//           notificationText: "Scanning for your devices");
//       final scan = fb.scanForDevices(withServices: []);
//       final sub = scan.listen(null);
//       bool scanned = false;
//       List<PillPacket> results = [];
//       sub.onData((result) {
//         scanned = true;
//         if (PillPacket.isPillPalPacket(result)) {
//           // print(result);
//           results.add(PillPacket(result));
//         }
//       });
//       sub.onDone(() {
//         print(results);
//         print(scanned);
//         // sendPort?.send(results);
//       });
//       sub.onError((error) {
//         print(error);
//         timer.cancel();
//       });
//     });
//   }

//   @override
//   Future<void> onDestroy(DateTime timestamp) async {}

//   @override
//   Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {}
// }
