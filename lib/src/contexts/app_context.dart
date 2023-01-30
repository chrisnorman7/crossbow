import 'dart:io';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';

/// Context for the app.
class AppContext {
  /// Create an instance.
  const AppContext({
    required this.crossbowDirectory,
    required this.synthizer,
    required this.context,
    required this.sdl,
  });

  /// The directory where crossbow documents might be stored.
  final Directory crossbowDirectory;

  /// The main synthizer object.
  final Synthizer synthizer;

  /// The synthizer context.
  final Context context;

  /// The SDL instance to use.
  final Sdl sdl;
}
