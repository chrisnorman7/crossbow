import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'preset_field_type.dart';

part 'preset_field.g.dart';

final _null = jsonEncode(null);

/// A field in a preset.
@JsonSerializable()
class PresetField {
  /// Create an instance.
  PresetField({
    this.name = 'untitled',
    this.description = 'A new preset field',
    this.type = PresetFieldType.string,
    final String? defaultValue,
  }) : defaultValue = defaultValue ?? _null;

  /// Create an instance from a JSON object.
  factory PresetField.fromJson(final Map<String, dynamic> json) =>
      _$PresetFieldFromJson(json);

  /// The name of this field.
  ///
  /// This value will be used as the key in the JSON data.
  final String name;

  /// The description of this field.
  String description;

  /// The type of this field.
  final PresetFieldType type;

  /// The default value for this preset.
  ///
  /// This value will be a JSON dump of the actual value.
  String defaultValue;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$PresetFieldToJson(this);
}
