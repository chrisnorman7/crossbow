import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart' hide Command;

import 'database.dart';
import 'project_runner.dart';
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

  /// Get the initial command to run.
  Future<Command> get initialCommand =>
      db.commandsDao.getCommand(id: project.initialCommandId);

  /// Get a project runner for this project context.
  @useResult
  ProjectRunner get projectRunner {
    final sdl = Sdl();
    final synthizer = Synthizer();
    final synthizerContext = synthizer.createContext();
    final random = Random();
    return ProjectRunner(
      projectContext: this,
      sdl: sdl,
      synthizerContext: synthizerContext,
      random: random,
      soundBackend: SynthizerSoundBackend(
        context: synthizerContext,
        bufferCache: BufferCache(
          synthizer: synthizer,
          maxSize: 1.gb,
          random: random,
        ),
      ),
    );
  }
}
