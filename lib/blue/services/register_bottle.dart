// Registers the Pill Bottle using Bluetooth.

import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pill_pal/blue/data/packets.dart';
import 'package:pill_pal/med/data/medication.dart';

// Called from edit_medication.dart in "EditMedicationState" constructor.
// Get the bottle id of a valid PillPal device broadcasting a register packet
Future<int> registerBottle(List<Medication> meds) async {
  Set<int> registeredIds = <int>{};
  for (var element in meds) {
    registeredIds.add(element.id);
  }

  int id = -1; // Get ID from Register Packet.
  var stream = FlutterBackgroundService().onDataReceived;

  var snapshot = await stream.firstWhere((snap) {
    var packets = snap!['packets'];
    for (var packet in packets) {
      PillPacket p = PillPacket.fromJson(packet);
      if (!registeredIds.contains(p.id) && p.type == PacketType.register) {
        id = p.id;
        return true;
      }
    }
    return false;
  });

  return id;
}
