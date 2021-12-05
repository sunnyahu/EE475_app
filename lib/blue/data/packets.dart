import 'dart:typed_data';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

enum PacketType { beacon, register, cap, none }

const int uuid = 0xFFFF;
const String deviceName = "PPal";

class PillPacket {
  late int id;
  late int seqNum;
  late DateTime timestamp;
  late PacketType type;

  PillPacket(DiscoveredDevice d) {
    id = getBottleId(d);
    seqNum = getSeqNum(d);
    timestamp = DateTime.now();
    type = getType(d);
  }

  @override
  String toString() {
    return "{timestamp: " +
        timestamp.toString() +
        ", id: " +
        id.toString() +
        ", seqNum: " +
        seqNum.toString() +
        ", type: " +
        type.toString() +
        "}";
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'seqNum': seqNum,
        'type': type.index,
        'timestamp': timestamp.toString()
      };

  PillPacket.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        seqNum = json['seqNum'],
        type = PacketType.values[json['type']],
        timestamp = DateTime.parse(json['timestamp']);

  static bool isPillPalPacket(DiscoveredDevice device) {
    return device.name == deviceName;
  }

  static PacketType getType(DiscoveredDevice d) {
    switch (d.manufacturerData[8]) {
      case 0:
        return PacketType.beacon;
      case 1:
        return PacketType.register;
      case 2:
        return PacketType.cap;
      default:
        return PacketType.none;
    }
  }

  static int getBottleId(DiscoveredDevice d) {
    return d.manufacturerData.buffer.asByteData().getUint32(2, Endian.big);
  }

  static int getSeqNum(DiscoveredDevice d) {
    return d.manufacturerData.buffer.asByteData().getUint16(6, Endian.big);
  }
}
