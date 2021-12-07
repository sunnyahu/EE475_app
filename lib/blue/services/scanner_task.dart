import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:pill_pal/blue/data/packets.dart';
import 'package:pill_pal/notifications/services/notifs.dart';

void startScanner() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  service.onDataReceived.listen((event) {
    if (event!["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });

  // bring service to foreground
  service.setForegroundMode(true);
  final fb = FlutterReactiveBle();
  var controller = StreamController<Set<PillPacket>>();

  // start broadcasting
  Timer.periodic(const Duration(seconds: 8), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
        title: "PillPal Scanning Service",
        content: "Scanning for your PillPal Bottles");
    final scan =
        fb.scanForDevices(withServices: [], scanMode: ScanMode.lowPower);
    final sub = scan.listen(null);
    // bool scanned = false;
    HashSet<PillPacket> results = HashSet();
    sub.onData((result) {
      // scanned = true;
      if (PillPacket.isPillPalPacket(result)) {
        results.add(PillPacket(result));
      }
    });
    sub.onDone(() {
      print(results);
      // print(scanned);
      service.sendData({"packets": List.of(results)});
      controller.add(results);
    });
    sub.onError((error) {
      print(error);
      timer.cancel();
    });
  });

  packetHandlerTask(controller.stream);
  reminderTask();
}
