// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preset _$PresetFromJson(Map<String, dynamic> json) => Preset(
      name: json['name'] as String? ?? 'Untitled Preset',
      description: json['description'] as String? ?? 'DESCRIBE ME',
      code: json['code'] as String? ?? '/// This preset needs code.\n',
      fields: (json['fields'] as List<dynamic>?)
          ?.map((e) => PresetField.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PresetToJson(Preset instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'code': instance.code,
      'fields': instance.fields,
    };
