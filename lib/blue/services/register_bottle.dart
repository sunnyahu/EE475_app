// Registers the Pill Bottle using Bluetooth.

import 'package:flutter_blue/flutter_blue.dart';

// Called from edit_medication.dart in "EditMedicationState" constructor.
int registerBottle() {
  int id = 0; // Get ID from Register Packet.
  FlutterBlue flutterBlue = FlutterBlue.instance;
  flutterBlue.startScan(timeout: Duration(seconds: 4));
  var subscription = flutterBlue.scanResults.listen((results) {
    for (ScanResult device in results) {
      // device is a bluetooth device
    }
  });
  // Stop scanning
  flutterBlue.stopScan();

  return id;
}
