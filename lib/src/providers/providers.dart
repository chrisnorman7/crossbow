import 'dart:io';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../contexts/app_context.dart';

/// Provide an app context.
final appContextProvider = FutureProvider<AppContext>((final ref) async {
  final synthizer = Synthizer()..initialize();
  final context = synthizer.createContext();
  final sdl = Sdl();
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final crossbowDirectory = Directory(
    path.join(
      documentsDirectory.path,
      'crossbow',
    ),
  );
  if (crossbowDirectory.existsSync() == false) {
    crossbowDirectory.createSync(recursive: true);
  }
  return AppContext(
    crossbowDirectory: crossbowDirectory,
    synthizer: synthizer,
    context: context,
    sdl: sdl,
  );
});

/// Provide shared preferences.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (final ref) => SharedPreferences.getInstance(),
);

/// Provides the path to the most recently loaded project.
final recentProjectPathProvider = FutureProvider<String?>(
  (final ref) async {
    final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
    return sharedPreferences.getString(recentProjectPathKey);
  },
);
