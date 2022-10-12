// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresetCollection _$PresetCollectionFromJson(Map<String, dynamic> json) =>
    PresetCollection(
      name: json['name'] as String? ?? 'Untitled Preset Collection',
      description: json['description'] as String? ?? 'A collection of presets.',
      authors: json['authors'] as String? ?? 'Unknown',
      presets: (json['presets'] as List<dynamic>?)
          ?.map((e) => Preset.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PresetCollectionToJson(PresetCollection instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'authors': instance.authors,
      'presets': instance.presets,
    };
