import 'dart:io';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:path/path.dart' as path;

/// The context for the application.
class AppContext {
  /// Create an instance.
  const AppContext({
    required this.crossbowDirectory,
    required this.synthizer,
    required this.context,
    required this.sdl,
  });

  /// The directory where crossbow data will be stored.
  final Directory crossbowDirectory;

  /// The directory where presets will be stored.
  Directory get presetsDirectory =>
      Directory(path.join(crossbowDirectory.path, 'presets'));

  /// The synthizer instance to use.
  final Synthizer synthizer;

  /// The synthizer context to use.
  final Context context;

  /// The SDL instance to use.
  final Sdl sdl;
}
