library writer;

import 'dart:convert';
import 'dart:io';

/// Here you can find async and sync for the same function
/// 1- Json Write
/// 2- Yaml Write
/// 3- Bytes Write
/// 4- String Write

/// ### Write Json File
/// Write the json file and returns a [File]
Future<File> writeJsonToFile(String fileName, Object contents,
        {FileMode mode = FileMode.write,
        Encoding encoding = utf8,
        bool flush = false}) async =>
    await File(fileName).writeAsString(
      json.encode(contents),
      encoding: encoding,
      flush: flush,
      mode: mode,
    );

/// ### Write Json File Synchronously
/// Write the json file
void writeAsJsonToFileSync(String fileName, Object contents,
        {FileMode mode = FileMode.write,
        Encoding encoding = utf8,
        bool flush = false}) =>
    File(fileName).writeAsStringSync(
      json.encode(contents),
      encoding: encoding,
      flush: flush,
      mode: mode,
    );

/// ### Write Bytes File
/// Write the byest file and returns a [File]
Future<File> writeByestToFile(String fileName, List<int> contents,
        {FileMode mode = FileMode.write, bool flush = false}) async =>
    await File(fileName).writeAsBytes(
      contents,
      flush: flush,
      mode: mode,
    );

/// ### Write Bytes File Synchronously
/// Write the byest file
void writeByestToFileSync(String fileName, List<int> contents,
        {FileMode mode = FileMode.write, bool flush = false}) =>
    File(fileName).writeAsBytesSync(
      contents,
      flush: flush,
      mode: mode,
    );

/// ### Write String File
/// Write the string file and returns a [File]
Future<File> writeStringToFile(String fileName, String contents,
        {FileMode mode = FileMode.write,
        Encoding encoding = utf8,
        bool flush = false}) async =>
    await File(fileName).writeAsString(
      contents,
      encoding: encoding,
      flush: flush,
      mode: mode,
    );

/// ### Write String File Synchronously
/// Write the string file
void writeStringToFileSync(String fileName, String contents,
        {FileMode mode = FileMode.write,
        Encoding encoding = utf8,
        bool flush = false}) =>
    File(fileName).writeAsStringSync(
      contents,
      encoding: encoding,
      flush: flush,
      mode: mode,
    );
