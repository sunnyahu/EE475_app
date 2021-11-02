import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class LocateMedication extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LocateMedicationState();
  }
}

class LocateMedicationState extends State<LocateMedication> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> devices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locate Medication'),
      ),
      body: Column(
        children: <Widget>[
          const Text('Locate Medication'),
          ElevatedButton(
            child: const Text('Start Looking'),
            onPressed: () {
              // Start scanning
              devices.clear();
              flutterBlue.startScan(timeout: Duration(seconds: 4));

              // Listen to scan results
              var subscription = flutterBlue.scanResults.listen((results) {
                devices.addAll(results);
              });
              // Stop scanning
              flutterBlue.stopScan();
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
