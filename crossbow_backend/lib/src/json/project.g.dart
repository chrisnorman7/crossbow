// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      projectName: json['projectName'] as String,
      initialCommandId: json['initialCommandId'] as int,
      appName: json['appName'] as String? ?? 'example_game',
      orgName: json['orgName'] as String? ?? 'com.example',
      assetsDirectory: json['assetsDirectory'] as String? ?? 'assets',
      databaseFilename:
          json['databaseFilename'] as String? ?? defaultDatabasePath,
      framesPerSecond: json['framesPerSecond'] as int? ?? 60,
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'projectName': instance.projectName,
      'appName': instance.appName,
      'orgName': instance.orgName,
      'databaseFilename': instance.databaseFilename,
      'assetsDirectory': instance.assetsDirectory,
      'initialCommandId': instance.initialCommandId,
      'framesPerSecond': instance.framesPerSecond,
    };
