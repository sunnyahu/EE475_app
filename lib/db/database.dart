// Database using json file.

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

const String MEDICATIONS_DB = "medications_db.json";
const String LOGS_DB = "logs_db.json";
const String CONTACTS_DB = "contacts_db.json";

// Read json data from the given filename.
Future<Map<String, dynamic>> read(String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;

  try {
    final file = File('$path/$filename');
    // Read the file
    final contents = await file.readAsString();
    return jsonDecode(contents);
  } catch (e) {
    // If encountering an error, return empty map.
    return {};
  }
}

// Write json data to the given filename.
Future<File> write(String filename, dynamic object) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final file = File('$path/$filename');
  // Write the file
  return file.writeAsString(jsonEncode(object));
}
