import 'package:json_annotation/json_annotation.dart';

import '../../util.dart';
import 'project.dart';

part 'project_function.g.dart';

/// A function in a [Project].
@JsonSerializable()
class ProjectFunction {
  /// Create an instance.
  ProjectFunction({
    final String? id,
    this.name = 'function1',
    this.comment = 'A function which needs commenting.',
  }) : id = id ?? newId();

  /// Create an instance from a JSON object.
  factory ProjectFunction.fromJson(final Map<String, dynamic> json) =>
      _$ProjectFunctionFromJson(json);

  /// The ID of this function.
  final String id;

  /// The name of this function.
  String name;

  /// The comment of this function.
  String comment;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$ProjectFunctionToJson(this);
}
