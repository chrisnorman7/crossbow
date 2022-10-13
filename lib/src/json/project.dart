import 'package:json_annotation/json_annotation.dart';

import 'project_function.dart';

part 'project.g.dart';

/// The top-level project class.
@JsonSerializable()
class Project {
  /// Create an instance.
  Project({
    this.name = 'Untitled Project',
    this.appName = 'untitled_project',
    this.orgName = 'com.example',
    final List<ProjectFunction>? functions,
  }) : functions = functions ?? [];

  /// Create an instance from a JSON object.
  factory Project.fromJson(final Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// The name of this project.
  String name;

  /// The app name for this project.
  String appName;

  /// The org name for this project.
  String orgName;

  /// The functions which have been defined.
  List<ProjectFunction> functions;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
