// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      name: json['name'] as String? ?? 'Untitled Project',
      appName: json['appName'] as String? ?? 'untitled_project',
      orgName: json['orgName'] as String? ?? 'com.example',
      functions: (json['functions'] as List<dynamic>?)
          ?.map((e) => ProjectFunction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'name': instance.name,
      'appName': instance.appName,
      'orgName': instance.orgName,
      'functions': instance.functions,
    };
