/// PillPal
///
/// This file stores "Locate Medication" page which
/// stores the bluetooth scan results.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:pill_pal/blue/data/packets.dart';
import 'package:pill_pal/med/data/medication.dart';

import 'package:flutter_speedometer/flutter_speedometer.dart';

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
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> devices = [];

  int MIN_RSSI = 0;
  int MAX_RSSI = 1000;
  int RSSI = 0; // RSSI Value updating the Speedometer.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locate Medication'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: const Text('Start Looking'),
            trailing: const Icon(Icons.search),
            onTap: () {
              // Start scanning
              flutterBlue.stopScan();
              devices.clear();
              setState(() {});
              print("Searching for : " + widget.medication.id.toString());
              var scan = flutterBlue.startScan();
              flutterBlue.scanResults.listen((results) {
                if (results.isNotEmpty) {
                  for (ScanResult result in results) {
                    if (Packet.isPillPalPacket(result) &&
                        Packet.getType(result) == PacketType.beacon &&
                        Packet.getId(result) == widget.medication.id) {
                      devices.clear();
                      devices.add(result);
                      setState(() {
                        RSSI = result.rssi;
                      });
                    }
                  }
                }
              });

              // Stop scanning
              // flutterBlue.stopScan();
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (BuildContext context, int index) {
                ScanResult device = devices[index];
                return ListTile(
                  title: Text('${device.device.name} - RSSI: ${device.rssi}'),
                  subtitle: Text(device.device.id.toString()),
                  trailing: const Icon(Icons.medical_services),
                );
              },
            ),
          ),
          Speedometer(
            size: 250,
            minValue: MIN_RSSI,
            maxValue: MAX_RSSI,
            currentValue: RSSI,
            displayText: '${widget.medication.name} Proximity',
          ),
        ],
      ),
    );
  }
}
