/// All rights reserved for Mopilani Team, Acanxa Team, NexaPros Team
/// NexaPros 2021 
/// Under Non Public license
library reader;
@Info('0.1', '0.2+1', '11/22/2021')

import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'annotations.dart';

/// Here you can find async and sync for the same function
/// 1- Json Read
/// 2- Yaml Read
/// 3- Bytes Read
/// 4- String Read

/// ### Read Json File
/// 
/// Reads the json file and returns a dynamic value
Future<dynamic> readJsonFile(String fileName) async =>
    json.decode(await File(fileName).readAsString());

/// ### Read Json File Synchronously
/// 
/// Reads the json file and returns a dynamic value
dynamic readJsonFileSync(String fileName,
        {Encoding encoding = utf8}) =>
    json.decode(File(fileName).readAsStringSync(encoding: encoding));

/// ### Read Bytes File
/// Reads the byest file and returns a [Uint8List]
Future<Uint8List> readByestFile(String fileName) async =>
    await File(fileName).readAsBytes();

/// ### Read Bytes File Synchronously
/// Reads the byest file and returns a [Uint8List]
Uint8List readByestFileSync(String fileName) =>
    File(fileName).readAsBytesSync();

/// ### Read String File
/// Reads the string file and returns a [String]
Future<String> readStringFile(String fileName) async =>
    await File(fileName).readAsString();

/// ### Read String File Synchronously
/// Reads the string file and returns a [String]
String readStringFileSync(String fileName) => File(fileName).readAsStringSync();

Future<List<String>> readStringFileAsLines(String fileName,
        {Encoding encoding = utf8}) async =>
    await File(fileName).readAsLines();

List<String> readStringFileAsLinesSync(String fileName,
        {Encoding encoding = utf8}) =>
    File(fileName).readAsLinesSync();

// class C {
//   C();
//   static C ins =C();
//   f() {}
// }

// d() {
//   C c = C.ins;
//   c.f();
// }
