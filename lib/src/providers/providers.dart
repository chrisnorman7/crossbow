import 'dart:convert';
import 'dart:io';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../constants.dart';
import '../json/presets/preset.dart';
import 'app_context.dart';

/// Provide an app context.
final appContextProvider = FutureProvider((final ref) async {
  final synthizer = Synthizer()..initialize();
  final context = synthizer.createContext();
  final sdl = Sdl();
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final crossbowDirectory =
      Directory(path.join(documentsDirectory.path, 'crossbow'));
  return AppContext(
    crossbowDirectory: crossbowDirectory,
    synthizer: synthizer,
    context: context,
    sdl: sdl,
  );
});

/// Provide the current presets.
final presetsProvider = FutureProvider((final ref) async {
  final context = await ref.watch(appContextProvider.future);
  final presetsDirectory = context.presetsDirectory;
  if (!presetsDirectory.existsSync()) {
    return <Preset>[];
  }
  final files = presetsDirectory
      .listSync()
      .whereType<File>()
      .where((final element) => path.extension(element.path) == '.json');
  return files.map<Preset>(
    (final e) {
      final data = e.readAsStringSync();
      final json = jsonDecode(data) as JsonType;
      return Preset.fromJson(json);
    },
  );
});
