// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresetField _$PresetFieldFromJson(Map<String, dynamic> json) => PresetField(
      id: json['id'] as String?,
      name: json['name'] as String? ?? 'untitled',
      description: json['description'] as String? ?? 'A new preset field',
      type: $enumDecodeNullable(_$PresetFieldTypeEnumMap, json['type']) ??
          PresetFieldType.string,
      defaultValue: json['defaultValue'] as String?,
    );

Map<String, dynamic> _$PresetFieldToJson(PresetField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$PresetFieldTypeEnumMap[instance.type]!,
      'defaultValue': instance.defaultValue,
    };

const _$PresetFieldTypeEnumMap = {
  PresetFieldType.string: 'string',
  PresetFieldType.integer: 'integer',
  PresetFieldType.double: 'double',
  PresetFieldType.character: 'character',
  PresetFieldType.boolean: 'boolean',
  PresetFieldType.scanCode: 'scanCode',
  PresetFieldType.sound: 'sound',
  PresetFieldType.function: 'function',
};
