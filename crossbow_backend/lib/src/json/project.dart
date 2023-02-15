import 'package:json_annotation/json_annotation.dart';

import '../../crossbow_backend.dart';

part 'project.g.dart';

/// A class to hold information about a project.
@JsonSerializable()
class Project {
  /// Create an instance.
  const Project({
    required this.projectName,
    required this.initialCommandId,
    this.appName = 'example_game',
    this.orgName = 'com.example',
    this.assetsDirectory = 'assets',
    this.databaseFilename = defaultDatabasePath,
    this.framesPerSecond = 60,
  });

  /// Create an instance from a JSON object.
  factory Project.fromJson(final Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// The name of this project.
  final String projectName;

  /// The app name for this project.
  final String appName;

  /// The org name for this project.
  final String orgName;

  /// The filename of the database which holds project data.
  ///
  /// This file will be anchored at the project directory.
  final String databaseFilename;

  /// The name of the directory where assets are stored.
  ///
  /// This value will be anchored at the project directory.
  final String assetsDirectory;

  /// The ID of the initial command to use.
  final int initialCommandId;

  /// How many frames per second this project should run at.
  final int framesPerSecond;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}