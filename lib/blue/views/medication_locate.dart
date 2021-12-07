/// PillPal
///
/// This file stores "Locate Medication" page which
/// stores the bluetooth scan results.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pill_pal/blue/data/packets.dart';
import 'package:pill_pal/med/data/medication.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

@immutable
class LocateMedication extends StatefulWidget {
  final Medication medication;

  const LocateMedication({
    Key? key,
    required this.medication,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LocateMedicationState();
}

class LocateMedicationState extends State<LocateMedication> {
  static const double MIN_RSSI = -150;
  static const double MAX_RSSI = 0;
  static const double SEG_THIRD = 50;
  int RSSI = -75; // RSSI Value updating the Speedometer.

  final stream = FlutterBackgroundService().onDataReceived;
  late StreamSubscription<dynamic> subscriber;
  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      firstBuild = false;
      print("Searching for : " + widget.medication.id.toString());
      subscriber = stream.listen((snapshot) {
        var packets = snapshot!['packets'];
        for (var packet in packets) {
          PillPacket p = PillPacket.fromJson(packet);
          if (p.type == PacketType.beacon && p.id == widget.medication.id) {
            print("Found with " + p.rssi.toString());
            RSSI = p.rssi;
            setState(() {});
          }
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locate Medication'),
      ),
      body: Column(
        children: <Widget>[
          SfRadialGauge(
            axes: [
              RadialAxis(
                minimum: MIN_RSSI,
                maximum: MAX_RSSI,
                ranges: [
                  GaugeRange(
                      startValue: MIN_RSSI,
                      endValue: MIN_RSSI + SEG_THIRD,
                      color: Colors.red,
                      label: "Far"),
                  GaugeRange(
                      startValue: MIN_RSSI + SEG_THIRD,
                      endValue: MAX_RSSI - SEG_THIRD,
                      color: Colors.yellow,
                      label: "Close"),
                  GaugeRange(
                      startValue: MAX_RSSI - SEG_THIRD,
                      endValue: MAX_RSSI,
                      color: Colors.green,
                      label: "Very Close")
                ],
                pointers: [NeedlePointer(value: RSSI.toDouble())],
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  @mustCallSuper
  void dispose() {
    subscriber.cancel();
    super.dispose();
  }
}
