import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

enum PacketType { beacon, register, cap, none }

const int uuid = 0xFFFF;
const String deviceName = "PPal";

class PillPacket {
  late int id;
  late int seqNum;
  late DateTime timestamp;
  late PacketType type;
  late int rssi;

  PillPacket(DiscoveredDevice d) {
    id = getBottleId(d);
    seqNum = getSeqNum(d);
    timestamp = DateTime.now();
    type = getType(d);
    rssi = d.rssi;
  }

  PillPacket.dummy() {
    id = -1;
    seqNum = -1;
    timestamp = DateTime(2069, DateTime.april, 20);
    type = PacketType.none;
    rssi = 0;
  }

  @override
  String toString() {
    return "{timestamp: " +
        timestamp.toString() +
        ", rssi: " +
        rssi.toString() +
        ", id: " +
        id.toString() +
        ", seqNum: " +
        seqNum.toString() +
        ", type: " +
        type.toString() +
        "}";
  }

  @override
  bool operator ==(o) => o is PillPacket && id == o.id && seqNum == o.seqNum;
  @override
  int get hashCode => hashValues(id.hashCode, seqNum.hashCode);

  Map<String, dynamic> toJson() => {
        'id': id,
        'seqNum': seqNum,
        'type': type.index,
        'timestamp': timestamp.toIso8601String(),
        'rssi': rssi,
      };

  PillPacket.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        seqNum = json['seqNum'],
        type = PacketType.values[json['type']],
        timestamp = DateTime.parse(json['timestamp']),
        rssi = json['rssi'];

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
