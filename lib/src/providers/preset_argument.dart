import 'dart:io';

import '../json/presets/preset.dart';
import '../json/presets/preset_collection.dart';

/// A class which holds both the [file] which stores a [PresetCollection], and
/// the [id] of a [Preset].
class PresetArgument {
  /// Create an instance.
  const PresetArgument({
    required this.file,
    required this.id,
  });

  /// The file where the [PresetCollection] is stored.
  final File file;

  /// The ID of the [Preset] which this argument will retrieve.
  final String id;
}
