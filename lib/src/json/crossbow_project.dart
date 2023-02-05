import 'package:json_annotation/json_annotation.dart';

import 'crossbow_command_trigger.dart';

part 'crossbow_project.g.dart';

/// A crossbow project.
@JsonSerializable()
class CrossbowProject {
  /// Create an instance.
  CrossbowProject({
    this.projectName = 'Untitled Project',
    this.appName = 'untitled_game',
    this.orgName = 'com.example',
    this.assetDirectory = 'assets',
    this.lastModified,
    final List<CrossbowCommandTrigger>? commandTriggers,
  }) : commandTriggers = commandTriggers ?? [];

  /// Create an instance from a JSON object.
  factory CrossbowProject.fromJson(final Map<String, dynamic> json) =>
      _$CrossbowProjectFromJson(json);

  /// The human-readable name of this project.
  String projectName;

  /// The app name for this project.
  String appName;

  /// The org name for this project.
  String orgName;

  /// The directory where assets will be stored.
  String assetDirectory;

  /// The time this project was last modified.
  ///
  /// If this value is `null`, then the project has not been modified since it
  /// was loaded.
  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime? lastModified;

  /// The command triggers.
  final List<CrossbowCommandTrigger> commandTriggers;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$CrossbowProjectToJson(this);
}
