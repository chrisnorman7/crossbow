import 'dart:convert';
import 'dart:io';

import '../../constants.dart';
import '../json/crossbow_project.dart';

/// A context for a crossbow [project].
class ProjectContext {
  /// Create an instance.
  const ProjectContext({
    required this.projectFile,
    required this.project,
  });

  /// Load a project from the [projectFile].
  ProjectContext.fromFile({required this.projectFile})
      : project = CrossbowProject.fromJson(
          jsonDecode(projectFile.readAsStringSync()) as JsonType,
        );

  /// The project which has been loaded.
  final CrossbowProject project;

  /// The file where the [project] has been loaded from.
  final File projectFile;

  /// The directory where the [project] has been loaded from.
  Directory get projectDirectory => projectFile.parent;

  /// Save the attached [project].
  void save() {
    final object = project.toJson();
    final data = indentedJsonEncoder.convert(object);
    projectFile.writeAsStringSync(data);
  }

  /// Mark the [project] as having been modified.
  void touch() => project.lastModified = DateTime.now();
}
