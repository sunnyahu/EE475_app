// Registers the Pill Bottle using Bluetooth.

import 'package:flutter_blue/flutter_blue.dart';
import 'package:pill_pal/blue/data/packets.dart';

// Called from edit_medication.dart in "EditMedicationState" constructor.
// Get the bottle id of a valid PillPal device broadcasting a register packet
Future<int> registerBottle() async {
  int id = -1; // Get ID from Register Packet.
  FlutterBlue flutterBlue = FlutterBlue.instance;
  // Get the first PillPal type Register packetz
  var scan = flutterBlue.scan(timeout: const Duration(seconds: 4));
  var sub = scan.listen(null);
  sub.onData((result) {
    if (Packet.isPillPallPacket(result) &&
        Packet.getType(result) == PacketType.register) {
      id = Packet.getId(result);
      // print("Registering bottle " + id.toString());
      flutterBlue.stopScan();
    }
  });

  await sub.asFuture();
  return id;
}
