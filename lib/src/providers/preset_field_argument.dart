import '../json/json_value_context.dart';
import '../json/presets/preset_collection.dart';
import '../json/presets/preset_field.dart';

/// A class to hold information required for loading a [PresetField].
class PresetFieldArgument {
  /// Create an instance.
  const PresetFieldArgument({
    required this.presetCollectionContext,
    required this.presetId,
    required this.presetFieldId,
  });

  /// The preset collection to use.
  final JsonValueContext<PresetCollection> presetCollectionContext;

  /// The ID of the preset to use.
  final String presetId;

  /// The ID of the field to use.
  final String presetFieldId;
}
