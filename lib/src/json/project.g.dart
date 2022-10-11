// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      name: json['name'] as String? ?? 'Untitled Project',
      appName: json['appName'] as String? ?? 'untitled_project',
      orgName: json['orgName'] as String? ?? 'com.example',
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'name': instance.name,
      'appName': instance.appName,
      'orgName': instance.orgName,
    };
