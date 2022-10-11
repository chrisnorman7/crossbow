import 'package:json_annotation/json_annotation.dart';

import 'preset_field.dart';

part 'preset.g.dart';

/// A preset.
@JsonSerializable()
class Preset {
  /// Create an instance.
  Preset({
    this.name = 'Untitled Preset',
    this.description = 'DESCRIBE ME',
    this.code = '/// This preset needs code.\n',
    final List<PresetField>? fields,
  }) : fields = fields ?? [];

  /// Create an instance from a JSON object.
  factory Preset.fromJson(final Map<String, dynamic> json) =>
      _$PresetFromJson(json);

  /// The name of this preset.
  String name;

  /// The description of this preset.
  String description;

  /// The code for this preset.
  String code;

  /// The fields in this preset.
  List<PresetField> fields;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$PresetToJson(this);
}
