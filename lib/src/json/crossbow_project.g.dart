// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crossbow_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrossbowProject _$CrossbowProjectFromJson(Map<String, dynamic> json) =>
    CrossbowProject(
      name: json['name'] as String? ?? 'Untitled Project',
      appName: json['appName'] as String? ?? 'untitled_game',
      orgName: json['orgName'] as String? ?? 'com.example',
    );

Map<String, dynamic> _$CrossbowProjectToJson(CrossbowProject instance) =>
    <String, dynamic>{
      'name': instance.name,
      'appName': instance.appName,
      'orgName': instance.orgName,
    };
