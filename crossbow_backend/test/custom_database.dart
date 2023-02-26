import 'dart:ffi';
import 'dart:io';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';

DynamicLibrary _openOnLinux() {
  final workingDirectory = Directory.current.path;
  return DynamicLibrary.open('$workingDirectory/sqlite3.so');
}

DynamicLibrary _openOnWindows() => DynamicLibrary.open('sqlite3.dll');

/// Do initial setup and get a database.
CrossbowBackendDatabase getDatabase() {
  open
    ..overrideFor(OperatingSystem.windows, _openOnWindows)
    ..overrideFor(OperatingSystem.linux, _openOnLinux);
  return CrossbowBackendDatabase(
    LazyDatabase(NativeDatabase.memory),
  );
}
