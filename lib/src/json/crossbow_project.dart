import 'package:json_annotation/json_annotation.dart';

part 'crossbow_project.g.dart';

/// A crossbow project.
@JsonSerializable()
class CrossbowProject {
  /// Create an instance.
  CrossbowProject({
    this.name = 'Untitled Project',
    this.appName = 'untitled_game',
    this.orgName = 'com.example',
  });

  /// Create an instance from a JSON object.
  factory CrossbowProject.fromJson(final Map<String, dynamic> json) =>
      _$CrossbowProjectFromJson(json);

  /// The human-readable name of this project.
  String name;

  /// The app name for this project.
  String appName;

  /// The org name for this project.
  String orgName;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$CrossbowProjectToJson(this);
}
