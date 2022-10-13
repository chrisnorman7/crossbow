import '../json/json_value_context.dart';
import '../json/presets/preset.dart';
import '../json/presets/preset_collection.dart';

/// A class which provides a [preset], by its [id], as well as a
/// [presetCollectionContext].
class PresetContext {
  /// Create an instance.
  const PresetContext({
    required this.presetCollectionContext,
    required this.id,
  });

  /// The ID of the preset to use.
  final String id;

  /// The preset collection context.
  final JsonValueContext<PresetCollection> presetCollectionContext;

  /// The preset to use.
  Preset get preset => presetCollectionContext.value.presets
      .firstWhere((final element) => element.id == id);
}
