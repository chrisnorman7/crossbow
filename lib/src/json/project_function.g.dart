// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_function.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectFunction _$ProjectFunctionFromJson(Map<String, dynamic> json) =>
    ProjectFunction(
      id: json['id'] as String?,
      name: json['name'] as String? ?? 'function1',
      comment:
          json['comment'] as String? ?? 'A function which needs commenting.',
    );

Map<String, dynamic> _$ProjectFunctionToJson(ProjectFunction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'comment': instance.comment,
    };
