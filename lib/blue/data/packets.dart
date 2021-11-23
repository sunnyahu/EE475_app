import 'dart:typed_data';
import 'package:flutter_blue/flutter_blue.dart';

enum PacketType { beacon, register, cap, none }

const int uuid = 0xFFFF;
const String deviceName = "PPal";

class Packet {
  static bool isPillPalPacket(ScanResult result) {
    return result.advertisementData.localName == deviceName &&
        result.advertisementData.manufacturerData.containsKey(uuid);
  }

  static PacketType getType(ScanResult r) {
    List<int>? data = r.advertisementData.manufacturerData[uuid];
    switch (data![4]) {
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

  static int getId(ScanResult r) {
    List<int>? data = r.advertisementData.manufacturerData[uuid];
    Uint8List temp = Uint8List.fromList(data!.sublist(0, 4));
    return temp.buffer.asByteData().getUint32(0, Endian.big);
  }
}
