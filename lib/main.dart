import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {
            FlutterBlue flutterBlue = FlutterBlue.instance;
            // Start scanning
            flutterBlue.startScan(timeout: Duration(seconds: 4));

            // Listen to scan results
            var subscription = flutterBlue.scanResults.listen((results) {
              // do something with scan results
              for (ScanResult r in results) {
                print('${r.device.name} found! rssi: ${r.rssi}');
              }
            });
            // Stop scanning
            flutterBlue.stopScan();
          },
          child: Text('TextButton'),
        ),
      );
}
