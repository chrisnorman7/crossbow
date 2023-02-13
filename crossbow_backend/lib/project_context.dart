import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'database.dart';
import 'src/json/project.dart';

/// The context for a particular project.
class ProjectContext {
  /// Create an instance.
  const ProjectContext({
    required this.file,
    required this.project,
    required this.db,
  });

  /// Create an instance from a file.
  factory ProjectContext.fromFile(final File file) {
    final data = file.readAsStringSync();
    final json = jsonDecode(data);
    final project = Project.fromJson(json);
    final databaseFile =
        File(path.join(file.parent.path, project.databaseFilename));
    final db = CrossbowBackendDatabase.fromFile(databaseFile);
    return ProjectContext(file: file, project: project, db: db);
  }

  /// The file where the [project] is stored.
  final File file;

  /// The directory where [project] files are stored.
  Directory get projectDirectory => file.parent;

  /// The project this context references.
  final Project project;

  /// The directory where assets are stored.
  Directory get assetsDirectory =>
      Directory(path.join(projectDirectory.path, project.assetsDirectory));

  /// The database to use.
  final CrossbowBackendDatabase db;
}
