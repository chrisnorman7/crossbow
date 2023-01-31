// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crossbow_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrossbowProject _$CrossbowProjectFromJson(Map<String, dynamic> json) =>
    CrossbowProject(
      projectName: json['projectName'] as String? ?? 'Untitled Project',
      appName: json['appName'] as String? ?? 'untitled_game',
      orgName: json['orgName'] as String? ?? 'com.example',
      assetDirectory: json['assetDirectory'] as String? ?? 'assets',
    );

Map<String, dynamic> _$CrossbowProjectToJson(CrossbowProject instance) =>
    <String, dynamic>{
      'projectName': instance.projectName,
      'appName': instance.appName,
      'orgName': instance.orgName,
      'assetDirectory': instance.assetDirectory,
    };
