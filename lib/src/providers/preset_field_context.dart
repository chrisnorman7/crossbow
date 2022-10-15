import '../json/presets/preset_field.dart';
import 'preset_context.dart';

/// A class to hold a [presetContext], and the id of a [PresetField].
class PresetFieldContext {
  /// Create an instance.
  const PresetFieldContext({
    required this.presetContext,
    required this.presetId,
    required this.presetFieldId,
  });

  /// The preset context to use.
  final PresetContext presetContext;

  /// The ID of the preset to use.
  final String presetId;

  /// The ID of the field to use.
  final String presetFieldId;

  /// Get the preset field.
  PresetField get presetField => presetContext.preset.fields
      .firstWhere((final element) => element.id == presetFieldId);
}
