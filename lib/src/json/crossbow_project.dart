import 'package:json_annotation/json_annotation.dart';

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
  });

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
  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime? lastModified;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$CrossbowProjectToJson(this);
}
