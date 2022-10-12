import 'package:json_annotation/json_annotation.dart';

import 'preset.dart';

part 'preset_collection.g.dart';

/// A file which holds a collection of [presets].
@JsonSerializable()
class PresetCollection {
  /// Create an instance.
  PresetCollection({
    this.name = 'Untitled Preset Collection',
    this.description = 'A collection of presets.',
    this.authors = 'Unknown',
    final List<Preset>? presets,
  }) : presets = presets ?? [];

  /// Create an instance from a JSON object.
  factory PresetCollection.fromJson(final Map<String, dynamic> json) =>
      _$PresetCollectionFromJson(json);

  /// The name of this preset collection.
  String name;

  /// The description for this collection of presets.
  String description;

  /// The author(s) of this collection.
  String authors;

  /// The list of presets which are contained by this collection.
  List<Preset> presets;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$PresetCollectionToJson(this);
}
